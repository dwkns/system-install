#!/bin/bash
######################## SYSTEM Settings ########################


###################### set machine name ######################

echo -e "$PG Setting Machine name to : $PY $MACHINE_NAME"
sudo scutil --set ComputerName $MACHINE_NAME
sudo scutil --set HostName $MACHINE_NAME
sudo scutil --set LocalHostName $MACHINE_NAME
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string $MACHINE_NAME


######################  Random other configurations ######################
echo -e "$PG Disabling OS X Gate Keeper so no more annoying 'you can't open this app messages'"
sudo spctl --master-disable
sudo defaults write /var/db/SystemPolicy-prefs.plist enabled -string no
defaults write com.apple.LaunchServices LSQuarantine -bool false

echo -e "$PG Turn off keyboard illumination when computer is not used for 5 minutes"
defaults write com.apple.BezelServices kDimTime -int 300

echo -e "$PG Showing all filename extensions in Finder by default"
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

echo -e "$PG Showing Library & ~Library"
chflags nohidden ~/Library
chflags nohidden /Library

echo -e "$PG Hiding ~/Applications"
chflags hidden ~/Applications

echo -e "$PG Set sidebar icon size to medium"
defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 1

echo -e "$PG Scrollbars to automatic"
defaults write NSGlobalDomain AppleShowScrollBars -string "Automatic"
# Possible values: `WhenScrolling`, `Automatic` and `Always`

echo -e "$PG Increase window resize speed for Cocoa applications"
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001

echo -e "$PG Expand save panel by default"
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

echo -e "$PG Expand print panel by default"
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

echo -e "$PG Save to disk (not to iCloud) by default"
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

echo -e "$PG Automatically quit printer app once the print jobs complete"
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

echo -e "$PG Reveal IP address, hostname, OS version, etc. when clicking the clock in the login window"
sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName

# echo -e "$PG Restart automatically if the computer freezes"
# sudo systemsetup -setrestartfreeze on

echo -e "$PG Check for software updates daily, not just once per week"
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

echo -e "$PG Disable smart quotes as they’re annoying when typing code"
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

echo -e "$PG Disable smart dashes as they’re annoying when typing code"
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

echo -e "$PG Increase sound quality for Bluetooth headphones/headsets"
defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40

echo -e "$PG Set a blazingly fast keyboard repeat rate"
defaults write NSGlobalDomain KeyRepeat -int 0

###############################################################################
# Screen                                                                    #
###############################################################################


echo -e "$PG Save screenshots to the desktop"
defaults write com.apple.screencapture location -string "${HOME}/Desktop"

echo -e "$PG Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)"
defaults write com.apple.screencapture type -string "png"

echo -e "$PG Disable shadow in screenshots"
defaults write com.apple.screencapture disable-shadow -bool true

echo -e "$PG Enable subpixel font rendering on non-Apple LCDs"
defaults write NSGlobalDomain AppleFontSmoothing -int 2

###############################################################################
# Finder                                                                      #
###############################################################################

echo -e "$PG Set home folder as the default location for new Finder windows"
# "PfDe" - "file://${HOME}/Desktop/"
# For other paths, use "PfLo" - "file://${HOME}/Desktop/"
defaults write com.apple.finder NewWindowTarget -string "PfLo"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"

echo -e "$PG Show / hide icons for hard drives, servers, and removable media on the desktop"
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowMountedServersOnDesktop -bool false
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false

# echo -e "$PG Finder: show hidden files by default"
# defaults write com.apple.finder AppleShowAllFiles -bool true

echo -e "$PG Finder: show status bar"
defaults write com.apple.finder ShowStatusBar -bool false

echo -e "$PG Finder: show path bar"
defaults write com.apple.finder ShowPathbar -bool false

echo -e "$PG Finder: allow text selection in Quick Look"
defaults write com.apple.finder QLEnableTextSelection -bool true

echo -e "$PG Display full POSIX path as Finder window title"
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

echo -e "$PG When performing a search, search the current folder by default"
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

echo -e "$PG Disable the warning when changing a file extension"
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

echo -e "$PG Enable spring loading for directories"
defaults write NSGlobalDomain com.apple.springing.enabled -bool true

echo -e "$PG Remove the spring loading delay for directories"
defaults write NSGlobalDomain com.apple.springing.delay -float 0

echo -e "$PG Avoid creating .DS_Store files on network volumes"
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

echo -e "$PG Disable disk image verification"
defaults write com.apple.frameworks.diskimages skip-verify -bool true
defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true

echo -e "$PG Automatically open a new Finder window when a volume is mounted"
defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true
defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true

echo -e "$PG Increase grid spacing for icons on the desktop and in other icon views"
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist

echo -e "$PG Increase the size of icons on the desktop and in other icon views"
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:iconSize 60" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:iconSize 60" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:iconSize 60" ~/Library/Preferences/com.apple.finder.plist

echo -e "$PG Use list view in all Finder windows by default"
# Four-letter codes for the other view modes: `icnv`, `clmv`, `Flwv`
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

echo -e "$PG Disable the warning before emptying the Trash"
defaults write com.apple.finder WarnOnEmptyTrash -bool false

echo -e "$PG Set the icon size of Dock items to 36 pixels"
defaults write com.apple.dock tilesize -int 36

echo -e "$PG Show indicator lights for open applications in the Dock"
defaults write com.apple.dock show-process-indicators -bool true

echo -e "$PG Speed up Mission Control animations"
defaults write com.apple.dock expose-animation-duration -float 0.1

# # Don’t group windows by application in Mission Control
# # (i.e. use the old Exposé behavior instead)
# defaults write com.apple.dock expose-group-by-app -bool false

echo -e "$PG Disable Dashboard"
defaults write com.apple.dashboard mcx-disabled -bool true

echo -e "$PG Don’t show Dashboard as a Space"
defaults write com.apple.dock dashboard-in-overlay -bool true

echo -e "$PG Don’t automatically rearrange Spaces based on most recent use"
defaults write com.apple.dock mru-spaces -bool false

echo -e "$PG Remove the auto-hiding Dock delay"
defaults write com.apple.dock autohide-delay -float 0

echo -e "$PG Remove the animation when hiding/showing the Dock"
defaults write com.apple.dock autohide-time-modifier -float 0

echo -e "$PG Automatically hide and show the Dock"
defaults write com.apple.dock autohide -bool false

# echo -e "$PG Make Dock icons of hidden applications translucent"
# defaults write com.apple.dock showhidden -bool false



###############################################################################
# Safari & WebKit                                                             #
###############################################################################

echo -e "$PG Privacy: don’t send search queries to Apple"
defaults write com.apple.Safari UniversalSearchEnabled -bool false
defaults write com.apple.Safari SuppressSearchSuggestions -bool true

echo -e "$PG Show the full URL in the address bar (note: this still hides the scheme)"
defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true

echo -e "$PG Set Safari’s home page to about:blank for faster loading"
defaults write com.apple.Safari HomePage -string "about:blank"

echo -e "$PG Hide Safari’s bookmarks bar by default"
defaults write com.apple.Safari ShowFavoritesBar -bool false

echo -e "$PG Hide Safari’s sidebar in Top Sites"
defaults write com.apple.Safari ShowSidebarInTopSites -bool false

echo -e "$PG Make Safari’s search banners default to Contains instead of Starts With"
defaults write com.apple.Safari FindOnPageMatchesWordStartsOnly -bool false

echo -e "$PG Remove useless icons from Safari’s bookmarks bar"
defaults write com.apple.Safari ProxiesInBookmarksBar "()"

echo -e "$PG Enable the Develop menu and the Web Inspector in Safari"
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true

echo -e "$PG Add a context menu item for showing the Web Inspector in web views"
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true


###############################################################################
# Terminal & iTerm 2                                                         #
###############################################################################

echo -e "$PG Only use UTF-8 in Terminal.app"
defaults write com.apple.terminal StringEncodings -array 4


echo -e "$PG Don’t display the annoying prompt when quitting iTerm"
defaults write com.googlecode.iterm2 PromptOnQuit -bool false

###############################################################################
# Time Machine                                                                #
###############################################################################

echo -e "$PG Prevent Time Machine from prompting to use new hard drives as backup volume"
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true


###############################################################################
# Activity Monitor                                                            #
###############################################################################

echo -e "$PG Show the main window when launching Activity Monitor"
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true

echo -e "$PG Visualize CPU usage in the Activity Monitor Dock icon"
defaults write com.apple.ActivityMonitor IconType -int 5

echo -e "$PG Show all processes in Activity Monitor"
defaults write com.apple.ActivityMonitor ShowCategory -int 0

echo -e "$PG Sort Activity Monitor results by CPU usage"
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0

###############################################################################
# Address Book, Dashboard, iCal, TextEdit, and Disk Utility                   #
###############################################################################

echo -e "$PG Enable the debug menu in Address Book"
defaults write com.apple.addressbook ABShowDebugMenu -bool true

echo -e "$PG Sort Names by First Name / Last Name"
defaults write com.apple.addressbook ABNameSortingFormat -string "sortingFirstName sortingLastName"

echo -e "$PG Use plain text mode for new TextEdit documents"
defaults write com.apple.TextEdit RichText -int 0

echo -e "$PG Open and save files as UTF-8 in TextEdit"
defaults write com.apple.TextEdit PlainTextEncoding -int 4
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4

###############################################################################
# Mac App Store                                                               #
###############################################################################

echo -e "$PG Enable the WebKit Developer Tools in the Mac App Store"
defaults write com.apple.appstore WebKitDeveloperExtras -bool true

echo -e "$PG Enable Debug Menu in the Mac App Store"
defaults write com.apple.appstore ShowDebugMenu -bool true


###############################################################################
# Transmission.app                                                            #
###############################################################################

echo -e "$PG Use ~/Documents/Torrents to store incomplete downloads"
mkdir -p "$HOME/Documents/Torrents"
defaults write org.m0k.transmission UseIncompleteDownloadFolder -bool true
defaults write org.m0k.transmission IncompleteDownloadFolder -string "${HOME}/Documents/Torrents"

echo -e "$PG Don’t prompt for confirmation before downloading"
defaults write org.m0k.transmission DownloadAsk -bool false

echo -e "$PG Trash original torrent files"
defaults write org.m0k.transmission DeleteOriginalTorrent -bool true

echo -e "$PG Hide the donate message"
defaults write org.m0k.transmission WarningDonate -bool false

echo -e "$PG Hide the legal disclaimer"
defaults write org.m0k.transmission WarningLegal -bool false

echo -e "$PG Set the background colour"
osascript -e 'tell application "Finder" to set desktop picture to POSIX file "/Library/Desktop Pictures/Solid Colors/Solid Aqua Dark Blue.png"'


###############################################################################
# Kill affected applications                                                  #
###############################################################################

for app in "Activity Monitor" "Address Book" "Calendar" "Contacts" "cfprefsd" \
  "Dock" "Finder" "Google Chrome" "Mail" "Messages" \
  "Safari" "SystemUIServer"  \
  "Transmission"  "iCal"; do
  killall "${app}" > /dev/null 2>&1
done
echo -e "Done. Note that some of these changes require a logout/restart to take effect."
















