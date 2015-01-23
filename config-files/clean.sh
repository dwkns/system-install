#!/bin/bash
echo
echo "--- Starting clean"
echo
cd ~ 

sudo -v
# Keep-alive: update existing `sudo` time stamp until script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

sudo rm  -rf /Library/Caches/Homebrew
sudo rm  -rf /usr/local/*
sudo rm  -rf /opt/homebrew-cask

which -s brew

if [[ $? = 0 ]] ; then
    echo "--- Brew installed"
    brew cleanup
else
    echo "--- Brew not installed - not a problem, just letting you know"
fi

sudo rm -rf .bash_profile .git* .rspec .profile .zshrc .zlogin .bashrc
sudo rm -rf ~/.rvm  ~/.gem ~/.dropbox ~/.subversion
sudo rm -rf .bash_profile .git* .rspec
sudo rm -rf /usr/local/bin/ruby-terminal.sh
sudo rm -rf ~/Library/'Application Support/Sublime Text 3'/*


#remove symlinks from Application folder
find /Applications -maxdepth 1 -type l -exec rm -f {} \;

defaults write com.apple.dashboard mcx-disabled -boolean false 
killall Dock 
chflags hidden ~/Library/
cd ~
cd ~/Desktop


echo
echo "--- Got to the end - all done - probably best to open a new terminal before you do anything."
echo