# Film-Artifact Texture Pipeline Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a deterministic PNG texture generator for the Disco Elysium rice — a `scripts/build-textures.sh` that reads `assets/textures/textures.toml`, layers film artifacts (halation, grain, scratches, vignette) on a solid base, and emits PNGs consumers can reference.

**Architecture:** A single bash script drives G'MIC CLI to compose per-texture PNGs. Config is parsed via Python 3's `tomllib` (avoiding bash TOML pain). Each artifact is one G'MIC pipeline stage with parameters from the config. Tests use `bats-core` (shell test runner) with ImageMagick's `identify`/`convert` for asserting on output properties (dimensions, per-region brightness, standard deviation, byte-identity across reruns). Determinism comes from seeding every stochastic filter with a stable hash of the texture name.

**Tech Stack:**
- `gmic` — image filter pipeline
- `imagemagick` — `identify`, `convert` for test assertions
- `python3` (≥3.11, for `tomllib`) — TOML parsing
- `bats` (bats-core) — shell tests
- `sha256sum`, `coreutils` — hashing / manifest

---

## File Map

- Create: `scripts/build-textures.sh` — main script (executable)
- Create: `assets/textures/textures.toml` — declarative config (one table per texture)
- Create: `assets/textures/.gitkeep` — keep directory in git before first build
- Create: `assets/textures/manifest.txt` — generated on each build
- Create: `tests/textures.bats` — test suite
- Create: `tests/fixtures/textures.toml` — config fixture used by tests
- Create: `tests/helpers.bash` — shared test helpers (invoke script with fixture, read pixel stats)
- Modify: `packages/pacman.txt` — add `gmic`, `imagemagick`, `bats` (python3 is already base)

Outputs (`assets/textures/*.png`) are committed to git once built, per spec.

---

### Task 1: Scaffolding and dependencies

Creates directory layout, empty config, executable stub, and adds the packages. Ensures nothing downstream fails on missing dirs/deps.

**Files:**
- Create: `scripts/build-textures.sh`
- Create: `assets/textures/.gitkeep`
- Create: `assets/textures/textures.toml`
- Create: `tests/textures.bats`
- Modify: `packages/pacman.txt`

- [ ] **Step 1: Write failing bats test**

Create `tests/textures.bats`:

```bash
#!/usr/bin/env bats

setup() {
  REPO_ROOT="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"
  SCRIPT="$REPO_ROOT/scripts/build-textures.sh"
}

@test "build-textures.sh exists and is executable" {
  [ -x "$SCRIPT" ]
}

@test "build-textures.sh --help prints usage" {
  run "$SCRIPT" --help
  [ "$status" -eq 0 ]
  [[ "$output" == *"Usage:"* ]]
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `bats tests/textures.bats`
Expected: both tests FAIL (script missing).

- [ ] **Step 3: Create scaffolding and minimal script**

Create `assets/textures/.gitkeep` (empty file).

Create `assets/textures/textures.toml`:

```toml
# Film-artifact texture definitions.
# One table per texture; each produces assets/textures/<name>.png.
# See docs/superpowers/specs/2026-04-13-film-artifact-texture-pipeline-design.md
```

Create `scripts/build-textures.sh`:

```bash
#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEXTURES_DIR="$REPO_ROOT/assets/textures"
CONFIG="$TEXTURES_DIR/textures.toml"

usage() {
  cat <<EOF
Usage: build-textures.sh [--help] [<texture_name>]

Generates PNG textures defined in $CONFIG into $TEXTURES_DIR.
With no argument, builds all textures. With a name, builds only that one.
EOF
}

case "${1:-}" in
  --help|-h) usage; exit 0 ;;
esac

echo "build-textures.sh: not yet implemented" >&2
exit 1
```

Make it executable:

```bash
chmod +x scripts/build-textures.sh
```

Modify `packages/pacman.txt` — append these lines (after existing entries):

```
gmic
imagemagick
bats
```

- [ ] **Step 4: Run test to verify it passes**

Run: `bats tests/textures.bats`
Expected: both tests PASS.

- [ ] **Step 5: Commit**

```bash
git add scripts/build-textures.sh assets/textures/.gitkeep assets/textures/textures.toml tests/textures.bats packages/pacman.txt
git commit -m "feat(textures): scaffold build-textures.sh and dependencies"
```

---

### Task 2: TOML config parsing via python3 tomllib

Shell TOML parsing is brittle. Shell out to `python3` with `tomllib` for every config read. This task adds a helper that lists the texture names (top-level tables) and a helper that reads an arbitrary scalar at a dotted path.

**Files:**
- Modify: `scripts/build-textures.sh`
- Create: `tests/fixtures/textures.toml`
- Create: `tests/helpers.bash`
- Modify: `tests/textures.bats`

- [ ] **Step 1: Write fixture config**

Create `tests/fixtures/textures.toml`:

```toml
[sample]
width = 64
height = 48
base_color = "#112233"

[sample.halation]
enabled = true
color = "#ff8800"
strength = 0.5
origin = "top-right"
radius = 0.7
```

- [ ] **Step 2: Write shared test helper**

Create `tests/helpers.bash`:

```bash
# Shared helpers for texture pipeline tests.

setup_repo() {
  REPO_ROOT="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"
  SCRIPT="$REPO_ROOT/scripts/build-textures.sh"
  FIXTURE="$REPO_ROOT/tests/fixtures/textures.toml"
}

# Invoke the script with a fixture config instead of the real one.
# Usage: run_with_fixture <args...>
run_with_fixture() {
  TEXTURES_CONFIG="$FIXTURE" \
  TEXTURES_OUT_DIR="$BATS_TEST_TMPDIR" \
    run "$SCRIPT" "$@"
}
```

- [ ] **Step 3: Write failing tests for the config helpers**

Append to `tests/textures.bats`:

```bash
load helpers

@test "lists texture names from config" {
  setup_repo
  TEXTURES_CONFIG="$FIXTURE" run "$SCRIPT" --list
  [ "$status" -eq 0 ]
  [[ "$output" == *"sample"* ]]
}
```

- [ ] **Step 4: Run tests — verify the new one fails**

Run: `bats tests/textures.bats`
Expected: the new "lists texture names" test FAILS (no `--list` flag yet); earlier tests still pass.

- [ ] **Step 5: Implement config-reading helpers in the script**

Replace the body of `scripts/build-textures.sh` with:

```bash
#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEXTURES_DIR="${TEXTURES_OUT_DIR:-$REPO_ROOT/assets/textures}"
CONFIG="${TEXTURES_CONFIG:-$REPO_ROOT/assets/textures/textures.toml}"

require_cmd() { command -v "$1" >/dev/null 2>&1 || { echo "error: $1 is required but not installed" >&2; exit 1; }; }
require_cmd gmic
require_cmd python3
require_cmd identify
require_cmd sha256sum

usage() {
  cat <<EOF
Usage: build-textures.sh [--help] [--list] [<texture_name>]

Generates PNG textures defined in \$CONFIG into \$TEXTURES_DIR.
  --help   Show this message.
  --list   Print the names of every texture in the config and exit.

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
esac

echo "build-textures.sh: rendering not yet implemented" >&2
exit 1
```

- [ ] **Step 6: Run tests**

Run: `bats tests/textures.bats`
Expected: all tests PASS.

- [ ] **Step 7: Commit**

```bash
git add scripts/build-textures.sh tests/textures.bats tests/helpers.bash tests/fixtures/textures.toml
git commit -m "feat(textures): add TOML config helpers and --list flag"
```

---

### Task 3: Base fill texture

Produces a solid-colored PNG at the configured dimensions. This is the foundation every other layer composites onto.

**Files:**
- Modify: `scripts/build-textures.sh`
- Modify: `tests/textures.bats`

- [ ] **Step 1: Write failing test**

Append to `tests/textures.bats`:

```bash
@test "base fill: produces PNG of correct dimensions" {
  setup_repo
  run_with_fixture sample
  [ "$status" -eq 0 ]
  out="$BATS_TEST_TMPDIR/sample.png"
  [ -f "$out" ]
  dims=$(identify -format "%wx%h" "$out")
  [ "$dims" = "64x48" ]
}

@test "base fill: dominant color matches base_color" {
  setup_repo
  run_with_fixture sample
  [ "$status" -eq 0 ]
  out="$BATS_TEST_TMPDIR/sample.png"
  # Average color of an image dominated by #112233 should be near #112233.
  # Read mean per channel (0..1); scale to 0..255; allow wide tolerance so
  # later artifact layers that shift means (halation, vignette) still pass.
  r=$(convert "$out" -format "%[fx:int(255*mean.r)]" info:)
  g=$(convert "$out" -format "%[fx:int(255*mean.g)]" info:)
  b=$(convert "$out" -format "%[fx:int(255*mean.b)]" info:)
  # #112233 = 17,34,51. Allow ±30 per channel (loose for future layers).
  (( r >= 0 && r <= 60 ))
  (( g >= 10 && g <= 70 ))
  (( b >= 25 && b <= 90 ))
}
```

- [ ] **Step 2: Run tests — verify new ones fail**

Run: `bats tests/textures.bats`
Expected: new tests FAIL (script still exits 1 for render).

- [ ] **Step 3: Implement base fill**

In `scripts/build-textures.sh`, replace the final `echo "… not yet implemented" >&2; exit 1` block with a dispatch and a `render_texture` function. The script should end like this:

```bash
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
```

Also remove the old `echo "… not yet implemented"` lines if they remain.

- [ ] **Step 4: Run tests**

Run: `bats tests/textures.bats`
Expected: all tests PASS. If the `gmic -fill "[$rgb]"` form errors on your G'MIC version, try `gmic ${width},${height},1,3,255 -fill "I=[${rgb}]" -output "$out"` — the assertion is on the output PNG, not the G'MIC syntax.

- [ ] **Step 5: Commit**

```bash
git add scripts/build-textures.sh tests/textures.bats
git commit -m "feat(textures): render solid base fill to PNG"
```

---

### Task 4: Halation layer

A warm radial gradient screen-blended onto the base, weighted toward a configurable origin corner. This is the most signature artifact — the "sunset through a window" warm bleed.

**Files:**
- Modify: `scripts/build-textures.sh`
- Modify: `tests/textures.bats`
- Modify: `tests/fixtures/textures.toml` (already has halation)

- [ ] **Step 1: Write failing test**

Append to `tests/textures.bats`:

```bash
@test "halation: top-right quadrant is warmer than bottom-left" {
  setup_repo
  run_with_fixture sample
  [ "$status" -eq 0 ]
  out="$BATS_TEST_TMPDIR/sample.png"
  # Mean R-minus-B in top-right 32x24 vs bottom-left 32x24.
  # Halation color #ff8800 (warm) should lift R relative to B in the TR quadrant.
  tr=$(convert "$out" -crop 32x24+32+0 +repage -format "%[fx:mean.r-mean.b]" info:)
  bl=$(convert "$out" -crop 32x24+0+24 +repage -format "%[fx:mean.r-mean.b]" info:)
  awk -v tr="$tr" -v bl="$bl" 'BEGIN { exit !(tr > bl + 0.02) }'
}
```

- [ ] **Step 2: Run tests — verify new one fails**

Run: `bats tests/textures.bats`
Expected: "halation" test FAILS (no halation logic yet).

- [ ] **Step 3: Implement halation**

Add this helper function above `render_texture` in `scripts/build-textures.sh`:

```bash
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
```

Extend `render_texture` — after the base-fill G'MIC call, before the final `-output`, insert halation composition. Replace the single-line base-fill command with a pipeline:

```bash
render_texture() {
  local name="$1"
  local out="$TEXTURES_DIR/$name.png"

  local width height base_color
  width=$(toml_get "$name" width)
  height=$(toml_get "$name" height)
  base_color=$(toml_get "$name" base_color)
  local rgb; rgb=$(hex_to_rgb_triple "$base_color")

  mkdir -p "$TEXTURES_DIR"

  # Build a temp work file; compose layers, then move to final location atomically.
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
    # Pixel-space center and radius.
    local px py rad
    px=$(python3 -c "print(int(${cx}*(${width}-1)))")
    py=$(python3 -c "print(int(${cy}*(${height}-1)))")
    rad=$(python3 -c "print(int(${h_radius}*max(${width},${height})))")

    # Generate a halation layer: black canvas, draw a soft warm disc, blur.
    # Then screen-blend over the base using G'MIC blend mode.
    gmic "$tmp" \
         -input "${width},${height},1,3" -fill "[0,0,0]" \
         -ellipse[-1] ${px},${py},${rad},${rad},0,${h_strength},${h_rgb} \
         -blur[-1] "$(python3 -c "print(max(1, ${rad}//4))"),2" \
         -blend screen \
         -output "$tmp" >/dev/null
  fi

  mv "$tmp" "$out"
}
```

- [ ] **Step 4: Run tests**

Run: `bats tests/textures.bats`
Expected: all tests PASS. If `-ellipse` syntax varies by G'MIC version, the alternative is to write a pure expression layer: `-input ${width},${height},1,3,"R=${h_rgb_r};G=${h_rgb_g};B=${h_rgb_b};val=exp(-((x-${px})^2+(y-${py})^2)/(2*(${rad}/2)^2))*${h_strength}*255;c==0?R*val/255:c==1?G*val/255:B*val/255"` — test assertion is still the same.

- [ ] **Step 5: Commit**

```bash
git add scripts/build-textures.sh tests/textures.bats
git commit -m "feat(textures): compose halation layer with configurable origin"
```

---

### Task 5: Grain layer

Silver-halide grain multiplied over the composite. Uses G'MIC's `-noise` core command (stable across versions). Monochrome by default — pick up the luminance character without tinting.

**Files:**
- Modify: `scripts/build-textures.sh`
- Modify: `tests/textures.bats`
- Modify: `tests/fixtures/textures.toml`

- [ ] **Step 1: Add grain section to fixture**

Append to `tests/fixtures/textures.toml`:

```toml
[sample.grain]
enabled = true
iso = 800
opacity = 0.25
monochrome = true
```

- [ ] **Step 2: Write failing test**

Append to `tests/textures.bats`:

```bash
@test "grain: output has higher stddev than base-only" {
  setup_repo
  # Reference stddev: base fill only (tiny, near-zero variance).
  tmp_fix="$BATS_TEST_TMPDIR/base-only.toml"
  cat > "$tmp_fix" <<'EOF'
[sample]
width = 64
height = 48
base_color = "#112233"
EOF
  TEXTURES_CONFIG="$tmp_fix" TEXTURES_OUT_DIR="$BATS_TEST_TMPDIR/baseout" \
    run "$SCRIPT" sample
  [ "$status" -eq 0 ]
  base_std=$(convert "$BATS_TEST_TMPDIR/baseout/sample.png" -format "%[fx:standard_deviation]" info:)

  # Actual stddev with full fixture (halation + grain enabled).
  run_with_fixture sample
  [ "$status" -eq 0 ]
  full_std=$(convert "$BATS_TEST_TMPDIR/sample.png" -format "%[fx:standard_deviation]" info:)

  # Grain should add ≥ 0.02 (on 0..1 scale) of extra variation beyond halation.
  awk -v b="$base_std" -v f="$full_std" 'BEGIN { exit !(f > b + 0.02) }'
}
```

- [ ] **Step 3: Run tests — verify new one fails**

Run: `bats tests/textures.bats`
Expected: "grain" test FAILS.

- [ ] **Step 4: Implement grain**

Add a helper function above `render_texture`:

```bash
# Map ISO to a noise standard deviation (0..100-ish in G'MIC terms).
# ISO 400 → ~6, ISO 800 → ~10, ISO 1600 → ~16. Linear, clamped.
iso_to_noise_std() {
  python3 -c "print(max(2, min(30, ${1} / 80)))"
}
```

Extend `render_texture` — append after the halation block, before `mv`:

```bash
  # Layer 2: grain.
  if [[ "$(toml_get "$name" grain enabled 2>/dev/null || echo false)" == "True" ]]; then
    local g_iso g_opacity g_mono g_std
    g_iso=$(toml_get "$name" grain iso)
    g_opacity=$(toml_get "$name" grain opacity)
    g_mono=$(toml_get "$name" grain monochrome)
    g_std=$(iso_to_noise_std "$g_iso")

    # Build a grain layer: neutral gray (128), then add gaussian noise, then
    # blend "multiply" — but multiply would darken too much. Use "overlay"
    # blend at the configured opacity by manipulating the layer's alpha via
    # `-j. 0` is not appropriate; we mix manually via `-blend overlay,<op>`.
    local mono_cmd=""
    if [[ "$g_mono" == "True" ]]; then
      mono_cmd="-channels[-1] 0,0 -to_rgb[-1]"   # collapse to luma, expand to RGB
    fi

    gmic "$tmp" \
         -input "${width},${height},1,3,128" \
         -noise[-1] "${g_std},0" \
         ${mono_cmd} \
         -blend overlay,${g_opacity} \
         -output "$tmp" >/dev/null
  fi
```

- [ ] **Step 5: Run tests**

Run: `bats tests/textures.bats`
Expected: all tests PASS.

- [ ] **Step 6: Commit**

```bash
git add scripts/build-textures.sh tests/textures.bats tests/fixtures/textures.toml
git commit -m "feat(textures): add silver-halide grain layer"
```

---

### Task 6: Scratches layer

Vertical emulsion-damage streaks, screen-blended at low opacity. Implemented as a 1-pixel-tall noise band stretched vertically — this gives long continuous vertical lines rather than isotropic noise.

**Files:**
- Modify: `scripts/build-textures.sh`
- Modify: `tests/textures.bats`
- Modify: `tests/fixtures/textures.toml`

- [ ] **Step 1: Add scratches to fixture**

Append to `tests/fixtures/textures.toml`:

```toml
[sample.scratches]
enabled = true
density = 0.08
opacity = 0.10
orientation = "vertical"
```

- [ ] **Step 2: Write failing test**

Append to `tests/textures.bats`:

```bash
@test "scratches: vertical variance exceeds horizontal variance" {
  setup_repo
  run_with_fixture sample
  [ "$status" -eq 0 ]
  out="$BATS_TEST_TMPDIR/sample.png"
  # Column-average image → stddev measures horizontal variation.
  # Row-average image → stddev measures vertical variation.
  # Vertical scratches produce strong horizontal-variation signal (differences
  # between columns) but weak vertical-variation (columns are uniform top-to-bottom).
  col_std=$(convert "$out" -resize 64x1\! -format "%[fx:standard_deviation]" info:)
  row_std=$(convert "$out" -resize 1x48\! -format "%[fx:standard_deviation]" info:)
  # Expect col_std (variation across columns) to be meaningfully > row_std.
  awk -v c="$col_std" -v r="$row_std" 'BEGIN { exit !(c > r + 0.005) }'
}
```

- [ ] **Step 3: Run tests — verify new one fails**

Run: `bats tests/textures.bats`
Expected: "scratches" test FAILS (or passes weakly — grain alone is isotropic so col_std ≈ row_std).

- [ ] **Step 4: Implement scratches**

In `render_texture`, append after the grain block:

```bash
  # Layer 3: scratches (vertical emulsion damage).
  if [[ "$(toml_get "$name" scratches enabled 2>/dev/null || echo false)" == "True" ]]; then
    local s_density s_opacity s_orient
    s_density=$(toml_get "$name" scratches density)
    s_opacity=$(toml_get "$name" scratches opacity)
    s_orient=$(toml_get "$name" scratches orientation)

    # Noise threshold that leaves roughly density fraction of columns as scratches.
    # For vertical orientation: generate a 1-tall noise row, threshold it to
    # density, stretch to full height. Horizontal: transpose.
    if [[ "$s_orient" == "vertical" ]]; then
      gmic "$tmp" \
           -input "${width},1,1,1,0" \
           -noise[-1] 100,0 -normalize[-1] 0,1 \
           -threshold[-1] "$(python3 -c "print(1-${s_density})")" \
           -resize[-1] "${width},${height},1,1" \
           -to_rgb[-1] \
           -blend screen,${s_opacity} \
           -output "$tmp" >/dev/null
    else
      gmic "$tmp" \
           -input "1,${height},1,1,0" \
           -noise[-1] 100,0 -normalize[-1] 0,1 \
           -threshold[-1] "$(python3 -c "print(1-${s_density})")" \
           -resize[-1] "${width},${height},1,1" \
           -to_rgb[-1] \
           -blend screen,${s_opacity} \
           -output "$tmp" >/dev/null
    fi
  fi
```

- [ ] **Step 5: Run tests**

Run: `bats tests/textures.bats`
Expected: all tests PASS.

- [ ] **Step 6: Commit**

```bash
git add scripts/build-textures.sh tests/textures.bats tests/fixtures/textures.toml
git commit -m "feat(textures): add vertical emulsion scratches layer"
```

---

### Task 7: Vignette layer

Multiplicative radial darkening at the corners. Last in the stack — an optical property of the whole frame.

**Files:**
- Modify: `scripts/build-textures.sh`
- Modify: `tests/textures.bats`
- Modify: `tests/fixtures/textures.toml`

- [ ] **Step 1: Add vignette to fixture**

Append to `tests/fixtures/textures.toml`:

```toml
[sample.vignette]
enabled = true
strength = 0.45
```

- [ ] **Step 2: Write failing test**

Append to `tests/textures.bats`:

```bash
@test "vignette: corners darker than center" {
  setup_repo
  run_with_fixture sample
  [ "$status" -eq 0 ]
  out="$BATS_TEST_TMPDIR/sample.png"
  center=$(convert "$out" -crop 16x12+24+18 +repage -format "%[fx:mean]" info:)
  corner=$(convert "$out" -crop 16x12+0+0 +repage -format "%[fx:mean]" info:)
  awk -v c="$center" -v k="$corner" 'BEGIN { exit !(c > k + 0.03) }'
}
```

- [ ] **Step 3: Run tests — verify new one fails**

Run: `bats tests/textures.bats`
Expected: "vignette" test FAILS.

- [ ] **Step 4: Implement vignette**

In `render_texture`, append after the scratches block, before `mv`:

```bash
  # Layer 4: vignette (final multiply).
  if [[ "$(toml_get "$name" vignette enabled 2>/dev/null || echo false)" == "True" ]]; then
    local v_strength; v_strength=$(toml_get "$name" vignette strength)
    # Radial white→dark gradient, then multiply against the composite.
    gmic "$tmp" \
         -input "${width},${height},1,3,255" \
         -vignette[-1] "$(python3 -c "print(int(${v_strength}*100))"),0,0,0 \
         -blend multiply \
         -output "$tmp" >/dev/null
  fi
```

If `-vignette` isn't available on the installed G'MIC version, replace with a hand-built radial mask:

```bash
  if [[ "$(toml_get "$name" vignette enabled 2>/dev/null || echo false)" == "True" ]]; then
    local v_strength; v_strength=$(toml_get "$name" vignette strength)
    gmic "$tmp" \
         -input "${width},${height},1,3,"\
"R=1-${v_strength}*(sqrt((x-${width}/2)^2+(y-${height}/2)^2)/sqrt((${width}/2)^2+(${height}/2)^2));R*255" \
         -blend multiply \
         -output "$tmp" >/dev/null
  fi
```

- [ ] **Step 5: Run tests**

Run: `bats tests/textures.bats`
Expected: all tests PASS.

- [ ] **Step 6: Commit**

```bash
git add scripts/build-textures.sh tests/textures.bats tests/fixtures/textures.toml
git commit -m "feat(textures): add radial vignette layer"
```

---

### Task 8: Deterministic seeding

Byte-identical output across reruns. Seed all stochastic G'MIC operations (`-noise`) with a stable hash derived from the texture name.

**Files:**
- Modify: `scripts/build-textures.sh`
- Modify: `tests/textures.bats`

- [ ] **Step 1: Write failing test**

Append to `tests/textures.bats`:

```bash
@test "determinism: two runs produce byte-identical output" {
  setup_repo
  TEXTURES_CONFIG="$FIXTURE" TEXTURES_OUT_DIR="$BATS_TEST_TMPDIR/a" run "$SCRIPT" sample
  [ "$status" -eq 0 ]
  TEXTURES_CONFIG="$FIXTURE" TEXTURES_OUT_DIR="$BATS_TEST_TMPDIR/b" run "$SCRIPT" sample
  [ "$status" -eq 0 ]
  hash_a=$(sha256sum "$BATS_TEST_TMPDIR/a/sample.png" | awk '{print $1}')
  hash_b=$(sha256sum "$BATS_TEST_TMPDIR/b/sample.png" | awk '{print $1}')
  [ "$hash_a" = "$hash_b" ]
}
```

- [ ] **Step 2: Run test — verify it fails**

Run: `bats tests/textures.bats`
Expected: "determinism" test FAILS (noise uses random seed).

- [ ] **Step 3: Implement stable seeding**

Add a helper at the top of the rendering section:

```bash
# Compute a stable 32-bit seed from a texture name (for G'MIC srand).
stable_seed() {
  local name="$1"
  # Take the first 8 hex chars of sha256, parse as int, mask to 31 bits (positive).
  local h; h=$(printf '%s' "$name" | sha256sum | cut -c1-8)
  python3 -c "print(int('$h', 16) & 0x7fffffff)"
}
```

Modify `render_texture` to `srand` before each stochastic step. Prepend each `gmic` call that uses `-noise` with `-srand <seed>`. For grain:

```bash
    gmic "$tmp" \
         -input "${width},${height},1,3,128" \
         -srand $(stable_seed "${name}-grain") \
         -noise[-1] "${g_std},0" \
         ${mono_cmd} \
         -blend overlay,${g_opacity} \
         -output "$tmp" >/dev/null
```

For scratches (both branches):

```bash
    gmic "$tmp" \
         -input "${width},1,1,1,0" \
         -srand $(stable_seed "${name}-scratches") \
         -noise[-1] 100,0 -normalize[-1] 0,1 \
         ...
```

Halation has no randomness (pure deterministic gradient); no srand needed. Vignette is deterministic; no srand needed.

- [ ] **Step 4: Run tests**

Run: `bats tests/textures.bats`
Expected: all tests PASS.

- [ ] **Step 5: Commit**

```bash
git add scripts/build-textures.sh tests/textures.bats
git commit -m "feat(textures): seed stochastic filters for byte-identical reruns"
```

---

### Task 9: Manifest generation

After each build, write `assets/textures/manifest.txt` — one line per output with name, dimensions, file size, sha256. Reviewers can diff the manifest to see texture changes without viewing binary PNGs.

**Files:**
- Modify: `scripts/build-textures.sh`
- Modify: `tests/textures.bats`

- [ ] **Step 1: Write failing test**

Append to `tests/textures.bats`:

```bash
@test "manifest: records each generated texture with dims, size, sha256" {
  setup_repo
  run_with_fixture
  [ "$status" -eq 0 ]
  manifest="$BATS_TEST_TMPDIR/manifest.txt"
  [ -f "$manifest" ]
  # Expect a line like: "sample  64x48  <size>B  <hash>"
  run grep -E '^sample[[:space:]]+64x48[[:space:]]+[0-9]+B[[:space:]]+[a-f0-9]{64}$' "$manifest"
  [ "$status" -eq 0 ]
}
```

- [ ] **Step 2: Run test — verify it fails**

Run: `bats tests/textures.bats`
Expected: "manifest" test FAILS.

- [ ] **Step 3: Implement manifest writing**

Modify `main` in `scripts/build-textures.sh`:

```bash
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
```

- [ ] **Step 4: Run tests**

Run: `bats tests/textures.bats`
Expected: all tests PASS. Note: the grep regex uses `[[:space:]]+` which matches tab or space — `printf '\t'` emits tab, compatible.

- [ ] **Step 5: Commit**

```bash
git add scripts/build-textures.sh tests/textures.bats
git commit -m "feat(textures): write manifest.txt with dims, size, sha256 per output"
```

---

### Task 10: Single-texture arg and unknown-name handling

`./scripts/build-textures.sh launcher` builds just `launcher`. `./scripts/build-textures.sh nonexistent` exits 1 with a helpful message.

**Files:**
- Modify: `scripts/build-textures.sh`
- Modify: `tests/textures.bats`

- [ ] **Step 1: Write failing tests**

Append to `tests/textures.bats`:

```bash
@test "arg: unknown texture name errors cleanly" {
  setup_repo
  run_with_fixture nonexistent
  [ "$status" -ne 0 ]
  [[ "$output" == *"nonexistent"* ]]
  [[ "$output" == *"not found"* ]]
}

@test "arg: named build only writes the requested texture" {
  setup_repo
  # Add a second fixture texture by writing a temp config.
  tmp_fix="$BATS_TEST_TMPDIR/two.toml"
  cat > "$tmp_fix" <<'EOF'
[one]
width = 32
height = 32
base_color = "#000000"

[two]
width = 32
height = 32
base_color = "#ffffff"
EOF
  TEXTURES_CONFIG="$tmp_fix" TEXTURES_OUT_DIR="$BATS_TEST_TMPDIR/out" \
    run "$SCRIPT" one
  [ "$status" -eq 0 ]
  [ -f "$BATS_TEST_TMPDIR/out/one.png" ]
  [ ! -f "$BATS_TEST_TMPDIR/out/two.png" ]
}
```

- [ ] **Step 2: Run tests — verify they fail**

Run: `bats tests/textures.bats`
Expected: unknown-name test FAILS (currently the script attempts to read missing keys and errors differently); named-build test likely passes already (main dispatches correctly) but may fail due to toml_get exiting non-zero in unexpected ways.

- [ ] **Step 3: Implement clean unknown-name error**

Modify `render_texture` to validate name first:

```bash
render_texture() {
  local name="$1"

  # Validate: texture must exist as a top-level table.
  if ! toml_list_tables | grep -Fxq "$name"; then
    echo "error: texture '$name' not found in $CONFIG" >&2
    exit 1
  fi

  local out="$TEXTURES_DIR/$name.png"
  # ... rest unchanged
}
```

- [ ] **Step 4: Run tests**

Run: `bats tests/textures.bats`
Expected: all tests PASS.

- [ ] **Step 5: Commit**

```bash
git add scripts/build-textures.sh tests/textures.bats
git commit -m "feat(textures): validate texture name, error on unknown"
```

---

### Task 11: Launcher defaults and acceptance

Populate the real `assets/textures/textures.toml` with the `[launcher]` entry from the spec, build, commit the PNG + manifest, and perform the subjective acceptance check against `references/disco-elysium/menu3.jpg`.

**Files:**
- Modify: `assets/textures/textures.toml`
- Create: `assets/textures/launcher.png` (generated)
- Modify: `assets/textures/manifest.txt` (generated)

- [ ] **Step 1: Write the launcher config**

Replace the contents of `assets/textures/textures.toml` with:

```toml
# Film-artifact texture definitions.
# One table per texture; each produces assets/textures/<name>.png.
# See docs/superpowers/specs/2026-04-13-film-artifact-texture-pipeline-design.md

[launcher]
width = 500
height = 420
base_color = "#1a2d2f"

[launcher.halation]
enabled = true
color = "#eb6408"
strength = 0.55
origin = "top-right"
radius = 0.7

[launcher.grain]
enabled = true
iso = 800
opacity = 0.25
monochrome = true

[launcher.scratches]
enabled = true
density = 0.08
opacity = 0.10
orientation = "vertical"

[launcher.vignette]
enabled = true
strength = 0.35
```

- [ ] **Step 2: Build the launcher texture**

```bash
./scripts/build-textures.sh launcher
```

Expected: exits 0; `assets/textures/launcher.png` exists at 500×420; `assets/textures/manifest.txt` contains a `launcher` line.

- [ ] **Step 3: Verify**

```bash
identify -format "%wx%h\n" assets/textures/launcher.png
cat assets/textures/manifest.txt
```

Expected: `500x420`; manifest line with dims, size, and sha256.

- [ ] **Step 4: Subjective acceptance against menu3**

Open both images side-by-side (any viewer):

```bash
xdg-open references/disco-elysium/menu3.jpg &
xdg-open assets/textures/launcher.png &
```

Confirm (visually — this is the spec's acceptance criterion #7):
- The launcher texture reads as dark teal with warm bleed in the top-right corner
- Grain is visible but not overwhelming
- Vertical scratches are faint, not dominant
- Corners darken compared to center
- Overall aesthetic family matches menu3's postcard backdrop

If any dimension feels wrong, tune the relevant knob in `textures.toml` (e.g., lower `grain.opacity` if grain is too loud, raise `halation.strength` if warmth reads too subtle) and rerun `./scripts/build-textures.sh launcher`.

- [ ] **Step 5: Run the full test suite once more**

Run: `bats tests/textures.bats`
Expected: all tests PASS.

- [ ] **Step 6: Commit**

```bash
git add assets/textures/textures.toml assets/textures/launcher.png assets/textures/manifest.txt
git commit -m "feat(textures): generate launcher texture from spec defaults"
```

---

## Acceptance Check (from spec)

After Task 11, verify each spec acceptance criterion:

1. ✓ `scripts/build-textures.sh` exists, executable, invokable with and without name (Tasks 1, 10)
2. ✓ `assets/textures/textures.toml` has `[launcher]` with spec defaults (Task 11)
3. ✓ Running produces `assets/textures/launcher.png` at 500×420 with halation/grain/scratches/vignette (Tasks 3–7, 11)
4. ✓ Re-running produces byte-identical output (Task 8)
5. ✓ `manifest.txt` lists each generated texture (Task 9)
6. ✓ `packages/pacman.txt` includes `gmic` (Task 1)
7. ✓ Subjective menu3 comparison (Task 11, step 4)
