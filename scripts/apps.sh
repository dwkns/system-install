#!/bin/bash
######################## apps ########################
ITERM=true
KREP=true
SUBLIME=true

############ SCRIPT ############
echo -e "$PG Installing Cask Apps"

for pkg in "${CASKS_PACKAGES[@]}"
  do
    echo -e "$PG Installing '$pkg'..."
    brew cask install --force --appdir='/Applications' $pkg #do the install

   # if this package is in the ADD_TO_DOCK array then add it to the dock
   if containsElement $pkg "${ADD_TO_DOCK[@]}"; then
      appNameFromCask=`brew cask info $pkg | sed -n '/==> Contents/{n;p;}'`
      appname=`echo -e ${appNameFromCask:0:${#appNameFromCask}-6}`
      dockutil --add "/Applications/$appname" --no-restart
      echo "Adding $appname to the Dock"
  fi
done

############ CONFIGURE ITERM ############
if $ITERM; then
  echo -e "$PG  Configure iTerm"
  echo "Downloading preference file and copy into place"
  URL="$BASE_URL/system-config-files/com.googlecode.iterm2.plist"
  curl $URL > "$HOME/Library/Preferences/com.googlecode.iterm2.plist"
  killall cfprefsd
  echo -e "$PN"
fi
######################## INSTALL KREP ########################
if $KREP; then
  echo -e "$PG Installing Krep"

  ps cax | grep Krep > /dev/null # Is Krep running?

  if [ $? -eq 0 ]; then # yep, killing it
    echo -e "$PR Krep is running. Killing it"
    killall -9 Krep
  fi

  if [  -d "/Applications/Krep.app" ]; then # is Krep installed
    echo -e "$PY Krep is installed, skipping"
  else
    wget https://github.com/dwkns/krep/archive/master.zip -O "$HOME/Downloads/Krep.zip"
    unzip -o -q "$HOME/Downloads/Krep.zip" -d "$HOME/Downloads"
    cp -rf "$HOME/Downloads/krep-master/Krep.app" "/Applications"
    rm -rf "$HOME/Downloads/krep-master"
    rm -rf "$HOME/Downloads/Krep.zip"

    appname="Krep.app"
    appNameAndPath="/Applications/"$appname

    defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>$appNameAndPath</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>"
  fi
fi
##################### Configure Sublime ######################
if $SUBLIME;then
  echo -e "$PG configuring sublime"

  SUBLIME="$HOME/Library/Application Support/Sublime Text 3"

  SUBLIME_LOCAL_DIR="$SUBLIME/local"

  SUBLIME_PACKAGES_DIR="$SUBLIME/Packages"

  SUBLIME_USER_DIR="$SUBLIME/Packages/User"

  SUBLIME_INSTALLED_PACKAGES_DIR="$SUBLIME/Installed Packages"

  mkdir -p "$SUBLIME_LOCAL_DIR"
  mkdir -p "$SUBLIME_USER_DIR"
  mkdir -p "$SUBLIME_INSTALLED_PACKAGES_DIR"

  echo -e "$PG  installing Package Control"
  wget "http://sublime.wbond.net/Package Control.sublime-package" -O "$SUBLIME_INSTALLED_PACKAGES_DIR/Package Control.sublime-package"

  # echo -e "$PG  installing pin_console.py"
  # wget "$BASE_URL/sublime-config-files/pin_console.py" -O "$SUBLIME_PACKAGES_DIR/pin_console.py"

  echo -e "$PG  intalling license"
  wget "$BASE_URL/sublime-config-files/License.sublime_license" -O "$SUBLIME_LOCAL_DIR/License.sublime_license"

  echo -e "$PG   installing sublime preferences"
  wget "$BASE_URL/sublime-config-files/Preferences.sublime-settings" -O "$SUBLIME_USER_DIR/Preferences.sublime-settings"

  echo -e "$PG   installing scopehunter preferences"
  wget "$BASE_URL/sublime-config-files/scope_hunter.sublime-settings" -O "$SUBLIME_USER_DIR/scope_hunter.sublime-settings"

  echo -e "$PG   installing sublime Package Control Settings"
  wget "$BASE_URL/sublime-config-files/Package Control.sublime-settings" -O "$SUBLIME_USER_DIR/Package Control.sublime-settings"

  git clone "https://github.com/dwkns/sublime-code-snipits.git" "$SUBLIME_USER_DIR/"

  echo -e "$PG   installing sublime theme dwkns.tmTheme"
  wget "$BASE_URL/sublime-config-files/dwkns.tmTheme" -O "$SUBLIME_USER_DIR/dwkns.tmTheme"

  echo -e "$PG   installing sublime keymap"
  wget "$BASE_URL/sublime-config-files/Default (OSX).sublime-keymap" -O "$SUBLIME_USER_DIR/Default (OSX).sublime-keymap"

  echo -e "$PG   intalling ruby-terminal build system"
  git clone "https://github.com/dwkns/ruby-iTerm2.git" "$SUBLIME_PACKAGES_DIR/ruby-iTerm2"
  chmod u+x "$SUBLIME_PACKAGES_DIR/ruby-iTerm2/ruby-iterm2.sh"
  ln -s "$SUBLIME_PACKAGES_DIR/ruby-iTerm2/ruby-iterm2.sh" "/usr/local/bin"
fi