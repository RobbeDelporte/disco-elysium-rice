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
  # #112233 = 17,34,51. Allow ±30 per channel (loose for future layers).
  (( r >= 0 && r <= 60 ))
  (( g >= 10 && g <= 70 ))
  (( b >= 25 && b <= 90 ))
}
