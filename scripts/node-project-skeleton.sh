#!/usr/bin/env zsh
. $HOME/.system-config/scripts/set-up-projects.sh $1;

echo -n "Enable ESLint? ( y/n > default - n) : "
read -t 3 ESLINT
ESLINT=${ESLINT:-N}

success "Project $PROJECTNAME will be created!"

######## Create the folder
mkdir -p $PROJECTNAME
cd "$PROJECTNAME"

# ######## Init the project with auto-defaults, add Parcel.
yarn init -y
yarn add the-answer --dev
# yarn add parcel-bundler --dev
# yarn add parcel-plugin-clean-dist --dev


######## Do some processing of package.json to add build scrips & title.

# change the name property of package.json (need to save temp file first)
tmp=$(mktemp) 
JQVAR='.name = \"$PROJECTNAME\"'
jq "$JQVAR" package.json > "$tmp" && mv "$tmp" package.json

tmp=$(mktemp) 
JQVAR='.main = "src/index.js'
jq "$JQVAR" package.json > "$tmp" && mv "$tmp" package.json

# add some build scripts to package.json
tmp=$(mktemp) 
JQVAR='.scripts |= .+ { "run": "node src/index.js" }'
jq "$JQVAR" package.json > "$tmp" && mv "$tmp" package.json

# # add author
tmp=$(mktemp) 
JQVAR='.author |= .+ "dwkns"'
jq "$JQVAR" package.json > "$tmp" && mv "$tmp" package.json



cat >README.md <<'EOL'
##Read Me File
EOL


# cat >Gemfile <<'EOL'
# source 'https://rubygems.org'
# gem 'rspec'
# gem 'awesome_print'
# EOL
######## Add source folder and files. 
mkdir 'src'
mkdir 'bin'



cat >src/index.js <<'EOL'
const answer = require( 'the-answer' );
console.log( 'the answer is ' + answer );
EOL


cat >.eslintignore <<'EOL'
**/*
EOL

if [  "$ESLINT" = "Y" ] || [  "$ESLINT" = "y" ] ; then
 rm -rf .eslintignore
fi




cat >bin/s <<'EOL'
#!/usr/bin/env bash
node ./src/index.js
EOL



chmod +x bin/s




######## Initialize git.
git init
git add .
git commit -m "Initial commit"




# ######## Open a new iTerm tab at the project root. 
# ######## Required because server will run in current tab.
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

success "Project created"
note "Use : "
note "bin/s to run"

# ######## Format sublimes windows to my favorite layout.
# subl --command  'terminus_open {"config_name": "Default","cwd": "${file_path:${folder}}","pre_window_hooks": [["set_layout",{"cols": [0.0, 0.5, 1.0],"rows": [0.0, 0.5, 1.0],"cells": [[0, 0, 1, 2],[1, 0, 2, 1],[1, 1, 2, 2]]}]]}'


# ######## Start the server.
# yarn serve