#!/bin/bash
######################## DOTFILES ########################

############ CONFIG ############
SYSTEM_CONFIG_FILES="https://raw.githubusercontent.com/dwkns/system-install/master/system-config-files"


############# FUNCTIONS ############


###################### SCRIPT ######################
echo -e "$PG  Downloading bash profile"
wget -r "$SYSTEM_CONFIG_FILES/bash.bash_profile" -O "$HOME/.bash_profile"

echo -e "$PG  Downloading rspec config"
wget  -r "$SYSTEM_CONFIG_FILES/bash.rspec" -O "$HOME/.rspec"

echo -e "$PG  Downloading gemrc config"
wget -r "$SYSTEM_CONFIG_FILES/bash.gemrc" -O "$HOME/.gemrc"

echo -e "$PG  Downloading .gitconfig"
wget -r "$SYSTEM_CONFIG_FILES/bash.gitconfig" -O "$HOME/.gitconfig"

echo -e "$PG  Downloading .gitignore"
wget -r "$SYSTEM_CONFIG_FILES/bash.gitignore_global" -O "$HOME/.gitignore_global"


###################### configure git ######################
echo -e "$PG  Configuring git"
git config --global core.excludesfile $HOME/.gitignore_global

echo -e "$PG  load bash profile into shell"
source $HOME/.bash_profile

