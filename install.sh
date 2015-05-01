
#!/bin/bash
######################## CONFIG ########################
PG="\n\033[0;32m==============>\033[0m"
PY="\n\033[1;33m==============>\033[0m"
PR="\n\033[0;31m==============>\033[0m"
PDONE="\n\033[0;34m====> Done\033[0m"

CURRENT_USER=`whoami`
MACHINE_NAME="dwkns-mbp"
BASE_URL="https://raw.githubusercontent.com/dwkns/system-install/master"
LOCAL_SCRIPTS=true
SOFTWARE_UPDATE=true

BREW_PACKAGES=( "wget" "git" "python" "dockutil") 

CASKS_PACKAGES=("iterm2-nightly" "dropbox" "sublime-text3" "things" "flash" "handbrake" "omnigraffle" "transmission" "mplayerx" "charles" "lightpaper" "fluid" "codekit" "font-source-code-pro" )

ADD_TO_DOCK=("iterm2-nightly" "sublime-text3" "things" "omnigraffle" "transmission" "mplayerx"  "lightpaper" "codekit")

# add "slingbox" when the pull request is accepted.

EXCLUSION_LIST=("/Applications/" "/Library/" "/System/" "/bin/" "/cores/" "/opt/" "/private/" "/sbin/" "/usr/" "/.vol" "/.fseventsd" "/Users/$CURRENT_USER/Downloads/" "/Users/$CURRENT_USER/Library/Caches/" "/Users/$CURRENT_USER/Library/Mail/" "/Users/$CURRENT_USER/Documents/Torrents/" )


 ################### FUNCTIONS ###################
 download_and_run() {
   URL="$1"
   FILENAME=`echo $URL | sed 's/.*\///'` # get just the filename from the URL
   curl -s -L $URL -o $TEMP_DIR/$FILENAME # download the file
  #  chmod +x $TEMP_DIR/$FILENAME
  source $TEMP_DIR/$FILENAME # run it
 }

######################## SCRIPT ########################
sudo -v # ask for sudo upfront
echo -e "$PG Starting Install"

TEMP_DIR=`mktemp -d -t osx-install` # Create a tmp directoy

# Keep-alive: update existing sudo time stamp if set, otherwise do nothing.
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

if $LOCAL_SCRIPTS; then
    echo -e "$PG using local scripts"
    source scripts/clean.sh
    source scripts/homebrew.sh
    source scripts/postgres.sh
    source scripts/casks.sh
    source scripts/sublime.sh
    source scripts/rvm-ruby.sh
    source scripts/gems.sh
    source scripts/node.sh
    source scripts/krep.sh
    source scripts/dotfiles.sh
    source scripts/system-settings.sh
    source scripts/time-machine.sh
else
    echo -e "$PG using remote scripts"

    download_and_run $BASE_URL/clean.sh
    download_and_run $BASE_URL/homebrew.sh
    download_and_run $BASE_URL/postgres.sh
    download_and_run $BASE_URL/casks.sh
    download_and_run $BASE_URL/sublime.sh
    download_and_run $BASE_URL/rvm-ruby.sh
    download_and_run $BASE_URL/gems.sh
    download_and_run $BASE_URL/node.sh
    download_and_run $BASE_URL/krep.sh
    download_and_run $BASE_URL/dotfiles.sh
    download_and_run $BASE_URL/system-settings.sh
    download_and_run $BASE_URL/time-machine.sh

fi

## Install any Apple System Updates
if $SOFTWARE_UPDATE; then
    sudo softwareupdate -ia
fi

######################## cleanup ########################

echo -e "$PG  load bash profile into shell"
source $HOME/.bash_profile

echo -e "$PG Deleteing Temp Directory"
rm -rf $TEMP_DIR
echo -e "$PG All done I recommend Rebooting \033[0;32m<=======\033[1;37m\n"



