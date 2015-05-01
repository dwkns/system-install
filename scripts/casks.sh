#!/bin/bash
######################## HOMEBREW ########################


containsElement () {
  local e
  for e in "${@:2}"; do [[ "$e" == "$1" ]] && return 0; done
  return 1
}

install_cask () {
    echo -e "$PG Installing Cask"
    brew install caskroom/cask/brew-cask

    echo -e "$PG Tapping up caskroom/versions"
    brew tap caskroom/versions

    echo -e "$PG Tapping up caskroom/fonts"
    brew tap caskroom/fonts
}

install_cask_packages () {
  for pkg in "${CASKS_PACKAGES[@]}"
  do

     echo -e "$PG Installing '$pkg'..."
     
      brew cask install --force --appdir='/Applications' $pkg #do the install

     # if this package is in the ADD_TO_DOCK array then add it to the dock
     if containsElement $pkg "${ADD_TO_DOCK[@]}"; then

    	appNameFromCask=`brew cask info $pkg | sed -n '/==> Contents/{n;p;}'`
 
      appname=`echo -e ${appNameFromCask:0:${#appNameFromCask}-6}`

        dockutil --add "/Applications/$appname" --no-restart
      fi
  
  done
}

############ SCRIPT ############
echo -e "$PG Configuring Homebrew"

install_cask
install_cask_packages






