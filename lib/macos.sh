#!/usr/bin/env bash

ROOT_DIR="${ROOT_DIR:-$HOME/.system-config}"

# shellcheck disable=SC1090
source "$ROOT_DIR/lib/common.sh"

set_machine_name() {
  local default_name
  default_name="$(scutil --get LocalHostName || true)"
  local machine_name="${1:-$default_name}"

  if [[ -z "$machine_name" ]]; then
    die "Machine name is empty"
  fi

  log "Setting machine name to: $machine_name"
  run sudo scutil --set ComputerName "$machine_name"
  run sudo scutil --set HostName "$machine_name"
  run sudo scutil --set LocalHostName "$machine_name"
}

apply_macos_defaults() {
  local macos_file="$ROOT_DIR/dotfiles/.macos"
  if [[ -r "$macos_file" ]]; then
    log "Applying macOS defaults"
    # shellcheck disable=SC1090
    run bash "$macos_file"
  else
    warn "macOS defaults file not found: $macos_file"
  fi
}
