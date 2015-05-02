#!/bin/bash
######################## CLEAN ########################

############ FUNCTIONS ############


remove_homebrew () {
    echo -e "$PR Removing Homebrew"
    sudo rm -rf "/usr/local"
    sudo rm -rf "/Library/Caches/Homebrew"
    echo -e "$PDONE"
}

remove_system_config () {
    echo -e "$PR Removing '~/.system-config'"
    rm -rf "$HOME/.system-config"
    echo -e "$PDONE"
}

remove_cask () {
    echo -e "$PR Removing Cask"

    sudo rm -rf  "/opt/homebrew-cask"
    #remove symlinks from Application folder - anoying escaping at end.
    find /Applications -maxdepth 1 -lname '*' -exec rm {} \;
echo -e "$PDONE"	
}

remove_krep () {
    echo -e "$PR Removing Krep"
    sudo rm -rf "/Applications/Krep.app"
    dockutil --remove "Krep" --no-restart
echo -e "$PDONE"
}

remove_postgres () {
echo -e "$PR Removing Postgres"
    launchctl unload ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist # quit posgres
	
	if command -v brew > /dev/null 2>&1; then
  	  brew uninstall postgresql # test if brew is installed first?
	fi

    sudo rm -rf "/usr/local/var"  && (echo "/usr/local/var removed"; exit 0) || (c=$?; echo "NOK"; (exit $c))
    sudo rm -rf "$HOME/Library/LaunchAgents/homebrew.mxcl.postgresql.plist"
    sudo rm -rf "$HOME/Library/LaunchAgents/*.plist"
echo -e "$PDONE"
}


remove_dotfiles () {
  echo -e "$PR Removing dotfiles"
  sudo rm -rf "$HOME/.git*"
  sudo rm -rf "$HOME/.rspec"
  sudo rm -rf "$HOME/.profile"
  sudo rm -rf "$HOME/.bash_profile"
  sudo rm -rf "$HOME/.zshrc"
  sudo rm -rf "$HOME/.zlogin"
  sudo rm -rf "$HOME/.gem"
  sudo rm -rf "$HOME/.dropbox"
  sudo rm -rf "$HOME/.subversion"
 echo -e "$PDONE"
}

remove_sublime_config () {
  echo -e "$PR Removing SublimeConfig"
  sudo rm -rf "$HOME/Library/Application Support/Sublime Text 3"
  sudo rm -rf "/usr/local/bin/ruby-iterm2.sh"
  echo -e "$PDONE"
}

remove_rvm () {
  echo -e "$PR Removing rvm"
  sudo rm -rf "$HOME/.rvm"
echo -e "$PDONE"
}

remove_apps(){
  echo -e "$PR Removing Apps"
  sudo rm -rf "/usr/bin/motion"
  sudo rm -rf "/Library/RubyMotion"
  sudo rm -rf "/tmp/krep"

 echo -e "$PDONE"
}

remove_iterm () {
  echo -e "$PR Removing iterm"
  rm -rf "$HOME/Library/Preferences/com.googlecode.iterm2.plist"
  rm -rf "$HOME/Library/Application Support/iTerm"
  rm -rf "$HOME/Library/Application Support/iTerm2"
  rm -rf "$HOME/Library/Caches/com.googlecode.iterm2"
  killall cfprefsd
echo -e "$PDONE"
}

remove_apps_from_dock () {
  echo -e "$PR Removing apps from Dock"
   if command -v dockutil > /dev/null 2>&1; then
   for APP in "${ADD_TO_DOCK[@]}"
  	do
    		appNameFromCask=`brew cask info $APP | sed -n '/==> Contents/{n;p;}'`
    		appname=`echo -e ${appNameFromCask:0:${#appNameFromCask}-6}`

    		appnameWithoutSuffix="${appname%????}"

    		dockutil --remove "$appnameWithoutSuffix" --no-restart
  	done
    	Killall Dock
  fi
 echo -e "$PDONE"
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
  	echo -e "$PDONE"
}

clean_all () {
  remove_krep
  remove_apps_from_dock
  remove_postgres
  remove_dotfiles
  remove_iterm
  remove_apps
  remove_sublime_config
  remove_rvm
  remove_cask
  remove_homebrew
  remove_time_machine_exclusions
}