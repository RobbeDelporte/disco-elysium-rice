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

echo "build-textures.sh: rendering not yet implemented" >&2
exit 1
