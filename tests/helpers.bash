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
