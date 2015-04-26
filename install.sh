
#!/bin/bash
######################## CONFIG ########################
#red=''
#green='\033[0;32m'
#yellow='\033[1;33m'
#white='\033[1;37m'
PG="\n\033[0;32m==============>\033[1;37m"
PY="\n\033[1;33m==============>\033[1;37m"
PR="\n\033[0;31m==============>\033[1;37m"

MACHINE_NAME="dwkns-mbp"
BASE_URL="https://raw.githubusercontent.com/dwkns/system-install/master"

################### FUNCTIONS ###################
download_and_run() {
  URL="$1"
  FILENAME=`echo $URL | sed 's/.*\///'` # get just the filename from the URL
  curl -s -L $URL -o $TEMP_DIR/$FILENAME # download the file
  source $TEMP_DIR/$FILENAME # run it
}

######################## SCRIPT ########################
sudo -v # ask for sudo upfront
echo -e "$PG Starting Install"

TEMP_DIR=`mktemp -d -t osx-install` # Create a tmp directoy

# Keep-alive: update existing sudo time stamp if set, otherwise do nothing.
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &


# # download_and_run URL scriptname
# download_and_run $BASE_URL/sripts/hello.sh
source scripts/clean.sh
source scripts/homebrew.sh
source scripts/postgres.sh
source scripts/casks.sh
source scripts/node.sh


######################## cleanup ########################
killall Dock
echo -e "$PG Deleteing Temp Directory"
rm -rf $TEMP_DIR
echo -e "$PG All done $green<=======$white\n"






















################### functions ###################


remove_sublime_config () {
  echo -e "$PR Removing SublimeConfig"
  sudo rm -rf "$HOME/Library/Application Support/Sublime Text 3"
  sudo rm -rf "/usr/local/bin/ruby-iterm2.sh"
}

remove_rvm () {
  echo -e "$PR Removing rvm"
  sudo rm -rf "$HOME/.rvm"
}

remove_dotfiles () {
  echo -e "$PR Removing dotfiles"
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
  echo -e "$PR Removing Apps"
  sudo rm -rf "/usr/bin/motion"
  sudo rm -rf "/Library/RubyMotion"
  sudo rm -rf "/tmp/krep"
  sudo rm -rf "/Applications/Krep.app"


}







###################### Config ######################














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

# echo -e "$PG  Downloading bash profile"
# wget -r "$SYSTEM_CONFIG_FILES/bash.bash_profile" -O "$HOME/.bash_profile"

# echo -e "$PG  Downloading rspec config"
# wget  -r "$SYSTEM_CONFIG_FILES/bash.rspec" -O "$HOME/.rspec"

# echo -e "$PG  Downloading gemrc config"
# wget -r "$SYSTEM_CONFIG_FILES/bash.gemrc" -O "$HOME/.gemrc"

# echo -e "$PG  Downloading .gitconfig"
# wget -r "$SYSTEM_CONFIG_FILES/bash.gitconfig" -O "$HOME/.gitconfig"

# echo -e "$PG  Downloading .gitignore"
# wget -r "$SYSTEM_CONFIG_FILES/bash.gitignore_global" -O "$HOME/.gitignore_global"


# ###################### configure git ######################
# echo -e "$PG  Configuring git"
# git config --global core.excludesfile $HOME/.gitignore_global

# echo -e "$PG  load bash profile into shell"
# source $HOME/.bash_profile

# ##################### Configure Sublime ######################

# echo -e "$PG configuring sublime"

# SUBLIME="$HOME/Library/Application Support/Sublime Text 3"


# SUBLIME_LOCAL_DIR="$SUBLIME/local"


# SUBLIME_PACKAGES_DIR="$SUBLIME/Packages"


# SUBLIME_USER_DIR="$SUBLIME/Packages/User"


# SUBLIME_INSTALLED_PACKAGES_DIR="$SUBLIME/Installed Packages"

# mkdir -p "$SUBLIME_LOCAL_DIR"
# mkdir -p "$SUBLIME_USER_DIR"
# mkdir -p "$SUBLIME_INSTALLED_PACKAGES_DIR"

# echo -e "$PG  installing Package Control"
# wget "http://sublime.wbond.net/Package Control.sublime-package" -O "$SUBLIME_INSTALLED_PACKAGES_DIR/Package Control.sublime-package"



# echo -e "$PG  installing pin_console.py"
# wget "$BASE_URL/sublime-config-files/pin_console.py" -O "$SUBLIME_PACKAGES_DIR/pin_console.py"


# echo -e "$PG  intalling license"
# wget "$BASE_URL/sublime-config-files/License.sublime_license" -O "$SUBLIME_LOCAL_DIR/License.sublime_license"


# echo -e "$PG   installing sublime preferences"
# wget "$BASE_URL/sublime-config-files/Preferences.sublime-settings" -O "$SUBLIME_USER_DIR/Preferences.sublime-settings"


# echo -e "$PG   installing sublime Package Control Settings"
# wget "$BASE_URL/sublime-config-files/Package Control.sublime-settings" -O "$SUBLIME_USER_DIR/Package Control.sublime-settings"


# echo -e "$PG   installing sublime theme dwkns.tmTheme"
# wget "$BASE_URL/sublime-config-files/dwkns.tmTheme" -O "$SUBLIME_USER_DIR/dwkns.tmTheme"


# echo -e "$PG   installing sublime keymap"
# wget "$BASE_URL/sublime-config-files/Default (OSX).sublime-keymap" -O "$SUBLIME_USER_DIR/Default (OSX).sublime-keymap"

# echo -e "$PG   intalling ruby-terminal build system"
# git clone "https://github.com/dwkns/ruby-iTerm2.git" "$SUBLIME_PACKAGES_DIR/ruby-iTerm2"
# chmod u+x "$SUBLIME_PACKAGES_DIR/ruby-iTerm2/ruby-iterm2.sh"
# ln -s "$SUBLIME_PACKAGES_DIR/ruby-iTerm2/ruby-iterm2.sh" "/usr/local/bin"


# ######################  Random other configurations ######################
# echo -e "$PG   Disabling OS X Gate Keeper so no more annoying 'you can't open this app messages'"
# sudo spctl --master-disable
# sudo defaults write /var/db/SystemPolicy-prefs.plist enabled -string no
# defaults write com.apple.LaunchServices LSQuarantine -bool false

# echo -e "$PG   Increasing the window resize speed for Cocoa applications"
# defaults write NSGlobalDomain NSWindowResizeTime -float 0.001

# echo -e "$PG   Saving to disk (not to iCloud) by default"
# defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# echo -e "$PG   Setting a blazingly fast keyboard repeat rate"
# defaults write NSGlobalDomain KeyRepeat -int 0

# echo -e "$PG   Turn off keyboard illumination when computer is not used for 5 minutes"
# defaults write com.apple.BezelServices kDimTime -int 300

# echo -e "$PG   Showing all filename extensions in Finder by default"
# defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# echo -e "$PG   Displaying full POSIX path as Finder window title"
# defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# echo -e "$PG   Disabling the warning when changing a file extension"
# defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# echo -e "$PG   Use column view in all Finder windows by default"
# defaults write com.apple.finder FXPreferredViewStyle Clmv

# echo -e "$PG   Avoiding the creation of .DS_Store files on network volumes"
# defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# echo -e "$PG   Setting the icon size of Dock items to 36 pixels for optimal size/screen-realestate"
# defaults write com.apple.dock tilesize -int 36

# echo -e "$PG   Hiding dashboard"
# defaults write com.apple.dashboard mcx-disabled -boolean true

# echo -e "$PG   Showing Library & ~Library"
# chflags nohidden ~/Library
# chflags nohidden /Library


# #-------------------- Install RVM and Ruby --------------------
# echo -e "$PG Installing RVM and Ruby"
# curl -sSL https://get.rvm.io | bash -s stable --ruby

# source $HOME/.rvm/scripts/rvm

# if [ $? -eq 0 ]; then
#    echo -e "$PG RVM and Ruby installed successfully"
# else
#    echo -e  "$PR Somethihng went wrong installing RVM and Ruby "
# fi

# echo -e "$PG  load bash profile into shell"
# source $HOME/.bash_profile

# # Print out the Ruby and RVM versions
# echo -e "$PG Check RVM and Ruby versions"
# rvm -v
# ruby -v


# #-------------------- Install some Ruby gems --------------------
# echo -e "$PG Installing some gems"

# gems=( "bundler" "rails" )

# for pkg in "${gems[@]}"
# do
# gem install $pkg

# done

# killall Dock


















