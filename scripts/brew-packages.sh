#!/bin/bash

msg "Installing Homebrew Packages"

for PACKAGE in "${BREW_PACKAGES[@]}"
    do
       if brew list -1 | grep -q "^${PACKAGE}\$"; then
         warn "Package '$PACKAGE' is installed, skipping it..."
       else
         msg "Installing '$PACKAGE'..."
         brew install $PACKAGE
      fi
    done
note "Done"

msg "Configuring postgres..."

# the wrong permissions get set on the db folder
rm -rf /usr/local/var/postgres # remove the old.
mkdir /usr/local/var/postgres # create a new
chmod 0700 /usr/local/var/postgres # set the permissions
initdb -D /usr/local/var/postgres # create a new db folder

ln -sfv /usr/local/opt/postgresql/*.plist ~/Library/LaunchAgents #lauch at start up
launchctl load ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist #launch now
note "Done"

msg "Installing node (npm) packages..."
for pkg in "${NODE_PACKAGES[@]}"
    do
       echo -e "$PG Installing '$pkg'..."
       npm install -g  $pkg
    done
note "Done"




