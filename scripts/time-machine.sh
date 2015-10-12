#!/bin/bash 
######################## Time Machine ########################
msg "Adding Time Machine Exclusions"

TIME_MACHINE_EXCLUSION_LIST=(
  "$HOME/Downloads/"
  "$HOME/Library/Caches/"
  "$HOME/Documents/Torrents/"
  "$HOME/Documents/Parallels/"
  "$HOME/Library/Application Support/Google/"
)

for LOCATION in "${TIME_MACHINE_EXCLUSION_LIST[@]}"
do
  # ensure that the directories exist.
  mkdir -p "$LOCATION"
  sudo tmutil addexclusion "$LOCATION"
done

if $TM_DEBUG; then
  warn "These locations are being excluded :"
  sudo mdfind "com_apple_backup_excludeItem = 'com.apple.backupd'"
fi
note "done"

msg "Prevent Time Machine from prompting to use new hard drives as backup volume"
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true


warn "~/Dropbox has NOT added to the time machine exclusion list"
echo "If you want to add the exclusion run :"
echo "sudo tmutil addexclusion '~/Dropbox/'"

note "done"



# do we want to open the preferences?
# open /System/Library/PreferencePanes/TimeMachine.prefPane/

