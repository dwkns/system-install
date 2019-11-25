#!/bin/bash
# set up some colours
note () {
  echo -e "\n\033[0;94m====> $1 \033[0m"
}
success () {
  echo -e "\n\033[0;32m==============> $1 \033[0m"
}
warn () {
  echo -e "\n\033[0;31m====> $1 \033[0m"
}

# ask for sudo upfront
sudo -v 

# Keep-alive: update existing sudo time stamp if set, otherwise do nothing.
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

ROOT_DIR="$HOME/.system-config"
REMOTE_URL="https://raw.githubusercontent.com/dwkns/system-install/master/"

success "Starting install"

############ Download config files  ############
success "$PG Downloading config files"

if [ -d "$ROOT_DIR" ]; then
  echo "'.system-config' folder is already there. Updating..."
  cd $ROOT_DIR
  git pull
else
  echo "Cloning 'https://github.com/dwkns/system-install.git' into '~/.system-config'"
  git clone https://github.com/dwkns/system-install.git ~/.system-config
  cd $ROOT_DIR
fi



######################## DOTFILES ########################
source "$ROOT_DIR/scripts/dotfiles.sh"




############ CONFIGURE ITERM ############
success "Configure iTerm"

echo "Downloading preference file and copy into place"
cp -f "$ROOT_DIR/system-config-files/com.googlecode.iterm2.plist" "$HOME/Library/Preferences/com.googlecode.iterm2.plist"
killall cfprefsd
note "done"

mkdir -p ~/Applications

############ CONFIGURE Sublime ############
source "$ROOT_DIR/scripts/sublime-config.sh"


############ CONFIGURE Time Machine ############
source "$ROOT_DIR/scripts/time-machine.sh"


############ CONFIGURE System Settings ############
source "$ROOT_DIR/scripts/system-settings.sh"


############ Install App Store Apps ############
# source "$ROOT_DIR/scripts/app-store-apps.sh"

############ CONFIGURE System Settings that use sudo############
## These are in here to allow system-settings.sh not to require sudo and thus get run on `usys`
echo "Reveal IP address, hostname, OS version, etc. when clicking the clock in the login window"
sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName

echo "Disabling OS X Gate Keeper so no more annoying 'you can't open this app messages'"
sudo spctl --master-disable
sudo  defaults write /var/db/SystemPolicy-prefs.plist enabled -string no
defaults write com.apple.LaunchServices LSQuarantine -bool false



# ###################### set machine name ######################
DEFAULT_NAME="dwkns-mbp"

echo "Enter a machine name within 30 seconds (or press Enter to default to $DEFAULT_NAME)"

read -t 30 MACHINE_NAME
if [ $? -eq 0 ]; then
    : #do nothing
else
    echo "No input detected. Defaulting to $DEFAULT_NAME"
    MACHINE_NAME=$DEFAULT_NAME
fi

success "Setting Machine name to : $MACHINE_NAME"
sudo scutil --set ComputerName $MACHINE_NAME
sudo scutil --set HostName $MACHINE_NAME
sudo scutil --set LocalHostName $MACHINE_NAME
# sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string $MACHINE_NAME
note "done"

###################### configure git ######################
success "Configuring git"

git config --global core.excludesfile $HOME/.gitignore_global
note "Done" 


success "And that's it. All done." 