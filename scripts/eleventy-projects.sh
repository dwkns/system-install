#!/usr/bin/env zsh
FILENAME=$2
REPO=$1

if [ -z "${FILENAME}" ]; then # have we passed in a variable $1
    echo
    echo $YELLOW"Nothing passed in..."$RESET
    echo
    echo $CYAN"Enter project name (default -> demo-project): "$RESET
    read PROJECTNAME
    PROJECTNAME=${PROJECTNAME:-demo-project}
    success  "Setting project name to '$PROJECTNAME'"
else   
    PROJECTNAME=$FILENAME
    success  "Setting project name to '$PROJECTNAME'"
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

success "Project $PROJECTNAME will be created!"
success "Using $REPO as the source repo"
echo "using as the git repo"
git clone $REPO $PROJECTNAME

# ######## Create the folder
cd "$PROJECTNAME"

# ######## Do some processing of package.json to add build scrips & title.

# # change the name property of package.json (need to save temp file first)
tmp=$(mktemp)
JQVAR=".name = \"$PROJECTNAME\""
jq "$JQVAR" package.json >"$tmp" && mv "$tmp" package.json

# # add author to package.json
tmp=$(mktemp)
JQVAR=".author  = \"dwkns\""
jq "$JQVAR" package.json >"$tmp" && mv "$tmp" package.json


# ######## Initialize git.
rm -rf .git #  remove the previous git files.
git init
git add .
git commit -m "Initial commit"

# doing 'running yarn'
yarn install

code .
