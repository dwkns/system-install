#!/bin/bash
######################## SYSTEM Settings ########################


###################### set machine name ######################

sudo scutil --set ComputerName $MACHINE_NAME
sudo scutil --set HostName $MACHINE_NAME
sudo scutil --set LocalHostName $MACHINE_NAME
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string $MACHINE_NAME


######################  Random other configurations ######################
echo -e "$PG   Disabling OS X Gate Keeper so no more annoying 'you can't open this app messages'"
sudo spctl --master-disable
sudo defaults write /var/db/SystemPolicy-prefs.plist enabled -string no
defaults write com.apple.LaunchServices LSQuarantine -bool false

echo -e "$PG   Increasing the window resize speed for Cocoa applications"
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001

echo -e "$PG   Saving to disk (not to iCloud) by default"
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

echo -e "$PG   Setting a blazingly fast keyboard repeat rate"
defaults write NSGlobalDomain KeyRepeat -int 0

echo -e "$PG   Turn off keyboard illumination when computer is not used for 5 minutes"
defaults write com.apple.BezelServices kDimTime -int 300

echo -e "$PG   Showing all filename extensions in Finder by default"
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

echo -e "$PG   Displaying full POSIX path as Finder window title"
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

echo -e "$PG   Disabling the warning when changing a file extension"
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

echo -e "$PG   Use column view in all Finder windows by default"
defaults write com.apple.finder FXPreferredViewStyle Clmv

echo -e "$PG   Avoiding the creation of .DS_Store files on network volumes"
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

echo -e "$PG   Setting the icon size of Dock items to 36 pixels for optimal size/screen-realestate"
defaults write com.apple.dock tilesize -int 36

echo -e "$PG   Hiding dashboard"
defaults write com.apple.dashboard mcx-disabled -boolean true

echo -e "$PG   Showing Library & ~Library"
chflags nohidden ~/Library
chflags nohidden /Library