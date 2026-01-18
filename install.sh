#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

ROOT_DIR="${ROOT_DIR:-$HOME/.system-config}"

echo "Starting install"

if [[ -d "$ROOT_DIR/.git" ]]; then
  echo "Updating existing repo in $ROOT_DIR"
  git -C "$ROOT_DIR" pull
else
  echo "Cloning repo into $ROOT_DIR"
  git clone https://github.com/dwkns/system-install.git "$ROOT_DIR"
fi

echo "Running bootstrap"
exec "$ROOT_DIR/bin/bootstrap" "$@"