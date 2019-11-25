#!/usr/bin/env zsh
. $HOME/.system-config/scripts/utils/set-up-projects.sh $1;

success "Project $PROJECTNAME will be created!"

######## Create the folder
mkdir -p $PROJECTNAME
cd "$PROJECTNAME"

git clone https://github.com/dwkns/web-project-skeleton.git .

# create a temp file
tmp=$(mktemp) 

# change the name property of package.json (need to save temp file first)
JQVAR=".name = \"$PROJECTNAME\""
jq "$JQVAR" package.json > "$tmp" && mv "$tmp" package.json

sed -i "" -e "s/{{page-title}}/$PROJECTNAME/g" ./source/index.html

echo;

yarn install;

git init
git add -A
git commit -m 'Initial commit'
git remote rm origin


subl .

osascript <<END > /dev/null 2>&1
tell application "CodeKit"
  add project at path "$PWD"
  delay 1
  build project containing path "$PWD"
end tell
END