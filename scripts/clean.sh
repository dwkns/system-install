#!/bin/bash
######################## CLEAN ########################



remove_cask () {
    warn "Removing Cask"

    sudo rm -rf  "/opt/homebrew-cask"
    #remove symlinks from Application folder - anoying escaping at end.
    find /Applications -maxdepth 1 -lname '*' -exec rm {} \;
	
}

remove_krep () {
  warn "Removing Krep"
  rm -rf "/Applications/Krep.app"
  if command -v dockutil > /dev/null 2>&1; then
    echo "removing Krep"
    dockutil --remove "Krep" --no-restart
  else
    echo "Dockutil not installed. Unable to remove Krep from Dock"
  fi
   
}

remove_postgres () {
warn "Removing Postgres"
    launchctl unload ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist # quit posgres
	
	if command -v brew > /dev/null 2>&1; then
  	  brew uninstall postgresql # test if brew is installed first?
	fi

    sudo rm -rf "/usr/local/var"  && (echo "/usr/local/var removed"; exit 0) || (c=$?; echo "NOK"; (exit $c))
    sudo rm -rf "$HOME/Library/LaunchAgents/homebrew.mxcl.postgresql.plist"
    sudo rm -rf "$HOME/Library/LaunchAgents/*.plist"
}

remove_dotfiles () {
  warn "Removing dotfiles"
  sudo rm -rf "$HOME/.git*"
  sudo rm -rf "$HOME/.rspec"
  sudo rm -rf "$HOME/.profile"
  sudo rm -rf "$HOME/.bash_profile"
  sudo rm -rf "$HOME/.zshrc"
  sudo rm -rf "$HOME/.zlogin"
  sudo rm -rf "$HOME/.gem"
  sudo rm -rf "$HOME/.dropbox"
  sudo rm -rf "$HOME/.subversion"
 
}

remove_sublime_config () {
  warn "Removing SublimeConfig"
  sudo rm -rf "$HOME/Library/Application Support/Sublime Text 3"
  sudo rm -rf "/usr/local/bin/ruby-iterm2.sh"
  
}

remove_rvm_ruby_gems () {
  warn "Removing rvm"
  sudo rm -rf "$HOME/.rvm"
  
}

remove_iterm () {
  warn "Removing iterm"
  rm -rf "$HOME/Library/Preferences/com.googlecode.iterm2.plist"
  rm -rf "$HOME/Library/Application Support/iTerm"
  rm -rf "$HOME/Library/Application Support/iTerm2"
  rm -rf "$HOME/Library/Caches/com.googlecode.iterm2"
}

remove_apps_from_dock () {
  warn "Removing apps from Dock"
   if command -v dockutil > /dev/null 2>&1; then
   for APP in "${ADD_TO_DOCK[@]}"
  	do
    		appNameFromCask=`brew cask info $APP | sed -n '/==> Contents/{n;p;}'`
    		appname=`echo -e ${appNameFromCask:0:${#appNameFromCask}-6}`

    		appnameWithoutSuffix="${appname%????}"

    		dockutil --remove "$appnameWithoutSuffix" --no-restart
  	done	
  else
    echo "Dockutil not installed. Unable to remove apps from Dock"
  fi
 
}

remove_time_machine_exclusions () {
  warn "Removing time machine exclusions"
  for LOCATION in "${EXCLUSION_LIST[@]}"
  do
    	sudo tmutil removeexclusion "$LOCATION"
  done
	if $TM_DEBUG; then
  		echo "These locations will still be backed up :"
  		sudo mdfind "com_apple_backup_excludeItem = 'com.apple.backupd'"
	fi
  	
}

remove_homebrew () {
  warn "Removing Homebrew"
  sudo rm -rf "/usr/local"
  sudo rm -rf "/Library/Caches/Homebrew"  
}

remove_system_files () {
  warn "Removing '~/.system-config'"
  rm -rf "$HOME/.system-config"
}


clean_all () {
  msg "Doing a complete clean up - this deletes shits loads of stuff"
  remove_krep
  remove_apps_from_dock
  remove_iterm
  remove_homebrew
  remove_system_files
  remove_dotfiles
  remove_postgres
  remove_sublime_config
  remove_time_machine_exclusions
  remove_rvm_ruby_gems
  killall Dock
killall cfprefsd
  note "done"
}