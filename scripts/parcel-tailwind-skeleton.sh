#!/usr/bin/env zsh
. $HOME/.system-config/scripts/utils/set-up-projects.sh $1;

success "Project $PROJECTNAME will be created!"

######## Create the folder
mkdir -p $PROJECTNAME
cd "$PROJECTNAME"

######## Init the project with auto-defaults, add Parcel.
yarn init -y
yarn add parcel-bundler 
yarn add @fullhuman/postcss-purgecss@1.2.0 --tilde  --dev
yarn add autoprefixer  --dev
yarn add cssnano  --dev
yarn add npm-run-all  --dev
yarn add postcss-cli  --dev
yarn add postcss-fontpath  --dev
yarn add posthtml-expressions  --dev
yarn add posthtml-include  --dev
yarn add posthtml-load-config  --dev
yarn add tailwindcss  --dev

######## Do some processing of package.json to add build scrips & title.

# change the name property of package.json (need to save temp file first)
tmp=$(mktemp) 
JQVAR=".name = \"$PROJECTNAME\""
jq "$JQVAR" package.json > "$tmp" && mv "$tmp" package.json

# add  build scripts to package.json
tmp=$(mktemp) 
JQVAR='.scripts |= .+ { 
  "postcss:watch": "postcss src/css/index.pcss -o src/css/index.css --env development -w",
  "postcss:build": "postcss src/css/index.pcss -o src/css/index.css --env production",
  "parcel:serve": "parcel src/index.html --open",
  "parcel:watch": "parcel watch src/index.html",
  "parcel:build": "parcel build src/index.html",
  "clean": "rm -rf dist .cache",
  "build": "npm-run-all -s clean postcss:build parcel:build",
  "start": "npm-run-all -s clean -p postcss:watch parcel:serve"
}'
jq "$JQVAR" package.json > "$tmp" && mv "$tmp" package.json

# add dependencies to package.json
tmp=$(mktemp) 
JQVAR='.dependencies |= .+ { 
  "parcel-bundler": "^1.12.4"
}'
jq "$JQVAR" package.json > "$tmp" && mv "$tmp" package.json


# add author scripts to package.json
tmp=$(mktemp) 
JQVAR='.author |= .+ "dwkns"'
jq "$JQVAR" package.json > "$tmp" && mv "$tmp" package.json



######## Add source folder and files. 
mkdir 'src'
mkdir 'src/js'
mkdir 'src/css'
mkdir 'src/partials'

cat >src/index.html <<'EOL'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <link rel="stylesheet" href="css/index.css">
    <title>Document</title>
</head>
<body class="min-h-screen font-sans">
    <include src="partials/header.html"></include>
    <script src="js/index.js"></script>
</body>
</html>
EOL

cat >src/partials/header.html <<'EOL'
<header>
    <h1 class="text-4xl">TailwindCSS + Parcel</h1>
</header>
EOL

cat >src/js/index.js <<'EOL'
const lastElement = document.body.lastChild ;
const paragraph = document.createElement('p');
paragraph.innerText = 'This is a paragraph added from JS which shows bundling is working.';
document.body.insertBefore(paragraph, lastElement);
EOL

cat >src/css/index.pcss <<'EOL'
@tailwind base;
@tailwind components;
@tailwind utilities;
EOL

cat >src/css/index.css <<'EOL'
//Will get replaced on initial build
EOL

##config files##

cat >.gitignore <<'EOL'
.DS_Store
node_modules
.cache
dist
EOL

cat >postcss.config.js <<'EOL'
module.exports = {
  plugins: {
    'postcss-fontpath': { checkFiles: true, ie8Fix: true },
    'tailwindcss': 'tailwind.config.js',
    '@fullhuman/postcss-purgecss': process.env.NODE_ENV === 'production',
    'autoprefixer': {},
  },
}
EOL

cat >posthtml.config.js <<'EOL'
module.exports = {
  plugins: [
    require('posthtml-include')({ root: 'src' }),
    require('posthtml-expressions')({}),
  ],
}
EOL

cat >purgecss.config.js <<'EOL'
module.exports = {
  content: ['./src/**/*.html', './src/**/*.svg', './src/**/*.js'],
  extractors: [
    {
      extensions: ['html', 'svg', 'js'],
      extractor: class TailwindExtractor {
        static extract (content) {
          return content.match(/[A-Za-z0-9-_:/]+/g) || []
        }
      },
    },
  ],
}
EOL

cat >tailwind.config.js <<'EOL'
module.exports = {
  prefix: '',
  important: false,
  separator: ':',
  theme: {},
  variants: {},
  corePlugins: {},
  plugins: [],
}
EOL


######## Put the project name into the HTML Title. 
sed -i "" -e "s/{{page-title}}/$PROJECTNAME/g" ./src/index.html

# Install any dependencies
yarn

# Do initial build of CSS
node_modules/.bin/postcss src/css/index.pcss -o src/css/index.css


######## Initialize git.
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