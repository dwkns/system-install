#!/bin/bash
######################## SYSTEM Settings ########################
msg "Updating system settings"


######################  Random other configurations ######################
echo "General : Turn off keyboard illumination when computer is not used for 5 minutes"
defaults write com.apple.BezelServices kDimTime -int 300

echo "General : Scrollbars to WhenScrolling"
defaults write NSGlobalDomain AppleShowScrollBars -string "WhenScrolling"
# Possible values: `WhenScrolling`, `Automatic` and `Always`

echo "General : Increase window resize speed for Cocoa applications"
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001

echo "General : Automatically quit printer app once the print jobs complete"
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

# echo "Restart automatically if the computer freezes"
# sudo systemsetup -setrestartfreeze on

echo "General : Check for software updates daily, not just once per week"
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

echo "General : Disable smart quotes as they're annoying when typing code"
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

echo "General : Disable smart dashes as they’re annoying when typing code"
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

echo "General : Increase sound quality for Bluetooth headphones/headsets"
defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40

echo "General : Set a blazingly fast keyboard repeat rate"
# Disable press-and-hold for keys in favor of key repeat
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Set a blazingly fast keyboard repeat rate
defaults write NSGlobalDomain KeyRepeat -int 1 
defaults write NSGlobalDomain InitialKeyRepeat -int 12

# defaults write -g KeyRepeat -float 0.000000000001 # normal minimum is 2 (30 ms)
# defaults write -g InitialKeyRepeat -int 12 # normal minimum is 15 (225 ms)



echo                        

###############################################################################
# Screen                                                                    #
###############################################################################


echo "Screen : Save screenshots to the desktop"
defaults write com.apple.screencapture location -string "${HOME}/Desktop"

echo "Screen : Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)"
defaults write com.apple.screencapture type -string "png"

echo "Screen : Disable shadow in screenshots"
defaults write com.apple.screencapture disable-shadow -bool true

echo "Screen : Enable subpixel font rendering on non-Apple LCDs"
defaults write NSGlobalDomain AppleFontSmoothing -int 2

echo


###############################################################################
# Finder                                                                      #
###############################################################################

echo "Finder : Setting interface style to Dark"
defaults write NSGlobalDomain AppleInterfaceStyle Dark

echo "Finder : Expand save panel by default"
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

echo "Finder : Expand print panel by default"
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

echo "Finder : Save to disk (not to iCloud) by default"
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

echo "Finder : Showing all filename extensions in Finder by default"
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

echo "Finder : Showing Library & ~/Library"
chflags nohidden ~/Library
chflags nohidden /Library

echo "Finder : Hiding ~/Applications"
chflags hidden ~/Applications

echo "Finder : Set sidebar icon size to small"
defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 1

echo "Finder : Set home folder as the default location for new Finder windows"
# "PfDe" - "file://${HOME}/Desktop/"
# For other paths, use "PfLo" - "file://${HOME}/Desktop/"
defaults write com.apple.finder NewWindowTarget -string "PfLo"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"

echo "Finder : Show / hide icons for hard drives, servers, and removable media on the desktop"
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowMountedServersOnDesktop -bool false
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false

# echo "Finder : show hidden files by default"
# defaults write com.apple.finder AppleShowAllFiles -bool true

echo "Finder : hide status bar"
defaults write com.apple.finder ShowStatusBar -bool false

echo "Finder : hide path bar"
defaults write com.apple.finder ShowPathbar -bool false

echo "Finder : allow text selection in Quick Look"
defaults write com.apple.finder QLEnableTextSelection -bool true

echo "Finder : Display full POSIX path as Finder window title"
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

echo "Finder : When performing a search, search the current folder by default"
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

echo "Finder : Disable the warning when changing a file extension"
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

echo "Finder : Enable spring loading for directories"
defaults write NSGlobalDomain com.apple.springing.enabled -bool true

echo "Finder : Remove the spring loading delay for directories"
defaults write NSGlobalDomain com.apple.springing.delay -float 0

echo "Finder : Avoid creating .DS_Store files on network volumes"
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

echo "Finder : Disable disk image verification"
defaults write com.apple.frameworks.diskimages skip-verify -bool true
defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true

echo "Finder : Automatically open a new Finder window when a volume is mounted"
defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true
defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true

# echo "Finder : Increase grid spacing for icons on the desktop and in other icon views"
# /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:gridSpacing 85" ~/Library/Preferences/com.apple.finder.plist
# /usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:gridSpacing 85" ~/Library/Preferences/com.apple.finder.plist
# /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:gridSpacing 85" ~/Library/Preferences/com.apple.finder.plist

# echo "Finder : Increase the size of icons on the desktop and in other icon views"
# /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:iconSize 50" ~/Library/Preferences/com.apple.finder.plist
# /usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:iconSize 50" ~/Library/Preferences/com.apple.finder.plist
# /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:iconSize 50" ~/Library/Preferences/com.apple.finder.plist

echo "Finder : Use column view in all Finder windows by default"
# Flwv ▸ Cover Flow View
# Nlsv ▸ List View
# clmv ▸ Column View
# icnv ▸ Icon View
defaults write com.apple.finder FXPreferredViewStyle -string "clmv"

echo "Finder : Disable the warning before emptying the Trash"
defaults write com.apple.finder WarnOnEmptyTrash -bool false

echo "Finder : Set the icon size of Dock items to 36 pixels"
defaults write com.apple.dock tilesize -int 36

echo "Finder : Show indicator lights for open applications in the Dock"
defaults write com.apple.dock show-process-indicators -bool true

echo "Finder : Speed up Mission Control animations"
defaults write com.apple.dock expose-animation-duration -float 0.1

# # Don’t group windows by application in Mission Control
# # (i.e. use the old Exposé behavior instead)
# defaults write com.apple.dock expose-group-by-app -bool false

echo "Finder : Disable Dashboard"
defaults write com.apple.dashboard mcx-disabled -bool true

echo "Finder : Don’t show Dashboard as a Space"
defaults write com.apple.dock dashboard-in-overlay -bool true

echo "Finder : Don’t automatically rearrange Spaces based on most recent use"
defaults write com.apple.dock mru-spaces -bool false

echo "Finder : Remove the auto-hiding Dock delay"
defaults write com.apple.dock autohide-delay -float 0

echo "Finder : Remove the animation when hiding/showing the Dock"
defaults write com.apple.dock autohide-time-modifier -float 0

echo "Finder : Automatically hide and show the Dock"
defaults write com.apple.dock autohide -bool false

# echo "Finder : Make Dock icons of hidden applications translucent"
# defaults write com.apple.dock showhidden -bool false

echo

###############################################################################
# Safari & WebKit                                                             #
###############################################################################

echo "Safari : UniversalSearchEnabled set to true"
defaults write com.apple.Safari UniversalSearchEnabled -bool true

echo "Safari : SuppressSearchSuggestions set to false"
defaults write com.apple.Safari SuppressSearchSuggestions -bool false

echo "Safari : Show the full URL in the address bar (note: this still hides the scheme)"
defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true

echo "Safari : Set Safari’s home page to about:blank for faster loading"
defaults write com.apple.Safari HomePage -string "about:blank"

echo "Safari : Show Safari’s bookmarks bar by default"
defaults write com.apple.Safari ShowFavoritesBar -bool true

echo "Safari : Hide Safari’s sidebar in Top Sites"
defaults write com.apple.Safari ShowSidebarInTopSites -bool false

echo "Safari : Make Safari’s search banners default to Contains instead of Starts With"
defaults write com.apple.Safari FindOnPageMatchesWordStartsOnly -bool false

echo "Safari : Remove useless icons from Safari’s bookmarks bar"
defaults write com.apple.Safari ProxiesInBookmarksBar "()"

echo "Safari : Enable the Develop menu and the Web Inspector in Safari"
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true

echo "Safari : Add a context menu item for showing the Web Inspector in web views"
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

echo

###############################################################################
# Activity Monitor                                                            #
###############################################################################

echo "Activity Monitor : show the main window when launching"
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true

echo "Activity Monitor : Visualize CPU usage in the Dock icon"
defaults write com.apple.ActivityMonitor IconType -int 5

echo "Activity Monitor : Show all processes"
defaults write com.apple.ActivityMonitor ShowCategory -int 0

echo "Activity Monitor : Sort results by CPU usage"
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0

echo

###############################################################################
# Address Book, Dashboard, iCal, TextEdit, and Disk Utility                   #
###############################################################################

echo "Address Book : Enable the debug menu"
defaults write com.apple.addressbook ABShowDebugMenu -bool true

echo "Address Book : Sort Names by First Name / Last Name"
defaults write com.apple.addressbook ABNameSortingFormat -string "sortingFirstName sortingLastName"

echo

echo "TextEdit : Use plain text mode for new = documents"
defaults write com.apple.TextEdit RichText -int 0

echo "TextEdit : Open and save files as UTF-8 in TextEdit"
defaults write com.apple.TextEdit PlainTextEncoding -int 4
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4

echo

###############################################################################
# Mac App Store                                                               #
###############################################################################

echo "Mac App Store : Enable the WebKit Developer Tools in the Mac App Store"
defaults write com.apple.appstore WebKitDeveloperExtras -bool true

echo "Mac App Store : Enable Debug Menu in the Mac App Store"
defaults write com.apple.appstore ShowDebugMenu -bool true

echo

###############################################################################
# Transmission.app                                                            #
###############################################################################

echo "Transmission.app : Use ~/Documents/Torrents to store incomplete downloads"
mkdir -p "$HOME/Documents/Torrents"
defaults write org.m0k.transmission UseIncompleteDownloadFolder -bool true
defaults write org.m0k.transmission IncompleteDownloadFolder -string "${HOME}/Documents/Torrents"

echo "Transmission.app : Don’t prompt for confirmation before downloading"
defaults write org.m0k.transmission DownloadAsk -bool false

echo "Transmission.app : Trash original torrent files"
defaults write org.m0k.transmission DeleteOriginalTorrent -bool true

echo "Transmission.app : Hide the donate message"
defaults write org.m0k.transmission WarningDonate -bool false

echo "Transmission.app : Hide the legal disclaimer"
defaults write org.m0k.transmission WarningLegal -bool false

echo

echo

note "done - some settings may require a restart"


###############################################################################
# NOT USED.............................                                       #
###############################################################################

  # # Disable window animations ("new window" scale effect)
  # defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false

  # # Turn on dashboard-as-space
  # defaults write com.apple.dashboard enabled-state 2

  # # Use plain text mode for new TextEdit documents
  # defaults write com.apple.TextEdit RichText -int 0

  # # Make top-right hotspot start screensaver
  # defaults write com.apple.dock wvous-tr-corner -int 5 && \
  # defaults write com.apple.dock wvous-tr-modifier -int 0

  # # Set default Finder location to home folder (~/)
  # defaults write com.apple.finder NewWindowTarget -string "PfLo" && \
  # defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}"

  # # Expand save panel by default
  # defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true

  # # Disable ext change warning
  # defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

  # # Check for software updates daily, not just once per week
  # defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

  # # Use current directory as default search scope in Finder
  # defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

  # # Show Path bar in Finder
  # defaults write com.apple.finder ShowPathbar -bool true

  # # Show Status bar in Finder
  # defaults write com.apple.finder ShowStatusBar -bool true

  # # Show icons for hard drives, servers, and removable media on the desktop
  # defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true && \
  # defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true && \
  # defaults write com.apple.finder ShowMountedServersOnDesktop -bool true && \
  # defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

  # # Avoid creating .DS_Store files on network volumes
  # defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

  # # Disable disk image verification
  # defaults write com.apple.frameworks.diskimages skip-verify -bool true && \
  # defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true && \
  # defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true

  # # Trackpad: map bottom right corner to right-click
  # defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 2 && \
  # defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true && \
  # defaults -currentHost write NSGlobalDomain com.apple.trackpad.trackpadCornerClickBehavior -int 1 && \
  # defaults -currentHost write NSGlobalDomain com.apple.trackpad.enableSecondaryClick -bool true

  # # Enable the Develop menu and the Web Inspector in Safari
  # defaults write com.apple.Safari IncludeInternalDebugMenu -bool true && \
  # defaults write com.apple.Safari IncludeDevelopMenu -bool true && \
  # defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true && \
  # defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true && \
  # defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

  # # Show the ~/Library folder
  # chflags nohidden ~/Library

  # # Show absolute path in finder's title bar. 
  # defaults write com.apple.finder _FXShowPosixPathInTitle -bool YES

  # # Auto-play videos when opened with QuickTime Player
  # defaults write com.apple.QuickTimePlayerX MGPlayMovieOnOpen 1

  # # Enable AirDrop over Ethernet and on unsupported Macs
  # defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true

  # # Disable WebkitNightly.app's homepage
  # defaults write org.webkit.nightly.WebKit StartPageDisabled -bool true
