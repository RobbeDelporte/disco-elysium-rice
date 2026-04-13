#!/usr/bin/env bats

load helpers

setup() {
  REPO_ROOT="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"
  SCRIPT="$REPO_ROOT/scripts/build-textures.sh"
  FIXTURE="$REPO_ROOT/tests/fixtures/textures.toml"
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
  setup_repo
  TEXTURES_CONFIG="$FIXTURE" run "$SCRIPT" --list
  [ "$status" -eq 0 ]
  [[ "$output" == *"sample"* ]]
}
