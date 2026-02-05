#!/usr/bin/env bash
###############################################################################
# common.sh - Shared Utility Functions
###############################################################################
#
# PURPOSE:
#   Provides common utility functions used by all other scripts in the
#   system-config repository. This is the foundation library that everything
#   else depends on.
#
# DEPENDENCIES:
#   - lib/colours.sh (optional, for colored output)
#
# USAGE:
#   source "$ROOT_DIR/lib/common.sh"
#
# ENVIRONMENT VARIABLES:
#   ROOT_DIR    - Base path of system-config repo (default: ~/.system-config)
#   ASSUME_YES  - If "1", skip confirmation prompts (default: 0)
#   DRY_RUN     - If "1", show commands without executing (default: 0)
#
# FUNCTIONS PROVIDED:
#   has_cmd     - Check if a command exists
#   log         - Print a log message (green)
#   note        - Print a note message (cyan)
#   warn        - Print a warning message (yellow)
#   error       - Print an error message (red)
#   die         - Print error and exit with code 1
#   timestamp   - Generate a timestamp string (YYYYMMDD-HHMMSS)
#   ensure_dir  - Create directory if it doesn't exist
#   confirm     - Ask user for yes/no confirmation
#   run         - Execute command (or show in dry-run mode)
#   is_macos    - Check if running on macOS
#
###############################################################################

# Configuration
ROOT_DIR="${ROOT_DIR:-$HOME/.system-config}"

# Load color definitions if available
# This provides colored terminal output for better readability
# Falls back gracefully if colours.sh doesn't exist
if [[ -r "$ROOT_DIR/lib/colours.sh" ]]; then
  # shellcheck disable=SC1090
  source "$ROOT_DIR/lib/colours.sh"
fi

###############################################################################
# has_cmd - Check if a command exists in PATH
###############################################################################
# Tests whether a given command is available on the system.
#
# Arguments:
#   $1 - Command name to check
#
# Returns:
#   0 - Command exists
#   1 - Command not found
#
# Example:
#   if has_cmd git; then
#     echo "Git is installed"
#   fi
###############################################################################
has_cmd() { command -v "$1" >/dev/null 2>&1; }

###############################################################################
# Logging Functions
###############################################################################
# These functions provide consistent, colored output for different message types.
# Colors are defined in colours.sh; if not loaded, output is plain text.
#
# log   - General information (green arrow prefix)
# note  - Informational notes (cyan "Note" prefix)
# warn  - Warning messages (yellow "Warning" prefix)
# error - Error messages (red "Error" prefix)
###############################################################################
log()   { echo -e "${GREEN:-}==>${RESET:-} $*"; }
note()  { echo -e "${CYAN:-}Note${RESET:-} $*"; }
warn()  { echo -e "${YELLOW:-}Warning${RESET:-} $*"; }
error() { echo -e "${RED:-}Error${RESET:-} $*"; }

###############################################################################
# die - Print error message and exit
###############################################################################
# Prints an error message to stderr and terminates the script with exit code 1.
# Use this for unrecoverable errors where the script cannot continue.
#
# Arguments:
#   $* - Error message to display
#
# Example:
#   [[ -f "$config" ]] || die "Config file not found: $config"
###############################################################################
die() {
  error "$*"
  exit 1
}

###############################################################################
# timestamp - Generate a formatted timestamp
###############################################################################
# Returns a timestamp string suitable for file/directory names.
# Format: YYYYMMDD-HHMMSS (e.g., 20240215-143052)
#
# Returns:
#   Timestamp string via stdout
#
# Example:
#   backup_dir="backups/$(timestamp)"  # e.g., "backups/20240215-143052"
###############################################################################
timestamp() {
  date "+%Y%m%d-%H%M%S"
}

###############################################################################
# ensure_dir - Create directory if it doesn't exist
###############################################################################
# Wrapper around mkdir -p that creates the directory and all parent
# directories as needed. Silent if directory already exists.
#
# Arguments:
#   $1 - Directory path to create
#
# Example:
#   ensure_dir "$HOME/.config/myapp"
###############################################################################
ensure_dir() {
  mkdir -p "$1"
}

###############################################################################
# confirm - Ask user for yes/no confirmation
###############################################################################
# Prompts the user for confirmation before proceeding. Respects the
# ASSUME_YES environment variable to skip prompts in automated scenarios.
#
# Arguments:
#   $1 - Optional: Custom prompt message (default: "Are you sure?")
#
# Returns:
#   0 - User confirmed (yes) or ASSUME_YES=1
#   1 - User declined (no)
#
# Example:
#   if confirm "Delete all files?"; then
#     rm -rf "$dir"
#   fi
###############################################################################
confirm() {
  local prompt="${1:-Are you sure?} [y/N] "
  
  # Skip prompt if ASSUME_YES is set (for automated/scripted usage)
  if [[ "${ASSUME_YES:-0}" == "1" ]]; then
    return 0
  fi
  
  read -r -p "$prompt" reply
  [[ "$reply" =~ ^[Yy]$ ]]
}

###############################################################################
# run - Execute command with dry-run support
###############################################################################
# Wrapper for command execution that supports dry-run mode. When DRY_RUN=1,
# prints what would be executed without actually running it.
#
# Arguments:
#   $@ - Command and arguments to execute
#
# Returns:
#   Command's exit code, or 0 in dry-run mode
#
# Example:
#   run cp -a "$src" "$dst"      # Actually copies in normal mode
#   DRY_RUN=1 run cp -a "$src" "$dst"  # Just prints the command
###############################################################################
run() {
  if [[ "${DRY_RUN:-0}" == "1" ]]; then
    note "DRY RUN: $*"
    return 0
  fi
  "$@"
}

###############################################################################
# is_macos - Check if running on macOS
###############################################################################
# Tests whether the current operating system is macOS (Darwin).
#
# Returns:
#   0 - Running on macOS
#   1 - Not macOS (Linux, WSL, etc.)
#
# Example:
#   if is_macos; then
#     # macOS-specific code
#     defaults write com.apple.finder ShowPathbar -bool true
#   fi
###############################################################################
is_macos() {
  [[ "$(uname -s)" == "Darwin" ]]
}
