#!/bin/bash 
######################## Time Machine ########################
echo -e "$PG Adding Time Machine Exclusions"



for LOCATION in "${EXCLUSION_LIST[@]}"
do
  sudo tmutil addexclusion "$LOCATION"
done

echo -e "$PG These locations are being excluded :"
sudo mdfind "com_apple_backup_excludeItem = 'com.apple.backupd'"

open /System/Library/PreferencePanes/TimeMachine.prefPane/

