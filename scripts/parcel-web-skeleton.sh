#!/usr/bin/env bash

############################### Variables ###############################
RED="\033[0;31m"          
YELLOW="\033[0;33m"       
GREEN="\033[0;32m"          
BLUE="\033[0;94m"
RESET="\033[0m"

############################### Functions ###############################


success () {
  echo -e "$GREEN====> $1 $RESET"
}

warn () {
 echo -e "$YELLOW====> $1 $RESET"
}

error () {  
 echo -e "$RED====> $1 $RESET"
}

note () {
  echo -e "$RESET====> $1 $RESET"
}


############################### Main Script ###############################



if [ -z ${1+x} ]; then # have we passed in a variable $1
    warn "Nothing passed in..."
    warn "You can use 'pws <projectName>' as a shortcut."
    echo
    read -p "Enter project name (default -> demoProject) : " PROJECTNAME
    echo
    PROJECTNAME=${PROJECTNAME:-demoProject}
else 
    echo -e "$GREEN====> Setting project name to $BLUE'$1'$RESET"
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

success "Project $PROJECTNAME will be created!"

mkdir -p $PROJECTNAME

cd "$PROJECTNAME"

yarn init -y
yarn add parcel-bundler --dev
yarn add parcel-plugin-clean-dist --dev


# create a temp file
tmp=$(mktemp) 

# change the name property of package.json (need to save temp file first)
JQVAR=".name = \"$PROJECTNAME\""
jq "$JQVAR" package.json > "$tmp" && mv "$tmp" package.json

# add some build scripts to package.json
tmp=$(mktemp) 
JQVAR='.scripts |= .+ { "serve": "parcel src/index.html --open", "build": "parcel build src/index.html" }'
jq "$JQVAR" package.json > "$tmp" && mv "$tmp" package.json

# add author
tmp=$(mktemp) 
JQVAR='.author |= .+ "dwkns"'
jq "$JQVAR" package.json > "$tmp" && mv "$tmp" package.json

mkdir 'src'

cat >src/index.html <<'EOL'
<!DOCTYPE html>
<html lang='en'>
<head>
  <meta charset='UTF-8'>
  <title>vaadin demo</title>
</head>
<body>
  <h1>Parcel bootstrap project</h1>
  <p>Make it into something cool</p>
  <script src="./index.js"></script>
</body>
</html>
EOL

cat >src/index.js <<'EOL'
import './main.scss';
import testModule from './testModule.js';
testModule();
EOL

cat >src/testModule.js <<'EOL'
export function testModule() {
    let testVar = 'Bootstrap Project';
    console.log(`Parcel ${testVar}`);
}
EOL

cat >src/main.scss <<'EOL'
$brand: #4A90E2;
$brand-alternate: #F5A623;

body {
    font-family: -apple-system, Sans-Serif;
    color: $brand;
}

h1 {
    font-size: 24pt;
    color: $brand-alternate;
}
EOL

git init
git add .
git commit -m "Initial commit"

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

subl .
subl --command  'terminus_open {"config_name": "Default","cwd": "${file_path:${folder}}","pre_window_hooks": [["set_layout",{"cols": [0.0, 0.5, 1.0],"rows": [0.0, 0.5, 1.0],"cells": [[0, 0, 1, 2],[1, 0, 2, 1],[1, 1, 2, 2]]}],["focus_group",{"group": 2}]]}'

yarn serve