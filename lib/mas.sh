#!/usr/bin/env bash
###############################################################################
# mas.sh - Mac App Store Application Management
###############################################################################
#
# PURPOSE:
#   Manages installation of applications from the Mac App Store using the
#   'mas' command-line tool. This allows automated installation of App Store
#   apps as part of system setup.
#
# DEPENDENCIES:
#   - lib/common.sh (provides: has_cmd, warn, die, run)
#   - mas CLI tool (install via: brew install mas)
#   - config/mas-apps.txt (list of apps to install)
#
# USAGE:
#   source "$ROOT_DIR/lib/mas.sh"
#   install_mas_apps              # Install all apps from mas-apps.txt
#
# MAS-APPS.TXT FORMAT:
#   One app per line: APP_ID APP_NAME
#   Lines starting with # are comments
#   
#   Example:
#     # Productivity
#     497799835 Xcode
#     409183694 Keynote
#     # Utilities
#     441258766 Magnet
#
# FINDING APP IDS:
#   - Search: mas search "app name"
#   - Or look at the App Store URL: apps.apple.com/app/id{APP_ID}
#
# PREREQUISITES:
#   - Must be signed into the Mac App Store
#   - Apps must have been "purchased" (even if free) at least once
#   - mas CLI must be installed
#
# FUNCTIONS:
#   mas_signed_in       - Check if signed into App Store
#   install_mas_apps    - Install all apps from the list
#
###############################################################################

# Configuration
ROOT_DIR="${ROOT_DIR:-$HOME/.system-config}"
MAS_LIST="${MAS_LIST:-$ROOT_DIR/config/mas-apps.txt}"

# Load common utilities
# shellcheck disable=SC1090
source "$ROOT_DIR/lib/common.sh"

###############################################################################
# mas_signed_in - Check if signed into Mac App Store
###############################################################################
# Tests whether the user is currently signed into the Mac App Store.
# This is required before apps can be installed via mas.
#
# Returns:
#   0 - Signed in
#   1 - Not signed in or mas not available
#
# Example:
#   if mas_signed_in; then
#     echo "Ready to install apps"
#   fi
###############################################################################
mas_signed_in() {
  mas account >/dev/null 2>&1
}

###############################################################################
# install_mas_apps - Install applications from Mac App Store
###############################################################################
# Reads the mas-apps.txt file and installs each listed application from
# the Mac App Store using the mas CLI tool.
#
# Returns:
#   0 - Success (even if no apps to install)
#   Non-zero - On error (missing list file)
#
# Behavior:
#   - Checks that mas is installed
#   - Verifies user is signed into App Store
#   - Reads app IDs from mas-apps.txt
#   - Installs each app (skips already-installed)
#   - Ignores comments and empty lines
#
# Prerequisites:
#   1. Install mas: brew install mas
#   2. Sign in: Open App Store.app and sign in, or run: mas signin email@example.com
#   3. Create mas-apps.txt with app IDs
#
# Example:
#   install_mas_apps
###############################################################################
install_mas_apps() {
  # Check if mas CLI is installed
  if ! has_cmd mas; then
    warn "mas is not installed. Install it with: brew install mas"
    return 0
  fi

  # Check if user is signed into App Store
  # Without this, mas install will fail
  if ! mas_signed_in; then
    warn "Not signed in to the Mac App Store. Open App Store.app and sign in."
    return 0
  fi

  # Ensure the apps list file exists
  [[ -r "$MAS_LIST" ]] || die "MAS apps list not found: $MAS_LIST"

  # Process each line in the apps list
  while IFS= read -r line; do
    # Skip empty lines and comments
    [[ -z "$line" || "$line" =~ ^# ]] && continue
    
    # Extract the app ID (first word on the line)
    # Format: "497799835 Xcode" -> "497799835"
    local app_id="${line%% *}"
    
    # Validate that it looks like an app ID (numeric)
    if [[ "$app_id" =~ ^[0-9]+$ ]]; then
      # Install the app
      # mas install skips already-installed apps automatically
      run mas install "$app_id"
    fi
  done < "$MAS_LIST"
}
