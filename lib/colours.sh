#!/usr/bin/env zsh
###############################################################################
# colours.sh - Terminal Color Definitions and Output Functions
###############################################################################
#
# PURPOSE:
#   Defines ANSI color codes and helper functions for colored terminal output.
#   Used throughout the system-config scripts for consistent, readable output.
#
# USAGE:
#   source "$ROOT_DIR/lib/colours.sh"
#   echo -e "${GREEN}Success!${RESET}"
#   doing "Installing packages"
#   warn "File not found"
#
# AVAILABLE COLORS:
#   WHITE, GRAY, RED, YELLOW, GREEN, BLUE, CYAN, PURPLE
#   WHITE_BOLD, GRAY_BOLD, RED_BOLD, YELLOW_BOLD, GREEN_BOLD, BLUE_BOLD, CYAN_BOLD, PURPLE_BOLD
#   RESET - Resets to default terminal color
#
# AVAILABLE FUNCTIONS:
#   success "message"   - Green success message
#   warn "message"      - Yellow warning message  
#   error "message"     - Red error message
#   note "message"      - Cyan informational message
#   doing "message"     - Green action message (for "doing X...")
#   complete "message"  - Completion message
#   setting "message"   - Setting configuration message
#
# EMOJIS:
#   UNICORN, THUMBS_UP, GREEN_TICK, WARNING
#
###############################################################################

###############################################################################
# Color Definitions
###############################################################################
# ANSI escape codes for terminal colors
# Format: \033[STYLE;COLORm where:
#   STYLE: 0=normal, 1=bold
#   COLOR: 30-37 for standard colors, 90-97 for bright colors

# Standard colors (normal weight)
WHITE="\033[0;37m"
GRAY="\033[0;30m"
RED="\033[0;31m"          
YELLOW="\033[0;33m"       
GREEN="\033[0;32m"          
BLUE="\033[0;94m"
CYAN="\033[0;36m"
PURPLE="\033[0;35m"

# Bold colors (heavier weight, more prominent)
WHITE_BOLD="\033[1;37m"
GRAY_BOLD="\033[1;30m"
RED_BOLD="\033[1;31m"          
YELLOW_BOLD="\033[1;33m"       
GREEN_BOLD="\033[1;32m"          
BLUE_BOLD="\033[1;94m"
CYAN_BOLD="\033[1;36m"
PURPLE_BOLD="\033[1;35m"

# Reset code - returns terminal to default color
RESET="\033[0m"

###############################################################################
# Emoji Definitions
###############################################################################
# Unicode emoji characters for visual indicators
# Usage: echo -e "${UNICORN} Magic happening!"

UNICORN='\U1F984'           # 🦄 Unicorn
THUMBS_UP='\U1F44D'         # 👍 Thumbs up
GREEN_TICK=$GREEN'\U2714'$RESET  # ✔ Green checkmark
WARNING='\U26A0'            # ⚠ Warning sign

###############################################################################
# Output Functions
###############################################################################
# Helper functions for consistent message formatting across all scripts

# success - Print a success message (green)
# Usage: success "Operation completed"
success () {
  echo -e $GREEN"Success ====>$CYAN $1 $RESET"
}

# warn - Print a warning message (yellow)
# Usage: warn "File might be outdated"
warn () {
  echo -e $YELLOW"Warning ====>$CYAN $1 $RESET"
}

# error - Print an error message (red)
# Usage: error "Failed to connect"
error () {  
  echo -e $RED"Error ====>$CYAN $1 $RESET"
}

# note - Print an informational note (cyan)
# Usage: note "Using default configuration"
note () {
  echo -e $CYAN"Note ====>$RESET $1 $RESET"
}

# doing - Print an action message (green arrow)
# Usage: doing "Installing dependencies"
doing () {
  echo -e $GREEN"====> $1 $RESET"
}

# complete - Print a completion message
# Usage: complete "Setup finished"
complete () {
  echo -e $GREEN"====>$RESET $1 $RESET"
}

# setting - Print a setting message
# Usage: setting "Verbose mode enabled"
setting () {
  echo -e $GREEN"Setting ====>$RESET $1"
}
