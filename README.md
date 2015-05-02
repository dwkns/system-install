##System Install
Highly opinionated Bash Script to set up a new OS X machine with Homebrew, Cask, RMV, Rails etc.

As with all bash scripts **read it** before you run it. And if you don't understand it. **DON'T RUN IT**.

If you want to run it then :

    $ curl https://raw.githubusercontent.com/dwkns/system-install/master/install.sh | bash

###Known issues
1. Although we issue a `sudo -v` at the beginning of the script for some reason you get asked for your password again later on. It's not `sudo` timing out and appears to be related to the mixing of commands that need `sudo` and those that don't.
2. SublimeText will appear to be going a bit nuts when you first open it. Don't worry, it's just loading in a `Package Control.sublime-settings` which automatically installs various Packages and a display Theme. Give it a minute or two and it should sort itself out.