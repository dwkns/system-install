 
   source "$HOME/.system-config/scripts/colours.sh"
  ##################### Configure Sublime ######################
  msg "Configure sublime"

  
  ROOT_DIR="$HOME/.system-config"
  SUBLIME="$HOME/Library/Application Support/Sublime Text 3"
  SUBLIME_LOCAL_DIR="$SUBLIME/local"
  SUBLIME_PACKAGES_DIR="$SUBLIME/Packages"
  SUBLIME_USER_DIR="$SUBLIME/Packages/User"
  SUBLIME_INSTALLED_PACKAGES_DIR="$SUBLIME/Installed Packages"



  mkdir -p "$SUBLIME_LOCAL_DIR"
  mkdir -p "$SUBLIME_USER_DIR"
  mkdir -p "$SUBLIME_INSTALLED_PACKAGES_DIR"

  echo "-------------------------- Installing Package Control"
  curl -L "http://sublime.wbond.net/Package Control.sublime-package" -o "$SUBLIME_INSTALLED_PACKAGES_DIR/Package Control.sublime-package"

  # if $DEBUG; then
  #   echo "-------------------------- Installing pin_console.py"
  #  cp -f "$ROOT_DIR/sublime-config-files/pin_console.py" "$SUBLIME_PACKAGES_DIR/pin_console.py"
  # fi 

  echo "-------------------------- Intalling license"
  cp -f "$ROOT_DIR/sublime-config-files/License.sublime_license" "$SUBLIME_LOCAL_DIR/License.sublime_license"

  echo "-------------------------- Installing dwkns Theme"
  rm -rf "$SUBLIME_PACKAGES_DIR/Seti_UI"
  git clone "https://github.com/dwkns/Seti_UI_dwkns_additions.git" "$SUBLIME_PACKAGES_DIR/Seti_UI"

  echo "-------------------------- Installing sublime preferences"
  cp -f "$ROOT_DIR/sublime-config-files/Preferences.sublime-settings" "$SUBLIME_USER_DIR/Preferences.sublime-settings"

  echo "-------------------------- Installing BeautifyRuby preferences"
  cp -f "$ROOT_DIR/sublime-config-files/BeautifyRuby.sublime-settings" "$SUBLIME_USER_DIR/BeautifyRuby.sublime-settings"



  echo "-------------------------- Installing scopehunter preferences"
  cp -f "$ROOT_DIR/sublime-config-files/scope_hunter.sublime-settings" "$SUBLIME_USER_DIR/scope_hunter.sublime-settings"

  echo "-------------------------- Installing SublimeLinter preferences"
  cp -f "$ROOT_DIR/sublime-config-files/SublimeLinter.sublime-settings" "$SUBLIME_USER_DIR/SublimeLinter.sublime-settings"

  echo "-------------------------- Installing sublime Package Control Settings"
  cp -f "$ROOT_DIR/sublime-config-files/Package Control.sublime-settings" "$SUBLIME_USER_DIR/Package Control.sublime-settings"
 
  echo "-------------------------- Cloning in some code snipits"
  rm -rf "$SUBLIME_USER_DIR/code-snipits"
  git clone "https://github.com/dwkns/sublime-code-snipits.git" "$SUBLIME_USER_DIR/code-snipits"

  echo "-------------------------- Installing sublime theme dwkns.tmTheme"
  cp -f "$ROOT_DIR/sublime-config-files/dwkns.tmTheme" "$SUBLIME_USER_DIR/dwkns.tmTheme"

  echo "-------------------------- Installing sublime keymap"
  cp -f "$ROOT_DIR/sublime-config-files/Default (OSX).sublime-keymap" "$SUBLIME_USER_DIR/Default (OSX).sublime-keymap"

  echo "-------------------------- Intalling ruby-terminal build system"
  rm -rf "$SUBLIME_PACKAGES_DIR/ruby-iTerm2"
  git clone "https://github.com/dwkns/ruby-iTerm2.git" "$SUBLIME_PACKAGES_DIR/ruby-iTerm2"
  chmod u+x "$SUBLIME_PACKAGES_DIR/ruby-iTerm2/ruby-iterm2.sh"
  ln -s "$SUBLIME_PACKAGES_DIR/ruby-iTerm2/ruby-iterm2.sh" "/usr/local/bin"

  note "done"