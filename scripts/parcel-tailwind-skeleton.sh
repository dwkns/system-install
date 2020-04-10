#!/usr/bin/env zsh
. $HOME/.system-config/scripts/utils/set-up-projects.sh $1;

success "Project $PROJECTNAME will be created!"

git clone https://github.com/dwkns/parcel-tailwind.git $PROJECTNAME

######## Create the folder
cd "$PROJECTNAME"

######## Do some processing of package.json to add build scrips & title.

# change the name property of package.json (need to save temp file first)
tmp=$(mktemp) 
JQVAR=".name = \"$PROJECTNAME\""
jq "$JQVAR" package.json > "$tmp" && mv "$tmp" package.json


# add author  to package.json
tmp=$(mktemp) 
JQVAR=".author = \"$USER\""
jq "$JQVAR" package.json > "$tmp" && mv "$tmp" package.json


######## Put the project name into the HTML Title. 
sed -i "" -e "s/---page-title---/$PROJECTNAME/g" ./src/index.html

# Install any dependencies
yarn

######## Initialize git.
rm -rf .git #  remove the previous git files.
git init
git add .
git commit -m "Initial commit"


######## Open a new iTerm tab at the project root. 
######## Required because server will run in current tab.
osascript  <<EOL > /dev/null 2>&1
tell application "iTerm"
  set currentWindow to current window 
  tell currentWindow
    create tab with default profile
    delay 0.5
    tell current session of currentWindow
      write text "cd $PROJECTNAME"
    end tell
  end tell
end tell
EOL


######## Open project in Sublime
subl .

######## Format sublimes windows to my favorite layout.
# subl --command  'terminus_open {"config_name": "Default","cwd": "${file_path:${folder}}","pre_window_hooks": [["set_layout",{"cols": [0.0, 0.5, 1.0],"rows": [0.0, 0.5, 1.0],"cells": [[0, 0, 1, 2],[1, 0, 2, 1],[1, 1, 2, 2]]}]]}'


# ######## Start the server.
yarn start