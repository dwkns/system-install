#!/usr/bin/env bash

ROOT_DIR="${ROOT_DIR:-$HOME/.system-config}"

# Load colours if available (works in bash too)
if [[ -r "$ROOT_DIR/lib/colours.sh" ]]; then
  # shellcheck disable=SC1090
  source "$ROOT_DIR/lib/colours.sh"
fi

has_cmd() { command -v "$1" >/dev/null 2>&1; }

log() { echo -e "${GREEN:-}==>${RESET:-} $*"; }
note() { echo -e "${CYAN:-}Note${RESET:-} $*"; }
warn() { echo -e "${YELLOW:-}Warning${RESET:-} $*"; }
error() { echo -e "${RED:-}Error${RESET:-} $*"; }

die() {
  error "$*"
  exit 1
}

timestamp() {
  date "+%Y%m%d-%H%M%S"
}

ensure_dir() {
  mkdir -p "$1"
}

confirm() {
  local prompt="${1:-Are you sure?} [y/N] "
  if [[ "${ASSUME_YES:-0}" == "1" ]]; then
    return 0
  fi
  read -r -p "$prompt" reply
  [[ "$reply" =~ ^[Yy]$ ]]
}

run() {
  if [[ "${DRY_RUN:-0}" == "1" ]]; then
    note "DRY RUN: $*"
    return 0
  fi
  "$@"
}

is_macos() {
  [[ "$(uname -s)" == "Darwin" ]]
}
