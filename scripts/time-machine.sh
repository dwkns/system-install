#!/bin/bash 
######################## Time Machine ########################
msg "Adding Time Machine Exclusions"

for LOCATION in "${TIME_MACHINE_EXCLUSION_LIST[@]}"
do
  sudo tmutil addexclusion "$LOCATION"
done

if $DEGBUG; then
warn "These locations are being excluded :"
sudo mdfind "com_apple_backup_excludeItem = 'com.apple.backupd'"
fi
note "done"

msg "Prevent Time Machine from prompting to use new hard drives as backup volume"
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true
note "done"



# do we want to open the preferences?
# open /System/Library/PreferencePanes/TimeMachine.prefPane/

