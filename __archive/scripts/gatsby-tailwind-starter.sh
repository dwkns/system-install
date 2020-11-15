#!/usr/bin/env zsh
. $HOME/.system-config/scripts/utils/set-up-projects.sh $1;

success "Project $PROJECTNAME will be created!"

git clone https://github.com/dwkns/dwkns-gatsby-tailwind-starter.git $PROJECTNAME

######## Create the folder
cd "$PROJECTNAME"

######## Do some processing of package.json to add build scrips & title.

# change the name property of package.json (need to save temp file first)
tmp=$(mktemp) 
JQVAR=".name = \"$PROJECTNAME\""
jq "$JQVAR" package.json > "$tmp" && mv "$tmp" package.json


# add author  to package.json
tmp=$(mktemp) 
JQVAR=".author = \"$USER\""
jq "$JQVAR" package.json > "$tmp" && mv "$tmp" package.json




mkdir -p bin
cat >bin/s <<'EOL'
#!/usr/bin/env zsh
yarn develop
EOL
chmod +x bin/s


######## Put the project name into the HTML Title. 
# sed -i "" -e "s/---page-title---/$PROJECTNAME/g" ./src/index.html

# Install any dependencies
yarn

######## Initialize git.
rm -rf .git #  remove the previous git files.
git init
git add .
git commit -m "Initial commit"


######## Open project in Sublime
code .


# ######## Start the server.
gatsby develop 