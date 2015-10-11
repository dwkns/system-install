#!/bin/bash
# set up some colours
note () {
  echo -e "\n\033[0;34m====> $1 \033[0m"
}
msg () {
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


msg "Starting install"

############ Download config files  ############

msg "$PG Downloading config files"

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

msg "Copying dotfiles"

echo "Copying .bash_profile"
cp -f "$ROOT_DIR/system-config-files/bash.bash_profile"  "$HOME/.bash_profile"

echo "Copying .rspec"
cp -f  "$ROOT_DIR/system-config-files/bash.rspec" "$HOME/.rspec"

echo "Copying .gemrc"
cp -f "$ROOT_DIR/system-config-files/bash.gemrc" "$HOME/.gemrc"

echo "Copying .gitconfig"
cp -f "$ROOT_DIR/system-config-files/bash.gitconfig" "$HOME/.gitconfig"

echo "Copying .gitignore"
cp -f "$ROOT_DIR/system-config-files/bash.gitignore_global" "$HOME/.gitignore_global"
note "done"

###################### configure git ######################
msg "Configuring git"
git config --global core.excludesfile $HOME/.gitignore_global
note "Done" 

############ CONFIGURE ITERM ############

  msg "Configure iTerm"
  echo "Downloading preference file and copy into place"
  cp -f "$ROOT_DIR/system-config-files/com.googlecode.iterm2.plist" "$HOME/Library/Preferences/com.googlecode.iterm2.plist"
  killall cfprefsd
 note "done"

