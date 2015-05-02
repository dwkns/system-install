#!/bin/bash
######################## local config ########################
ITERM=false
KREP=false
SUBLIME=true
############ functions ############
containsElement () {
  local e
  for e in "${@:2}"; do [[ "$e" == "$1" ]] && return 0; done
  return 1
}

############ script ############
msg "Installing Cask" 
brew install caskroom/cask/brew-cask

echo "Tapping up caskroom/versions"
brew tap caskroom/versions

echo "Tapping up caskroom/fonts"
brew tap caskroom/fonts


msg "Installing Cask Apps"

for pkg in "${CASKS_PACKAGES[@]}"
  do
    msg "Installing '$pkg'..."
    brew cask install --force --appdir='/Applications' $pkg #do the install

   # if this package is in the ADD_TO_DOCK array then add it to the dock
   if containsElement $pkg "${ADD_TO_DOCK[@]}"; then
      appNameFromCask=`brew cask info $pkg | sed -n '/==> Contents/{n;p;}'`
      appname=`echo -e ${appNameFromCask:0:${#appNameFromCask}-6}`
      dockutil --add "/Applications/$appname" --no-restart
      echo "Adding $appname to the Dock"
  fi
  note "done"
done

############ CONFIGURE ITERM ############
if $ITERM; then
  msg "Configure iTerm"
  echo "Downloading preference file and copy into place"
  cp -f "$ROOT_DIR/system-config-files/com.googlecode.iterm2.plist" "$HOME/Library/Preferences/com.googlecode.iterm2.plist"
  # URL="$$ROOT_DIR/system-config-files/com.googlecode.iterm2.plist"
  # curl $URL > 
  killall cfprefsd
 note "done"
fi

######################## INSTALL KREP ########################
if $KREP; then
  msg "Installing Krep"

  ps cax | grep Krep > /dev/null # Is Krep running?

  if [ $? -eq 0 ]; then # yep, killing it
    warn "Krep is running. Killing it"
    killall -9 Krep
  fi

  if [  -d "/Applications/Krep.app" ]; then # is Krep installed
    warn "Krep is installed, skipping"
  else
    mkdir -p /tmp/krep
    curl -L https://github.com/dwkns/krep/archive/master.zip -o  "/tmp/krep/Krep.zip"

    unzip -o -q "/tmp/krep/Krep.zip" -d "/tmp/krep"
    cp -rf "/tmp/krep/krep-master/Krep.app" "/Applications"
    rm -rf "/tmp/krep/krep-master"
    rm -rf "/tmp/krep/Downloads/Krep.zip"

    dockutil --add "/Applications/Krep.app" --no-restart

  fi
  note "done"
fi


##################### Configure Sublime ######################
if $SUBLIME;then
  msg "configuring sublime"

  SUBLIME="$HOME/Library/Application Support/Sublime Text 3"
  SUBLIME_LOCAL_DIR="$SUBLIME/local"
  SUBLIME_PACKAGES_DIR="$SUBLIME/Packages"
  SUBLIME_USER_DIR="$SUBLIME/Packages/User"
  SUBLIME_INSTALLED_PACKAGES_DIR="$SUBLIME/Installed Packages"

  mkdir -p "$SUBLIME_LOCAL_DIR"
  mkdir -p "$SUBLIME_USER_DIR"
  mkdir -p "$SUBLIME_INSTALLED_PACKAGES_DIR"

  msg "Installing Package Control"
  curl -L "http://sublime.wbond.net/Package Control.sublime-package" -o "$SUBLIME_INSTALLED_PACKAGES_DIR/Package Control.sublime-package"

  if $DEBUG; then
    msg "Installing pin_console.py"
   cp -f "$ROOT_DIR/sublime-config-files/pin_console.py" "$SUBLIME_PACKAGES_DIR/pin_console.py"
  fi 

  msg "Intalling license"
  cp -f "$ROOT_DIR/sublime-config-files/License.sublime_license" "$SUBLIME_LOCAL_DIR/License.sublime_license"

  msg "Installing sublime preferences"
  cp -f "$ROOT_DIR/sublime-config-files/Preferences.sublime-settings" "$SUBLIME_USER_DIR/Preferences.sublime-settings"

  msg "Installing scopehunter preferences"
  cp -f "$ROOT_DIR/sublime-config-files/scope_hunter.sublime-settings" "$SUBLIME_USER_DIR/scope_hunter.sublime-settings"

  msg "Installing sublime Package Control Settings"
  cp -f "$ROOT_DIR/sublime-config-files/Package Control.sublime-settings" "$SUBLIME_USER_DIR/Package Control.sublime-settings"
 
  msg "Cloning in some code snipits"
  git clone "https://github.com/dwkns/sublime-code-snipits.git" "$SUBLIME_USER_DIR/code-snipits"

  msg "Installing sublime theme dwkns.tmTheme"
  cp -f "$ROOT_DIR/sublime-config-files/dwkns.tmTheme" "$SUBLIME_USER_DIR/dwkns.tmTheme"

  msg "Installing sublime keymap"
  cp -f "$ROOT_DIR/sublime-config-files/Default (OSX).sublime-keymap" "$SUBLIME_USER_DIR/Default (OSX).sublime-keymap"

  msg "Intalling ruby-terminal build system"
  git clone "https://github.com/dwkns/ruby-iTerm2.git" "$SUBLIME_PACKAGES_DIR/ruby-iTerm2"
  chmod u+x "$SUBLIME_PACKAGES_DIR/ruby-iTerm2/ruby-iterm2.sh"
  ln -s "$SUBLIME_PACKAGES_DIR/ruby-iTerm2/ruby-iterm2.sh" "/usr/local/bin"
fi