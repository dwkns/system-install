 #!/bin/bash
 # Just a little testing ground for things.


#  echo "hello"

# if xcode-select -p; then
#  echo "tools installed";
# else
#  echo "tools not installed";
# fi


# osascript -e 'tell application "Finder" to set desktop picture to POSIX file "/Library/Desktop Pictures/Solid Colors/Solid Aqua Dark Blue.png"'

URL="https://raw.githubusercontent.com/dwkns/system-install/master/system-config-files/com.googlecode.iterm2.plist"

curl $URL > myfile.jpg "$HOME/Library/Preferences/com.googlecode.iterm2.plist"