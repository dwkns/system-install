
#!/bin/bash
######################## CONFIG ########################
PG="\n\033[0;32m==============>\033[1;37m"
PY="\n\033[1;33m==============>\033[1;37m"
PR="\n\033[0;31m==============>\033[1;37m"

MACHINE_NAME="dwkns-mbp"
BASE_URL="https://raw.githubusercontent.com/dwkns/system-install/master"
LOCAL_SCRIPTS=false
SOFTWARE_UPDATE=true

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
    source scripts/node.sh
    source scripts/krep.sh
    source scripts/dotfiles.sh
    source scripts/system-settings.sh
    source scripts/sublime.sh
    source scripts/rvm-ruby.sh
    source scripts/gems.sh
else
    echo -e "$PG using remote scripts"
    download_and_run $BASE_URL/scripts/clean.sh
    download_and_run $BASE_URL/scripts/homebrew.sh
    download_and_run $BASE_URL/scripts/postgres.sh
    download_and_run $BASE_URL/scripts/casks.sh
    download_and_run $BASE_URL/scripts/node.sh
    download_and_run $BASE_URL/scripts/krep.sh
    download_and_run $BASE_URL/scripts/dotfiles.sh
    download_and_run $BASE_URL/scripts/system-settings.sh
    download_and_run $BASE_URL/scripts/sublime.sh
    download_and_run $BASE_URL/scripts/rvm-ruby.sh
    download_and_run $BASE_URL/scripts/gems.sh
fi

## Install any Apple System Updates
if $SOFTWARE_UPDATE; then
    sudo softwareupdate -ia
fi

######################## cleanup ########################

echo -e "$PG  load bash profile into shell"
source $HOME/.bash_profile


killall Dock
echo -e "$PG Deleteing Temp Directory"
rm -rf $TEMP_DIR
echo -e "$PG All done \033[0;32m<=======\033[1;37m\n"



