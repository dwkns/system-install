#!/usr/bin/env zsh
######################## SYSTEM Settings ########################
doing "Updating system settings"

######################  Random other configurations ######################
echo $CYAN"General :$RESET Turn off keyboard illumination when computer is not used for 5 minutes"
defaults write com.apple.BezelServices kDimTime -int 300

echo $CYAN"General :$RESET Scrollbars to WhenScrolling"
defaults write NSGlobalDomain AppleShowScrollBars -string "WhenScrolling"
# Possible values: `WhenScrolling`, `Automatic` and `Always`

echo $CYAN"General :$RESET Increase window resize speed for Cocoa applications"
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001

echo $CYAN"General :$RESET Automatically quit printer app once the print jobs complete"
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

# echo $CYAN"Restart automatically if the computer freezes"
# sudo systemsetup -setrestartfreeze on

echo $CYAN"General :$RESET Check for software updates daily, not just once per week"
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

echo $CYAN"General :$RESET Disable smart quotes as they're annoying when typing code"
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

echo $CYAN"General :$RESET Disable smart dashes as they’re annoying when typing code"
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

echo $CYAN"General :$RESET Increase sound quality for Bluetooth headphones/headsets"
defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40

echo $CYAN"General :$RESET Set a blazingly fast keyboard repeat rate"
# Disable press-and-hold for keys in favor of key repeat
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Set a blazingly fast keyboard repeat rate
defaults write -g KeyRepeat -int 1 # normal minimum is 2 (30 ms)
defaults write -g InitialKeyRepeat -int 15 # normal minimum is 15 (225 ms)

echo $CYAN"General :$RESET Set highlight color to green"
# defaults write NSGlobalDomain AppleHighlightColor -string "0.764700 0.976500 0.568600"


echo $CYAN"General :$RESET Disable the “Are you sure you want to open this application?” dialog"
#defaults write com.apple.LaunchServices LSQuarantine -bool false

echo $CYAN"General :$RESET Disable Resume system-wide"
defaults write com.apple.systempreferences NSQuitAlwaysKeepsWindows -bool false

echo $CYAN"General :$RESET Enable full keyboard access for all controls"
# Enable full keyboard access for all controls
# (e.g. enable Tab in modal dialogs)
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3



echo    

###############################################################################
# Time Machine                                                                #
###############################################################################

echo $CYAN"Time Machine :$RESET Prevent Time Machine from prompting to use new hard drives as backup volume"
# # Prevent Time Machine from prompting to use new hard drives as backup volume
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

# # Disable local Time Machine backups
# hash tmutil &> /dev/null && sudo tmutil disablelocal

echo

###############################################################################
# Screen                                                                    #
###############################################################################


echo $CYAN"Screen :$RESET Save screenshots to the desktop"
defaults write com.apple.screencapture location -string "${HOME}/Desktop"

echo $CYAN"Screen :$RESET Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)"
defaults write com.apple.screencapture type -string "png"

echo $CYAN"Screen :$RESET Disable shadow in screenshots"
defaults write com.apple.screencapture disable-shadow -bool true

echo $CYAN"Screen :$RESET Enable subpixel font rendering on non-Apple LCDs"
defaults write NSGlobalDomain AppleFontSmoothing -int 2

echo


###############################################################################
# Finder                                                                      #
###############################################################################

echo $CYAN"Finder :$RESET Setting interface style to Dark"
defaults write NSGlobalDomain AppleInterfaceStyle Dark

echo $CYAN"Finder :$RESET Expand save panel by default"
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

echo $CYAN"Finder :$RESET Expand print panel by default"
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

echo $CYAN"Finder :$RESET Save to disk (not to iCloud) by default"
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

echo $CYAN"Finder :$RESET Showing all filename extensions in Finder by default"
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

echo $CYAN"Finder :$RESET Showing Library & ~/Library"

chflags nohidden ~/Library && xattr -d com.apple.FinderInfo  ~/Library
chflags nohidden /Library && xattr -d com.apple.FinderInfo  /Library

echo $CYAN"Finder :$RESET Hiding ~/Applications"
chflags hidden ~/Applications

echo $CYAN"Finder :$RESET Set sidebar icon size to small"
defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 1

echo $CYAN"Finder :$RESET Set home folder as the default location for new Finder windows"
# "PfDe" - "file://${HOME}/Desktop/"
# For other paths, use "PfLo" - "file://${HOME}/Desktop/"
# defaults write com.apple.finder NewWindowTarget -string "PfLo"
# defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"

defaults write com.apple.finder NewWindowTarget -string "PfDe"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/Desktop/"

echo $CYAN"Finder :$RESET Show / hide icons for hard drives, servers, and removable media on the desktop"
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowMountedServersOnDesktop -bool false
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false

# echo $CYAN"Finder :$RESET show hidden files by default"
# defaults write com.apple.finder AppleShowAllFiles -bool true

echo $CYAN"Finder :$RESET hide status bar"
defaults write com.apple.finder ShowStatusBar -bool false

echo $CYAN"Finder :$RESET hide path bar"
defaults write com.apple.finder ShowPathbar -bool false

echo $CYAN"Finder :$RESET allow text selection in Quick Look"
defaults write com.apple.finder QLEnableTextSelection -bool true

echo $CYAN"Finder :$RESET Display full POSIX path as Finder window title"
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

echo $CYAN"Finder :$RESET When performing a search, search the current folder by default"
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

echo $CYAN"Finder :$RESET Disable the warning when changing a file extension"
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

echo $CYAN"Finder :$RESET Enable spring loading for directories"
defaults write NSGlobalDomain com.apple.springing.enabled -bool true

echo $CYAN"Finder :$RESET Remove the spring loading delay for directories"
defaults write NSGlobalDomain com.apple.springing.delay -float 0

echo $CYAN"Finder :$RESET Avoid creating .DS_Store files on network volumes"
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

echo $CYAN"Finder :$RESET Avoid creating .DS_Store files on network or USB volumes"
# Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

echo $CYAN"Finder :$RESET Disable disk image verification"
defaults write com.apple.frameworks.diskimages skip-verify -bool true
defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true

echo $CYAN"Finder :$RESET Automatically open a new Finder window when a volume is mounted"
defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true
defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true

# echo $CYAN"Finder :$RESET Increase grid spacing for icons on the desktop and in other icon views"
# /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:gridSpacing 85" ~/Library/Preferences/com.apple.finder.plist
# /usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:gridSpacing 85" ~/Library/Preferences/com.apple.finder.plist
# /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:gridSpacing 85" ~/Library/Preferences/com.apple.finder.plist

# echo $CYAN"Finder :$RESET Increase the size of icons on the desktop and in other icon views"
# /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:iconSize 50" ~/Library/Preferences/com.apple.finder.plist
# /usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:iconSize 50" ~/Library/Preferences/com.apple.finder.plist
# /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:iconSize 50" ~/Library/Preferences/com.apple.finder.plist

echo $CYAN"Finder :$RESET Use column view in all Finder windows by default"
# Flwv ▸ Cover Flow View
# Nlsv ▸ List View
# clmv ▸ Column View
# icnv ▸ Icon View
defaults write com.apple.finder FXPreferredViewStyle -string "clmv"

echo $CYAN"Finder :$RESET Disable the warning before emptying the Trash"
defaults write com.apple.finder WarnOnEmptyTrash -bool false

echo $CYAN"Finder :$RESET Set the icon size of Dock items to 36 pixels"
defaults write com.apple.dock tilesize -int 36

echo $CYAN"Finder :$RESET Show indicator lights for open applications in the Dock"
defaults write com.apple.dock show-process-indicators -bool true

echo $CYAN"Finder :$RESET Speed up Mission Control animations"
defaults write com.apple.dock expose-animation-duration -float 0.1

# # Don’t group windows by application in Mission Control
# # (i.e. use the old Exposé behavior instead)
# defaults write com.apple.dock expose-group-by-app -bool false

echo $CYAN"Finder :$RESET Disable Dashboard"
defaults write com.apple.dashboard mcx-disabled -bool true

echo $CYAN"Finder :$RESET Don’t show Dashboard as a Space"
defaults write com.apple.dock dashboard-in-overlay -bool true

echo $CYAN"Finder :$RESET Don’t automatically rearrange Spaces based on most recent use"
defaults write com.apple.dock mru-spaces -bool false

echo $CYAN"Finder :$RESET Remove the auto-hiding Dock delay"
defaults write com.apple.dock autohide-delay -float 0

echo $CYAN"Finder :$RESET Remove the animation when hiding/showing the Dock"
defaults write com.apple.dock autohide-time-modifier -float 0

echo $CYAN"Finder :$RESET Automatically hide and show the Dock"
defaults write com.apple.dock autohide -bool false

# echo $CYAN"Finder :$RESET Make Dock icons of hidden applications translucent"
# defaults write com.apple.dock showhidden -bool false

echo

###############################################################################
# Safari & WebKit                                                             #
###############################################################################

# Privacy: don’t send search queries to Apple
defaults write com.apple.Safari UniversalSearchEnabled -bool false
defaults write com.apple.Safari SuppressSearchSuggestions -bool true

# Prevent Safari from opening ‘safe’ files automatically after downloading
defaults write com.apple.Safari AutoOpenSafeDownloads -bool false

# Enable continuous spellchecking
defaults write com.apple.Safari WebContinuousSpellCheckingEnabled -bool true
# Disable auto-correct
defaults write com.apple.Safari WebAutomaticSpellingCorrectionEnabled -bool false

# Disable AutoFill
defaults write com.apple.Safari AutoFillFromAddressBook -bool false
defaults write com.apple.Safari AutoFillPasswords -bool false
defaults write com.apple.Safari AutoFillCreditCardData -bool false
defaults write com.apple.Safari AutoFillMiscellaneousForms -bool false

# Enable “Do Not Track”
defaults write com.apple.Safari SendDoNotTrackHTTPHeader -bool true


echo $CYAN"Safari :$RESET UniversalSearchEnabled set to true"
defaults write com.apple.Safari UniversalSearchEnabled -bool true

echo $CYAN"Safari :$RESET SuppressSearchSuggestions set to false"
defaults write com.apple.Safari SuppressSearchSuggestions -bool false

echo $CYAN"Safari :$RESET Show the full URL in the address bar (note: this still hides the scheme)"
defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true

echo $CYAN"Safari :$RESET Set Safari’s home page to about:blank for faster loading"
defaults write com.apple.Safari HomePage -string "about:blank"

echo $CYAN"Safari :$RESET Show Safari’s bookmarks bar by default"
defaults write com.apple.Safari ShowFavoritesBar -bool true

echo $CYAN"Safari :$RESET Hide Safari’s sidebar in Top Sites"
defaults write com.apple.Safari ShowSidebarInTopSites -bool false

echo $CYAN"Safari :$RESET Make Safari’s search banners default to Contains instead of Starts With"
defaults write com.apple.Safari FindOnPageMatchesWordStartsOnly -bool false

echo $CYAN"Safari :$RESET Remove useless icons from Safari’s bookmarks bar"
defaults write com.apple.Safari ProxiesInBookmarksBar "()"

echo $CYAN"Safari :$RESET Enable the Develop menu and the Web Inspector in Safari"
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true

echo $CYAN"Safari :$RESET Add a context menu item for showing the Web Inspector in web views"
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

echo

###############################################################################
# Activity Monitor                                                            #
###############################################################################

echo $CYAN"Activity Monitor :$RESET show the main window when launching"
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true

echo $CYAN"Activity Monitor :$RESET Visualize CPU usage in the Dock icon"
defaults write com.apple.ActivityMonitor IconType -int 5

echo $CYAN"Activity Monitor :$RESET Show all processes"
defaults write com.apple.ActivityMonitor ShowCategory -int 0

echo $CYAN"Activity Monitor :$RESET Sort results by CPU usage"
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0

echo

###############################################################################
# Address Book, Dashboard, iCal, TextEdit, and Disk Utility                   #
###############################################################################

echo $CYAN"Address Book :$RESET Enable the debug menu"
defaults write com.apple.addressbook ABShowDebugMenu -bool true

echo $CYAN"Address Book :$RESET Sort Names by First Name / Last Name"
defaults write com.apple.addressbook ABNameSortingFormat -string "sortingFirstName sortingLastName"

echo

echo $CYAN"TextEdit :$RESET Use plain text mode for new = documents"
defaults write com.apple.TextEdit RichText -int 0

echo $CYAN"TextEdit :$RESET Open and save files as UTF-8 in TextEdit"
defaults write com.apple.TextEdit PlainTextEncoding -int 4
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4

echo

###############################################################################
# Mac App Store                                                               #
###############################################################################

echo $CYAN"Mac App Store :$RESET Enable the WebKit Developer Tools in the Mac App Store"
defaults write com.apple.appstore WebKitDeveloperExtras -bool true

echo $CYAN"Mac App Store :$RESET Enable Debug Menu in the Mac App Store"
defaults write com.apple.appstore ShowDebugMenu -bool true


# Enable the automatic update check
defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true

# Check for software updates daily, not just once per week
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

# Download newly available updates in background
defaults write com.apple.SoftwareUpdate AutomaticDownload -int 1

# Install System data files & security updates
defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -int 1

# Automatically download apps purchased on other Macs
defaults write com.apple.SoftwareUpdate ConfigDataInstall -int 1

# Turn on app auto-update
defaults write com.apple.commerce AutoUpdate -bool true

# Allow the App Store to reboot machine on macOS updates
defaults write com.apple.commerce AutoUpdateRestartRequired -bool true




echo

###############################################################################
# Photos                                                                      #
###############################################################################

# Prevent Photos from opening automatically when devices are plugged in
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true




###############################################################################
# Transmission.app                                                            #
###############################################################################

echo $CYAN"Transmission.app :$RESET Use ~/Downloads/Torrents to store incomplete downloads"

# mkdir -p "$HOME/Downloads/Torrents"
defaults write org.m0k.transmission UseIncompleteDownloadFolder -bool true
defaults write org.m0k.transmission IncompleteDownloadFolder -string "${HOME}/Downloads/Torrents"

# Use `~/Downloads` to store completed downloads
defaults write org.m0k.transmission DownloadLocationConstant -bool true

# Don’t prompt for confirmation before removing non-downloading active transfers
defaults write org.m0k.transmission CheckRemoveDownloading -bool true

echo $CYAN"Transmission.app :$RESET Don’t prompt for confirmation before downloading"
defaults write org.m0k.transmission DownloadAsk -bool false
defaults write org.m0k.transmission MagnetOpenAsk -bool false

echo $CYAN"Transmission.app :$RESET Trash original torrent files"
defaults write org.m0k.transmission DeleteOriginalTorrent -bool true

echo $CYAN"Transmission.app :$RESET Hide the donate message"
defaults write org.m0k.transmission WarningDonate -bool false

echo $CYAN"Transmission.app :$RESET Hide the legal disclaimer"
defaults write org.m0k.transmission WarningLegal -bool false

echo

echo $CYAN"iTerm2.app :$RESET ~/.system-config/system-config-files/ for preferences"
# Specify the preferences directory
defaults write com.googlecode.iterm2.plist PrefsCustomFolder -string "~/.system-config/system-config-files/"
# Tell iTerm2 to use the custom preferences in the directory
defaults write com.googlecode.iterm2.plist LoadPrefsFromCustomFolder -bool true
echo
echo $CYAN"Github :$RESET use osxkeychain to store password"
git config --global credential.helper osxkeychain

echo
echo $CYAN"Desktop :$RESET Adding Symlink to ~/Dropbox/dev"
ln -s ~/Dropbox/dev ~/Desktop
echo
echo
success "done - some settings may require a restart"






