#!/bin/bash
sudo -v 

# Keep-alive: update existing sudo time stamp if set, otherwise do nothing.
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

ROOT_DIR="$HOME/.system-config"
REMOTE_URL="https://raw.githubusercontent.com/dwkns/system-install/master/"

echo "Doing ========> Starting install " 

############ Download config files  ############
# doing "$PG Downloading config files"
echo "Doing ========> Downloading config files " 

if [ -d "$ROOT_DIR" ]; then
  echo $YELLOW"Warning ========> '.system-config' folder is already there. Updating... "
  cd $ROOT_DIR
  git pull
else
  echo "Doing ========> Cloning 'https://github.com/dwkns/system-install.git' into '~/.system-config' " 
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
#  Make ~/Applications folder                                                   
###############################################################################
doing "Making ~/Applications folder"
mkdir -p ~/Applications



###############################################################################
# set machine name                                                      
###############################################################################
DEFAULT_NAME="dwkns-mac"

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
# CONFIGURE Sublime                                                      
###############################################################################

# source "$ROOT_DIR/scripts/sublime-config.sh"


###############################################################################
# CONFIGURE Time Machine                                                      #
###############################################################################

# success "Adding Time Machine Exclusions"

# TIME_MACHINE_EXCLUSION_LIST=(
#   "$HOME/Downloads/"
#   "$HOME/Library/Caches/"
#   "$HOME/Documents/Torrents/"
#   "$HOME/Documents/Parallels/"
#   "$HOME/Library/Application Support/Google/"
# )

# for LOCATION in "${TIME_MACHINE_EXCLUSION_LIST[@]}"
# do
#   # ensure that the directories exist.
#   mkdir -p "$LOCATION"
#   sudo tmutil addexclusion "$LOCATION"
# done

# if $TM_DEBUG; then
#   warn "These locations are being excluded :"
#   sudo mdfind "com_apple_backup_excludeItem = 'com.apple.backupd'"
# fi
# note "done"

# success "Prevent Time Machine from prompting to use new hard drives as backup volume"
# defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true


# warn "~/Dropbox has NOT been added to the time machine exclusion list"
# echo "If you want to add the exclusion run :"
# echo "sudo tmutil addexclusion '~/Dropbox/'"

# note "done"

###############################################################################
# CONFIGURE System Settings                                                   #
###############################################################################

source "$HOME/.macos"

###############################################################################
# Install App Store Apps                                                      #
###############################################################################

# source "$ROOT_DIR/scripts/app-store-apps.sh"

echo -e $GREEN"################################################"
echo;
echo -e $CYAN"To install App Store apps run..."
echo -e $RESET"./ ~/.system-config/scripts/app-store-apps.sh"
echo;

###############################################################################
# Things that require sudo                                                    #
###############################################################################
# Means .macos can run without sudo

# Show the /Volumes folder
sudo chflags nohidden /Volumes
# Reveal IP address, hostname, OS version, etc. when clicking the clock
# in the login window
sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName





doing "And that's it. All done." 