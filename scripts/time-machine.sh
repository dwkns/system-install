#!/usr/bin/env zsh
source "$HOME/.system-config/scripts/utils/colours.sh"

######################## Time Machine ########################
msg "Adding Time Machine Exclusions"

TIME_MACHINE_EXCLUSION_LIST=(
  "$HOME/Downloads/"
  "$HOME/Library/Caches/"
  "$HOME/Documents/Torrents/"
  "$HOME/Documents/Parallels/"
  "$HOME/Library/Application Support/Google/"
  "$HOME/Library/Calendars/Calendar Cache"
  "$HOME/Music/iTunes/iTunes Music Library.xml"
  "$HOME/Library/iTunes/iPod Software Updates"
  "$HOME/Library/iTunes/iPad Software Updates"
  "$HOME/Library/iTunes/iPhone Software Updates"
  "$HOME/Pictures/iPod Photo Cache"
  "$HOME/Music/iTunes/Album Artwork/Cache"
  "$HOME/Library/Saved Application State"
  "$HOME/Library/Icons/WebpageIcons.db"
  "$HOME/Library/Safari/WebpageIcons.db"
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



warn "~/Dropbox has NOT been added to the time machine exclusion list"
echo "If you want to add the exclusion run :"
echo "sudo tmutil addexclusion '~/Dropbox/'"

note "done"



# do we want to open the preferences?
# open /System/Library/PreferencePanes/TimeMachine.prefPane/

