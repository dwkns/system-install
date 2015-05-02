#!/bin/bash
echo "Doing the main install"
# # set up some colours
# PG="\n\033[0;32m==============>\033[0m"
# PY="\n\033[1;33m==============>\033[0m"
# PR="\n\033[0;31m==============>\033[0m"
# PDONE="\n\033[0;34m====> Done\033[0m"

# DEBUG=true
# ROOT_DIR="$HOME/.system-config"

# # ask for sudo upfront
# sudo -v 

# # Keep-alive: update existing sudo time stamp if set, otherwise do nothing.
# while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &


# if $DEBUG; then
#   WORKING_DIR="`( cd \"$MY_PATH\" && pwd )`"

#   #clean up before we install
#   source $WORKING_DIR/scripts/clean.sh
#   # remove_homebrew
#   # remove_system_config

#   # remove_krep
#   # remove_apps_from_dock
#   # remove_postgres
#   # remove_dotfiles
#   # remove_iterm
#   # remove_apps
#   # remove_sublime_config
#   # remove_rvm
#   # remove_cask
   
#   # remove_time_machine_exclusions
# fi

# ############ Install Homebrew ############
# echo -e "$PG Installing Homebrew"

# if xcode-select -p; then
#   echo "Developer tools are installed"
#   if command -v brew > /dev/null 2>&1; then
#      echo "Homebrew is installed... skipping the installation"
#      echo "Running 'brew update'"
#      #brew update
#    else
#     echo "Installing Homebrew"
#     yes '' | ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
#   fi
# else
#   echo "Developer tools are installed"
#   ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
# fi
# echo -e $PDONE

# ############ Download config files  ############

# echo -e "$PG Downloading config files"

# if [ -d "$ROOT_DIR" ]; then
#   echo "'.system-config' folder is already there. Updating..."
#   cd $ROOT_DIR
#   git pull
# else
#   echo "Cloning 'https://github.com/dwkns/system-install.git' into '~/.system-config'"
#   git clone https://github.com/dwkns/system-install.git ~/.system-config
#   cd $ROOT_DIR
# fi
# echo "ROOT_DIR is set to $ROOT_DIR"
# echo -e $PDONE

# source "$ROOT_DIR/scripts/main-install.sh"















# # SOFTWARE_UPDATE=false
# # CURRENT_USER=`whoami`


# # MACHINE_NAME="dwkns-mbp"

# # BASE_URL="https://raw.githubusercontent.com/dwkns/system-install/master"

# # EXCLUSION_LIST=("/Applications/" "/Library/" "/System/" "/bin/" "/cores/" "/opt/" "/private/" "/sbin/" "/usr/" "/.vol" "/.fseventsd" "$HOME/Downloads/" "$HOME/Library/Caches/"  "$HOME/Documents/Torrents/" "$HOME/Dropbox/" "$HOME/Library/Application Support/Google/")


# # BREW_PACKAGES=( "wget" "git" "python" "dockutil") 

# # CASKS_PACKAGES=("iterm2-nightly" "dropbox" "sublime-text3" "things" "flash" "handbrake" "omnigraffle" "transmission" "mplayerx" "charles" "lightpaper" "fluid" "codekit" "font-source-code-pro" )

# # ADD_TO_DOCK=("iterm2-nightly" "sublime-text3" "things" "omnigraffle" "transmission" "mplayerx"  "lightpaper" "codekit")



# # ##### debug and testing ######
# # if $DEBUG; then 
# #   CASKS_PACKAGES=("iterm2-nightly" "dropbox" "sublime-text3" "things")
# #   ADD_TO_DOCK=("iterm2-nightly" "sublime-text3")
# # fi 
# # # add "slingbox" when the pull request is accepted.


# # ######################## CONFIG ########################
# # PG="\n\033[0;32m==============>\033[0m"
# # PY="\n\033[1;33m==============>\033[0m"
# # PR="\n\033[0;31m==============>\033[0m"
# # PDONE="\n\033[0;34m====> Done\033[0m"

# # SCRIPT_PATH="`dirname \"$0\"`"


# # ######################## SCRIPT ########################
# # sudo -v # ask for sudo upfront
# # echo -e "$PG Starting Install"

# # TEMP_DIR=`mktemp -d -t osx-install` # Create a tmp directoy

# # # Keep-alive: update existing sudo time stamp if set, otherwise do nothing.
# # while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# # echo -e "$PG using local scripts"

# # source $WORKING_DIR/scripts/clean.sh # Add in the clean functions
# # clean_all #cleans everything

# # source $WORKING_DIR/scripts/homebrew.sh
# # source $WORKING_DIR/scripts/dotfiles.sh 
# # source $WORKING_DIR/scripts/system-settings.sh
# # source $WORKING_DIR/scripts/apps.sh


# # source $WORKING_DIR/scripts/postgres.sh
# # source $WORKING_DIR/scripts/node.sh
# # source $WORKING_DIR/scripts/time-machine.sh
# # source $WORKING_DIR/scripts/rvm-ruby.sh
# # source $WORKING_DIR/scripts/gems.sh


# # echo -e "$PG  Checking for Apple System Updates"
# # ## Install any Apple System Updates
# # if $SOFTWARE_UPDATE; then
# #     sudo softwareupdate -ia
# # fi
# # ###############################################################################
# # # Clean up                                                                    #
# # ###############################################################################
# # echo -e "$PG  Resarting a bunch of stuff"
# # for app in "Activity Monitor" "Address Book" "Calendar" "Contacts" "cfprefsd" \
# #   "Dock" "Finder" "Google Chrome" "Mail" "Messages" \
# #   "Safari" "SystemUIServer"  \
# #   "Transmission"  "iCal"; do
# #   killall "${app}" > /dev/null 2>&1
# # done

# # echo -e "$PG  load bash profile into shell"
# # source $HOME/.bash_profile

# # echo -e "$PG Deleteing Temp Directory"
# # rm -rf $TEMP_DIR

# # echo -e "$PG All done I recommend Rebooting \033[0;32m<=======\033[1;37m\n"



