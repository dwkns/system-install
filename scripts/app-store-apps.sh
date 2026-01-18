#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

ROOT_DIR="${ROOT_DIR:-$HOME/.system-config}"

if [[ -x "$ROOT_DIR/bin/mas" ]]; then
  exec "$ROOT_DIR/bin/mas"
fi

echo "ERROR: Unable to find $ROOT_DIR/bin/mas"
exit 1