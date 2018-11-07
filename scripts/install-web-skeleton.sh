#!/usr/bin/env bash

# have we passed in a variable $1
if [ -z ${1+x} ]; then 
    echo "Nothing paseed in..."; 
    echo "you can use 'iws projectName' as a shortcut."; 
    read -p "Enter project name (default - demoProject) : " PROJECTNAME
    PROJECTNAME=${PROJECTNAME:-demoProject}
else 
    echo "Setting project name to '$1'"; 
    PROJECTNAME=$1
fi


if [ -d "$PROJECTNAME" ]; then
  read -p "Project $PROJECTNAME already exists delete it y/n (default - y) : " DELETEIT
  DELETEIT=${DELETEIT:-Y}

  if [  "$DELETEIT" = "Y" ] || [  "$DELETEIT" = "y" ] ; then
   rm -rf $PROJECTNAME
  else
    echo "OK not doing anything & exiting" 
    exit 0
  fi
fi

echo "Project $PROJECTNAME will be created!"

mkdir -p $PROJECTNAME

cd "$PROJECTNAME"
git clone https://github.com/dwkns/web-project-skeleton.git .

# create a temp file
tmp=$(mktemp) 

# change the name property of package.json (need to save temp file first)
JQVAR=".name = \"$PROJECTNAME\""
jq "$JQVAR" package.json > "$tmp" && mv "$tmp" package.json


yarn install;

git init
git add -A
git commit -m 'Initial commit'

subl .

# echo $PWD
osascript <<END
tell application "CodeKit"
  add project at path "$PWD"
  delay 1
  build project containing path "$PWD"
end tell
END

# delay 5
# preview in browser