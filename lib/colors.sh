#!/usr/bin/env bash

# Color files backup and restore
# Manages .clr files from ~/Library/Colors

ROOT_DIR="${ROOT_DIR:-$HOME/.system-config}"
COLORS_DIR="${COLORS_DIR:-$ROOT_DIR/colors}"
COLORS_TARGET="$HOME/Library/Colors"

# shellcheck disable=SC1090
source "$ROOT_DIR/lib/common.sh"

install_colors() {
  local backup_root="${1:-$ROOT_DIR/backups/colors-$(timestamp)}"
  
  [[ -d "$COLORS_DIR" ]] || return 0
  
  # Check if there are any color files to install
  local color_files
  color_files=$(find "$COLORS_DIR" -name "*.clr" -type f 2>/dev/null)
  [[ -z "$color_files" ]] && return 0
  
  ensure_dir "$backup_root"
  ensure_dir "$COLORS_TARGET"
  
  while IFS= read -r -d '' file; do
    local basename="${file#$COLORS_DIR/}"
    local src="$file"
    local dst="$COLORS_TARGET/$basename"
    
    # Backup existing color file before overwriting
    if [[ -e "$dst" ]]; then
      ensure_dir "$backup_root/$(dirname "$basename")"
      run cp -a "$dst" "$backup_root/$basename"
    fi
    
    ensure_dir "$(dirname "$dst")"
    run cp -a "$src" "$dst"
  done < <(find "$COLORS_DIR" -name "*.clr" -type f -print0)
  
  note "Colors installed. Backup: $backup_root"
}

backup_colors() {
  local target_dir="${1:-$COLORS_DIR}"
  
  [[ -d "$COLORS_TARGET" ]] || return 0
  
  # Check if there are any color files to backup
  local color_files
  color_files=$(find "$COLORS_TARGET" -name "*.clr" -type f 2>/dev/null)
  [[ -z "$color_files" ]] && return 0
  
  ensure_dir "$target_dir"
  
  while IFS= read -r -d '' file; do
    local basename="${file#$COLORS_TARGET/}"
    local src="$file"
    local dst="$target_dir/$basename"
    
    ensure_dir "$(dirname "$dst")"
    run cp -a "$src" "$dst"
  done < <(find "$COLORS_TARGET" -name "*.clr" -type f -print0)
  
  note "Colors backed up to $target_dir"
}
