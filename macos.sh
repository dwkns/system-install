#!/usr/bin/env bash
# macOS defaults. Run directly, or via `sys setup` / `sys sync`.
source "$HOME/.system-config/lib/common.sh"

doing "Applying macOS defaults"

# Stop System Settings overwriting what we're about to change.
osascript -e 'tell application "System Settings" to quit' 2>/dev/null || true

# ── General ──────────────────────────────────────────────────────────────────
defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 1
defaults write NSGlobalDomain AppleShowScrollBars -string "WhenScrolling"
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001
defaults write NSGlobalDomain NSQuitAlwaysKeepsWindows -bool false
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false
defaults write com.apple.loginwindow TALLogoutSavesState -bool false
defaults write com.apple.loginwindow LoginwindowLaunchesRelaunchApps -bool false

# Expand save and print panels by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# No autocorrect, smart quotes or smart dashes — they mangle code.
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# ── Keyboard & trackpad ──────────────────────────────────────────────────────
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 13
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# ── Screenshots ──────────────────────────────────────────────────────────────
defaults write com.apple.screencapture location -string "$HOME/Desktop"
defaults write com.apple.screencapture type -string "png"
defaults write com.apple.screencapture disable-shadow -bool true

# ── Finder ───────────────────────────────────────────────────────────────────
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.finder AppleShowAllFiles -bool false
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder _FXSortFoldersFirst -bool true
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
chflags nohidden ~/Library || true

# Full path in the title bar. Handy, but screenshots then reveal your
# home-directory structure.
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# ── Dock ─────────────────────────────────────────────────────────────────────
defaults write com.apple.dock autohide -bool false
defaults write com.apple.dock tilesize -int 36
defaults write com.apple.dock mru-spaces -bool false

# ── Other ────────────────────────────────────────────────────────────────────
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true
defaults write org.m0k.transmission UseIncompleteDownloadFolder -bool true
defaults write org.m0k.transmission IncompleteDownloadFolder -string "$HOME/Downloads/Torrents"

# Safari keeps its preferences inside a sandbox container, so this is a no-op
# unless your terminal has Full Disk Access.
defaults write com.apple.Safari IncludeDevelopMenu -bool true

# ── Apply ────────────────────────────────────────────────────────────────────
for app in cfprefsd Dock Finder SystemUIServer; do
  killall "$app" &>/dev/null || true
done

note "Done. Some changes need a logout to take effect."
