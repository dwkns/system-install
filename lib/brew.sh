#!/usr/bin/env bash

ROOT_DIR="${ROOT_DIR:-$HOME/.system-config}"
BREWFILE="${BREWFILE:-$ROOT_DIR/Brewfile}"

# shellcheck disable=SC1090
source "$ROOT_DIR/lib/common.sh"

install_homebrew() {
  if has_cmd brew; then
    return 0
  fi

  if ! is_macos; then
    die "Homebrew install only supported on macOS"
  fi

  log "Installing Homebrew"
  run /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
}

brew_bundle() {
  [[ -r "$BREWFILE" ]] || die "Brewfile not found: $BREWFILE"
  install_homebrew
  log "Running brew bundle"
  run brew bundle --file "$BREWFILE"
}
