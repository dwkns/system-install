#!/bin/bash

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

echo ""
echo "Disabling OS X Gate Keeper so no annoying you can't open this app messages"
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

echo "--- Reloading bash profile into this window."
osascript -e 'tell application "Terminal" to do script "source ~/.bash_profile" in front window'

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
 host=true
 doQuestions=false

if $doQuestions
  then
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
fi



#get the original directory
origninalDirectory=`pwd`


echo ""
echo "—————- Current Direcory is : $installFilesDirectory"
echo ""

echo "Copying .bash_profile"
echo "From $installFilesDirectory/bash.bash_profile"
echo cp -f "$installFilesDirectory"/bash.bash_profile ~/.bash_profile

echo "Copying .gitconfig"
cp -fv "$installFilesDirectory"/bash.gitconfig ~/.gitconfig

echo "Copying .gitignore_global"
cp -fv "$installFilesDirectory"/bash.gitignore_global ~/.gitignore_global

echo "Copying .rspec"
cp -fv "$installFilesDirectory"/bash.rspec ~/.rspec

echo "Copying .gemrc"
cp -fv "$installFilesDirectory"/bash.gemrc ~/.gemrc

source ~/.bash_profile



if $host 
  then 
    echo ""
    echo "Setting your computer name (as done via System Preferences & Sharing)"
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
echo "Increasing the window resize speed for Cocoa applications"
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001

echo ""
echo "Saving to disk (not to iCloud) by default"
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

echo ""
echo "Setting a blazingly fast keyboard repeat rate"
defaults write NSGlobalDomain KeyRepeat -int 0

echo ""
echo "Turn off keyboard illumination when computer is not used for 5 minutes"
defaults write com.apple.BezelServices kDimTime -int 300

echo ""
echo "Showing all filename extensions in Finder by default"
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

echo ""
echo "Displaying full POSIX path as Finder window title"
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

echo ""
echo "Disabling the warning when changing a file extension"
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
 
echo ""
echo "Use column view in all Finder windows by default"
defaults write com.apple.finder FXPreferredViewStyle Clmv
 
echo ""
echo "Avoiding the creation of .DS_Store files on network volumes"
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

echo ""
echo "Setting the icon size of Dock items to 36 pixels for optimal size/screen-realestate"
defaults write com.apple.dock tilesize -int 36

echo ""
echo "Hiding dashboard"
defaults write com.apple.dashboard mcx-disabled -boolean true

echo ""
echo "Showing Library & ~Library "
chflags nohidden ~/Library
chflags nohidden /Library

echo ""
echo "Check for Homebrew and install if we don't have it"
if test ! $(which brew); then
  echo "Installing homebrew..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
  echo "Homebrew is already installed"
fi

echo ""
echo "Update homebrew recipes"
brew update

if $homebrew 
  then # install a load of other stiuff
    echo""
    echo "installing various brew binaries..."
    brew install wget
    brew install git
    git config --global core.excludesfile ~/.gitignore_global
    
    echo "Installing posgres"
    echo "launch posgres at startup using : ln -sfv /usr/local/opt/postgresql/*.plist ~/Library/LaunchAgents"
    echo "launching posgres now using launchctl load ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist"
    brew install postgresql
    ln -sfv /usr/local/opt/postgresql/*.plist ~/Library/LaunchAgents
    launchctl load ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist
  else
    echo "Not installing homebrew apps"
fi

if $cask 
  then
    echo ""
    echo "installing cask..."
    brew install caskroom/cask/brew-cask
    brew tap caskroom/versions

    echo ""
    echo "install cask applications"
    # Apps
    apps=(
     dropbox
     google-chrome
     iterm2
     sublime-text3
     flash
     things
     transmission
     Mplayerx
     charles
     lightpaper
     fluidapp
    )

    # # Install apps to /Applications as default is: /Users/$user/Applications
    brew cask install --force --appdir="/Applications" ${apps[@]}
    if $dock
      then
      echo "Adding thinds to the dock"
      # loop through the list of apps and add them to the dock
      for i in "${apps[@]}"
      do
         :
         #brew cask info lists some info about the app
         #get the line after the one that contains : /==> Contents as this is the app’s real name.
         appNameFromCask=`brew cask info $i | sed -n '/==> Contents/{n;p;}'`
         # do whatever on $i in the loop
        if [[ $appNameFromCask == *link* ]]
        then

          appname=`echo ${appNameFromCask:0:${#appNameFromCask}-7}`
          appNameAndPath="/Applications/"$appname
          #adds the app to the dock. 
        defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>$appNameAndPath</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>"

        elif [[ $appNameFromCask == *install* ]]
          then

          appname=`echo ${appNameFromCask:0:${#appNameFromCask}-10}`
        fi
      done

      echo ""
      echo "Installing Krep"
      bash "$installFilesDirectory/install-krep.sh"
     
      #adds Krep app to the dock. 
      appNameAndPath="/Applications/Krep.app"
      defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>$appNameAndPath</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>"

    else
      echo "Not installing dock"
    fi

    echo "-------- Installing cscreen so you can change screen resolutions via the terminal"
    
    echo ""
    mkdir -p /usr/local/bin/
    unzip $installFilesDirectory/cscreen.zip -d /usr/local/bin

    echo "-------- configuring sublime"
    
    echo ""
    echo "-------- create the subl symlink"
    mkdir -p /usr/local/bin/ # ensure the folder is there
    ln -sf /Applications/'Sublime Text.app'/Contents/SharedSupport/bin/subl /usr/local/bin


    echo ""
    echo "-------- Ensure the directories we need are there"
    mkdir -p  ~/Library/'Application Support/Sublime Text 3'/Local
    mkdir -p  ~/Library/'Application Support/Sublime Text 3'/Packages/User

    echo ""
    echo "-------- Copy the licence file in"
    cp -f $installFilesDirectory/License.sublime_license ~/Library/'Application Support/Sublime Text 3'/Local

    echo ""
    echo "-------- Change to the Sublime directory"
    cd ~/Library/'Application Support/Sublime Text 3'/Packages/

    echo ""
    echo "-------- Install package manager"

    git clone git://github.com/wbond/sublime_package_control.git 'Package Control'
    cd 'Package Control'
    git checkout python3
    cd .. 

    echo ""
    echo "-------- Install Sublime Ruby Terminal package"
    git clone https://github.com/dwkns/sublime-ruby-terminal.git
    chmod  a+x sublime-ruby-terminal/ruby-terminal.sh
    ln -s ~/Library/'Application Support/Sublime Text 3'/Packages/sublime-ruby-terminal/ruby-terminal.sh /usr/local/bin


    echo ""
    echo "-------- Install Sublime Ruby Terminal package"
    git clone https://github.com/dwkns/sublime-terminal.git
    chmod  a+x sublime-terminal/terminal.sh
    ln -s ~/Library/'Application Support/Sublime Text 3'/Packages/sublime-terminal/terminal.sh /usr/local/bin


    echo ""
    echo "-------- Change to the User folder and install config files & snipits"
    cd ~/Library/'Application Support/Sublime Text 3'/Packages/User
    git clone https://github.com/dwkns/dwkns-sublime-config.git
    git clone https://github.com/dwkns/sublime-code-snipits.git

    cp -r  dwkns-sublime-config/*.* ./
    rm -rf dwkns-sublime-config/age%20Control.sublime-package -P ~/Library/'Application Support/Sublime Text 3/Installed Packages'
        
  else
    echo "Not installing cask apps"
fi

brew tap --repair
brew doctor

if $rvm
  then
  echo "Installing RVM and Ruby"
  curl -sSL https://get.rvm.io | bash -s stable 
  source ~/.profile
  source ~/.bash_profile
  source ~/.rvm/scripts/rvm
  type rvm | head -n 1 
  rvm install ruby --auto-dotfiles 
  echo `rvm -v` 
else
  echo "Not installing RVM and Ruby"
fi

if $rails
  then
  echo "Installing rails"
  gem update
  gem install bundler
  gem install rails 
else
  echo "Not installing rails"
fi

if $cask 
  then
  echo "open dropbox"
  open /Applications/Dropbox.app
  subl
fi

killall Dock
cd $origninalDirectory
source ~/.bash_profile

