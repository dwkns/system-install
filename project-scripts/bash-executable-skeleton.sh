#!/usr/bin/env zsh
# Bash executable skeleton - clones from git repo

set -euo pipefail

# Source common utilities
. "$HOME/.system-config/project-scripts/common.sh"

# Get repo URL from first argument
REPO_URL="$1"
PROJECT_NAME=""

# Get project name
PROJECT_NAME=$(get_project_name "$2" "demo-project")
check_project_exists "$PROJECT_NAME"
check_repo_exists "$REPO_URL"

# Clone repository
clone_repo "$REPO_URL" "$PROJECT_NAME"

# Determine filename for bash script (project name or project-name.sh)
if [[ ${PROJECT_NAME: -3} != ".sh" ]]; then
  FILENAME="$PROJECT_NAME.sh"
else
  FILENAME="$PROJECT_NAME"
fi

# If script.sh exists in repo, rename it to project-specific name
if [[ -f "script.sh" ]] && [[ "$FILENAME" != "script.sh" ]]; then
  mv script.sh "$FILENAME"
  chmod +x "$FILENAME"
  success "Renamed script.sh to $FILENAME"
fi

# Initialize git (remove old remote, reinitialize)
init_git

# Open in editor
open_project
