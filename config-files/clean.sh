#!/bin/bash

cd ~ 

sudo -v
# Keep-alive: update existing `sudo` time stamp until script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

rm -rf /Library/Caches/Homebrew
rm -rf /usr/local/Cellar /usr/local/.git && brew cleanup 
rm -rf /usr/local/*
sudo rm -rf /opt/homebrew-cask


# for a deeper clean
#rm -rf /Library/Caches/Homebrew/*


rm -rf .bash_profile .git* .rspec .profile .zshrc .zlogin .bashrc
rm -rf ~/.rvm  ~/.gem ~/.dropbox ~/.subversion
rm -rf .bash_profile .git* .rspec 
rm -rf /usr/local/bin/ruby-terminal.sh 
rm -rf ~/Library/'Application Support/Sublime Text 3'/*


#remove symlinks from Application folder
find /Applications -maxdepth 1 -type l -exec rm -f {} \;

defaults write com.apple.dashboard mcx-disabled -boolean false 
killall Dock 
chflags hidden ~/Library/
cd ~
ls -la
cd ~/Desktop

echo "got to the end - all done"