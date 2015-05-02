#!/bin/bash
######################## CLEAN ########################
remove_homebrew () {
    warn "Removing Homebrew"
    sudo rm -rf "/usr/local"
    sudo rm -rf "/Library/Caches/Homebrew"
    note "Done"
}

remove_system_config () {
    warn "Removing '~/.system-config'"
    rm -rf "$HOME/.system-config"
    note "Done"
}

remove_cask () {
    warn "Removing Cask"

    sudo rm -rf  "/opt/homebrew-cask"
    #remove symlinks from Application folder - anoying escaping at end.
    find /Applications -maxdepth 1 -lname '*' -exec rm {} \;
note "Done"	
}

remove_krep () {
    warn "Removing Krep"
    sudo rm -rf "/Applications/Krep.app"
    if command -v dockutil > /dev/null 2>&1; then
      dockutil --remove "Krep" --no-restart
       Killall Dock 
  else
    warn "dockutil not installed. Unable to remove apps from Dock"
  fi
    note "Done"
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
note "Done"
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
 note "Done"
}

remove_sublime_config () {
  warn "Removing SublimeConfig"
  sudo rm -rf "$HOME/Library/Application Support/Sublime Text 3"
  sudo rm -rf "/usr/local/bin/ruby-iterm2.sh"
  note "Done"
}

remove_rvm_ruby_gems () {
  warn "Removing rvm"
  sudo rm -rf "$HOME/.rvm"
  note "Done"
}

remove_iterm () {
  warn "Removing iterm"
  rm -rf "$HOME/Library/Preferences/com.googlecode.iterm2.plist"
  rm -rf "$HOME/Library/Application Support/iTerm"
  rm -rf "$HOME/Library/Application Support/iTerm2"
  rm -rf "$HOME/Library/Caches/com.googlecode.iterm2"
  killall cfprefsd
note "Done"
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
    Killall Dock	
  else
    warn "dockutil not installed. Unable to remove apps from Dock"
  fi
 note "Done"
}

remove_time_machine_exclusions () {
  for LOCATION in "${EXCLUSION_LIST[@]}"
  do
    	sudo tmutil removeexclusion "$LOCATION"
  done
	if $DEBUG; then
  		echo -e "$PG These locations will still be backed up :"
  		sudo mdfind "com_apple_backup_excludeItem = 'com.apple.backupd'"
	fi
  	note "Done"
}

clean_all () {
  remove_krep
  remove_iterm
  remove_apps_from_dock
  remove_homebrew
  remove_dotfiles
  remove_postgres
  remove_sublime_config
  remove_system_config
  remove_time_machine_exclusions
  remove_rvm_ruby_gems
}