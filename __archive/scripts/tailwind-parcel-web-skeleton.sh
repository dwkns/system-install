#!/usr/bin/env zsh

. $HOME/.system-config/scripts/utils/colours.sh $1;
. $HOME/.system-config/scripts/utils/set-up-projects.sh $1;


# ############################### colours.sh ###############################


# ############### Variables ###############
# RED="\033[0;31m"          
# YELLOW="\033[0;33m"       
# GREEN="\033[0;32m"          
# BLUE="\033[0;94m"
# RESET="\033[0m"
# CYAN="\033[0;36m"

# ############### Functions ###############

# success () {
#   echo -e $GREEN"Success ========>$CYAN $1 $RESET"
# }

# warn () {
#  echo -e $YELLOW"Warning ========>$CYAN $1 $RESET"
# }

# error () {  
#  echo -e $RED"Error ========>$CYAN $1 $RESET"
# }

# note () {
#   echo -e $CYAN"========>$RESET $1 $RESET"
# }
# ############################### END ###############################


# ############################### set-up-projects.sh ###############################

# ############### Ask for a project name or use default 'demo_project'
# if [ -z ${1+x} ]; then # have we passed in a variable $1
#     warn "Nothing passed in..."
#     warn "You can use '${0##*/} <projectName>' as a shortcut."
#     echo -n "Enter project name (default -> demoProject) : "
#     read PROJECTNAME
#     echo
#     PROJECTNAME=${PROJECTNAME:-demo_project}
# else   
#     success  "Setting project name to '$1'"
#     PROJECTNAME=$1
# fi

# ############### Does the folder already exist? Do you want overide it?
# if [ -d "$PROJECTNAME" ]; then
#   echo -n "Project $PROJECTNAME already exists delete it y/n (default - y) : "
#   read DELETEIT
#   DELETEIT=${DELETEIT:-Y}

#   if [  "$DELETEIT" = "Y" ] || [  "$DELETEIT" = "y" ] ; then
#    rm -rf $PROJECTNAME
#   else
#     error "OK not doing anything & exiting" 
#     exit 0
#   fi
# fi

# ############################### END ###############################

success "Project $PROJECTNAME will be created!"
AUTHOR=$USER 
######## Create the folder
mkdir -p $PROJECTNAME
cd "$PROJECTNAME"

######## Init the project with auto-defaults, add Parcel.
yarn init -y
yarn add parcel --dev
yarn add cssnano --dev
yarn add tailwindcss --dev
yarn add @fullhuman/postcss-purgecss --dev
yarn add parcel-plugin-clean-dist --dev


######## Do some processing of package.json to add build scrips & title.

# change the name property of package.json (need to save temp file first)
tmp=$(mktemp) 
JQVAR=".name = \"$PROJECTNAME\""
jq "$JQVAR" package.json > "$tmp" && mv "$tmp" package.json

# add some build scripts to package.json
tmp=$(mktemp) 
JQVAR='.scripts |= .+ { "serve" : "yarn dev","dev": "parcel serve src/index.html -d dev --target browser --open", "build": "parcel build src/index.html -d dist --target browser" }'
jq "$JQVAR" package.json > "$tmp" && mv "$tmp" package.json

# add author
tmp=$(mktemp) 
JQVAR=".author |= .+ \"$AUTHOR\""
# JQVAR='.author |= .+ "dwkns"'
jq "$JQVAR" package.json > "$tmp" && mv "$tmp" package.json


cat >tailwind.config.js <<'EOL'
module.exports = {
  theme: {
    extend: {}
  },
  variants: {},
  plugins: []
}

EOL

cat >postcss.config.js <<'EOL'
/*eslint-disable */
const purgecss = require('@fullhuman/postcss-purgecss')
module.exports = {
  plugins: [
    require('tailwindcss')('tailwind.config.js'),
    purgecss({
      content: ['./src/**/*.html', './src/**/*.js'],
      defaultExtractor: content => content.match(/[A-Za-z0-9-_:\/]+/g) || []
    })
  ]
}
EOL



######## Add source folder and files. 
mkdir 'src'

cat >src/index.html <<'EOL'
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <title>demo_project</title>
    <meta name="author" content="{{author}}">
    <meta name="description" content="dwkns provide digital consultancy and production services">

    <meta property="og:image" content="https://some-url.com/link-to-some-image.jpg">
    <meta property="og:description" content="Some Description">
    <meta property="og:title" content="Some title">
  </head>

  <body class="bg-gray-800 text-sm text-white">
    <p>If the background is grey and the text is white all is good</p>
    <script defer src="./index.js"></script>
  </body>
</html>
EOL

cat >src/index.js <<'EOL'
/*eslint-disable */
import './main.css';
EOL

cat >src/main.css <<'EOL'
@tailwind base;
@tailwind components;
@tailwind utilities;
EOL

######## Put the project name into the HTML Title. 
sed -i "" -e "s/{{page-title}}/$PROJECTNAME/g" ./src/index.html
sed -i "" -e "s/{{author}}/$AUTHOR/g" ./src/index.html

######## Initialize git.
git init
git add .
git commit -m "Initial commit"


######## Open a new iTerm tab at the project root. 
######## Required because server will run in current tab.
# osascript  <<EOL > /dev/null 2>&1
# tell application "iTerm"
#   set currentWindow to current window 
#   tell currentWindow
#     create tab with default profile
#     delay 0.5
#     tell current session of currentWindow
#       write text "cd $PROJECTNAME"
#     end tell
#   end tell
# end tell
# EOL



######## Open project in Sublime
 subl .

######## Format sublimes windows to my favorite layout.
# subl --command  'terminus_open {"config_name": "Default","cwd": "${file_path:${folder}}","pre_window_hooks": [["set_layout",{"cols": [0.0, 0.5, 1.0],"rows": [0.0, 0.5, 1.0],"cells": [[0, 0, 1, 2],[1, 0, 2, 1],[1, 1, 2, 2]]}]]}'


######## Start the server.
yarn dev