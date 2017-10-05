 
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

  msg "Intalling license"
  cp -f "$ROOT_DIR/sublime-config-files/License.sublime_license" "$SUBLIME_LOCAL_DIR/License.sublime_license"

  msg "Installing Package Control"
  curl -L "http://sublime.wbond.net/Package Control.sublime-package" -o "$SUBLIME_INSTALLED_PACKAGES_DIR/Package Control.sublime-package"

 msg "Installing sublime Package Control Settings"
  cp -f "$ROOT_DIR/sublime-config-files/Package Control.sublime-settings" "$SUBLIME_USER_DIR/Package Control.sublime-settings"

  msg "Installing sublime preferences"
  cp -f "$ROOT_DIR/sublime-config-files/Preferences.sublime-settings" "$SUBLIME_USER_DIR/Preferences.sublime-settings"

    msg "Installing Douglas Colour Theme"
  cp -f "$ROOT_DIR/sublime-config-files/Douglas.tmTheme" "$SUBLIME_USER_DIR/Douglas.tmTheme"

  # msg "Installing scopehunter preferences"
  # cp -f "$ROOT_DIR/sublime-config-files/scope_hunter.sublime-settings" "$SUBLIME_USER_DIR/scope_hunter.sublime-settings"

  msg "Installing SublimeLinter preferences"
  cp -f "$ROOT_DIR/sublime-config-files/SublimeLinter.sublime-settings" "$SUBLIME_USER_DIR/SublimeLinter.sublime-settings"
  
  msg "Cloning in my Macros"
  rm -rf "$SUBLIME_USER_DIR/custom_macros"
  git clone "https://github.com/dwkns/sublime_macros.git" "$SUBLIME_USER_DIR/custom_macros"
 

  # msg "Cloning in my Douglas theme"
  # rm -rf "$SUBLIME_PACKAGES_DIR/Theme - Douglas"
  # git clone "https://github.com/dwkns/Douglas.git" "$SUBLIME_PACKAGES_DIR/Theme - Douglas"

  msg "Cloning in my Rails snippets"
  rm -rf "$SUBLIME_PACKAGES_DIR/Rails"
  git clone "https://github.com/dwkns/sublime_rails_snippets.git" "$SUBLIME_PACKAGES_DIR/Rails"



  msg "Installing sublime keymap"
  cp -f "$ROOT_DIR/sublime-config-files/Default (OSX).sublime-keymap" "$SUBLIME_USER_DIR/Default (OSX).sublime-keymap"

  msg "Intalling ruby-terminal build system"
  rm -rf "$SUBLIME_PACKAGES_DIR/ruby-iTerm2"
  git clone "https://github.com/dwkns/ruby-iTerm2.git" "$SUBLIME_PACKAGES_DIR/ruby-iTerm2"
  chmod u+x "$SUBLIME_PACKAGES_DIR/ruby-iTerm2/ruby-iterm2.sh"
  ln -s "$SUBLIME_PACKAGES_DIR/ruby-iTerm2/ruby-iterm2.sh" "/usr/local/bin"

  note "done"