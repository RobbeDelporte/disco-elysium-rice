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
