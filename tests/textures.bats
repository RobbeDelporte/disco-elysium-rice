#!/usr/bin/env bats

load helpers

setup() {
  setup_repo
}

@test "build-textures.sh exists and is executable" {
  [ -x "$SCRIPT" ]
}

@test "build-textures.sh --help prints usage" {
  run "$SCRIPT" --help
  [ "$status" -eq 0 ]
  [[ "$output" == *"Usage:"* ]]
}

@test "lists texture names from config" {
  run_with_fixture --list
  [ "$status" -eq 0 ]
  [[ "$output" == *"sample"* ]]
}

@test "toml_get: reads scalar at dotted path" {
  run_with_fixture --get sample width
  [ "$status" -eq 0 ]
  [ "$output" = "64" ]
}

@test "toml_get: exits 2 on missing path" {
  run_with_fixture --get sample nonexistent
  [ "$status" -eq 2 ]
}

@test "toml_get: exits 3 when path resolves to a table" {
  run_with_fixture --get sample halation
  [ "$status" -eq 3 ]
}

@test "base fill: produces PNG of correct dimensions" {
  run_with_fixture sample
  [ "$status" -eq 0 ]
  out="$BATS_TEST_TMPDIR/sample.png"
  [ -f "$out" ]
  dims=$(identify -format "%wx%h" "$out")
  [ "$dims" = "64x48" ]
}

@test "base fill: dominant color matches base_color" {
  run_with_fixture sample
  [ "$status" -eq 0 ]
  out="$BATS_TEST_TMPDIR/sample.png"
  r=$(convert "$out" -format "%[fx:int(255*mean.r)]" info:)
  g=$(convert "$out" -format "%[fx:int(255*mean.g)]" info:)
  b=$(convert "$out" -format "%[fx:int(255*mean.b)]" info:)
  # #112233 = 17,34,51. Allow ±50 per channel (loose for future layers).
  (( r >= 0 && r <= 100 ))
  (( g >= 0 && g <= 100 ))
  (( b >= 0 && b <= 100 ))
}

@test "halation: top-right quadrant is warmer than bottom-left" {
  run_with_fixture sample
  [ "$status" -eq 0 ]
  out="$BATS_TEST_TMPDIR/sample.png"
  tr=$(convert "$out" -crop 32x24+32+0 +repage -format "%[fx:mean.r-mean.b]" info:)
  bl=$(convert "$out" -crop 32x24+0+24 +repage -format "%[fx:mean.r-mean.b]" info:)
  awk -v tr="$tr" -v bl="$bl" 'BEGIN { exit !(tr > bl + 0.02) }'
}

@test "grain: output has higher stddev than base-only" {
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

  run_with_fixture sample
  [ "$status" -eq 0 ]
  full_std=$(convert "$BATS_TEST_TMPDIR/sample.png" -format "%[fx:standard_deviation]" info:)

  awk -v b="$base_std" -v f="$full_std" 'BEGIN { exit !(f > b + 0.02) }'
}

@test "scratches: vertical variance exceeds horizontal variance" {
  run_with_fixture sample
  [ "$status" -eq 0 ]
  out="$BATS_TEST_TMPDIR/sample.png"
  # Column-average image → stddev measures horizontal variation (across columns).
  # Row-average image → stddev measures vertical variation (across rows).
  # Vertical scratches produce strong variation-across-columns but columns
  # are near-uniform top-to-bottom, so col_std should exceed row_std.
  col_std=$(convert "$out" -resize 64x1\! -format "%[fx:standard_deviation]" info:)
  row_std=$(convert "$out" -resize 1x48\! -format "%[fx:standard_deviation]" info:)
  awk -v c="$col_std" -v r="$row_std" 'BEGIN { exit !(c > r + 0.005) }'
}

@test "vignette: corners darker than center" {
  run_with_fixture sample
  [ "$status" -eq 0 ]
  out="$BATS_TEST_TMPDIR/sample.png"
  center=$(convert "$out" -crop 16x12+24+18 +repage -format "%[fx:mean]" info:)
  corner=$(convert "$out" -crop 16x12+0+0 +repage -format "%[fx:mean]" info:)
  awk -v c="$center" -v k="$corner" 'BEGIN { exit !(c > k + 0.03) }'
}

@test "determinism: two runs produce byte-identical output" {
  TEXTURES_CONFIG="$FIXTURE" TEXTURES_OUT_DIR="$BATS_TEST_TMPDIR/a" run "$SCRIPT" sample
  [ "$status" -eq 0 ]
  TEXTURES_CONFIG="$FIXTURE" TEXTURES_OUT_DIR="$BATS_TEST_TMPDIR/b" run "$SCRIPT" sample
  [ "$status" -eq 0 ]
  hash_a=$(sha256sum "$BATS_TEST_TMPDIR/a/sample.png" | awk '{print $1}')
  hash_b=$(sha256sum "$BATS_TEST_TMPDIR/b/sample.png" | awk '{print $1}')
  [ "$hash_a" = "$hash_b" ]
}

@test "manifest: records each generated texture with dims, size, sha256" {
  run_with_fixture
  [ "$status" -eq 0 ]
  manifest="$BATS_TEST_TMPDIR/manifest.txt"
  [ -f "$manifest" ]
  # Expect a line like: "sample<tab>64x48<tab><size>B<tab><hash>"
  run grep -E '^sample[[:space:]]+64x48[[:space:]]+[0-9]+B[[:space:]]+[a-f0-9]{64}$' "$manifest"
  [ "$status" -eq 0 ]
}

@test "arg: unknown texture name errors cleanly" {
  run_with_fixture nonexistent
  [ "$status" -ne 0 ]
  [[ "$output" == *"nonexistent"* ]]
  [[ "$output" == *"not found"* ]]
}

@test "arg: named build only writes the requested texture" {
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
