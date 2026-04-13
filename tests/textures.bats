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
