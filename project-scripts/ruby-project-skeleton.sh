#!/usr/bin/env zsh
# Ruby project skeleton - clones from git repo and updates files

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

# Update package.json if it exists (shouldn't for Ruby, but check anyway)
if [[ -f "package.json" ]] && command -v jq >/dev/null 2>&1; then
  doing "Updating package.json"
  tmp=$(mktemp)
  jq ".name = \"$PROJECT_NAME\"" package.json > "$tmp" && mv "$tmp" package.json
fi

# Initialize git (remove old remote, reinitialize)
init_git

# Install dependencies
if [[ -f "Gemfile" ]] && command -v bundle >/dev/null 2>&1; then
  doing "Installing gem dependencies"
  bundle install 2>/dev/null || true
fi

success "Project created"
note "Use:"
note "  bin/s to run"
note "  bin/t to test"

# Open in editor
open_project
