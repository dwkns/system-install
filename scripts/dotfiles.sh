#!/bin/bash
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

#load bash profile into shell
source $HOME/.bash_profile

note "done"






