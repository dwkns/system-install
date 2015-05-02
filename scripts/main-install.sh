#!/bin/bash
msg "Starting the main install"

# load all the configuation variables 
source $ROOT_DIR/scripts/config.sh  
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
note "done"

msg "All done I recommend Rebooting"



