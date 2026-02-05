###############################################################################
#  Configure oh-my-zsh
###############################################################################
# Exit early if shell is not interactive (e.g., running scripts, scp, etc.)
# This prevents unnecessary configuration loading for non-interactive sessions
[[ -o interactive ]] || return

# Set oh-my-zsh installation directory
export ZSH="$HOME/.oh-my-zsh"

# Configure oh-my-zsh plugins
# git: provides git aliases and prompt integration
plugins=(git)

# Load oh-my-zsh framework
# This initializes all plugins and sets up the oh-my-zsh environment
source "$ZSH/oh-my-zsh.sh"

###############################################################################
#  Define variables
###############################################################################
# Root directory for system configuration files
# All system config files are managed from this directory
SYS_FILES_ROOT="$HOME/.system-config"

# Directory containing project skeleton scripts
# These scripts help quickly bootstrap new projects (Ruby, Node, Eleventy, etc.)
SYS_PROJECT_SCRIPTS="$SYS_FILES_ROOT/project-scripts"

###############################################################################
#  Helper functions
###############################################################################
# Check if a command exists in PATH
# Usage: has_cmd <command-name>
# Returns 0 if command exists, 1 otherwise
has_cmd() { command -v "$1" >/dev/null 2>&1; }

# Execute a command with a descriptive message
# Usage: run_do <message> <command> [args...]
# Displays the message using the 'doing' function, then executes the command
# This provides consistent feedback for operations throughout the shell
run_do() {
  local msg="$1"
  shift
  doing "$msg"
  "$@"
}

###############################################################################
#  Prevent alias/function name collisions
###############################################################################
# oh-my-zsh's git plugin defines aliases that conflict with our custom functions
# Remove these default aliases so our custom versions can take precedence
# The 2>/dev/null suppresses errors if the alias doesn't exist
# The || true ensures the loop continues even if unalias fails
for _name in ga gc gs gl gp aliases la lp; do
  unalias "$_name" 2>/dev/null || true
done

###############################################################################
#  Import useful scripts
###############################################################################
# Load color definitions and helper functions (doing, warn, error, note, etc.)
# These provide consistent terminal output formatting throughout the shell
if [[ -r "$SYS_FILES_ROOT/lib/colours.sh" ]]; then
  source "$SYS_FILES_ROOT/lib/colours.sh"
fi

# Load dotfile management functions
# Provides: install_dotfiles(), backup_dotfiles()
# These handle syncing configuration files between ~/ and ~/.system-config
if [[ -r "$SYS_FILES_ROOT/lib/dotfiles.sh" ]]; then
  source "$SYS_FILES_ROOT/lib/dotfiles.sh"
fi

# Load macOS preference file management functions
# Provides: install_preferences(), backup_preferences()
# These handle syncing .plist preference files to/from ~/Library/Preferences
if [[ -r "$SYS_FILES_ROOT/lib/preferences.sh" ]]; then
  source "$SYS_FILES_ROOT/lib/preferences.sh"
fi

# Load color file management functions
# Provides: install_colors(), backup_colors()
# These handle syncing .clr color palette files to/from ~/Library/Colors
if [[ -r "$SYS_FILES_ROOT/lib/colors.sh" ]]; then
  source "$SYS_FILES_ROOT/lib/colors.sh"
fi

###############################################################################
#  Shell behavior
###############################################################################
# History configuration
HISTFILE="$HOME/.zsh_history"      # File to store command history
HISTSIZE=20000                      # Number of commands to keep in memory
SAVEHIST=20000                      # Number of commands to save to history file

# History options
setopt HIST_IGNORE_ALL_DUPS         # Remove older duplicate commands from history
setopt HIST_REDUCE_BLANKS           # Remove extra blanks from commands
setopt SHARE_HISTORY                # Share history between all shell sessions

# Shell options
setopt EXTENDED_GLOB                # Enable extended globbing patterns (#, ~, ^)
setopt PROMPT_SUBST                 # Allow variable substitution in prompt

###############################################################################
#  Dotfiles update functions
###############################################################################
# Update system configuration from the repository
# This function pulls the latest changes from git and applies them to the system
# Usage: usys
usys () {
  doing 'Getting latest system config files.'
  cd "$HOME/.system-config" || return 1
  has_cmd git && git pull
  echo

  # Install/update dotfiles from repository to home directory
  # Copies files from ~/.system-config/dotfiles/ to ~/
  if typeset -f install_dotfiles >/dev/null; then
    install_dotfiles
  else
    warn "install_dotfiles not found"
  fi
  echo

  # Install/update macOS preference files
  # Copies .plist files from ~/.system-config/preferences/ to ~/Library/Preferences
  if typeset -f install_preferences >/dev/null; then
    install_preferences
  else
    warn "install_preferences not found"
  fi
  echo

  # Install/update color palette files
  # Copies .clr files from ~/.system-config/colors/ to ~/Library/Colors
  if typeset -f install_colors >/dev/null; then
    install_colors
  else
    warn "install_colors not found"
  fi
  echo

  # Source macOS-specific configuration if it exists
  # This file may contain additional macOS settings
  if [[ -r "$HOME/.macos" ]]; then
    source "$HOME/.macos"
  fi
  echo

  # Reload the shell configuration to apply any changes
  doing 'Reloading .zshrc profile'
  source "$HOME/.zshrc"

  # Ensure VSCode configuration directory exists
  mkdir -p "$HOME/.vscode/"
}

# Backup system configuration to the repository
# This function copies current dotfiles and preferences from the system to the repo,
# then commits and pushes the changes
# Usage: bsys
bsys () {
  # Backup dotfiles from home directory to repository
  # Copies files from ~/ to ~/.system-config/dotfiles/
  if typeset -f backup_dotfiles >/dev/null; then
    backup_dotfiles
  else
    warn "backup_dotfiles not found"
  fi
  echo

  # Backup macOS preference files
  # Copies .plist files from ~/Library/Preferences to ~/.system-config/preferences/
  if typeset -f backup_preferences >/dev/null; then
    backup_preferences
  else
    warn "backup_preferences not found"
  fi
  echo

  # Commit and push changes to the repository
  # Runs in a subshell to avoid changing the current working directory
  doing 'Backing up system config files'
  (
    cd "$HOME/.system-config" || exit 1
    doing 'Backing up system'
    git status
    # Check if there are any uncommitted changes (staged or unstaged)
    if ! git diff --quiet || ! git diff --cached --quiet; then
      git add -A
      git commit -m 'Updated Config Files'
    else
      note "No changes to commit"
    fi
    git push --all
  )
  echo ""
  doing 'Done Backing up'
}

###############################################################################
#  Utility functions
###############################################################################
# Recursively delete node_modules directories
# Removes node_modules, node_modules 2, and node_modules.nosync folders
# Useful for cleaning up disk space when switching between projects
# Usage: dnode
dnode () {
  doing "Recursively deleting node_modules folders from current directory"
  find . \( -name 'node_modules' -o -name 'node_modules 2' -o -name 'node_modules.nosync' \) -type d -prune -exec rm -rf '{}' +
}

# List all available project skeleton commands
# This function is now an alias to list_projects() which reads from JSON
# Usage: projects
projects() {
  list_projects
}

# Display helpful command reference
# Shows commonly used commands and git operations for quick reference
# Usage: commands
commands () {
  doing 'Common commands:'
  note "Kill process on port:$fg[yellow] kp <port>$reset_color"
  note "List starter projects:$fg[yellow] projects $reset_color"
  note "List aliases from .zshrc:$fg[yellow] la$reset_color"
  note "List active aliases:$fg[yellow] list_all_aliases$reset_color"
  echo
  doing 'Common git commands:'
  note "Rename branch:$fg[yellow] git branch -m <old> <new> $reset_color"
  note "Delete Branch:$fg[yellow] git branch -d <old-branch> $reset_color"
  note "Push current branch:$fg[yellow] git push -u origin HEAD —>  $fg[red]gp $reset_color"
  note "Reset branch to remote/origin:"
  echo "$fg[yellow] git checkout <branch>$reset_color"
  echo "$fg[yellow] git reset --hard origin/<branch>$reset_color"
  note "List remotes:$fg[yellow] git remote -v $reset_color"
  note "Show recent branches:$fg[yellow] git branch --sort=-committerdate $reset_color"
  echo
}

# Load aliases from JSON configuration file
# Parses config/.aliases.json and creates aliases/functions dynamically
# Uses jq to parse JSON and handles simple aliases vs complex functions
# Simple commands become aliases; complex commands (with &&, ||, ;) become functions
# Commands with warnings always become functions to display the warning
# All output is suppressed during loading for a clean shell startup
load_aliases() {
  local aliases_file="$SYS_FILES_ROOT/config/.aliases.json"
  
  # Verify aliases file exists and is readable
  if [[ ! -r "$aliases_file" ]]; then
    warn "Aliases file not found: $aliases_file" >&2
    return 1
  fi

  # Check for jq dependency (required for JSON parsing)
  if ! has_cmd jq; then
    warn "jq is required to load aliases. Install with: brew install jq" >&2
    return 1
  fi

  # Parse all aliases in one jq call for better performance
  # Output format: name|description|command|category|warning
  # Process substitution (< <(...)) feeds jq output into the while loop
  while IFS='|' read -r name desc cmd cat warning; do
    # Skip if any required field is missing
    [[ "$name" == "null" || -z "$name" ]] && continue
    [[ "$cmd" == "null" || -z "$cmd" ]] && continue
    
    # Check if command contains shell operators that require function syntax
    # Aliases cannot handle &&, ||, or ; operators reliably
    local is_complex=false
    if [[ "$cmd" == *"&&"* ]] || [[ "$cmd" == *"||"* ]] || [[ "$cmd" == *";"* ]]; then
      is_complex=true
    fi
    
    # Create function for complex commands or if warning exists, otherwise use alias
    if [[ -n "$warning" ]] || [[ "$is_complex" == "true" ]]; then
      # Use function for complex commands or commands with warnings
      # Functions allow proper handling of compound commands and can display warnings
      local escaped_warning escaped_desc escaped_cmd
      if [[ -n "$warning" ]]; then
        escaped_warning=$(printf '%q' "$warning")  # Quote for safe eval
      fi
      escaped_desc=$(printf '%q' "$desc")
      escaped_cmd=$(printf '%q' "$cmd")
      
      # Build and eval function definition
      # Functions call 'doing' for consistent output, and 'warn' if warning exists
      if [[ -n "$warning" ]]; then
        eval "${name}() { warn ${escaped_warning}; doing ${escaped_desc}; eval ${escaped_cmd}; }"
      else
        eval "${name}() { doing ${escaped_desc}; eval ${escaped_cmd}; }"
      fi
    else
      # Simple alias - uses run_do wrapper for consistent messaging
      # run_do displays the description and executes the command
      if typeset -f run_do >/dev/null 2>&1; then
        local escaped_desc
        escaped_desc=$(printf '%q' "$desc")
        eval "alias ${name}='run_do ${escaped_desc} ${cmd}'"
      else
        # Fallback if run_do is not available (shouldn't happen normally)
        local escaped_cmd
        escaped_cmd=$(printf '%q' "$cmd")
        eval "alias ${name}=${escaped_cmd}"
      fi
    fi
  done < <(jq -r '.aliases[] | "\(.name)|\(.description)|\(.command)|\(.category)|\(.warning // "")"' "$aliases_file" 2>/dev/null)
}

# List all aliases defined in the JSON configuration file
# Displays aliases grouped by category with colored output and icons
# Only shows alias name and description (not the command) for clean output
# Usage: la (aliased to this function)
list_zshrc_aliases() {
  local aliases_file="$SYS_FILES_ROOT/config/.aliases.json"
  
  # Verify aliases file exists and is readable
  if [[ ! -r "$aliases_file" ]]; then
    error "Aliases file not found: $aliases_file"
    return 1
  fi

  # Check for jq dependency
  if ! has_cmd jq; then
    error "jq is required to list aliases. Install with: brew install jq"
    return 1
  fi

  doing "Listing aliases from .aliases.json"
  echo
  
  # Define icon mapping for each category
  # Associative array (Zsh-specific) for efficient lookup
  typeset -A category_icons
  category_icons=(
    "general" "📦"
    "git" "🔀"
    "brew" "🍺"
    "system" "⚙️"
    "editor" "📝"
    "navigation" "🗺️"
    "python" "🐍"
  )
  
  local current_category=""
  local temp_file
  temp_file=$(mktemp)
  
  # Generate sorted TSV (tab-separated values) output to temp file
  # Using TSV instead of pipe-delimited avoids issues with commands containing pipes
  # sort_by(.category) ensures aliases are grouped by category
  # @tsv converts the array to tab-separated format
  jq -r '.aliases | sort_by(.category) | .[] | [.name, .description, .command, .category] | @tsv' "$aliases_file" 2>/dev/null > "$temp_file"
  
  # Parse tab-delimited file using file descriptor 3
  # IFS=$'\t' sets tab as the field separator
  while IFS=$'\t' read -r name desc cmd cat <&3; do
    # Skip if any field is missing or empty
    [[ -z "$name" || "$name" == "null" ]] && continue
    
    # Print category header when category changes
    # This creates visual grouping of related aliases
    if [[ "$cat" != "$current_category" ]]; then
      # Add blank line between categories (except for first category)
      if [[ -n "$current_category" ]]; then
        echo
      fi
      # Get icon for category, default to 📁 if not found
      local icon="${category_icons[$cat]:-📁}"
      # Capitalize first letter of category name
      local first_char="${cat:0:1}"
      local rest="${cat:1}"
      local capitalized="$(echo "$first_char" | tr '[:lower:]' '[:upper:]')$rest"
      # Print category header in cyan/bold
      echo -e "${CYAN_BOLD:-${CYAN:-}}$icon $capitalized${RESET:-}"
      current_category="$cat"
    fi
    
    # Print alias with formatting
    # Name in green (left-aligned, 20 chars wide), description in yellow
    # Only shows name and description, not the command for cleaner output
    printf "  ${GREEN:-}%-20s${RESET:-} ${YELLOW:-}%s${RESET:-}\n" "$name" "$desc"
  done 3< "$temp_file"
  
  # Clean up temporary file
  rm -f "$temp_file"
  echo
}

# List all projects defined in the JSON configuration file
# Displays projects grouped by category with colored output and icons
# Only shows project name and description (not the command) for clean output
# Usage: projects (aliased to this function)
list_projects() {
  local projects_file="$SYS_FILES_ROOT/config/.projects.json"
  
  # Verify projects file exists and is readable
  if [[ ! -r "$projects_file" ]]; then
    error "Projects file not found: $projects_file"
    return 1
  fi

  # Check for jq dependency
  if ! has_cmd jq; then
    error "jq is required to list projects. Install with: brew install jq"
    return 1
  fi

  doing "Listing projects from .projects.json"
  echo
  
  # Define icon mapping for each category
  # Associative array (Zsh-specific) for efficient lookup
  typeset -A category_icons
  category_icons=(
    "ruby" "💎"
    "node" "📗"
    "bash" "🐚"
    "eleventy" "⚡"
  )
  
  local current_category=""
  local temp_file
  temp_file=$(mktemp)
  
  # Generate sorted TSV (tab-separated values) output to temp file
  # Using TSV instead of pipe-delimited avoids issues with commands containing pipes
  # sort_by(.category) ensures projects are grouped by category
  # @tsv converts the array to tab-separated format
  jq -r '.projects | sort_by(.category) | .[] | [.name, .description, .command, .category] | @tsv' "$projects_file" 2>/dev/null > "$temp_file"
  
  # Parse tab-delimited file using file descriptor 3
  # IFS=$'\t' sets tab as the field separator
  while IFS=$'\t' read -r name desc cmd cat <&3; do
    # Skip if any field is missing or empty
    [[ -z "$name" || "$name" == "null" ]] && continue
    
    # Print category header when category changes
    # This creates visual grouping of related projects
    if [[ "$cat" != "$current_category" ]]; then
      # Add blank line between categories (except for first category)
      if [[ -n "$current_category" ]]; then
        echo
      fi
      # Get icon for category, default to 📁 if not found
      local icon="${category_icons[$cat]:-📁}"
      # Capitalize first letter of category name
      local first_char="${cat:0:1}"
      local rest="${cat:1}"
      local capitalized="$(echo "$first_char" | tr '[:lower:]' '[:upper:]')$rest"
      # Print category header in cyan/bold
      echo -e "${CYAN_BOLD:-${CYAN:-}}$icon $capitalized${RESET:-}"
      current_category="$cat"
    fi
    
    # Print project with formatting
    # Name in green (left-aligned, 20 chars wide), description in yellow
    # Only shows name and description, not the command for cleaner output
    printf "  ${GREEN:-}%-20s${RESET:-} ${YELLOW:-}%s${RESET:-}\n" "$name" "$desc"
  done 3< "$temp_file"
  
  # Clean up temporary file
  rm -f "$temp_file"
  echo
}

# List all active shell aliases (both oh-my-zsh and custom)
# Shows the actual alias definitions currently loaded in the shell
# Usage: list_all_aliases (aliased to this function)
list_aliases_fn () {
  doing "Listing active aliases"
  alias | sort
}

# List all shell functions
# Displays all function names currently defined in the shell
# Usage: funcs
funcs () {
  doing "Listing functions"
  # ${(k)functions} gets all function names (keys)
  # print -l prints each on a new line
  print -l ${(k)functions} | sort
}

# List all directories in PATH
# Useful for debugging PATH issues or understanding where commands are found
# Usage: paths
paths () {
  doing "Listing PATH entries"
  # ${(s/:/)PATH} splits PATH by colons into an array
  # print -l prints each on a new line
  print -l ${(s/:/)PATH}
}

# Kill process(es) running on a specific port
# Useful for freeing up ports when development servers don't shut down cleanly
# Usage: kp <port-number>
kp () {
  if [[ -z "$1" ]]; then
    error "Port required: kp <port>"
    return 1
  fi
  doing "Kill port $1"
  # Find process IDs using the specified TCP port
  # lsof -t returns only PIDs, -i tcp:PORT filters by port
  local pids
  pids="$(lsof -t -i tcp:"$1")"
  if [[ -n "$pids" ]]; then
    # Force kill (SIGKILL) all processes on that port
    kill -9 $pids
  else
    note "No process found on port $1"
  fi
}

# Project skeleton creation functions
# These functions bootstrap new projects from git repositories
# All projects are defined in config/.projects.json and dynamically loaded
# Each project uses its own script but shares common utilities from common.sh

# Load project functions dynamically from JSON
# Creates functions for each project defined in config/.projects.json
load_project_functions() {
  local projects_file="$SYS_FILES_ROOT/config/.projects.json"
  
  # Check if projects file exists
  if [[ ! -r "$projects_file" ]]; then
    warn "Projects configuration file not found: $projects_file" >&2
    return 1
  fi
  
  # Check for jq dependency
  if ! has_cmd jq; then
    warn "jq is required to load project functions. Install with: brew install jq" >&2
    return 1
  fi
  
  # Create functions for each project in JSON
  while IFS= read -r project_data; do
    local project_name repo_url description script_path
    project_name=$(echo "$project_data" | jq -r '.name')
    repo_url=$(echo "$project_data" | jq -r '.repo')
    description=$(echo "$project_data" | jq -r '.description')
    script_path=$(echo "$project_data" | jq -r '.script')
    
    if [[ -n "$project_name" && "$project_name" != "null" && -n "$script_path" && "$script_path" != "null" ]]; then
      # Create function that calls the appropriate script with repo URL
      # Source the script so cd commands work in current shell
      eval "${project_name}() { 
        doing '${description}';
        . \"\$SYS_FILES_ROOT/$script_path\" \"$repo_url\" \"\$1\"; 
      }"
    fi
  done < <(jq -c '.projects[]' "$projects_file" 2>/dev/null)
}

# Load project functions silently during shell startup
# Errors are suppressed to keep startup clean
load_project_functions >/dev/null 2>&1

# Create directory and change into it
# -p flag creates parent directories as needed
# Usage: mkd <directory-name>
mkd () { mkdir -p "$1" && cd "$1"; }

# Extract compressed archives based on file extension
# Handles multiple archive formats automatically
# Usage: extract <archive-file>
extract () {
  if [[ -f "$1" ]]; then
    case "$1" in
      *.tar.bz2) tar xjf "$1" ;;    # bzip2 compressed tar
      *.tar.gz) tar xzf "$1" ;;     # gzip compressed tar
      *.bz2) bunzip2 "$1" ;;        # bzip2 file
      *.rar) unrar x "$1" ;;        # RAR archive
      *.gz) gunzip "$1" ;;          # gzip file
      *.tar) tar xf "$1" ;;         # uncompressed tar
      *.tbz2) tar xjf "$1" ;;       # bzip2 compressed tar (alternative extension)
      *.tgz) tar xzf "$1" ;;        # gzip compressed tar (alternative extension)
      *.zip) unzip "$1" ;;          # ZIP archive
      *.Z) uncompress "$1" ;;       # compress file
      *.7z) 7z x "$1" ;;            # 7-Zip archive
      *) error "Cannot extract '$1'" ;;  # Unknown format
    esac
  else
    error "'$1' is not a valid file"
  fi
}

###############################################################################
#  Load Aliases
###############################################################################
# Load all aliases from JSON configuration file
# Output is suppressed (>/dev/null 2>&1) to keep shell startup clean
# Errors are redirected to stderr in the function itself for debugging
load_aliases >/dev/null 2>&1

# Create convenient aliases for listing functions
# These must be defined after the functions they reference are loaded
alias la="list_zshrc_aliases"                 # List aliases from JSON config
alias lp="projects"                           # List projects from JSON config
alias list_all_aliases="list_aliases_fn"      # List all active shell aliases

###############################################################################
#  Prompt Configuration
###############################################################################
# Define newline variable for use in prompt
NEWLINE=$'\n'

# Load and configure git version control info for prompt
# vcs_info provides git branch information
autoload -Uz vcs_info
# Run vcs_info before each prompt
precmd() { vcs_info }
# Format: "on <branch-name>" in green, preceded by reset color
zstyle ':vcs_info:git:*' formats "$reset_color on $fg[green]%b"

# Custom prompt format
# Shows: current directory (with ~ for home), git branch info, newline, then $
# ${PWD/#$HOME/~} replaces $HOME with ~ for shorter display
# %{$fg[yellow]%} sets yellow color for directory
# ${vcs_info_msg_0_} displays git branch info from vcs_info
PROMPT='%{$fg[yellow]%}${PWD/#$HOME/~}${vcs_info_msg_0_}%{$reset_color%}$NEWLINE$ '

###############################################################################
#  Auto-change to Desktop Directory
###############################################################################
# Automatically change to Desktop when opening a new terminal in home directory
# Skips this behavior when:
#   - Connected via SSH (no X11/desktop environment)
#   - Running in VSCode or Cursor (IDE terminals should stay where they are)
# This provides a convenient default location for terminal work
if [[ -z "$SSH_CONNECTION" && "$PWD" == "$HOME" ]]; then
  case "${TERM_PROGRAM:-}" in
    vscode|Cursor) ;;              # Don't cd in IDE terminals
    *) cd ~/Desktop ;;             # Change to Desktop in regular terminals
  esac
fi

###############################################################################
#  Environment Variables (Exports)
###############################################################################

############### System-wide Default Editor ################ 
# Set default editor for git and other tools
# -w flag makes code wait for file to be closed before continuing
# Falls back to vi if VS Code is not installed
if has_cmd code; then
  export EDITOR='code -w'
else
  export EDITOR='vi'
fi

############### Homebrew Cask Installation Directory ################
# Configure Homebrew to install GUI applications in /Applications
# This ensures all apps are in the standard macOS location
export HOMEBREW_CASK_OPTS="--appdir=/Applications"  

############### PATH Configuration ################ 
# PATH initialization is critical - ensure system paths are always present
# Some tools (rbenv, Homebrew) modify PATH and may remove system paths
# This can cause "command not found" errors for basic commands (mkdir, etc.)

# Initialize PATH from scratch with system paths first if PATH is empty or corrupted
# This is a safety measure in case PATH gets completely overwritten
if [[ -z "${PATH:-}" ]] || [[ "$PATH" != *"/bin"* ]]; then
  export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
fi

# Make PATH unique (remove duplicates) while preserving system paths
# typeset -U makes the array unique (Zsh-specific feature)
# This ensures each directory appears only once in PATH
typeset -U path PATH
path=(
  /usr/local/bin      # Homebrew (Intel) and other local binaries
  /usr/bin            # System binaries
  /bin                # Essential system binaries
  /usr/sbin           # System administration binaries
  /sbin               # Essential system administration binaries
  $path               # Append existing PATH entries
)

# Initialize Homebrew (Apple Silicon / M-series Macs)
# Homebrew on Apple Silicon installs to /opt/homebrew
# The shellenv command sets up PATH and other environment variables
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
  # Ensure system paths remain after Homebrew modifies PATH
  # Some Homebrew setups can remove system paths, causing issues
  for sys_path in /usr/local/bin /usr/bin /bin /usr/sbin /sbin; do
    if [[ ":$PATH:" != *":$sys_path:"* ]]; then
      export PATH="$sys_path:$PATH"
    fi
  done
fi

# Initialize rbenv (Ruby version manager)
# rbenv manages multiple Ruby versions and modifies PATH
if has_cmd rbenv; then
  export PATH="$HOME/.rbenv/bin:$PATH"
  eval "$(rbenv init - zsh)"
  # Ensure system paths remain after rbenv modifies PATH
  # rbenv has been known to remove system paths in some configurations
  for sys_path in /usr/local/bin /usr/bin /bin /usr/sbin /sbin; do
    if [[ ":$PATH:" != *":$sys_path:"* ]]; then
      export PATH="$sys_path:$PATH"
    fi
  done
fi

# Add Sublime Text command-line tools to PATH
# This allows using 'subl' command to open files in Sublime Text
export PATH="/Applications/Sublime Text.app/Contents/SharedSupport/bin:$PATH"

###############################################################################
#  Helper Functions and Final Aliases
###############################################################################
# Run an npm script with error handling
# Provides a shorter alias for 'npm run <script>'
# Usage: n <script-name>
n() {
  if [[ -z "$1" ]]; then
    error "Usage: n <npm-script>"
    return 1
  fi
  doing "Running npm script: $1"
  npm run "$1" || {
    echo "Failed to run npm script: $1"
    return 1
  }
}

# Python 3 aliases
# macOS ships with Python 2 (deprecated) and Python 3
# These aliases ensure Python 3 is used by default
alias python=python3
alias pip=pip3
