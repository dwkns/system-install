 #!/bin/bash
 echo "hello"

if xcode-select -p; then
 echo "tools installed";
else
 echo "tools not installed";
fi