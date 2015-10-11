##################### Configure Sublime ######################
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

  # if $DEBUG; then
  #   msg "Installing pin_console.py"
  #  cp -f "$ROOT_DIR/sublime-config-files/pin_console.py" "$SUBLIME_PACKAGES_DIR/pin_console.py"
  # fi 

  msg "Intalling license"
  cp -f "$ROOT_DIR/sublime-config-files/License.sublime_license" "$SUBLIME_LOCAL_DIR/License.sublime_license"

  msg "Installing sublime preferences"
  cp -f "$ROOT_DIR/sublime-config-files/Preferences.sublime-settings" "$SUBLIME_USER_DIR/Preferences.sublime-settings"

  msg "Installing scopehunter preferences"
  cp -f "$ROOT_DIR/sublime-config-files/scope_hunter.sublime-settings" "$SUBLIME_USER_DIR/scope_hunter.sublime-settings"

  msg "Installing SublimeLinter preferences"
  cp -f "$ROOT_DIR/sublime-config-files/SublimeLinter.sublime-settings" "$SUBLIME_USER_DIR/SublimeLinter.sublime-settings"

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