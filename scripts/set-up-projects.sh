#!/usr/bin/env zsh
set -euo pipefail

######## Ask for a project name or use default 'demo-project'
if [[ -z "${1:-}" ]]; then
  echo
  echo "$YELLOW"Nothing passed in..."$RESET
  echo "You can use '${0##*/} <projectName>' as a shortcut."
  echo
  echo "$CYAN"Enter project name (default -> demo-project): "$RESET
  read -r PROJECTNAME
  PROJECTNAME="${PROJECTNAME:-demo-project}"
else
  success "Setting project name to '$1'"
  PROJECTNAME="$1"
fi

if [[ -z "$PROJECTNAME" || "$PROJECTNAME" == -* ]]; then
  error "Invalid project name"
  exit 1
fi

######## Does the folder already exist? Do you want to override it?
if [[ -e "$PROJECTNAME" ]]; then
  echo "$CYAN"Project $PROJECTNAME already exists delete it Y/n: "$RESET
  read -r DELETEIT
  DELETEIT="${DELETEIT:-Y}"

  case "$DELETEIT" in
    Y|y)
      rm -rf -- "$PROJECTNAME"
      ;;
    *)
      error "OK not doing anything & exiting"
      exit 0
      ;;
  esac
fi