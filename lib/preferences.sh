#!/usr/bin/env bash

ROOT_DIR="${ROOT_DIR:-$HOME/.system-config}"
PREFERENCES_DIR="${PREFERENCES_DIR:-$ROOT_DIR/preferences}"
PREFERENCES_TARGET="$HOME/Library/Preferences"

# shellcheck disable=SC1090
source "$ROOT_DIR/lib/common.sh"

install_preferences() {
  local backup_root="${1:-$ROOT_DIR/backups/preferences-$(timestamp)}"
  ensure_dir "$backup_root"

  [[ -d "$PREFERENCES_DIR" ]] || return 0

  while IFS= read -r -d '' file; do
    local basename="${file#$PREFERENCES_DIR/}"
    local src="$file"
    local dst="$PREFERENCES_TARGET/$basename"

    if [[ -e "$dst" ]]; then
      ensure_dir "$backup_root/$(dirname "$basename")"
      run cp -a "$dst" "$backup_root/$basename"
    fi

    ensure_dir "$(dirname "$dst")"
    run cp -a "$src" "$dst"
  done < <(find "$PREFERENCES_DIR" -name "*.plist" -type f -print0)

  note "Preferences installed. Backup: $backup_root"
}

backup_preferences() {
  local target_dir="${1:-$PREFERENCES_DIR}"
  ensure_dir "$target_dir"

  [[ -d "$PREFERENCES_TARGET" ]] || return 0
  [[ -d "$PREFERENCES_DIR" ]] || return 0

  # Only backup preferences that exist in the repo
  while IFS= read -r -d '' file; do
    local basename="${file#$PREFERENCES_DIR/}"
    local src="$PREFERENCES_TARGET/$basename"
    local dst="$file"

    if [[ ! -e "$src" ]]; then
      warn "Missing on system: $src"
      continue
    fi

    ensure_dir "$(dirname "$dst")"
    run cp -a "$src" "$dst"
  done < <(find "$PREFERENCES_DIR" -name "*.plist" -type f -print0)

  note "Preferences backed up to $target_dir"
}
