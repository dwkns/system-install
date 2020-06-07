  #!/usr/bin/env zsh
  source "$HOME/.system-config/scripts/utils/colours.sh"

  ##################### Configure Sublime ######################
 
  success "Configure sublime"

  
  # Set up some defaults
  ROOT_DIR="$HOME/.system-config"
  SUBLIME="$HOME/Library/Application Support/Sublime Text 3"
  SUBLIME_LOCAL="$SUBLIME/local"
  SUBLIME_PACKAGES="$SUBLIME/Packages"
  SUBLIME_USER="$SUBLIME/Packages/User"
  SUBLIME_INSTALLED_PACKAGES="$SUBLIME/Installed Packages"
  DWKNS_SETTINGS="$SUBLIME_USER/dwkns-sublime-settings"


  success "Removing the existing Sublime User folder"
  rm -rf "$SUBLIME_USER" # clean the Sublime user folder

  mkdir -p "$SUBLIME_LOCAL"
  mkdir -p "$SUBLIME_USER"
  mkdir -p "$SUBLIME_INSTALLED_PACKAGES"

  ### first clone in the settings folder
  success "Cloning in dwkns settings"
  rm -rf "$SUBLIME_USER/dwkns-sublime-settings"
  git clone "https://github.com/dwkns/dwkns-sublime-settings.git" "$SUBLIME_USER/dwkns-sublime-settings"

  success "Cloning in A3 Theme"
  rm -rf "$SUBLIME_PACKAGES/A3-Theme"
  git clone "https://github.com/dwkns/A3-Theme.git" "$SUBLIME_PACKAGES/A3-Theme"


  success "Cloning in the dwkns fork of tailwind-sublime-autocomplete"
  rm -rf "$SUBLIME_PACKAGES/tailwind-sublime-autocomplete"
  git clone "https://github.com/dwkns/tailwind-sublime-autocomplete.git" "$SUBLIME_PACKAGES/tailwind-sublime-autocomplete"
  
  success "Intalling license"
  cp -f "$DWKNS_SETTINGS/License.sublime_license" "$SUBLIME_LOCAL/License.sublime_license"

  success "Installing Package Control"
  curl -L "http://sublime.wbond.net/Package Control.sublime-package" -o "$SUBLIME_INSTALLED_PACKAGES/Package Control.sublime-package"

  success "Creating Symbolic links for various files"
  DWKNS_SETTINGS="dwkns-sublime-settings"
  files=( 
    "Preferences.sublime-settings"
    "Package Control.sublime-settings"
    "SublimeLinter.sublime-settings"
    "scope_hunter.sublime-settings"
    "BeautifyRuby.sublime-settings"
    "Emmet.sublime-settings"
    "Default (OSX).sublime-keymap"
    "HTMLPrettify.sublime-settings"
    "JavaScript (Babel).sublime-settings"
    "test.py"
  )

  for i in "${files[@]}"
  do
     rm -f "$DWKNS_SETTINGS/$i"
     ln -s "$DWKNS_SETTINGS/settings/$i" "$SUBLIME_USER/$i"
  done

  # success "Cloning in my Rails snippets"
  # rm -rf "$SUBLIME_PACKAGES/Rails"
  # git clone "https://github.com/dwkns/sublime_rails_snippets.git" "$SUBLIME_PACKAGES/Rails"

  note "done"