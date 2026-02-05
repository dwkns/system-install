#!/usr/bin/env bash
###############################################################################
# brew.sh - Homebrew Package Management
###############################################################################
#
# PURPOSE:
#   Manages Homebrew installation and package management via Brewfile.
#   Homebrew is the package manager for macOS that installs command-line
#   tools, applications (via casks), and fonts.
#
# DEPENDENCIES:
#   - lib/common.sh (provides: has_cmd, die, log, run, is_macos)
#   - Brewfile (list of packages to install)
#
# USAGE:
#   source "$ROOT_DIR/lib/brew.sh"
#   brew_bundle                   # Install all packages from Brewfile
#
# BREWFILE FORMAT:
#   The Brewfile uses a simple DSL:
#     tap "homebrew/cask-fonts"           # Add a tap (repository)
#     brew "git"                          # Install a CLI formula
#     cask "visual-studio-code"           # Install a GUI application
#     mas "Xcode", id: 497799835          # Install from Mac App Store
#
# FILE LOCATIONS:
#   - Brewfile: ~/.system-config/Brewfile
#
# FUNCTIONS:
#   install_homebrew    - Install Homebrew if not present
#   brew_bundle         - Run brew bundle to install all packages
#
###############################################################################

# Configuration
ROOT_DIR="${ROOT_DIR:-$HOME/.system-config}"
BREWFILE="${BREWFILE:-$ROOT_DIR/Brewfile}"

# Load common utilities
# shellcheck disable=SC1090
source "$ROOT_DIR/lib/common.sh"

###############################################################################
# install_homebrew - Install Homebrew package manager
###############################################################################
# Installs Homebrew if it's not already present on the system.
# This is required before any brew commands can be run.
#
# Returns:
#   0 - Success (Homebrew installed or already present)
#   Non-zero - On error
#
# Notes:
#   - Only works on macOS
#   - Installs to /opt/homebrew on Apple Silicon, /usr/local on Intel
#   - Requires internet connection
#   - May prompt for password (installs to system directories)
###############################################################################
install_homebrew() {
  # Skip if Homebrew is already installed
  if has_cmd brew; then
    return 0
  fi

  # Homebrew only works on macOS
  if ! is_macos; then
    die "Homebrew install only supported on macOS"
  fi

  log "Installing Homebrew"
  
  # Run the official Homebrew installation script
  run /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  
  # On Apple Silicon Macs, Homebrew installs to /opt/homebrew
  # We need to add it to the PATH for the current session
  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
}

###############################################################################
# brew_bundle - Install packages from Brewfile
###############################################################################
# Runs 'brew bundle' to install all packages defined in the Brewfile.
# This is the main function for setting up all required software.
#
# Returns:
#   0 - Success
#   Non-zero - On error (missing Brewfile, brew bundle fails)
#
# Behavior:
#   - Ensures Homebrew is installed first
#   - Reads packages from the Brewfile
#   - Installs missing packages, skips already-installed ones
#   - Handles formulas (CLI), casks (GUI apps), and taps (repos)
#
# Example:
#   brew_bundle    # Installs everything from ~/.system-config/Brewfile
###############################################################################
brew_bundle() {
  # Ensure Brewfile exists
  [[ -r "$BREWFILE" ]] || die "Brewfile not found: $BREWFILE"
  
  # Make sure Homebrew is installed
  install_homebrew
  
  log "Running brew bundle"
  
  # Run brew bundle with the specified Brewfile
  # --file specifies the Brewfile location
  # brew bundle automatically skips already-installed packages
  run brew bundle --file "$BREWFILE"
}
