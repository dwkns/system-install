#!/bin/bash

############ Install Homebrew ############
msg "$PG Installing Homebrew"

if xcode-select -p; then
  echo "Developer tools are installed"
  if command -v brew > /dev/null 2>&1; then
     echo "Homebrew is installed... skipping the installation"
     echo "Running 'brew update'"
     #brew update
   else
    echo "Installing Homebrew using yes''"
    yes '' | ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi
else
  echo "No developer tools are installed"
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi
note "Done"
