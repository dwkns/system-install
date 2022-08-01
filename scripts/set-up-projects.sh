#!/usr/bin/env zsh
######## Ask for a project name or use default 'demo_project'
if [ -z ${1+x} ]; then # have we passed in a variable $1
    echo
    echo $YELLOW"Nothing passed in..."$RESET
    echo "You can use '${0##*/} <projectName>' as a shortcut."
    echo
    echo $CYAN"Enter project name (default -> demo-project): "$RESET
    read PROJECTNAME
    PROJECTNAME=${PROJECTNAME:-demo-project}
else   
    success  "Setting project name to '$1'"
    PROJECTNAME=$1
fi


# True if the FILE exists and is a file, regardless of type (node, directory, socket, etc.).
######## Does the folder already exist? Do you want overide it?
if [ -e "$PROJECTNAME" ]; then
  echo $CYAN"Project $PROJECTNAME already exists delete it Y/n: "$RESET
  read DELETEIT
  DELETEIT=${DELETEIT:-Y}

  if [  "$DELETEIT" = "Y" ] || [  "$DELETEIT" = "y" ] ; then
   rm -rf $PROJECTNAME
  else
    error "OK not doing anything & exiting" 
    exit 0
  fi
fi