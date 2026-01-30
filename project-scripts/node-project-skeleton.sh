#!/usr/bin/env zsh
# Node.js project skeleton - clones from git repo and updates files

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

# Update package.json with project name and author
if [[ -f "package.json" ]] && command -v jq >/dev/null 2>&1; then
  doing "Updating package.json"
  tmp=$(mktemp)
  jq ".name = \"$PROJECT_NAME\" | .author = \"$USER\"" package.json > "$tmp" && mv "$tmp" package.json
  success "Updated package.json"
else
  warn "package.json not found or jq not available. Skipping update."
fi

# Initialize git (remove old remote, reinitialize)
init_git

# Install dependencies
if [[ -f "package.json" ]]; then
  doing "Installing npm dependencies"
  npm install 2>/dev/null || true
fi

# Open in editor
open_project
