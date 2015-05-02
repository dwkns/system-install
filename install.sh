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
ROOT_DIR="$HOME/.system-config"
REMOTE_URL="https://raw.githubusercontent.com/dwkns/system-install/master/"

# ask for sudo upfront
sudo -v 

# Keep-alive: update existing sudo time stamp if set, otherwise do nothing.
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

msg "Starting install"

echo "Linking to clean script"
mkdir -p /tmp/os-install/
curl "$REMOTE_URL/scripts/clean.sh" -o "/tmp/os-install/clean.sh"
source /tmp/os-install/clean.sh



if $DEBUG; then
  warn "Debug is active"
  warn "Software update is set to false"
  WORKING_DIR="`( cd \"$MY_PATH\" && pwd )`"
  # source $WORKING_DIR/scripts/clean.sh
  #clean up before we install
  remove_krep
  remove_iterm
  remove_apps_from_dock
  remove_homebrew
  remove_dotfiles
  remove_postgres
  remove_sublime_config
  remove_system_config
  remove_time_machine_exclusions
  remove_rvm_ruby_gems
  killall Dock

  
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

if $DEBUG; then 
  warn "Resetting ROOT_DIR to $WORKING_DIR"
  ROOT_DIR="$WORKING_DIR"
fi

echo "ROOT_DIR is set to $ROOT_DIR"
note "Done" 

source "$ROOT_DIR/scripts/main-install.sh"

