#!/usr/bin/env zsh
. $HOME/.system-config/scripts/set-up-projects.sh $1

# echo -n "Enable ESLint? ( y/n > default - y) : "
# read -t 3 ESLINT
# ESLINT=${ESLINT:-Y}

# echo -n "Enable Jest? ( y/n > default - n) : "
# read -t 3 TESTING
# TESTING=${TESTING:-Y}

# echo -n "Use Typescript? ( y/n > default - n) : "
# read -t 3 TYPESCRIPT
# TYPESCRIPT=${TYPESCRIPT:-N}

success "Project $PROJECTNAME will be created!"

######## Create the folder
mkdir -p $PROJECTNAME
cd "$PROJECTNAME"

# ######## Init the project with auto-defaults, add Parcel.
yarn init -y

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
##Read Me for $PROJECTNAME
EOL

######## Add source folder and files.
mkdir 'src'

cat >src/index.js <<'EOL'
export const sum = (a, b) => a + b;
console.log(`1 + 2 is: ${sum(1, 2)}`);

EOL

cat >src/index.test.js <<'EOL'
import { sum } from './index';

test('adds 1 + 2 to equal 3', () => {
  expect(sum(1, 2)).toBe(3);
});

EOL



# if [ "$TESTING" = "Y" ] || [ "$TESTING" = "y" ]; then
   yarn add jest --dev

  tmp=$(mktemp)
  JQVAR=".scripts |= .+ { \"test\": \"NODE_OPTIONS='--experimental-vm-modules --no-warnings' npx jest --verbose\" }"
  jq "$JQVAR" package.json >"$tmp" && mv "$tmp" package.json

# fi




# if [ "$ESLINT" = "Y" ] || [ "$ESLINT" = "y" ]; then
#   yarn add @babel/core @babel/eslint-parser @babel/preset-react @types/node @typescript-eslint/eslint-plugin @typescript-eslint/parser eslint eslint-config-airbnb eslint-config-airbnb-typescript eslint-config-prettier eslint-config-wesbos eslint-plugin-html eslint-plugin-import eslint-plugin-jsx-a11y eslint-plugin-prettier eslint-plugin-react eslint-plugin-react-hooks prettier typescript --dev

#   # Add lint config to package.json
#   tmp=$(mktemp)
#   JQVAR=".eslintConfig |= .+ { \"extends\": [ \"wesbos\" ] }"
#   jq "$JQVAR" package.json >"$tmp" && mv "$tmp" package.json

# else
#   cat >.eslintignore <<'EOL'
# **/*
# EOL
# fi


cat >.gitignore <<'EOL'
node_modules
.env
EOL

######## Initialize git.
rm -rf .git #  remove the previous git files.
git init
git add .
git commit -m "Initial commit"



code -r .
