#!/bin/bash
######################## HOMEBREW ########################

############ CONFIG ############
CASKS_PACKAGES=("iterm2-nightly" "dropbox" "sublime-text3" "things" "flash" "handbrake" "omnigraffle" "transmission" "mplayerx" "charles" "lightpaper" "fluid" "codekit" "font-source-code-pro" )
#CASKS_PACKAGES=( "dropbox" "sublime-text3" "things" "font-source-code-pro" "omnigraffle" )

############ FUNCTIONS ############

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
   if brew cask list -1 | grep -q "^${pkg}\$"; then
     echo -e "$PY Cask '$pkg' is installed, skipping it..."
   else
     echo -e "$PG Installing '$pkg'..."
     brew cask install --force --appdir='/Applications' $pkg #do the install


     # get the casks Applicaiton name
     appNameFromCask=`brew cask info $pkg | sed -n '/==> Contents/{n;p;}'`


     if [[ $appNameFromCask == *app* ]]; then # if it's an app add to dock
      appname=`echo -e ${appNameFromCask:0:${#appNameFromCask}-6}`
      appNameAndPath="/Applications/"$appname
      
      echo -e "appNameAndPath is $appNameAndPath"

      defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>$appNameAndPath</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>"
    fi
  fi
  done
}

############ SCRIPT ############
echo -e "$PG Configuring Homebrew"

install_cask
install_cask_packages






