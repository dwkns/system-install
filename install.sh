#!/bin/bash

RED="\033[0;31m"          
YELLOW="\033[0;33m"       
GREEN="\033[0;32m"          
BLUE="\033[0;94m"
RESET="\033[0m"
CYAN="\033[0;36m"

sudo -v 

# Keep-alive: update existing sudo time stamp if set, otherwise do nothing.
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

ROOT_DIR="$HOME/.system-config"
REMOTE_URL="https://raw.githubusercontent.com/dwkns/system-install/master/"

echo -e $GREEN"Doing ========>$RESET Starting install " 

############ Download config files  ############
# doing "$PG Downloading config files"
echo -e $GREEN"Doing ========>$RESET Downloading config files " 

if [ -d "$ROOT_DIR" ]; then
  echo -e $YELLOW"Warning ========>$RESET '.system-config' folder is already there. Updating... "
  cd $ROOT_DIR
  git pull
else
  echo -e $GREEN"Doing ========>$RESET Cloning 'https://github.com/dwkns/system-install.git' into '~/.system-config' " 
  echo ""
  git clone https://github.com/dwkns/system-install.git ~/.system-config
  cd $ROOT_DIR
fi


###############################################################################
#  Import useful scripts                                                      #
###############################################################################

source "$ROOT_DIR/scripts/colours.sh"
source "$ROOT_DIR/scripts/dotfiles.sh"


###############################################################################
#  Install DotFiles                                                 
###############################################################################
installDotFiles


###############################################################################
# set machine name                                                      
###############################################################################
# DEFAULT_NAME="dwkns-mac"
DEFAULT_NAME=`scutil --get LocalHostName`
echo "Enter a machine name within 60 seconds (or press Enter to default to $DEFAULT_NAME)"

read -t 60 MACHINE_NAME
if [ $? -eq 0 ]; then
    : #do nothing
else
    echo "No input detected. Defaulting to $DEFAULT_NAME"
    MACHINE_NAME=$DEFAULT_NAME
fi

doing "Setting Machine name to : $MACHINE_NAME"
sudo scutil --set ComputerName $MACHINE_NAME
sudo scutil --set HostName $MACHINE_NAME
sudo scutil --set LocalHostName $MACHINE_NAME

# MACHINE_NAME="dwkns-mini-sur"; sudo scutil --set ComputerName $MACHINE_NAME && sudo scutil --set HostName $MACHINE_NAME && sudo scutil --set LocalHostName $MACHINE_NAME
# sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string $MACHINE_NAME
note "done"

###############################################################################
# CONFIGURE System Settings                                                   #
###############################################################################

source "$HOME/.macos"

###############################################################################
# Things that require sudo                                                    #
###############################################################################
# Means .macos can run without sudo

# Show the /Volumes folder
setting "General : Show the /Volumes folder"
sudo chflags nohidden /Volumes

# Reveal IP address, hostname, OS version, etc. when clicking the clock
# in the login window
setting "Reveal IP address, hostname, OS version in the login window"
sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName


setting "General : Enable Screen Sharing"
sudo defaults write /var/db/launchd.db/com.apple.launchd/overrides.plist com.apple.screensharing -dict Disabled -bool false

# need a test around this to see if it's running
sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.screensharing.plist

doing "Making ~/Applications & ~/dev folders"
mkdir -p ~/Applications
mkdir -p ~/dev

###############################################################################
# Install App Store Apps                                                      #
###############################################################################

# source "$ROOT_DIR/scripts/app-store-apps.sh"
echo;
echo -e $GREEN"################################################"
echo;
echo -e $CYAN"To install App Store apps run..."
echo -e $RESET"./ ~/.system-config/scripts/app-store-apps.sh"
echo;

complete "And that's it. All done." 