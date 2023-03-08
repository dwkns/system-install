#!/usr/bin/env zsh
. $HOME/.system-config/scripts/set-up-projects.sh $1

success "Project $PROJECTNAME will be created!"

# git clone https://github.com/dwkns/snowpack-tailwind-11ty-barebones.git $PROJECTNAME
git clone https://github.com/dwkns/tiny-start.git $PROJECTNAME

######## Create the folder
cd "$PROJECTNAME"

######## Do some processing of package.json to add build scrips & title.

# change the name property of package.json (need to save temp file first)
tmp=$(mktemp)
JQVAR=".name = \"$PROJECTNAME\""
jq "$JQVAR" package.json >"$tmp" && mv "$tmp" package.json

# add author  to package.json
tmp=$(mktemp)
JQVAR=".author = \"$USER\""
jq "$JQVAR" package.json >"$tmp" && mv "$tmp" package.json


# tmp=$(mktemp)
# JQVAR=".devDependencies = \"$USER\""
# jq "$JQVAR" package.json >"$tmp" && mv "$tmp" package.json



# we make a .gitignore file here because we don't want to commit yarn.lock
# In the tiny-start repo, but we do want it in the new project.
cat >.gitignore <<'EOL'
dist
node_modules
yarn-error.log

.DS_Store
.env

# Local Netlify folder if it exists
.netlify
EOL
# chmod +x bin/s

# create .env file
cp .env-template .env

######## Put the project name into the HTML Title.
sed -i "" -e "s/---project-name---/$PROJECTNAME/g" ./src/index.njk

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
yarn install

# echo $CYAN"Do you want linting? Y/n: "$RESET
#   read LINTING
#   LINTING=${LINTING:-Y}
#   if [  "$LINTING" = "Y" ] || [  "$LINTING" = "y" ] ; then
#    npx install-peerdeps --dev eslint-config-wesbos
#     echo '{"extends": ["wesbos"]}' >>.eslintrc
#     yarn add --dev prettier-plugin-tailwindcss
#   else
#     success "OK not not adding linting" 
#     exit 0
#   fi



code -r .
