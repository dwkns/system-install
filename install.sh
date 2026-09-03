#!/usr/bin/env bash
# One command to set up a new Mac:
#
#   curl -fsSL https://raw.githubusercontent.com/dwkns/system-install/master/install.sh | bash
#
set -euo pipefail
ROOT_DIR="${ROOT_DIR:-$HOME/.system-config}"

# Xcode Command Line Tools — git needs them, and the install is a GUI prompt.
if ! xcode-select -p >/dev/null 2>&1; then
  echo "Installing Xcode Command Line Tools — accept the dialog, then re-run this."
  xcode-select --install
  exit 1
fi

if [[ -d "$ROOT_DIR/.git" ]]; then
  git -C "$ROOT_DIR" pull --ff-only
else
  git clone https://github.com/dwkns/system-install.git "$ROOT_DIR"
fi

exec "$ROOT_DIR/bin/sys" setup "$@"
