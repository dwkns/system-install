#!/usr/bin/env bash
###############################################################################
# dotfiles.sh - Dotfile Management
###############################################################################
#
# PURPOSE:
#   Manages the installation and backup of dotfiles (configuration files that
#   typically start with a dot, like .zshrc, .gitconfig, etc.). These files
#   configure shell behavior, git, editors, and other command-line tools.
#
# DEPENDENCIES:
#   - lib/common.sh (provides: ensure_dir, run, note, warn, die, timestamp)
#   - config/.dotfiles (list of dotfiles to manage)
#
# USAGE:
#   source "$ROOT_DIR/lib/dotfiles.sh"
#   install_dotfiles              # Copy dotfiles from repo to home
#   backup_dotfiles               # Copy dotfiles from home to repo
#
# FILE LOCATIONS:
#   - Repository: ~/.system-config/dotfiles/.zshrc, .gitconfig, etc.
#   - System:     ~/.zshrc, ~/.gitconfig, etc.
#   - List:       ~/.system-config/config/.dotfiles
#
# DOTFILES LIST FORMAT (config/.dotfiles):
#   - One filename per line (relative to home directory)
#   - Lines starting with # are comments
#   - Empty lines are ignored
#   Example:
#     .zshrc
#     .gitconfig
#     # This is a comment
#     .config/nvim/init.vim
#
# FUNCTIONS:
#   read_dotfiles                    - Read and return list of managed dotfiles
#   install_dotfiles [backup_dir]    - Install dotfiles to home directory
#   backup_dotfiles [target_dir]     - Backup dotfiles from home directory
#
###############################################################################

# Configuration
# ROOT_DIR: Base directory for the system-config repository
# DOTFILES_LIST: Path to the file listing which dotfiles to manage
ROOT_DIR="${ROOT_DIR:-$HOME/.system-config}"
DOTFILES_LIST="${DOTFILES_LIST:-$ROOT_DIR/config/.dotfiles}"

# Load common utilities
# shellcheck disable=SC1090
source "$ROOT_DIR/lib/common.sh"

###############################################################################
# read_dotfiles - Read the list of managed dotfiles
###############################################################################
# Reads the .dotfiles configuration file and outputs the list of files to
# manage. Filters out comments and empty lines.
#
# Returns:
#   List of dotfile paths via stdout (one per line)
#   Exits with error if .dotfiles list is not found
#
# Example:
#   while IFS= read -r file; do
#     echo "Managing: $file"
#   done < <(read_dotfiles)
###############################################################################
read_dotfiles() {
  # Ensure the dotfiles list exists
  [[ -r "$DOTFILES_LIST" ]] || die "Dotfiles list not found: $DOTFILES_LIST"
  
  # Filter out comments (lines starting with #) and empty lines
  # grep -v '^\s*#' removes comment lines
  # sed '/^\s*$/d' removes empty/whitespace-only lines
  grep -v '^\s*#' "$DOTFILES_LIST" | sed '/^\s*$/d'
}

###############################################################################
# install_dotfiles - Install dotfiles from repository to home directory
###############################################################################
# Copies dotfiles from the repository (dotfiles/) to the user's home
# directory. Before overwriting, backs up existing files to a timestamped
# backup directory.
#
# Arguments:
#   $1 - Optional: Backup directory (default: ~/.system-config/backups/dotfiles-TIMESTAMP)
#
# Returns:
#   0 - Success
#   Non-zero - On error
#
# Behavior:
#   - Reads list of files from config/.dotfiles
#   - For each file, copies from dotfiles/$file to ~/$file
#   - Creates parent directories as needed
#   - Backs up existing files before overwriting
#   - Warns if a file is in the list but missing from the repo
#
# Example:
#   install_dotfiles                          # Uses default backup location
#   install_dotfiles "/tmp/backup/dotfiles"   # Custom backup location
###############################################################################
install_dotfiles() {
  local backup_root="${1:-$ROOT_DIR/backups/dotfiles-$(timestamp)}"
  ensure_dir "$backup_root"

  # Process each dotfile listed in config/.dotfiles
  while IFS= read -r file; do
    local src="$ROOT_DIR/dotfiles/$file"    # Source: repo copy
    local dst="$HOME/$file"                  # Destination: home directory

    # Skip if file doesn't exist in the repository
    # This allows the list to include files that may not exist yet
    [[ ! -e "$src" ]] && { warn "Missing in repo: $src"; continue; }

    # Backup existing file before overwriting
    # This preserves the user's current config if they need to revert
    if [[ -e "$dst" ]]; then
      ensure_dir "$backup_root/$(dirname "$file")"
      run cp -a "$dst" "$backup_root/$file"
    fi

    # Copy the dotfile from repo to home
    # ensure_dir handles nested paths like .config/nvim/init.vim
    # -a flag preserves permissions, timestamps, symlinks, etc.
    ensure_dir "$(dirname "$dst")"
    run cp -a "$src" "$dst"
  done < <(read_dotfiles)

  note "Dotfiles installed. Backup: $backup_root"
}

###############################################################################
# backup_dotfiles - Backup dotfiles from home directory to repository
###############################################################################
# Copies dotfiles from the user's home directory back to the repository.
# This captures any changes made to configuration files so they can be
# committed to version control.
#
# Arguments:
#   $1 - Optional: Target directory (default: ~/.system-config/dotfiles)
#
# Returns:
#   0 - Success
#   Non-zero - On error
#
# Behavior:
#   - Reads list of files from config/.dotfiles
#   - For each file, copies from ~/$file to dotfiles/$file
#   - Creates parent directories as needed
#   - Warns if a file is in the list but missing from home
#
# Example:
#   backup_dotfiles                       # Backup to repo's dotfiles/
#   backup_dotfiles "/tmp/backup/dots"    # Backup to custom location
###############################################################################
backup_dotfiles() {
  local target_dir="${1:-$ROOT_DIR/dotfiles}"
  ensure_dir "$target_dir"

  # Process each dotfile listed in config/.dotfiles
  while IFS= read -r file; do
    local src="$HOME/$file"           # Source: home directory
    local dst="$target_dir/$file"     # Destination: repo copy

    # Skip if file doesn't exist in home directory
    [[ ! -e "$src" ]] && { warn "Missing on system: $src"; continue; }

    # Copy the dotfile from home to repo
    ensure_dir "$(dirname "$dst")"
    run cp -a "$src" "$dst"
  done < <(read_dotfiles)

  note "Dotfiles backed up to $target_dir"
}
