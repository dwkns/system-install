  #!/usr/bin/env bash

  source "$HOME/.system-config/scripts/colours.sh"

  ##################### Configure Sublime ######################
 
  msg "Configure sublime"

  
  # Set up some defaults
  ROOT_DIR="$HOME/.system-config"
  SUBLIME="$HOME/Library/Application Support/Sublime Text 3"
  SUBLIME_LOCAL="$SUBLIME/local"
  SUBLIME_PACKAGES="$SUBLIME/Packages"
  SUBLIME_USER="$SUBLIME/Packages/User"
  SUBLIME_INSTALLED_PACKAGES="$SUBLIME/Installed Packages"
  DWKNS_SETTINGS="$SUBLIME_USER/dwkns-sublime-settings"


  msg "Removing the existing Sublime User folder"
  rm -rf "$SUBLIME_USER" # clean the Sublime user folder

  mkdir -p "$SUBLIME_LOCAL"
  mkdir -p "$SUBLIME_USER"
  mkdir -p "$SUBLIME_INSTALLED_PACKAGES"

  ### first clone in the settings folder
  msg "Cloning in dwkns settings"
  rm -rf "$SUBLIME_USER/dwkns-sublime-settings"
  git clone "https://github.com/dwkns/dwkns-sublime-settings.git" "$SUBLIME_USER/dwkns-sublime-settings"
  
  msg "Intalling license"
  cp -f "$DWKNS_SETTINGS/License.sublime_license" "$SUBLIME_LOCAL/License.sublime_license"

  msg "Installing Package Control"
  curl -L "http://sublime.wbond.net/Package Control.sublime-package" -o "$SUBLIME_INSTALLED_PACKAGES/Package Control.sublime-package"

  msg "Creating Symbolic links for various files"
  DWKNS_SETTINGS="dwkns-sublime-settings"
  files=( 
    "Preferences.sublime-settings"
    "Package Control.sublime-settings"
    "SublimeLinter.sublime-settings"
    "scope_hunter.sublime-settings"
    "BeautifyRuby.sublime-settings"
    "Default (OSX).sublime-keymap"
  )

  for i in "${files[@]}"
  do
     rm -f "$DWKNS_SETTINGS/$i"
     ln -s "$DWKNS_SETTINGS/settings/$i" "$SUBLIME_USER/$i"
  done

  msg "Cloning in my Rails snippets"
  rm -rf "$SUBLIME_PACKAGES/Rails"
  git clone "https://github.com/dwkns/sublime_rails_snippets.git" "$SUBLIME_PACKAGES/Rails"

  note "done"