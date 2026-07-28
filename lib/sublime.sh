#!/usr/bin/env bash
###############################################################################
# sublime.sh - Sublime Text Configuration File Management
###############################################################################
#
# PURPOSE:
#   Manages Sublime Text configuration and preference files.
#   These files store settings, keybindings, and plugin configurations
#   that allow preserving Sublime Text setup across installations.
#
# DEPENDENCIES:
#   - lib/common.sh (provides: ensure_dir, run, note, warn, timestamp)
#
# USAGE:
#   source "$ROOT_DIR/lib/sublime.sh"
#   install_sublime              # Copy config from repo to system
#   backup_sublime               # Copy config from system to repo
#
# FILE LOCATIONS:
#   - Repository: ~/.system-config/config/sublime-config/*
#   - System:     ~/Library/Application Support/Sublime Text/User/*
#
# FEATURES:
#   - Automatically detects Sublime Text installation directory
#   - Creates User directory if it doesn't exist
#   - Backs up existing files before installing (whitelist approach)
#   - Supports all Sublime Text configuration file types
#
# FUNCTIONS:
#   install_sublime [backup_dir]  - Install config files to system
#   backup_sublime [target_dir]   - Backup config files from system
#
###############################################################################

# Configuration
# ROOT_DIR: Base directory for the system-config repository
# SUBLIME_DIR: Where Sublime config files are stored in the repository
# SUBLIME_TARGET: System location for Sublime Text user configuration
ROOT_DIR="${ROOT_DIR:-$HOME/.system-config}"
SUBLIME_DIR="${SUBLIME_DIR:-$ROOT_DIR/config/sublime-config}"
SUBLIME_TARGET="$HOME/Library/Application Support/Sublime Text/User"

# The Sublime Text license is a SECRET and must never live in this repo.
# It is stored in the macOS login keychain (single-line base64) and written
# into place at install time. To (re)store it:
#   openssl base64 -A -in License.sublime_license | \
#     xargs -0 security add-generic-password -U -a "$USER" -s sublime-text-license -w
# (or use the helper documented in the README).
SUBLIME_LICENSE_FILE="License.sublime_license"
SUBLIME_LICENSE_SERVICE="${SUBLIME_LICENSE_SERVICE:-sublime-text-license}"

# Load common utilities (provides logging, file operations, etc.)
# shellcheck disable=SC1090
source "$ROOT_DIR/lib/common.sh"

###############################################################################
# install_sublime - Copy config files from repository to system
###############################################################################
# Installs Sublime Text configuration files from the repository to
# ~/Library/Application Support/Sublime Text/User/.
# Before overwriting any existing files, creates a timestamped backup.
#
# Arguments:
#   $1 - Optional: Backup directory path (default: ~/.system-config/backups/sublime-TIMESTAMP)
#
# Returns:
#   0 - Success (even if no files to install)
#   Non-zero - On error
#
# Example:
#   install_sublime                              # Uses default backup location
#   install_sublime "/tmp/my-backup/sublime"    # Custom backup location
###############################################################################
# install_sublime_license - Write the license from the keychain into Sublime
#
# Reads the single-line base64 license from the login keychain, decodes it,
# and writes it to the Sublime User directory with 0600 permissions. If the
# keychain entry is missing, it warns and skips (rather than failing the run).
# The plaintext license is never printed.
install_sublime_license() {
  local backup_root="$1"
  local dst="$SUBLIME_TARGET/$SUBLIME_LICENSE_FILE"

  # Pull the base64-encoded license out of the login keychain.
  local license_b64
  license_b64="$(security find-generic-password -a "$USER" -s "$SUBLIME_LICENSE_SERVICE" -w 2>/dev/null || true)"

  if [[ -z "$license_b64" ]]; then
    warn "Sublime license not found in keychain (service: $SUBLIME_LICENSE_SERVICE); skipping license install."
    warn "Add it with:  openssl base64 -A -in License.sublime_license | security add-generic-password -U -a \"\$USER\" -s $SUBLIME_LICENSE_SERVICE -w \"\$(cat)\""
    return 0
  fi

  # Back up any existing license before overwriting.
  if [[ -e "$dst" ]]; then
    ensure_dir "$backup_root"
    run cp -a "$dst" "$backup_root/$SUBLIME_LICENSE_FILE"
  fi

  if [[ "${DRY_RUN:-0}" == "1" ]]; then
    note "DRY RUN: write Sublime license from keychain to $dst"
    return 0
  fi

  # Decode base64 -> plaintext license file. openssl is available on every
  # macOS and avoids the BSD/GNU 'base64 -d' vs '-D' flag difference.
  ensure_dir "$(dirname "$dst")"
  printf '%s' "$license_b64" | openssl base64 -A -d > "$dst"
  chmod 600 "$dst"
  note "Installed Sublime license from keychain"
}

install_sublime() {
  local backup_root="${1:-$ROOT_DIR/backups/sublime-$(timestamp)}"

  # We always need somewhere to back up to and a target to write into, because
  # the license comes from the keychain even if the repo has no config files.
  ensure_dir "$backup_root"
  ensure_dir "$SUBLIME_TARGET"

  # 1) License: sourced from the keychain, never from the repo.
  install_sublime_license "$backup_root"

  # 2) Non-secret config files (Preferences etc.): copied from the repo.
  #    The license file is explicitly excluded so a stray copy can't leak in.
  if [[ -d "$SUBLIME_DIR" ]]; then
    while IFS= read -r -d '' file; do
      # Extract relative path (e.g., "Preferences.sublime-settings" from full path)
      local basename="${file#$SUBLIME_DIR/}"
      local src="$file"
      local dst="$SUBLIME_TARGET/$basename"

      # Backup existing config file before overwriting
      if [[ -e "$dst" ]]; then
        ensure_dir "$backup_root/$(dirname "$basename")"
        run cp -a "$dst" "$backup_root/$basename"
      fi

      # Copy the config file from repo to system
      ensure_dir "$(dirname "$dst")"
      run cp -a "$src" "$dst"
    done < <(find "$SUBLIME_DIR" -type f ! -name "$SUBLIME_LICENSE_FILE" -print0)
  fi

  echo "$backup_root"
}

###############################################################################
# backup_sublime - Backup config files from system to repository
###############################################################################
# Copies Sublime Text configuration files from the system to the repository.
# Uses a whitelist approach: only backs up config files that already exist
# in the repository's sublime-config-files/ directory.
#
# Arguments:
#   $1 - Optional: Target directory (default: ~/.system-config/sublime-config-files)
#
# Returns:
#   0 - Success (even if no config to backup)
#   Non-zero - On error
#
# Behavior:
#   - Scans the repo's sublime-config-files/ directory for files
#   - For each file found, copies the matching file from the system
#   - Warns if a tracked config file is missing on the system
#
# Adding New Configuration Files to Track:
#   1. Find Sublime's User directory location
#   2. Copy the config file: cp ~/Library/Application\ Support/Sublime\ Text/User/*.sublime-settings ~/.system-config/config/sublime-config/
#   3. Now backup_sublime will track it
#
# Example:
#   backup_sublime                          # Backup to repo's sublime-config-files/
#   backup_sublime "/tmp/backup/sublime"    # Custom backup location
###############################################################################
backup_sublime() {
  local target_dir="${1:-$SUBLIME_DIR}"
  ensure_dir "$target_dir"

  # Exit early if system Sublime directory doesn't exist
  # (Sublime Text may not be installed)
  [[ -d "$SUBLIME_TARGET" ]] || return 0
  
  # Exit early if repo Sublime directory doesn't exist
  # (nothing to use as a whitelist)
  [[ -d "$SUBLIME_DIR" ]] || return 0

  # Process each config file that exists in the repo (whitelist approach)
  # Only backup configuration we're already tracking. The license is excluded
  # so it can never be copied back from the system into the repo.
  while IFS= read -r -d '' file; do
    # Get the relative path to find the matching system file
    local basename="${file#$SUBLIME_DIR/}"
    local src="$SUBLIME_TARGET/$basename"    # System copy
    local dst="$file"                        # Repo copy

    # Warn if the config file doesn't exist on the system
    # This might mean the file was deleted or the path changed
    if [[ ! -e "$src" ]]; then
      warn "Missing on system: $src"
      continue
    fi

    # Copy the config file from system to repo
    ensure_dir "$(dirname "$dst")"
    run cp -a "$src" "$dst"
  done < <(find "$SUBLIME_DIR" -type f ! -name "$SUBLIME_LICENSE_FILE" -print0)

  note "Sublime Text config backed up to $target_dir"
}
