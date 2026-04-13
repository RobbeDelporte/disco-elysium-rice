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
