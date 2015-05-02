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

# ask for sudo upfront
sudo -v 

# Keep-alive: update existing sudo time stamp if set, otherwise do nothing.
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

DEBUG=true
CLEAN_INSTALL=false
ROOT_DIR="$HOME/.system-config"
REMOTE_URL="https://raw.githubusercontent.com/dwkns/system-install/master/"
TMP_DIR=`mktemp -d /tmp/os-install.XXXXXXXXX`

msg "Starting install"

if $DEBUG; then
  warn "Debug is active"
  warn "Software update is set to false"
  TM_DEBUG=false
  WORKING_DIR="`( cd \"$MY_PATH\" && pwd )`"
fi

if $CLEAN_INSTALL; then
    # this is a special case when you want to clean everything 
    # before starting an install.
    echo "TMP_DIR is $TMP_DIR"
    curl $REMOTE_URL/scripts/clean.sh -o $TMP_DIR/clean.sh
    curl $REMOTE_URL/scripts/config.sh -o $TMP_DIR/config.sh
    source $TMP_DIR/clean.sh
    source $TMP_DIR/config.sh
    clean_all  
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

# if $WORKING_DIR; then 
#  warn "Resetting ROOT_DIR to $WORKING_DIR we are working locally"
#  ROOT_DIR="$WORKING_DIR"
# fi

echo "ROOT_DIR is set to $ROOT_DIR"
note "Done" 

source "$ROOT_DIR/scripts/main-install.sh"