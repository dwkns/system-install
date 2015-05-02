#!/bin/bash 
######################## Time Machine ########################
echo -e "$PG Adding Time Machine Exclusions"



for LOCATION in "${EXCLUSION_LIST[@]}"
do
  sudo tmutil addexclusion "$LOCATION"
done

echo -e "$PG These locations are being excluded :"
sudo mdfind "com_apple_backup_excludeItem = 'com.apple.backupd'"

###############################################################################
# Time Machine                                                                #
###############################################################################

echo -e "$PG Prevent Time Machine from prompting to use new hard drives as backup volume"
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true



# open /System/Library/PreferencePanes/TimeMachine.prefPane/

