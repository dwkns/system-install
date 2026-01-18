#!/usr/bin/env bash

ROOT_DIR="${ROOT_DIR:-$HOME/.system-config}"
DOTFILES_LIST="${DOTFILES_LIST:-$ROOT_DIR/config/.dotfiles}"

# shellcheck disable=SC1090
source "$ROOT_DIR/lib/common.sh"

read_dotfiles() {
  [[ -r "$DOTFILES_LIST" ]] || die "Dotfiles list not found: $DOTFILES_LIST"
  grep -v '^\s*#' "$DOTFILES_LIST" | sed '/^\s*$/d'
}

install_dotfiles() {
  local backup_root="${1:-$ROOT_DIR/backups/dotfiles-$(timestamp)}"
  ensure_dir "$backup_root"

  while IFS= read -r file; do
    local src="$ROOT_DIR/dotfiles/$file"
    local dst="$HOME/$file"

    [[ ! -e "$src" ]] && { warn "Missing in repo: $src"; continue; }

    if [[ -e "$dst" ]]; then
      ensure_dir "$backup_root/$(dirname "$file")"
      run cp -a "$dst" "$backup_root/$file"
    fi

    ensure_dir "$(dirname "$dst")"
    run cp -a "$src" "$dst"
  done < <(read_dotfiles)

  note "Dotfiles installed. Backup: $backup_root"
}

backup_dotfiles() {
  local target_dir="${1:-$ROOT_DIR/dotfiles}"
  ensure_dir "$target_dir"

  while IFS= read -r file; do
    local src="$HOME/$file"
    local dst="$target_dir/$file"

    [[ ! -e "$src" ]] && { warn "Missing on system: $src"; continue; }

    ensure_dir "$(dirname "$dst")"
    run cp -a "$src" "$dst"
  done < <(read_dotfiles)

  note "Dotfiles backed up to $target_dir"
}
