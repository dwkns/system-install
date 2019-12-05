#!/usr/bin/env zsh
######## Ask for a project name or use default 'demo_project'
if [ -z ${1+x} ]; then # have we passed in a variable $1
    warn "Nothing passed in..."
    warn "You can use '${0##*/} <projectName>' as a shortcut."
    echo -n "Enter project name (default -> demoProject) : "
    read PROJECTNAME
    echo
    PROJECTNAME=${PROJECTNAME:-demoProject}
else   
    success  "Setting project name to '$1'"
    PROJECTNAME=$1
fi

######## Does the folder already exist? Do you want overide it?
if [ -d "$PROJECTNAME" ]; then
  echo -n "Project $PROJECTNAME already exists delete it y/n (default - y) : "
  read DELETEIT
  DELETEIT=${DELETEIT:-Y}

  if [  "$DELETEIT" = "Y" ] || [  "$DELETEIT" = "y" ] ; then
   rm -rf $PROJECTNAME
  else
    error "OK not doing anything & exiting" 
    exit 0
  fi
fi