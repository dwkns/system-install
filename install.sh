#!/bin/sh
################### config ###################

red='\033[0;31m'
green='\033[0;32m'
yellow='\033[1;33m'
white='\033[1;37m'
PG="\n$green=======>$white"
PY="\n$yellow=======>$white"
PR="\n$red=======>$white"

MACHINE_NAME="dwkns-mbp"



################### functions ###################
remove_brew () {
    echo "$PR Removing Homebrew"
    sudo rm -rf "/usr/local"
    sudo rm -rf "/Library/Caches/Homebrew"
    sudo rm -rf  "/opt/homebrew-cask"
}

remove_sublime_config () {
    echo "$PR Removing SublimeConfig"
    sudo rm -rf "~/Library/'Application Support/Sublime Text 3'"
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

#remove_brew
#rvm implode

remove_sublime_config

if ! command -v brew > /dev/null 2>&1; then
    echo "$PG Downloading Homebrew"
    yes '' | ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
    echo "$PY Homebrew was already installed. Updating it..."
#    brew update
fi

brew_packages=( "wget" "git" "python" "node"  ) 
for pkg in "${brew_packages[@]}"
do
    if brew list -1 | grep -q "^${pkg}\$"; then
        echo "$PY Package '$pkg' is installed, skipping it..."
    else
        echo "$PG Installing '$pkg'..."
        brew install $pkg
    fi
done


if ! command -v postgres > /dev/null 2>&1; then
    echo "$PG Installing postgres..."
    brew install "postgresql"
     echo "$PG ...and configure"
    ln -sfv "/usr/local/opt/postgresql/*.plist" "$HOME/Library/LaunchAgents"
    launchctl load "$HOME/Library/LaunchAgents/homebrew.mxcl.postgresql.plist"
else
    echo "$PY Postgres already installed skipping..."
fi



##### Install Cask #####
echo "$PG Installing Cask"
brew install caskroom/cask/brew-cask

echo "$PG Tapping up caskroom/versions"
brew tap caskroom/versions

echo "$PG Tapping up caskroom/fonts"
brew tap caskroom/fonts

# cask_packages=( "dropbox" "sublime-text3" "things" "flash" "handbrake" "omnigraffle" "transmission" "mplayerx" "charles" "lightpaper" "fluid" "codekit""font-source-code-pro" )
cask_packages=( "dropbox" "sublime-text3"  )
for pkg in "${cask_packages[@]}"
do
    if brew cask list -1 | grep -q "^${pkg}\$"; then
        echo "$PY Cask '$pkg' is installed, skipping it..."
    else
        echo "$PG Installing '$pkg'..."
        brew cask install --force --appdir='/Applications' $pkg

        brew cask info $pkg | tail -n 1 >> echo
    fi
done

node_packages=( "jshint" "http-server" "gulp" )

for pkg in "${node_packages[@]}"
do
    if isNpmPackageInstalled $package; then
        echo "$PY Cask '$pkg' is installed, skipping it..."
    else
        echo "$PG Installing '$pkg'..."
        npm install -g $pkg
    fi

done



###################### set machine name ######################

sudo scutil --set ComputerName $MACHINE_NAME
sudo scutil --set HostName $MACHINE_NAME
sudo scutil --set LocalHostName $MACHINE_NAME
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string $MACHINE_NAME


SYSTEM_CONFIG_FILES="https://raw.githubusercontent.com/dwkns/system-install/master/system-config-files"

echo "$PG  Downloading bash profile"
wget -r "$SYSTEM_CONFIG_FILES/bash.bash_profile" -O "$HOME/.bash_profile"

echo "$PG  Downloading rspec config"
wget  -r "$SYSTEM_CONFIG_FILES/bash.rspec" -O "$HOME/.rspec"

echo "$PG  Downloading gemrc config"
wget -r "$SYSTEM_CONFIG_FILES/bash.gemrc" -O "$HOME/.gemrc"

echo "$PG  Downloading .gitconfig"
wget -r "$SYSTEM_CONFIG_FILES/bash.gitconfig" -O "$HOME/.gitconfig"

echo "$PG  Downloading .gitignore"
wget -r "$SYSTEM_CONFIG_FILES/bash.gitignore_global" -O "$HOME/.gitignore_global"


source $HOME/.bash_profile

###################### set machine name ######################

echo "$PG configuring sublime"

SUBLIME="$HOME/Library/Application Support/Sublime Text 3"

SUBLIME_LOCAL_DIR="$SUBLIME/local"
SUBLIME_PACKAGES_DIR="$SUBLIME/Packages"
SUBLIME_USER_DIR="$SUBLIME/Packages/User"
SUBLIME_INSTALLED_PACKAGES_DIR="$SUBLIME/Installed Packages"

mkdir -p SUBLIME_LOCAL_DIR
mkdir -p SUBLIME_USER_DIR
mkdir -p SUBLIME_INSTALLED_PACKAGES_DIR

echo "$PG  installing Package Control"
wget "http://sublime.wbond.net/Package Control.sublime-package" -O "$SUBLIME_INSTALLED_PACKAGES_DIR/Package Control.sublime-package"


BASE_URL="https://raw.githubusercontent.com/dwkns/system-install/master"

echo "$PG  installing pin_console.py"
wget "$BASE_URL/sublime-config-files/pin_console.py" -O "$SUBLIME_PACKAGES_DIR/pin_console.py"


echo "$PG  intalling license"
wget "$BASE_URL/sublime-config-files/License.sublime_license" -O "$SUBLIME_LOCAL_DIR/License.sublime_license"


echo "$PG   installing sublime preferences"
wget "$BASE_URL/sublime-config-files/Preferences.sublime-settings" -O "$SUBLIME_USER_DIR/Packages/User/Preferences.sublime-settings"


echo "$PG   installing sublime Package Control Settings"
wget "$BASE_URL/sublime-config-files/Package Control.sublime-settings" -O "$SUBLIME_USER_DIR/Packages/User/Package Control.sublime-settings"


echo "$PG   installing sublime theme dwkns.tmTheme"
wget "$BASE_URL/sublime-config-files/dwkns.tmTheme" -O "$SUBLIME_USER_DIR/Packages/User/dwkns.tmTheme"


echo "$PG   installing sublime keymap"
wget "$BASE_URL/sublime-config-files/Default (OSX).sublime-keymap" -O "$SUBLIME_USER_DIR/Packages/User/Default (OSX).sublime-keymap"



echo "$PG   intalling ruby-terminal build system"
git clone "https://github.com/dwkns/ruby-iTerm2.git" "$SUBLIME_PACKAGES_DIR/ruby-iTerm2"
chmod u+x "$SUBLIME_PACKAGES_DIR/ruby-iTerm2/ruby-iterm2.sh"
ln -s "$SUBLIME_PACKAGES_DIR/ruby-iTerm2/ruby-iterm2.sh" "/usr/local/bin"



subl .

echo "$PG All done $green<=======$white\n"




















