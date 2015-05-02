#!/bin/bash
# set up some colours
note () {
  echo -e "\n\033[0;34m====> $1 \033[0m"
}
msg () {
  echo -e "\n\033[0;32m==============> $1 \033[0m"
}
warn () {
  echo -e "\n\033[0;31m====> $1 \033[0m"
}

DEBUG=true
CLEAN_INSTALL=true
ROOT_DIR="$HOME/.system-config"
REMOTE_URL="https://raw.githubusercontent.com/dwkns/system-install/master/"

# ask for sudo upfront
sudo -v 

# Keep-alive: update existing sudo time stamp if set, otherwise do nothing.
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

msg "Starting install"

if $DEBUG; then
  warn "Debug is active - we are working locally"
  warn "Software update is set to false"
  WORKING_DIR="`( cd \"$MY_PATH\" && pwd )`"
  source $WORKING_DIR/scripts/clean.sh
fi

if $CLEAN_INSTALL; then
    # this is a special case when you want to clean everything up.
    warn "Removing Homebrew"
    sudo rm -rf "/usr/local"
    sudo rm -rf "/Library/Caches/Homebrew"  

    warn "Removing '~/.system-config'"
    rm -rf "$HOME/.system-config"
    
fi

############ Install Homebrew ############
msg "$PG Installing Homebrew"

if xcode-select -p; then
  echo "Developer tools are installed"
  if command -v brew > /dev/null 2>&1; then
     echo "Homebrew is installed... skipping the installation"
     echo "Running 'brew update'"
     #brew update
   else
    echo "Installing Homebrew"
    yes '' | ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi
else
  echo "Developer tools are installed"
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi
note "Done"

msg "Installing dockutil as we need it later"
 if brew list -1 | grep -q "dockutil"; then
     echo "dockutil is installed, skipping it..."
   else
     echo "Installing 'dockutil'..."
     brew install dockutil
  fi
note "Done"

############ Download config files  ############

msg "$PG Downloading config files"

if [ -d "$ROOT_DIR" ]; then
  echo "'.system-config' folder is already there. Updating..."
  cd $ROOT_DIR
  git pull
else
  echo "Cloning 'https://github.com/dwkns/system-install.git' into '~/.system-config'"
  git clone https://github.com/dwkns/system-install.git ~/.system-config
  cd $ROOT_DIR
fi

# if $DEBUG; then 
#   warn "Resetting ROOT_DIR to $WORKING_DIR"
#   ROOT_DIR="$WORKING_DIR"
# fi

echo "ROOT_DIR is set to $ROOT_DIR"
note "Done" 

source "$ROOT_DIR/scripts/main-install.sh"

