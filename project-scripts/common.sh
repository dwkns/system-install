#!/usr/bin/env zsh
# Common utilities for project creation scripts

set -euo pipefail

# Source color definitions if available
if [[ -r "$HOME/.system-config/lib/colours.sh" ]]; then
  source "$HOME/.system-config/lib/colours.sh"
fi

# Get project name with validation
# Usage: get_project_name [provided_name] [default_name]
get_project_name() {
  local provided_name="${1:-}"
  local default_name="${2:-demo-project}"
  
  # If a name was provided and it's not empty, use it
  if [[ -n "$provided_name" ]]; then
    echo "$provided_name"
    return
  fi
  
  # No name provided - prompt for one
  # Send prompt to stderr so it shows even when function output is captured
  echo >&2
  echo "${YELLOW}Nothing passed in...${RESET}" >&2
  echo >&2
  echo -n "${CYAN}Enter project name (default -> $default_name): ${RESET}" >&2
  
  # Read from the terminal explicitly
  local PROJECTNAME=""
  read -r PROJECTNAME </dev/tty 2>/dev/null || read -r PROJECTNAME
  
  # Use default if empty or just whitespace
  PROJECTNAME="${PROJECTNAME:-$default_name}"
  PROJECTNAME=$(echo "$PROJECTNAME" | tr -d '[:space:]' 2>/dev/null || echo "$PROJECTNAME")
  PROJECTNAME="${PROJECTNAME:-$default_name}"
  
  # Validate the name (use default if invalid)
  if [[ -z "$PROJECTNAME" || "$PROJECTNAME" == -* ]]; then
    warn "Invalid project name, using default: $default_name"
    PROJECTNAME="$default_name"
  fi
  
  echo "$PROJECTNAME"
}

# Check if project directory exists and handle it
# Usage: check_project_exists <project_name>
check_project_exists() {
  local project_name="$1"
  
  if [[ -e "$project_name" ]]; then
    echo "${CYAN}Project $project_name already exists delete it Y/n: ${RESET}"
    local DELETEIT=""
    read -r DELETEIT </dev/tty 2>/dev/null || read -r DELETEIT
    DELETEIT="${DELETEIT:-Y}"
    
    case "$DELETEIT" in
      Y|y)
        rm -rf -- "$project_name"
        ;;
      *)
        error "OK not doing anything & exiting"
        exit 0
        ;;
    esac
  fi
}

# Check if repository exists on GitHub
# Usage: check_repo_exists <repo_url>
check_repo_exists() {
  local repo_url="$1"
  
  # Extract repo owner and name from URL
  if [[ "$repo_url" =~ https://github.com/([^/]+)/([^/]+) ]]; then
    local repo_owner="${match[1]}"
    local repo_name="${match[2]%.git}"
    local repo_full_name="$repo_owner/$repo_name"
  else
    error "Invalid repository URL format. Expected: https://github.com/owner/repo.git"
    exit 1
  fi
  
  # Check if repository exists on GitHub
  # Use timeout to prevent hanging if gh is waiting for auth or network
  if command -v gh >/dev/null 2>&1; then
    if command -v timeout >/dev/null 2>&1; then
      # Use timeout to prevent hanging (5 second timeout)
      if ! timeout 5 gh repo view "$repo_full_name" >/dev/null 2>&1; then
        warn "Could not verify repository $repo_full_name exists (timeout or not found)"
        warn "Continuing anyway - clone will fail if repo doesn't exist"
      else
        note "Repository $repo_full_name exists on GitHub"
      fi
    else
      # Fallback: try without timeout, but redirect stderr to avoid hanging prompts
      if ! gh repo view "$repo_full_name" >/dev/null 2>&1 </dev/null; then
        warn "Could not verify repository $repo_full_name exists"
        warn "Continuing anyway - clone will fail if repo doesn't exist"
      else
        note "Repository $repo_full_name exists on GitHub"
      fi
    fi
  else
    warn "gh CLI not found. Skipping repository existence check."
    warn "Install GitHub CLI with: brew install gh"
    warn "Repository should exist before running this script"
  fi
}

# Clone repository
# Usage: clone_repo <repo_url> <project_name>
clone_repo() {
  local repo_url="$1"
  local project_name="$2"
  
  # Validate project name is not empty
  if [[ -z "$project_name" || "$project_name" == "" ]]; then
    error "Project name cannot be empty"
    exit 1
  fi
  
  success "Project $project_name will be created!"
  success "Using $repo_url as the source repo"
  doing "Cloning repository"
  
  # Clone with explicit error handling - don't suppress stderr completely
  if ! git clone "$repo_url" "$project_name" 2>&1; then
    error "Failed to clone repository"
    error "Ensure the repository exists and you have access"
    exit 1
  fi
  
  cd "$project_name" || {
    error "Failed to change into project directory: $project_name"
    exit 1
  }
}

# Initialize git repository
# Usage: init_git [commit_message]
init_git() {
  local commit_msg="${1:-Initial commit}"
  
  rm -rf .git
  git init
  git add .
  git commit -m "$commit_msg"
}

# Open project in editor
# Usage: open_project
open_project() {
  if command -v code >/dev/null 2>&1; then
    # Run code in background to avoid blocking
    code . >/dev/null 2>&1 &
  elif command -v subl >/dev/null 2>&1; then
    # Run subl in background to avoid blocking
    subl . >/dev/null 2>&1 &
  fi
}
