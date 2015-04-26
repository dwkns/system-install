#!/bin/bash

############ Set up ############
sudo -v # ask for sudo upfront


############ Make Sure Homebrew & Cask is gone ############
sudo rm -rf "/usr/local"
sudo rm -rf "/Library/Caches/Homebrew"
sudo rm -rf  "/opt/homebrew-cask"


############ Install Homebrew ############

# supress the need to press when in the install script runs.
yes '' | ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"


############ Install some packages ############

brew install "wget"
brew install "git"


############ Install cask ############
brew install caskroom/cask/brew-cask


############ Tap up some caskrooms  ############
brew tap caskroom/versions
brew tap caskroom/fonts


############ Install some cask apps ############
brew cask install  --appdir='/Applications' 'dropbox'
brew cask install  --appdir='/Applications' 'sublime-text3'
brew cask install  --appdir='/Applications' 'things'
brew cask install  --appdir='/Applications' 'font-source-code-pro'

echo "And done..."
