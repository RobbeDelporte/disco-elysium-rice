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

  # Base: a solid-fill image of the requested size.
  gmic -input "${width},${height},1,3" -fill "[$rgb]" -output "$out" >/dev/null
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
}

main "$@"
