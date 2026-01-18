#!/usr/bin/env zsh
set -euo pipefail

. "$HOME/.system-config/scripts/set-up-projects.sh" "$1"

success "Project $PROJECTNAME will be created!"

######## Create the folder
mkdir -p "$PROJECTNAME"
cd "$PROJECTNAME"

if [[ ${PROJECTNAME: -3} != ".sh" ]]; then
  FILENAME="$PROJECTNAME.sh"
fi

cat >"$FILENAME" <<'EOL'
  #!/usr/bin/env bash
EOL
chmod +x "$FILENAME"
echo -e ${GREEN}"====> "$BLUE"'$FILENAME'"${GREEN}" Created and set to be Executable"$RESET

cat >.gitignore <<'EOL'
.DS_Store
EOL

######## Initialize git.
rm -rf .git # remove previous git files.
git init
git add .
git commit -m "Initial commit"

code -r .
