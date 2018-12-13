#!/usr/bin/env bash


############################### Variables ###############################
RED="\[\033[0;31m\]"          #red
YELLOW="\[\033[0;33m\]"       #yellow
WHITE="\[\033[0;37m\]"        #white
GREEN="\[\033[32m\]"          #greeen

############################### Functions ###############################
note () {
  echo -e "\033[0;94m====> $1 \033[0m"
}
msg () {
  echo -e "\033[0;32m==============> $1 \033[0m"
}

smsg () {
  echo -e "\033[0;32m====> $1 \033[0m"
}
warn () {
  echo -e "\033[0;31m====> $1 \033[0m"
}


############################### Main Script ###############################

if [ -z ${1+x} ]; then # have we passed in a variable $1
    note "Nothing passed in..."; 
    note "You can use 'cws projectName' as a shortcut."; 
    echo
    read -p "Enter project name (default - demoProject) : " PROJECTNAME
    echo
    PROJECTNAME=${PROJECTNAME:-demoProject}
else 
    note "Setting project name to '$1'"; 
    PROJECTNAME=$1
fi


if [ -d "$PROJECTNAME" ]; then
  read -p "Project $PROJECTNAME already exists delete it y/n (default - y) : " DELETEIT
  DELETEIT=${DELETEIT:-Y}

  if [  "$DELETEIT" = "Y" ] || [  "$DELETEIT" = "y" ] ; then
   rm -rf $PROJECTNAME
  else
    warn "OK not doing anything & exiting" 
    exit 0
  fi
fi

smsg "Project $PROJECTNAME will be created!"

mkdir -p $PROJECTNAME

cd "$PROJECTNAME"
git clone https://github.com/dwkns/web-project-skeleton.git .

# create a temp file
tmp=$(mktemp) 

# change the name property of package.json (need to save temp file first)
JQVAR=".name = \"$PROJECTNAME\""
jq "$JQVAR" package.json > "$tmp" && mv "$tmp" package.json

sed -i "" -e "s/{{page-title}}/$PROJECTNAME/g" ./source/index.html

echo;

yarn install;

git init
git add -A
git commit -m 'Initial commit'
git remote rm origin


subl .

osascript <<END > /dev/null 2>&1
tell application "CodeKit"
  add project at path "$PWD"
  delay 1
  build project containing path "$PWD"
end tell
END