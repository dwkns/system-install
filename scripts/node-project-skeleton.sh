#!/usr/bin/env zsh
. $HOME/.system-config/scripts/set-up-projects.sh $1

echo -n "Enable ESLint? ( y/n > default - n) : "
read -t 3 ESLINT
ESLINT=${ESLINT:-N}


echo -n "Use Typescript? ( y/n > default - n) : "
read -t 3 TYPESCRIPT
TYPESCRIPT=${TYPESCRIPT:-N}

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

# change the name property of package.json (need to save temp file first)
tmp=$(mktemp)
JQVAR=".name = \"$PROJECTNAME\""
jq "$JQVAR" package.json >"$tmp" && mv "$tmp" package.json

# add author  to package.json
tmp=$(mktemp)
JQVAR=".author = \"$USER\""
jq "$JQVAR" package.json >"$tmp" && mv "$tmp" package.json

tmp=$(mktemp)
JQVAR=".main = \"src/index.js\""
jq "$JQVAR" package.json >"$tmp" && mv "$tmp" package.json

tmp=$(mktemp)
JQVAR=".type = \"module\""
jq "$JQVAR" package.json >"$tmp" && mv "$tmp" package.json

# add some build scripts to package.json
tmp=$(mktemp)
JQVAR=".scripts |= .+ { \"start\": \"node src/index.js\" }"
jq "$JQVAR" package.json >"$tmp" && mv "$tmp" package.json

cat >README.md <<'EOL'
##Read Me File

To add ESLint Congig:

```bash

```
EOL

# cat >Gemfile <<'EOL'
# source 'https://rubygems.org'
# gem 'rspec'
# gem 'awesome_print'
# EOL
######## Add source folder and files.
mkdir 'src'
# mkdir 'bin'

cat >src/index.js <<'EOL'
import answer from 'the-answer'
console.log( 'the answer is ' + answer );
EOL

cat >.eslintignore <<'EOL'
**/*
EOL

if [ "$ESLINT" = "Y" ] || [ "$ESLINT" = "y" ]; then
  rm -rf .eslintignore
  npx install-peerdeps --dev eslint-config-wesbos

  # Add lint config to package.json
  tmp=$(mktemp)
  JQVAR=".eslintConfig |= .+ { \"extends\": [ \"wesbos\" ] }"
  jq "$JQVAR" package.json >"$tmp" && mv "$tmp" package.json

fi

cat >.gitignore <<'EOL'
node_modules
.env
EOL

# cat >bin/s <<'EOL'
# #!/usr/bin/env bash
# node ./src/index.js
# EOL

# chmod +x bin/s

######## Initialize git.
rm -rf .git #  remove the previous git files.
git init
git add .
git commit -m "Initial commit"

# rm -rf node_modules.nosync
# rm -rf yarn.lock
# doing 'removing existing node_modules folder'; rm -rf node_modules
# doing 'removing existing node_modules folder'; rm -rf 'node_modules 2'
# doing 'creating node_modules.nosync'; mkdir node_modules.nosync
# doing 'creating symlink '; ln -s node_modules.nosync/ node_modules
doing 'running yarn'
yarn

code -r .
