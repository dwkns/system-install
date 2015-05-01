#!/bin/sh
echo -e "$PG Sublime"

##################### Configure Sublime ######################

echo -e "$PG configuring sublime"

SUBLIME="$HOME/Library/Application Support/Sublime Text 3"


SUBLIME_LOCAL_DIR="$SUBLIME/local"


SUBLIME_PACKAGES_DIR="$SUBLIME/Packages"


SUBLIME_USER_DIR="$SUBLIME/Packages/User"


SUBLIME_INSTALLED_PACKAGES_DIR="$SUBLIME/Installed Packages"

mkdir -p "$SUBLIME_LOCAL_DIR"
mkdir -p "$SUBLIME_USER_DIR"
mkdir -p "$SUBLIME_INSTALLED_PACKAGES_DIR"

echo -e "$PG  installing Package Control"
wget "http://sublime.wbond.net/Package Control.sublime-package" -O "$SUBLIME_INSTALLED_PACKAGES_DIR/Package Control.sublime-package"



# echo -e "$PG  installing pin_console.py"
# wget "$BASE_URL/sublime-config-files/pin_console.py" -O "$SUBLIME_PACKAGES_DIR/pin_console.py"


echo -e "$PG  intalling license"
wget "$BASE_URL/sublime-config-files/License.sublime_license" -O "$SUBLIME_LOCAL_DIR/License.sublime_license"

echo -e "$PG   installing sublime preferences"
wget "$BASE_URL/sublime-config-files/Preferences.sublime-settings" -O "$SUBLIME_USER_DIR/Preferences.sublime-settings"

echo -e "$PG   installing scopehunter preferences"
wget "$BASE_URL/sublime-config-files/scope_hunter.sublime-settings" -O "$SUBLIME_USER_DIR/scope_hunter.sublime-settings"


echo -e "$PG   installing sublime Package Control Settings"
wget "$BASE_URL/sublime-config-files/Package Control.sublime-settings" -O "$SUBLIME_USER_DIR/Package Control.sublime-settings"

git clone "https://github.com/dwkns/sublime-code-snipits.git" "$SUBLIME_USER_DIR/"

echo -e "$PG   installing sublime theme dwkns.tmTheme"
wget "$BASE_URL/sublime-config-files/dwkns.tmTheme" -O "$SUBLIME_USER_DIR/dwkns.tmTheme"


echo -e "$PG   installing sublime keymap"
wget "$BASE_URL/sublime-config-files/Default (OSX).sublime-keymap" -O "$SUBLIME_USER_DIR/Default (OSX).sublime-keymap"

echo -e "$PG   intalling ruby-terminal build system"
git clone "https://github.com/dwkns/ruby-iTerm2.git" "$SUBLIME_PACKAGES_DIR/ruby-iTerm2"
chmod u+x "$SUBLIME_PACKAGES_DIR/ruby-iTerm2/ruby-iterm2.sh"
ln -s "$SUBLIME_PACKAGES_DIR/ruby-iTerm2/ruby-iterm2.sh" "/usr/local/bin"
