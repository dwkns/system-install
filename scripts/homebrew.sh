#!/bin/bash
######################## HOMEBREW ########################

############ CONFIG ############

BREW_PACKAGES=( "wget" "git" "python" ) 

############ FUNCTIONS ############

install_brew () {
   	echo -e "$PG Downloading Homebrew"
	
	if xcode-select -p; then
 		echo "tools installed";
		yes '' | ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	else
		echo "tools not installed";
		ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	fi
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


