#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEXTURES_DIR="${TEXTURES_OUT_DIR:-$REPO_ROOT/assets/textures}"
CONFIG="${TEXTURES_CONFIG:-$REPO_ROOT/assets/textures/textures.toml}"

require_cmd() { command -v "$1" >/dev/null 2>&1 || { echo "error: $1 is required but not installed" >&2; exit 1; }; }

# python3 is needed for toml_list_tables and toml_get, which may be called before rendering
require_cmd python3

usage() {
  cat <<EOF
Usage: build-textures.sh [--help] [--list] [--get] [<texture_name>]

Generates PNG textures defined in \$CONFIG into \$TEXTURES_DIR.
  --help   Show this message.
  --list   Print the names of every texture in the config and exit.
  --get    Print a scalar from the config at a dotted path.
           Usage: --get <section> <key> [<subkey>...]
           Exit codes: 0 = found, 2 = path missing, 3 = path is table/list.

With no argument, builds all textures. With a name, builds only that one.
EOF
}

# List top-level table names in the TOML config.
toml_list_tables() {
  python3 - "$CONFIG" <<'PY'
import sys, tomllib
with open(sys.argv[1], "rb") as f:
    data = tomllib.load(f)
for name, value in data.items():
    if isinstance(value, dict):
        print(name)
PY
}

# Read a scalar at a dotted path. Prints nothing + exits 2 if missing.
# Usage: toml_get <section> <key> [<subkey>...]
toml_get() {
  python3 - "$CONFIG" "$@" <<'PY'
import sys, tomllib
with open(sys.argv[1], "rb") as f:
    data = tomllib.load(f)
node = data
for key in sys.argv[2:]:
    if isinstance(node, dict) and key in node:
        node = node[key]
    else:
        sys.exit(2)
if isinstance(node, (dict, list)):
    sys.exit(3)
print(node)
PY
}

case "${1:-}" in
  --help|-h) usage; exit 0 ;;
  --list)    toml_list_tables; exit 0 ;;
  --get)     shift; toml_get "$@"; exit $? ;;
esac

# Only check for rendering dependencies if actually rendering
require_cmd gmic
require_cmd identify
require_cmd sha256sum

# Dependencies: gmic, imagemagick (convert, identify), python3 >=3.11 (for tomllib),
# bats (for tests). Install via your system's package manager. No OS assumption.

# --- rendering ---

# Convert "#rrggbb" to "R,G,B" for G'MIC.
hex_to_rgb_triple() {
  local hex="${1#'#'}"
  printf '%d,%d,%d' "0x${hex:0:2}" "0x${hex:2:2}" "0x${hex:4:2}"
}

# Compute a stable 32-bit seed from a texture name (for G'MIC -srand).
stable_seed() {
  local name="$1"
  local h; h=$(printf '%s' "$name" | sha256sum | cut -c1-8)
  python3 -c "print(int('$h', 16) & 0x7fffffff)"
}

# Maps an origin keyword to normalized coordinates (cx, cy) in [0,1].
halation_origin_coords() {
  case "$1" in
    top-left)     echo "0 0" ;;
    top-right)    echo "1 0" ;;
    bottom-left)  echo "0 1" ;;
    bottom-right) echo "1 1" ;;
    center)       echo "0.5 0.5" ;;
    *) echo "error: unknown halation origin: $1" >&2; exit 1 ;;
  esac
}

# Map ISO to a noise standard deviation (0..30 range). Linear, clamped.
iso_to_noise_std() {
  python3 -c "print(max(2, min(30, ${1} / 80)))"
}

render_texture() {
  local name="$1"
  local out="$TEXTURES_DIR/$name.png"

  local width height base_color
  width=$(toml_get "$name" width)
  height=$(toml_get "$name" height)
  base_color=$(toml_get "$name" base_color)

  local rgb
  rgb=$(hex_to_rgb_triple "$base_color")

  mkdir -p "$TEXTURES_DIR"

  local tmp="$TEXTURES_DIR/.$name.tmp.png"

  # Layer 0: base fill.
  gmic -input "${width},${height},1,3" -fill "[$rgb]" -output "$tmp" >/dev/null

  # Layer 1: halation.
  if [[ "$(toml_get "$name" halation enabled 2>/dev/null || echo false)" == "True" ]]; then
    local h_color h_strength h_origin h_radius
    h_color=$(toml_get "$name" halation color)
    h_strength=$(toml_get "$name" halation strength)
    h_origin=$(toml_get "$name" halation origin)
    h_radius=$(toml_get "$name" halation radius)
    local h_rgb; h_rgb=$(hex_to_rgb_triple "$h_color")
    local coords; coords=$(halation_origin_coords "$h_origin")
    local cx cy; read -r cx cy <<< "$coords"
    local px py rad
    px=$(python3 -c "print(int(${cx}*(${width}-1)))")
    py=$(python3 -c "print(int(${cy}*(${height}-1)))")
    rad=$(python3 -c "print(int(${h_radius}*max(${width},${height})))")

    local blur_rad
    blur_rad=$(python3 -c "print(max(1, ${rad}//4))")

    # Generate a halation layer: black canvas, draw a soft warm disc, blur,
    # screen-blend onto the base.
    local r g b
    read -r r g b <<< "$h_rgb"
    gmic "$tmp" \
         -input "${width},${height},1,3" -fill "[0,0,0]" \
         -ellipse[-1] ${px},${py},${rad},${rad},0,${h_strength},${r},${g},${b} \
         -blur[-1] ${blur_rad} \
         -blend screen \
         -output "$tmp" >/dev/null
  fi

  # Layer 2: grain.
  if [[ "$(toml_get "$name" grain enabled 2>/dev/null || echo false)" == "True" ]]; then
    local g_iso g_opacity g_mono g_std
    g_iso=$(toml_get "$name" grain iso)
    g_opacity=$(toml_get "$name" grain opacity)
    g_mono=$(toml_get "$name" grain monochrome)
    g_std=$(iso_to_noise_std "$g_iso")

    local mono_cmd=""
    if [[ "$g_mono" == "True" ]]; then
      mono_cmd="-channels[-1] 0,0 -to_rgb[-1]"
    fi

    gmic "$tmp" \
         -input "${width},${height},1,3,128" \
         -srand $(stable_seed "${name}-grain") \
         -noise[-1] "${g_std},0" \
         ${mono_cmd} \
         -blend overlay,${g_opacity} \
         -output "$tmp" >/dev/null
  fi

  # Layer 3: scratches (vertical emulsion damage).
  if [[ "$(toml_get "$name" scratches enabled 2>/dev/null || echo false)" == "True" ]]; then
    local s_density s_opacity s_orient
    s_density=$(toml_get "$name" scratches density)
    s_opacity=$(toml_get "$name" scratches opacity)
    s_orient=$(toml_get "$name" scratches orientation)

    if [[ "$s_orient" == "vertical" ]]; then
      gmic "$tmp" \
           -input "${width},1,1,1,0" \
           -srand $(stable_seed "${name}-scratches") \
           -noise[-1] 100,0 -normalize[-1] 0,1 \
           -threshold[-1] "$(python3 -c "print(1-${s_density})")" \
           -resize[-1] "${width},${height},1,1" \
           -to_rgb[-1] \
           -blend screen,${s_opacity} \
           -output "$tmp" >/dev/null
    else
      gmic "$tmp" \
           -input "1,${height},1,1,0" \
           -srand $(stable_seed "${name}-scratches") \
           -noise[-1] 100,0 -normalize[-1] 0,1 \
           -threshold[-1] "$(python3 -c "print(1-${s_density})")" \
           -resize[-1] "${width},${height},1,1" \
           -to_rgb[-1] \
           -blend screen,${s_opacity} \
           -output "$tmp" >/dev/null
    fi
  fi

  # Layer 4: vignette (final multiply).
  if [[ "$(toml_get "$name" vignette enabled 2>/dev/null || echo false)" == "True" ]]; then
    local v_strength; v_strength=$(toml_get "$name" vignette strength)
    # Radial white→dark gradient, then multiply against the composite.
    gmic "$tmp" \
         -input "${width},${height},1,3,255" \
         -vignette[-1] "$(python3 -c "print(int(${v_strength}*100))"),0,0,0" \
         -blend multiply \
         -output "$tmp" >/dev/null
  fi

  mv "$tmp" "$out"
}

write_manifest() {
  local manifest="$TEXTURES_DIR/manifest.txt"
  : > "$manifest"
  local f name dims size hash
  for f in "$TEXTURES_DIR"/*.png; do
    [[ -e "$f" ]] || continue
    name=$(basename "$f" .png)
    dims=$(identify -format "%wx%h" "$f")
    size=$(stat -c %s "$f")
    hash=$(sha256sum "$f" | awk '{print $1}')
    printf '%s\t%s\t%sB\t%s\n' "$name" "$dims" "$size" "$hash" >> "$manifest"
  done
}

main() {
  local target="${1:-}"
  if [[ -n "$target" ]]; then
    render_texture "$target"
  else
    while IFS= read -r name; do
      render_texture "$name"
    done < <(toml_list_tables)
  fi
  write_manifest
}

main "$@"
