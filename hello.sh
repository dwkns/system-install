 #!/bin/bash
 # Just a little testing ground for things.
 echo "hello"

if xcode-select -p; then
 echo "tools installed";
else
 echo "tools not installed";
fi


osascript -e 'tell application "Finder" to set desktop picture to POSIX file "/Library/Desktop Pictures/Solid Colors/Solid Aqua Dark Blue.png"'
