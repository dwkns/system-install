#!/usr/bin/env bash
###############################################################################
# colors.sh - Color Palette File Management
###############################################################################
#
# PURPOSE:
#   Manages macOS color palette files (.clr) used by the system color picker.
#   These files store custom color swatches that appear in apps like Pages,
#   Keynote, and any app using the standard macOS color panel.
#
# DEPENDENCIES:
#   - lib/common.sh (provides: ensure_dir, run, note, timestamp)
#
# USAGE:
#   source "$ROOT_DIR/lib/colors.sh"
#   install_colors              # Copy colors from repo to system
#   backup_colors               # Copy colors from system to repo
#
# FILE LOCATIONS:
#   - Repository: ~/.system-config/colors/*.clr
#   - System:     ~/Library/Colors/*.clr
#
# FUNCTIONS:
#   install_colors [backup_dir]  - Install .clr files to ~/Library/Colors
#   backup_colors [target_dir]   - Backup .clr files from ~/Library/Colors
#
###############################################################################

# Configuration
# ROOT_DIR: Base directory for the system-config repository
# COLORS_DIR: Where color files are stored in the repository
# COLORS_TARGET: System location where macOS reads color palettes
ROOT_DIR="${ROOT_DIR:-$HOME/.system-config}"
COLORS_DIR="${COLORS_DIR:-$ROOT_DIR/colors}"
COLORS_TARGET="$HOME/Library/Colors"

# Load common utilities (provides logging, file operations, etc.)
# shellcheck disable=SC1090
source "$ROOT_DIR/lib/common.sh"

###############################################################################
# install_colors - Copy color files from repository to system
###############################################################################
# Installs .clr color palette files from the repository to ~/Library/Colors.
# Before overwriting any existing files, creates a timestamped backup.
#
# Arguments:
#   $1 - Optional: Backup directory path (default: ~/.system-config/backups/colors-TIMESTAMP)
#
# Returns:
#   0 - Success (even if no files to install)
#   Non-zero - On error
#
# Example:
#   install_colors                              # Uses default backup location
#   install_colors "/tmp/my-backup/colors"      # Custom backup location
###############################################################################
install_colors() {
  local backup_root="${1:-$ROOT_DIR/backups/colors-$(timestamp)}"
  
  # Exit early if colors directory doesn't exist in the repo
  # This is not an error - the user may not have any color files
  [[ -d "$COLORS_DIR" ]] || return 0
  
  # Check if there are any color files to install
  # Using find to check avoids issues with glob expansion
  local color_files
  color_files=$(find "$COLORS_DIR" -name "*.clr" -type f 2>/dev/null)
  [[ -z "$color_files" ]] && return 0
  
  # Create backup and target directories
  ensure_dir "$backup_root"
  ensure_dir "$COLORS_TARGET"
  
  # Process each .clr file in the repository
  # Using -print0 and read -d '' handles filenames with spaces/special chars
  while IFS= read -r -d '' file; do
    # Extract relative path (e.g., "MyColors.clr" from full path)
    local basename="${file#$COLORS_DIR/}"
    local src="$file"
    local dst="$COLORS_TARGET/$basename"
    
    # Backup existing color file before overwriting
    # This preserves the user's current colors if they need to revert
    if [[ -e "$dst" ]]; then
      ensure_dir "$backup_root/$(dirname "$basename")"
      run cp -a "$dst" "$backup_root/$basename"
    fi
    
    # Copy the color file from repo to system
    # -a flag preserves permissions, timestamps, etc.
    ensure_dir "$(dirname "$dst")"
    run cp -a "$src" "$dst"
  done < <(find "$COLORS_DIR" -name "*.clr" -type f -print0)
  
  echo "$backup_root"
}

###############################################################################
# backup_colors - Backup color files from system to repository
###############################################################################
# Backs up all .clr color palette files from ~/Library/Colors to the
# repository's colors directory. This captures any custom colors created
# in macOS apps.
#
# Arguments:
#   $1 - Optional: Target directory (default: ~/.system-config/colors)
#
# Returns:
#   0 - Success (even if no files to backup)
#   Non-zero - On error
#
# Example:
#   backup_colors                           # Backup to repo's colors/
#   backup_colors "/tmp/backup/colors"      # Backup to custom location
###############################################################################
backup_colors() {
  local target_dir="${1:-$COLORS_DIR}"
  
  # Exit early if system Colors directory doesn't exist
  # This is not an error - user may not have created any colors
  [[ -d "$COLORS_TARGET" ]] || return 0
  
  # Check if there are any color files to backup
  local color_files
  color_files=$(find "$COLORS_TARGET" -name "*.clr" -type f 2>/dev/null)
  [[ -z "$color_files" ]] && return 0
  
  # Ensure the target directory exists
  ensure_dir "$target_dir"
  
  # Process each .clr file on the system
  while IFS= read -r -d '' file; do
    # Extract relative path from the full system path
    local basename="${file#$COLORS_TARGET/}"
    local src="$file"
    local dst="$target_dir/$basename"
    
    # Copy the color file from system to repo
    ensure_dir "$(dirname "$dst")"
    run cp -a "$src" "$dst"
  done < <(find "$COLORS_TARGET" -name "*.clr" -type f -print0)
  
  note "Colors backed up to $target_dir"
}
