 #!/bin/bash
 # Just a little testing ground for things.


#  echo "hello"

# if xcode-select -p; then
#  echo "tools installed";
# else
#  echo "tools not installed";
# fi


# osascript -e 'tell application "Finder" to set desktop picture to POSIX file "/Library/Desktop Pictures/Solid Colors/Solid Aqua Dark Blue.png"'

rm -rfv "$HOME/Library/Preferences/com.googlecode.iterm2.plist"
rm -rfv "$HOME/Library/Application Support/iTerm"
rm -rfv "$HOME/Library/Application Support/iTerm2"
rm -rfv "$HOME/Library/Caches/com.googlecode.iterm2"
killall cfprefsd
open /Applications/iTerm.app

sleep 5

URL="https://raw.githubusercontent.com/dwkns/system-install/master/system-config-files/com.googlecode.iterm2.plist"

curl $URL > "$HOME/Library/Preferences/com.googlecode.iterm2.plist"
killall cfprefsd
open /Applications/iTerm.app