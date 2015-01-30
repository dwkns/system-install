#!/bin/bash

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

#hack to flush the stdin so it's empty when we start to ask the user questions.
while read -e -t 1; do : ; done


###### for testing #####
# rm -rf /usr/local/Cellar /usr/local/.git && brew cleanup
# rm -rf `brew --cache`

 homebrew=true
 cask=true
 dock= true
 rvm= true
 rails= true
 host=false
 rubymotion=true
 clean=true

while true; do
    read -p "Clean system (c), Clean then full install (f), Just install everything (e), Choose options (o) or Quit (q) : " fo < /dev/tty
        case $fo in
        [Oo]* ) doQuestions=true ; break;;
        [Ff]* ) doQuestions=false ; clean=true ; break;;
        [Ee]* ) doQuestions=false ;  break;;
        [Cc]* ) justClean=true ; clean=true ; break;;
        [Qq]* ) exit ; break;;
        * ) echo "Please choose Clean (c) Full (f) or Options (o).";;
    esac
done

echo

if $doQuestions
  then
  while true; do
    read -p "Do you want to clean things up before you start? : " yn < /dev/tty
    case $yn in
        [Yy]* ) clean=true ; break;;
        [Nn]* ) clean=false ; break;;
        * ) echo "Please answer yes or no.";;
    esac
 done


 while true; do
    read -p "Set host name? y/n : " yn < /dev/tty
    case $yn in
        [Yy]* ) host=true ; break;;
        [Nn]* ) host=false ; break;;
        * ) echo "Please answer yes or no.";;
    esac
  done

  while true; do
      read -p "Install Homebrew Apps? y/n : " yn < /dev/tty
      case $yn in
          [Yy]* ) homebrew=true ; break;;
          [Nn]* ) homebrew=false ; break;;
          * ) echo "Please answer yes or no.";;
      esac
  done
  while true; do
      read -p "Install Cask Apps? y/n : " yn < /dev/tty
      case $yn in
          [Yy]* ) cask=true ; break;;
          [Nn]* ) cask=false ; break;;
          * ) echo "Please answer yes or no.";;
      esac
  done

  if $cask 
    then
      while true; do
        read -p "Add apps to dock? y/n : " yn < /dev/tty
        case $yn in
            [Yy]* ) dock=true ; break;;
            [Nn]* ) dock=false ; break;;
            * ) echo "Please answer yes or no.";;
        esac
      done
  fi

  while true; do
      read -p "Install RVM and latest Ruby? y/n : " yn < /dev/tty
      case $yn in
          [Yy]* ) rvm=true ; break;;
          [Nn]* ) rvm=false ; break;;
          * ) echo "Please answer yes or no.";;
      esac
  done

  while true; do
      read -p "Install Rails? y/n : " yn < /dev/tty
      case $yn in
          [Yy]* ) rails=true ; break;;
          [Nn]* ) rails=false ; break;;
          * ) echo "Please answer yes or no.";;
      esac
  done
  
  while true; do
      read -p "Install RubyMotion? y/n : " yn < /dev/tty
      case $yn in
          [Yy]* ) rubymotion=true ; break;;
          [Nn]* ) rubymotion=false ; break;;
          * ) echo "Please answer yes or no.";;
      esac
  done

    echo
    echo "Got your anwers, working..."
    echo

else
    echo "Ok, lets go..."
    echo
fi

if $clean
  then
  bash "config-files/clean.sh"
  if $justClean; then
    echo 
    echo "Clean up files. Exiting..."
    exit
    else
     echo
     echo "Cleaning done. Starting Install now..."
  fi
fi
sleep 3

echo ""
echo "Disabling OS X Gate Keeper so no annoying 'you can't open this app messages'"
sudo spctl --master-disable
sudo defaults write /var/db/SystemPolicy-prefs.plist enabled -string no
defaults write com.apple.LaunchServices LSQuarantine -bool false


#get the location of the current script
currentDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
installFilesDirectory=$currentDir/config-files


#copy bash profile in first
echo "--- Copy the bash profile file"
cp -f $installFilesDirectory/bash.bash_profile ~/.bash_profile


#load the terminal styles in
echo "--- Open dwkns-dark terminal file."
open $installFilesDirectory/dwkns-dark.terminal

echo "--- Open dwkns-light terminal file."
open $installFilesDirectory/dwkns-light.terminal

#set the default terminal style
echo "--- set the default Termianl settings to dwkns-dark"
osascript -e 'tell application "Terminal" to set default settings to settings set "dwkns-dark"'

#set the current window to the dwkns-dark style
echo "--- set all open windows to dwkns-dark"
osascript -e 'tell application "Terminal" to set current settings of every tab of (every window whose visible is true) to settings set named "dwkns-dark"'


echo "--- Closing the unused windows"
osascript -e 'tell application "Terminal" to close the front window'
osascript -e 'tell application "Terminal" to close the front window'

echo

#get the original directory
origninalDirectory=`pwd`


#echo
#echo "—————- Current Direcory is : $installFilesDirectory"

echo "--- Copying .bash_profile"
cp -f "$installFilesDirectory"/bash.bash_profile ~/.bash_profile

echo "--- Copying .gitconfig"
cp -f "$installFilesDirectory"/bash.gitconfig ~/.gitconfig

echo "--- Copying .gitignore_global"
cp -f "$installFilesDirectory"/bash.gitignore_global ~/.gitignore_global

echo "--- Copying .rspec"
cp -f "$installFilesDirectory"/bash.rspec ~/.rspec

echo "--- Copying .gemrc"
cp -f "$installFilesDirectory"/bash.gemrc ~/.gemrc
echo

source ~/.bash_profile



if $host 
  then 
    echo ""
    echo "--- Setting your computer name (as done via System Preferences & Sharing)"
    echo "What would you like it to be?"
    read COMPUTER_NAME < /dev/tty
    sudo scutil --set ComputerName $COMPUTER_NAME
    sudo scutil --set HostName $COMPUTER_NAME
    sudo scutil --set LocalHostName $COMPUTER_NAME
    sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string $COMPUTER_NAME
  else 
    echo "Not setting the hostname " 
fi



 
echo ""
echo "--- Increasing the window resize speed for Cocoa applications"
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001

echo ""
echo "--- Saving to disk (not to iCloud) by default"
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

echo ""
echo "--- Setting a blazingly fast keyboard repeat rate"
defaults write NSGlobalDomain KeyRepeat -int 0

echo ""
echo "--- Turn off keyboard illumination when computer is not used for 5 minutes"
defaults write com.apple.BezelServices kDimTime -int 300

echo ""
echo "--- Showing all filename extensions in Finder by default"
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

echo ""
echo "--- Displaying full POSIX path as Finder window title"
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

echo ""
echo "--- Disabling the warning when changing a file extension"
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
 
echo ""
echo "--- Use column view in all Finder windows by default"
defaults write com.apple.finder FXPreferredViewStyle Clmv
 
echo ""
echo "--- Avoiding the creation of .DS_Store files on network volumes"
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

echo ""
echo "--- Setting the icon size of Dock items to 36 pixels for optimal size/screen-realestate"
defaults write com.apple.dock tilesize -int 36

echo ""
echo "--- Hiding dashboard"
defaults write com.apple.dashboard mcx-disabled -boolean true

echo ""
echo "--- Showing Library & ~Library "
chflags nohidden ~/Library
chflags nohidden /Library

echo ""
echo "--- Check for Homebrew and install if we don't have it"
if test ! $(which brew); then
  echo "Homebrew was not found. Installing homebrew..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
 echo "Found homebrew however it migh be bad clean up."
 if $clean ; then
  echo "Clean up was run so reinstalling homebrew"
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
 else
  echo "Nope homebrew is already installed"
  fi
fi
