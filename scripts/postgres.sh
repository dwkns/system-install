#!/bin/bash
######################## POSTGRES ########################

############ CONFIG ############
POSTGRES_CLEANUP=false
POSTGRES_INSTALL=true

############ FUNCTIONS ############
remove_postgres () {
  echo -e "$PR Removing Postgres"
  PPP=postgresql

  if brew list -1 | grep -q "^${PPP}\$"; then
    brew uninstall postgresql
  fi
   rm -rf "$HOME/Library/LaunchAgents/homebrew.mxcl.postgresql.plist"
   rm -rf "$HOME/Library/LaunchAgents/*.plist"
}

install_postgres () {
if ! command -v postgres > /dev/null 2>&1; then
  echo -e "$PG Installing postgres..."
  brew install "postgresql"

  echo -e "$PG ...and configure"
  ln -sfv /usr/local/opt/postgresql/*.plist ~/Library/LaunchAgents #lauch at start up
  launchctl load ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist #launch now
else
  echo -e "$PY Postgres already installed skipping..."
fi
}

############ SCRIPT ############
echo -e "$PG Configuring Postgres"

if $POSTGRES_CLEANUP; then remove_postgres; fi 
if $POSTGRES_INSTALL; then install_postgres; fi 




