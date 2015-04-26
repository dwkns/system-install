#!/bin/sh
################### config ###################

red='\033[0;31m'
green='\033[0;32m'
yellow='\033[1;33m'
white='\033[1;37m'
PG="\n$green==============>$white"
PY="\n$yellow==============>$white"
PR="\n$red==============>$white"

MACHINE_NAME="dwkns-mbp"
BASE_URL="https://raw.githubusercontent.com/dwkns/system-install/master"


################### functions ###################
remove_brew () {
  echo "$PR Removing Homebrew"
  sudo rm -rf "/usr/local"
  sudo rm -rf "/Library/Caches/Homebrew"
}
remove_cask () {
  sudo rm -rf  "/opt/homebrew-cask"
}


remove_sublime_config () {
  echo "$PR Removing SublimeConfig"
  sudo rm -rf "$HOME/Library/Application Support/Sublime Text 3"
  sudo rm -rf "/usr/local/bin/ruby-iterm2.sh"
}

remove_rvm () {
  echo "$PR Removing rvm"
  sudo rm -rf "$HOME/.rvm"
}

remove_dotfiles () {
  echo "$PR Removing dotfiles"
  sudo rm -rf "$HOME/.git*"
  sudo rm -rf "$HOME/.rspec"
  sudo rm -rf "$HOME/.profile"
  sudo rm -rf "$HOME/.bash_profile"
  sudo rm -rf "$HOME/.zshrc"
  sudo rm -rf "$HOME/.zlogin"
  sudo rm -rf "$HOME/.gem"
  sudo rm -rf "$HOME/.dropbox"
  sudo rm -rf "$HOME/.subversion"
  sudo rm -rf "$HOME/.rvm"
  sudo rm -rf "$HOME/.rvm"
  sudo rm -rf "$HOME/.rvm"
}

remove_apps(){
  echo "$PR Removing Apps"
  sudo rm -rf "/usr/bin/motion"
  sudo rm -rf "/Library/RubyMotion"
  sudo rm -rf "/tmp/krep"
  sudo rm -rf "/Applications/Krep.app"

#remove symlinks from Application folder - anoying escaping at end.
find /Applications -maxdepth 1 -lname '*' -exec rm {} \;
}

isNpmPackageInstalled() {
  npm list --depth 1 -g $1 > /dev/null 2>&1
}

################### script ###################
echo "$PG Starting Install"

# ask for sudo upfront
sudo -v

# Keep-alive: update existing sudo time stamp if set, otherwise do nothing.
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

remove_sublime_config
remove_apps
remove_dotfiles
remove_brew
remove_cask
remove_rvm

$BASE_URL/system-config-files/hello.sh

source <(curl -s "$BASE_URL/system-config-files/hello.sh")

# ####################### Install Homebrew ######################
# if ! command -v brew > /dev/null 2>&1; then
#  echo "$PG Downloading Homebrew"
#  yes '' | ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
# else
#  echo "$PY Homebrew was already installed. Updating it..."
# #    brew update
# fi

# ###################### Install Brew Packages ######################
# brew_packages=( "wget" "git" "python" "node"  ) 
# for pkg in "${brew_packages[@]}"
# do
#  if brew list -1 | grep -q "^${pkg}\$"; then
#    echo "$PY Package '$pkg' is installed, skipping it..."
#  else
#    echo "$PG Installing '$pkg'..."
#    brew install $pkg
#  fi
# done

# ###################### Install Postgres ######################

# if ! command -v postgres > /dev/null 2>&1; then
#   echo "$PG Installing postgres..."
#   brew install "postgresql"
#    echo "$PG ...and configure"
#   ln -sfv "/usr/local/opt/postgresql/*.plist" "$HOME/Library/LaunchAgents"
#   launchctl load "$HOME/Library/LaunchAgents/homebrew.mxcl.postgresql.plist"
# else
#   echo "$PY Postgres already installed skipping..."
# fi



# ###################### Install Casks ######################
# echo "$PG Installing Cask"
# brew install caskroom/cask/brew-cask

# echo "$PG Tapping up caskroom/versions"
# brew tap caskroom/versions

# echo "$PG Tapping up caskroom/fonts"
# brew tap caskroom/fonts

# cask_packages=( "dropbox" "sublime-text3" "things" "flash" "handbrake" "omnigraffle" "transmission" "mplayerx" "charles" "lightpaper" "fluid" "codekit" "font-source-code-pro" )

# cask_packages=( "dropbox" "sublime-text3" "things" )


# for pkg in "${cask_packages[@]}"
# do
#  if brew cask list -1 | grep -q "^${pkg}\$"; then
#    echo "$PY Cask '$pkg' is installed, skipping it..."
#  else
#    echo "$PG Installing '$pkg'..."
#    brew cask install --force --appdir='/Applications' $pkg

#    appNameFromCask=`brew cask info $pkg | sed -n '/==> Contents/{n;p;}'`

#    if [[ $appNameFromCask == *app* ]]; then

#     appname=`echo ${appNameFromCask:0:${#appNameFromCask}-6}`

#     appNameAndPath="/Applications/"$appname

#     echo "appNameAndPath is $appNameAndPath"

#     defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>$appNameAndPath</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>"
#   fi
# fi
# done

# ###################### Install Node Packages ######################
# node_packages=( "jshint" "http-server" "gulp" )
# {}
# for pkg in "${node_packages[@]}"
# do
#  if isNpmPackageInstalled $package; then
#    echo "$PY Cask '$pkg' is installed, skipping it..."
#  else
#    echo "$PG Installing '$pkg'..."
#    npm install -g $pkg
#  fi

# done

# #----------------------krep-----------------------
# killall -9 Krep
# wget https://github.com/dwkns/krep/archive/master.zip -O "$HOME/Downloads/Krep.zip"
# unzip -o -q "$downloadFile" -d "$HOME/Downloads"
# cp -rf "$HOME/Downloads/krep-master/Krep.app" "/Applications"
# rm -rf "$HOME/Downloads/krep-master"
# rm -rf "$HOME/Downloads/Krep.zip"

# appname="Krep.app"
# appNameAndPath="/Applications/"$appname

# defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>$appNameAndPath</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>"



# ###################### set machine name ######################

# sudo scutil --set ComputerName $MACHINE_NAME
# sudo scutil --set HostName $MACHINE_NAME
# sudo scutil --set LocalHostName $MACHINE_NAME
# sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string $MACHINE_NAME


# ###################### Dot Files ######################

# SYSTEM_CONFIG_FILES="https://raw.githubusercontent.com/dwkns/system-install/master/system-config-files"

# echo "$PG  Downloading bash profile"
# wget -r "$SYSTEM_CONFIG_FILES/bash.bash_profile" -O "$HOME/.bash_profile"

# echo "$PG  Downloading rspec config"
# wget  -r "$SYSTEM_CONFIG_FILES/bash.rspec" -O "$HOME/.rspec"

# echo "$PG  Downloading gemrc config"
# wget -r "$SYSTEM_CONFIG_FILES/bash.gemrc" -O "$HOME/.gemrc"

# echo "$PG  Downloading .gitconfig"
# wget -r "$SYSTEM_CONFIG_FILES/bash.gitconfig" -O "$HOME/.gitconfig"

# echo "$PG  Downloading .gitignore"
# wget -r "$SYSTEM_CONFIG_FILES/bash.gitignore_global" -O "$HOME/.gitignore_global"


# ###################### configure git ######################
# echo "$PG  Configuring git"
# git config --global core.excludesfile $HOME/.gitignore_global

# echo "$PG  load bash profile into shell"
# source $HOME/.bash_profile

# ##################### Configure Sublime ######################

# echo "$PG configuring sublime"

# SUBLIME="$HOME/Library/Application Support/Sublime Text 3"


# SUBLIME_LOCAL_DIR="$SUBLIME/local"


# SUBLIME_PACKAGES_DIR="$SUBLIME/Packages"


# SUBLIME_USER_DIR="$SUBLIME/Packages/User"


# SUBLIME_INSTALLED_PACKAGES_DIR="$SUBLIME/Installed Packages"

# mkdir -p "$SUBLIME_LOCAL_DIR"
# mkdir -p "$SUBLIME_USER_DIR"
# mkdir -p "$SUBLIME_INSTALLED_PACKAGES_DIR"

# echo "$PG  installing Package Control"
# wget "http://sublime.wbond.net/Package Control.sublime-package" -O "$SUBLIME_INSTALLED_PACKAGES_DIR/Package Control.sublime-package"



# echo "$PG  installing pin_console.py"
# wget "$BASE_URL/sublime-config-files/pin_console.py" -O "$SUBLIME_PACKAGES_DIR/pin_console.py"


# echo "$PG  intalling license"
# wget "$BASE_URL/sublime-config-files/License.sublime_license" -O "$SUBLIME_LOCAL_DIR/License.sublime_license"


# echo "$PG   installing sublime preferences"
# wget "$BASE_URL/sublime-config-files/Preferences.sublime-settings" -O "$SUBLIME_USER_DIR/Preferences.sublime-settings"


# echo "$PG   installing sublime Package Control Settings"
# wget "$BASE_URL/sublime-config-files/Package Control.sublime-settings" -O "$SUBLIME_USER_DIR/Package Control.sublime-settings"


# echo "$PG   installing sublime theme dwkns.tmTheme"
# wget "$BASE_URL/sublime-config-files/dwkns.tmTheme" -O "$SUBLIME_USER_DIR/dwkns.tmTheme"


# echo "$PG   installing sublime keymap"
# wget "$BASE_URL/sublime-config-files/Default (OSX).sublime-keymap" -O "$SUBLIME_USER_DIR/Default (OSX).sublime-keymap"

# echo "$PG   intalling ruby-terminal build system"
# git clone "https://github.com/dwkns/ruby-iTerm2.git" "$SUBLIME_PACKAGES_DIR/ruby-iTerm2"
# chmod u+x "$SUBLIME_PACKAGES_DIR/ruby-iTerm2/ruby-iterm2.sh"
# ln -s "$SUBLIME_PACKAGES_DIR/ruby-iTerm2/ruby-iterm2.sh" "/usr/local/bin"


# ######################  Random other configurations ######################
# echo "$PG   Disabling OS X Gate Keeper so no more annoying 'you can't open this app messages'"
# sudo spctl --master-disable
# sudo defaults write /var/db/SystemPolicy-prefs.plist enabled -string no
# defaults write com.apple.LaunchServices LSQuarantine -bool false

# echo "$PG   Increasing the window resize speed for Cocoa applications"
# defaults write NSGlobalDomain NSWindowResizeTime -float 0.001

# echo "$PG   Saving to disk (not to iCloud) by default"
# defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# echo "$PG   Setting a blazingly fast keyboard repeat rate"
# defaults write NSGlobalDomain KeyRepeat -int 0

# echo "$PG   Turn off keyboard illumination when computer is not used for 5 minutes"
# defaults write com.apple.BezelServices kDimTime -int 300

# echo "$PG   Showing all filename extensions in Finder by default"
# defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# echo "$PG   Displaying full POSIX path as Finder window title"
# defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# echo "$PG   Disabling the warning when changing a file extension"
# defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# echo "$PG   Use column view in all Finder windows by default"
# defaults write com.apple.finder FXPreferredViewStyle Clmv

# echo "$PG   Avoiding the creation of .DS_Store files on network volumes"
# defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# echo "$PG   Setting the icon size of Dock items to 36 pixels for optimal size/screen-realestate"
# defaults write com.apple.dock tilesize -int 36

# echo "$PG   Hiding dashboard"
# defaults write com.apple.dashboard mcx-disabled -boolean true

# echo "$PG   Showing Library & ~Library"
# chflags nohidden ~/Library
# chflags nohidden /Library


# #-------------------- Install RVM and Ruby --------------------
# echo "$PG Installing RVM and Ruby"
# curl -sSL https://get.rvm.io | bash -s stable --ruby

# source $HOME/.rvm/scripts/rvm

# if [ $? -eq 0 ]; then
#    echo "$PG RVM and Ruby installed successfully"
# else
#    echo  "$PR Somethihng went wrong installing RVM and Ruby "
# fi

# echo "$PG  load bash profile into shell"
# source $HOME/.bash_profile

# # Print out the Ruby and RVM versions
# echo "$PG Check RVM and Ruby versions"
# rvm -v
# ruby -v


# #-------------------- Install some Ruby gems --------------------
# echo "$PG Installing some gems"

# gems=( "bundler" "rails" )

# for pkg in "${gems[@]}"
# do
# gem install $pkg

# done

# killall Dock


# echo "$PG All done $green<=======$white\n"




















