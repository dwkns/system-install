#!/usr/bin/env bash
###############################################################################
# macos.sh - macOS System Configuration
###############################################################################
#
# PURPOSE:
#   Manages macOS system settings and defaults. This includes setting the
#   machine name and applying custom system preferences via the .macos script.
#
# DEPENDENCIES:
#   - lib/common.sh (provides: die, log, warn, run)
#   - dotfiles/.macos (macOS defaults script)
#
# USAGE:
#   source "$ROOT_DIR/lib/macos.sh"
#   set_machine_name "my-macbook"    # Set computer name
#   apply_macos_defaults             # Apply system preferences
#
# THE .macos FILE:
#   The .macos file contains 'defaults write' commands that configure
#   macOS system preferences. These are the same settings you'd change
#   in System Preferences, but applied via command line.
#
#   Example .macos contents:
#     # Show hidden files in Finder
#     defaults write com.apple.finder AppleShowAllFiles -bool true
#     
#     # Disable the "Are you sure you want to open this app?" dialog
#     defaults write com.apple.LaunchServices LSQuarantine -bool false
#
# FUNCTIONS:
#   set_machine_name [name]    - Set the computer/host name
#   apply_macos_defaults       - Run the .macos defaults script
#
###############################################################################

# Configuration
ROOT_DIR="${ROOT_DIR:-$HOME/.system-config}"

# Load common utilities
# shellcheck disable=SC1090
source "$ROOT_DIR/lib/common.sh"

###############################################################################
# set_machine_name - Set the computer name
###############################################################################
# Sets all the various "names" that macOS uses for the computer:
#   - ComputerName:  The user-friendly name (shown in Finder)
#   - HostName:      The name used for networking
#   - LocalHostName: The Bonjour name (used for .local addressing)
#
# Arguments:
#   $1 - The name to set (optional, defaults to current LocalHostName)
#
# Returns:
#   0 - Success
#   Non-zero - On error (empty name, sudo failure)
#
# Note:
#   Requires sudo privileges to modify system settings.
#
# Example:
#   set_machine_name "dwkns-macbook"
###############################################################################
set_machine_name() {
  # Get the current LocalHostName as default
  local default_name
  default_name="$(scutil --get LocalHostName || true)"
  local machine_name="${1:-$default_name}"

  # Validate that we have a name to set
  if [[ -z "$machine_name" ]]; then
    die "Machine name is empty"
  fi

  log "Setting machine name to: $machine_name"
  
  # Set all three name variants
  # ComputerName: The "friendly" name shown in Finder sidebar
  run sudo scutil --set ComputerName "$machine_name"
  
  # HostName: The name used in terminal prompts and networking
  run sudo scutil --set HostName "$machine_name"
  
  # LocalHostName: The Bonjour/mDNS name (machinename.local)
  run sudo scutil --set LocalHostName "$machine_name"
}

###############################################################################
# apply_macos_defaults - Apply macOS system preferences
###############################################################################
# Runs the .macos script which contains 'defaults write' commands to
# configure macOS system preferences. This allows you to set up a new
# Mac with your preferred settings automatically.
#
# Returns:
#   0 - Success
#   Non-zero - On error (script execution fails)
#
# Notes:
#   - The .macos file must be executable or will be run via bash
#   - Some settings require logout/restart to take effect
#   - Some settings require killing specific processes (Finder, Dock)
#   - The .macos script typically ends with commands like:
#       killall Finder
#       killall Dock
#
# Example:
#   apply_macos_defaults
###############################################################################
apply_macos_defaults() {
  local macos_file="$ROOT_DIR/dotfiles/.macos"
  
  if [[ -r "$macos_file" ]]; then
    log "Applying macOS defaults"
    
    # Run the .macos script via bash
    # Using 'run' allows dry-run mode to show what would be executed
    # shellcheck disable=SC1090
    run bash "$macos_file"
  else
    warn "macOS defaults file not found: $macos_file"
  fi
}
