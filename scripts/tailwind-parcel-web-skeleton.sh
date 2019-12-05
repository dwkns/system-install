#!/usr/bin/env zsh
. $HOME/.system-config/scripts/utils/set-up-projects.sh $1;

success "Project $PROJECTNAME will be created!"

######## Create the folder
mkdir -p $PROJECTNAME
cd "$PROJECTNAME"

######## Init the project with auto-defaults, add Parcel.
yarn init -y
yarn add parcel-bundler --dev
yarn add parcel-plugin-clean-dist --dev
yarn add tailwindcss --dev
yarn add cssnano --dev
yarn add @fullhuman/postcss-purgecss --dev
yarn add postcss-purgecss --dev
npx tailwind init --full


######## Do some processing of package.json to add build scrips & title.

# change the name property of package.json (need to save temp file first)
tmp=$(mktemp) 
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


cat >postcss.config.js <<'EOL'
module.exports = { 
    theme: {}, 
    variants: {}, 
    plugins: [ 
        require('tailwindcss'),
        cssnano({
              preset: 'default'
            }),
        purgecss({
          content: ['./layouts/**/*.html', './src/**/*.vue', './src/**/*.jsx'],
          defaultExtractor: content => content.match(/[\w-/:]+(?<!:)/g) || []
        })
    ] 
}
EOL
######## Add source folder and files. 
mkdir 'src'

cat >src/index.html <<'EOL'
<!DOCTYPE html>
<html lang='en'>
<head>
  <meta charset='UTF-8'>
  <title>{{page-title}}</title>
</head>
<body>
  <h1>Parcel bootstrap project : {{page-title}}</h1>
  <p>Make it into something cool</p>
  <script src="./index.js"></script>
</body>
</html>
EOL

cat >src/index.js <<'EOL'
import './main.scss';
const paragraph = document.createElement('p');
paragraph.innerText = 'This is a paragraph added from JS which shows bundling is working.';
document.body.appendChild(paragraph); 
EOL

cat >src/main.css <<'EOL'
@tailwind base;
@tailwind components;
@tailwind utilities;
EOL

######## Put the project name into the HTML Title. 
sed -i "" -e "s/{{page-title}}/$PROJECTNAME/g" ./src/index.html

# ######## Initialize git.
# git init
# git add .
# git commit -m "Initial commit"


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

# ######## Format sublimes windows to my favorite layout.
# subl --command  'terminus_open {"config_name": "Default","cwd": "${file_path:${folder}}","pre_window_hooks": [["set_layout",{"cols": [0.0, 0.5, 1.0],"rows": [0.0, 0.5, 1.0],"cells": [[0, 0, 1, 2],[1, 0, 2, 1],[1, 1, 2, 2]]}]]}'


######## Start the server.
yarn serve