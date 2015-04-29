
#!/bin/bash
######################## CONFIG ########################
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
download_and_run $BASE_URL/sripts/clean.sh
download_and_run $BASE_URL/sripts/homebrew.sh
download_and_run $BASE_URL/sripts/postgres.sh
download_and_run $BASE_URL/sripts/casks.sh
download_and_run $BASE_URL/sripts/node.sh
download_and_run $BASE_URL/sripts/krep.sh
download_and_run $BASE_URL/sripts/dotfiles.sh
download_and_run $BASE_URL/sripts/system-settings.sh

download_and_run $BASE_URL/sripts/sublime.sh
download_and_run $BASE_URL/sripts/rvm-ruby.sh
download_and_run $BASE_URL/sripts/gems.sh


######################## cleanup ########################

echo -e "$PG  load bash profile into shell"
source $HOME/.bash_profile

killall Dock
echo -e "$PG Deleteing Temp Directory"
rm -rf $TEMP_DIR
echo -e "$PG All done \033[0;32m<=======\033[1;37m\n"



