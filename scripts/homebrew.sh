#!/bin/bash
######################## HOMEBREW ########################

############ CONFIG ############

BREW_PACKAGES=( "wget" "git" "python" ) 

############ FUNCTIONS ############

install_brew () {
#  if ! command -v brew > /dev/null 2>&1; then
   echo -e "$PG Downloading Homebrew"
   
   if  command -v gcc > /dev/null 2>&1; then
    # gcc is installed so we can shortcut having to press 'return' by using the 'yes' command
    yes '' | ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    
    else
      ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi
  
#  else
#   echo -e "$PY Homebrew was already installed. Updating it..."
#    brew update
#  fi
}

install_brew_packages () {
  for PACKAGE in "${BREW_PACKAGES[@]}"
    do
     if brew list -1 | grep -q "^${PACKAGE}\$"; then
       echo -e "$PY Package '$PACKAGE' is installed, skipping it..."
     else
       echo -e "$PG Installing '$PACKAGE'..."
       brew install $PACKAGE
    fi
  done
}

############ SCRIPT ############
echo -e "$PG Configuring Homebrew"

install_brew
install_brew_packages


