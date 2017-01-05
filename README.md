##System Install
Highly opinionated config files for Sublime Text 3 and my OS X Bash terminal.
As with all bash scripts **read it** before you run it. And if you don't understand it. **DON'T RUN IT**.

If you want to run it then :

    $ bash <(curl -s https://raw.githubusercontent.com/dwkns/system-install/master/install.sh)

However you will probably want to use it with the following :

####Install homebrew

    $ ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

####Install system config & dot files

    $ bash <(curl -s https://raw.githubusercontent.com/dwkns/system-install/master/install.sh)
 
####Reload the bash profile

    $ ~/.bash_profile 

####Install cask git python and node etc.

    $ brew install caskroom/cask/brew-cask openssl git python node phantomjs heroku postgresql 

####Tap alternates 
    
    $ brew tap caskroom/versions
    $ brew tap caskroom/fonts
    $ brew tap homebrew/services

####Install apps
    
````
$ brew cask install sublime-text iterm2-nightly font-source-code-pro things flash handbrake omnigraffle transmission mplayerx charles parallels-desktop slingplayer-desktop dropbox macdown codekit
````

Install `Chrome`, `1Password`, `Dash 2`, `Transmit`, `Sketch`, `Affinity Designer` from the App Store

####Install rbenv
    
    $ brew install rbenv ruby-build 
    $ rbenv init
    
####Install Ruby

    $ rbenv install 2.2.4 // Or Whatever ruby version you want. 
    $ rbenv global  2.2.4 // Set this to be the global ruby version.

####Install Bundler
    
    $ gem install bundler rails powder

####Install Pow

    $ curl get.pow.cx | sh

####Copy Messages from another machine.

1. Open **Message** on both machines and ensure you're signed out of iCloud. `Messages > Preferences > Accounts > <Your Account> > Sign Out`
2. Quit **Messages** on both machines.
3. Copy `~/Library/Messages` and `~/Library/Containers/com.apple.iChat` from the old machine replacing these folders on the new one. ***Be careful!!! Get them the right way round***
4. Restart your machine.
5. Open **Messages** on the new machine and sign in `Messages > Preferences > Accounts > <Your Account> > Sign In`
