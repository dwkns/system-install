#!/usr/bin/env zsh
. $HOME/.system-config/scripts/set-up-projects.sh $1

success "Project $PROJECTNAME will be created!"

git clone https://github.com/dwkns/eleventy-minimal.git $PROJECTNAME

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


# we make a .gitignore file here because we don't want to commit yarn.lock
# In the tiny-start repo, but we do want it in the new project.
cat >.gitignore <<'EOL'
_site
dist
node_modules
yarn-error.log

.DS_Store
.env

# Local Netlify folder if it exists
.netlify
EOL

######## Initialize git.
rm -rf .git #  remove the previous git files.
git init
git add .
git commit -m "Initial commit"


doing 'running yarn'
yarn install




code -r .
