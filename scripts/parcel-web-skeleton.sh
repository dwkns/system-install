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

yarn init -y
yarn add parcel-bundler --dev
# yarn add @vaadin/vaadin-select 

# npm init -y
# npm install parcel-bundler --save-dev
# npm install @vaadin/vaadin-select  --save


# create a temp file
tmp=$(mktemp) 

# change the name property of package.json (need to save temp file first)
JQVAR=".name = \"$PROJECTNAME\""
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
import './main.scss'
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
parcel src/index.html --open