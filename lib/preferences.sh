#!/usr/bin/env bash
###############################################################################
# preferences.sh - macOS Preference File Management
###############################################################################
#
# PURPOSE:
#   Manages macOS application preference files (.plist files). These files
#   store settings for applications and system components. By backing up
#   and restoring these files, you can preserve app configurations across
#   system reinstalls or share settings between machines.
#
# DEPENDENCIES:
#   - lib/common.sh (provides: ensure_dir, run, note, warn, timestamp)
#
# USAGE:
#   source "$ROOT_DIR/lib/preferences.sh"
#   install_preferences              # Copy prefs from repo to system
#   backup_preferences               # Copy prefs from system to repo
#
# FILE LOCATIONS:
#   - Repository: ~/.system-config/preferences/*.plist
#   - System:     ~/Library/Preferences/*.plist
#
# IMPORTANT NOTES:
#   - Only backs up preferences that already exist in the repo (whitelist approach)
#   - To track a new app's preferences, manually copy its .plist to preferences/
#   - Some apps cache preferences; changes may not take effect until restart
#   - Some preferences require the app to be closed before modifying
#
# COMMON PLIST FILES:
#   - com.googlecode.iterm2.plist     (iTerm2 terminal)
#   - com.apple.finder.plist          (Finder)
#   - com.apple.dock.plist            (Dock)
#
# FUNCTIONS:
#   install_preferences [backup_dir]  - Install .plist files to system
#   backup_preferences [target_dir]   - Backup .plist files from system
#
###############################################################################

# Configuration
# ROOT_DIR: Base directory for the system-config repository
# PREFERENCES_DIR: Where preference files are stored in the repository
# PREFERENCES_TARGET: System location for user preferences
ROOT_DIR="${ROOT_DIR:-$HOME/.system-config}"
PREFERENCES_DIR="${PREFERENCES_DIR:-$ROOT_DIR/preferences}"
PREFERENCES_TARGET="$HOME/Library/Preferences"

# Load common utilities
# shellcheck disable=SC1090
source "$ROOT_DIR/lib/common.sh"

###############################################################################
# install_preferences - Install preference files from repository to system
###############################################################################
# Copies .plist preference files from the repository to ~/Library/Preferences.
# Before overwriting, backs up existing preferences to a timestamped directory.
#
# Arguments:
#   $1 - Optional: Backup directory (default: ~/.system-config/backups/preferences-TIMESTAMP)
#
# Returns:
#   0 - Success (even if no preferences to install)
#   Non-zero - On error
#
# Behavior:
#   - Finds all .plist files in the repository's preferences/ directory
#   - Backs up existing system preferences before overwriting
#   - Copies preference files to ~/Library/Preferences
#   - Preserves subdirectory structure if any
#
# Note:
#   After installing preferences, you may need to:
#   - Restart the affected application
#   - Log out and back in
#   - Run 'killall cfprefsd' to clear the preferences cache
#
# Example:
#   install_preferences                              # Uses default backup
#   install_preferences "/tmp/backup/prefs"          # Custom backup location
###############################################################################
install_preferences() {
  local backup_root="${1:-$ROOT_DIR/backups/preferences-$(timestamp)}"
  ensure_dir "$backup_root"

  # Exit early if preferences directory doesn't exist in repo
  [[ -d "$PREFERENCES_DIR" ]] || return 0

  # Process each .plist file in the repository's preferences directory
  # Using -print0 and read -d '' handles filenames with special characters
  while IFS= read -r -d '' file; do
    # Extract relative path from the full path
    # e.g., "/path/to/preferences/com.app.plist" -> "com.app.plist"
    local basename="${file#$PREFERENCES_DIR/}"
    local src="$file"
    local dst="$PREFERENCES_TARGET/$basename"

    # Backup existing preference file before overwriting
    if [[ -e "$dst" ]]; then
      ensure_dir "$backup_root/$(dirname "$basename")"
      run cp -a "$dst" "$backup_root/$basename"
    fi

    # Copy the preference file from repo to system
    ensure_dir "$(dirname "$dst")"
    run cp -a "$src" "$dst"
  done < <(find "$PREFERENCES_DIR" -name "*.plist" -type f -print0)

  note "Preferences installed. Backup: $backup_root"
}

###############################################################################
# backup_preferences - Backup preference files from system to repository
###############################################################################
# Copies .plist preference files from ~/Library/Preferences to the repository.
# Uses a whitelist approach: only backs up preferences that already exist in
# the repository's preferences/ directory.
#
# Arguments:
#   $1 - Optional: Target directory (default: ~/.system-config/preferences)
#
# Returns:
#   0 - Success (even if no preferences to backup)
#   Non-zero - On error
#
# Behavior:
#   - Scans the repo's preferences/ directory for .plist files
#   - For each file found, copies the matching file from the system
#   - Warns if a tracked preference is missing on the system
#
# Adding New Preferences to Track:
#   1. Find the app's plist: ls ~/Library/Preferences/ | grep appname
#   2. Copy it to repo: cp ~/Library/Preferences/com.app.plist ~/.system-config/preferences/
#   3. Now backup_preferences will track it
#
# Example:
#   backup_preferences                          # Backup to repo's preferences/
#   backup_preferences "/tmp/backup/prefs"      # Custom backup location
###############################################################################
backup_preferences() {
  local target_dir="${1:-$PREFERENCES_DIR}"
  ensure_dir "$target_dir"

  # Exit early if system preferences directory doesn't exist
  [[ -d "$PREFERENCES_TARGET" ]] || return 0
  
  # Exit early if repo preferences directory doesn't exist
  # (nothing to use as a whitelist)
  [[ -d "$PREFERENCES_DIR" ]] || return 0

  # Process each .plist file that exists in the repo (whitelist approach)
  # Only backup preferences we're already tracking
  while IFS= read -r -d '' file; do
    # Get the relative path to find the matching system file
    local basename="${file#$PREFERENCES_DIR/}"
    local src="$PREFERENCES_TARGET/$basename"    # System copy
    local dst="$file"                            # Repo copy

    # Warn if the preference file doesn't exist on the system
    # This might mean the app isn't installed or uses a different plist name
    if [[ ! -e "$src" ]]; then
      warn "Missing on system: $src"
      continue
    fi

    # Copy the preference file from system to repo
    ensure_dir "$(dirname "$dst")"
    run cp -a "$src" "$dst"
  done < <(find "$PREFERENCES_DIR" -name "*.plist" -type f -print0)

  note "Preferences backed up to $target_dir"
}
