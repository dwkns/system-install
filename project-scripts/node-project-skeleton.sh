#!/usr/bin/env zsh
set -euo pipefail
. "$HOME/.system-config/project-scripts/set-up-projects.sh" "$1"

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
mkdir -p "$PROJECTNAME"
cd "$PROJECTNAME"

# ######## Init the project with auto-defaults

if command -v yarn >/dev/null 2>&1; then
  yarn init -y
  yarn add -D vitest
else
  npm init -y
  npm install -D vitest
fi

######## Do some processing of package.json to add build scrips & title.
# change the name property of package.json (need to save temp file first)
if ! command -v jq >/dev/null 2>&1; then
  error "jq is required to edit package.json"
  exit 1
fi

tmp=$(mktemp)
JQVAR=".name = \"$PROJECTNAME\""
jq "$JQVAR" package.json >"$tmp" && mv "$tmp" package.json

# add author  to package.json
tmp=$(mktemp)
JQVAR=".author = \"$USER\""
jq "$JQVAR" package.json >"$tmp" && mv "$tmp" package.json

tmp=$(mktemp)
JQVAR=".main = \"app/index.js\""
jq "$JQVAR" package.json >"$tmp" && mv "$tmp" package.json

tmp=$(mktemp)
JQVAR=".type = \"module\""
jq "$JQVAR" package.json >"$tmp" && mv "$tmp" package.json

# add some build scripts to package.json
tmp=$(mktemp)
JQVAR=".scripts |= .+ { \"start\": \"node app/index.js\" }"
jq "$JQVAR" package.json >"$tmp" && mv "$tmp" package.json


tmp=$(mktemp)
JQVAR=".scripts |= .+ { \"dev\": \"npm run start\" }"
jq "$JQVAR" package.json >"$tmp" && mv "$tmp" package.json


tmp=$(mktemp)
JQVAR=".scripts |= .+ { \"test\": \"vitest run\" }"
jq "$JQVAR" package.json >"$tmp" && mv "$tmp" package.json


cat >README.md <<EOL
## Read Me for $PROJECTNAME
EOL

######## Add source folder and files.
mkdir 'app'

cat >app/index.js <<'EOL'
export const sum = (a, b) => a + b;
console.log(`1 + 2 is: ${sum(1, 2)}`);
EOL

cat >app/index.test.js <<'EOL'
import { expect, test } from 'vitest'
import { sum } from './index.js'

test('adds 1 + 2 to equal 3', () => {
  expect(sum(1, 2)).toBe(3)
})
EOL



cat >.gitignore <<'EOL'
node_modules
.env
EOL

######## Initialize git.
rm -rf .git # remove previous git files.
git init
git add .
git commit -m "Initial commit"



code -r .
