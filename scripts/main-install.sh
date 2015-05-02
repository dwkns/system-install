#!/bin/bash
msg "Starting the main install"

if ! $CLEAN_INSTALL; then
  # load all the configuation variables 
  source $ROOT_DIR/scripts/config.sh 

  # load the cleaing scripts
  source $ROOT_DIR/scripts/clean.sh 

  # choose what to clean
  remove_krep
  remove_iterm
  remove_apps_from_dock
  # remove_homebrew # probably not a good idea to do this here
  # remove_system_files # probably not a good idea to do this here
  remove_dotfiles
  remove_postgres
  remove_sublime_config
  remove_time_machine_exclusions
  remove_rvm_ruby_gems
fi

source $ROOT_DIR/scripts/dotfiles.sh  
source $ROOT_DIR/scripts/brew-packages.sh
source $ROOT_DIR/scripts/apps.sh
source $ROOT_DIR/scripts/system-settings.sh
source $ROOT_DIR/scripts/time-machine.sh
source $ROOT_DIR/scripts/rvm-ruby-gems.sh

## Install any Apple System Updates
if $SOFTWARE_UPDATE; then
    msg "Checking for Apple System Updates"
    sudo softwareupdate -ia
    note "done"
  else
    warn "Not checking for Apple System Updates"
fi

## Clean up           
msg "Resarting a bunch of stuff"
for app in "Activity Monitor" "Address Book" "Calendar" "Contacts" "cfprefsd" \
  "Dock" "Finder" "Google Chrome" "Mail" "Messages" \
  "Safari" "SystemUIServer"  \
  "Transmission"  "iCal"; do
  killall "${app}" > /dev/null 2>&1
done
note "done"

msg "load bash profile into shell"
source $HOME/.bash_profile
note "done"

msg "Deleteing Temp Directories"
rm -rf "/tmp/krep"
rm -rf $TMP_DIR
note "done"

msg "All done I recommend Rebooting"



