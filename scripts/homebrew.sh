#!/bin/bash
######################## HOMEBREW + CASK ########################
# sets up Homebrew and installs basic packages as defined in install.sh

############ FUNCTIONS ############

containsElement () {
  local e
  for e in "${@:2}"; do [[ "$e" == "$1" ]] && return 0; done
  return 1
}

############ SCRIPT ############
echo -e "$PG Installing Homebrew"

if xcode-select -p; then
		echo "tools installed";
	yes '' | ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
	echo "tools not installed";
	ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

echo -e "$PG Installing Homebrew Packages"

for PACKAGE in "${BREW_PACKAGES[@]}"
  do
   if brew list -1 | grep -q "^${PACKAGE}\$"; then
     echo -e "$PY Package '$PACKAGE' is installed, skipping it..."
   else
     echo -e "$PG Installing '$PACKAGE'..."
     brew install $PACKAGE
  fi
done