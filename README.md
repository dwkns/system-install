##System Install
Highly opinionated config files for Sublime and my Bash Terminal
As with all bash scripts **read it** before you run it. And if you don't understand it. **DON'T RUN IT**.

If you want to run it then :

    $ bash <(curl -s https://raw.githubusercontent.com/dwkns/system-install/master/install.sh)

However you will probably want to use it with the following :

Install homebrew

    $ ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

Install system config & dot files

    $ bash <(curl -s https://raw.githubusercontent.com/dwkns/system-install/master/install.sh)
 
Install git python and node

    $ brew install git python node

Install Cask

    $ brew install caskroom/cask/brew-cask

Tap alternates 
    
    $ brew tap caskroom/versions
    $ brew tap caskroom/fonts

Install apps
    
    $ brew cask install sublime-text3 iterm2-nightly font-source-code-pro things flash handbrake omnigraffle transmission mplayerx charles parallels-desktop slingplayer-desktop

Install RVM and Ruby
    
    $ curl -sSL https://get.rvm.io | bash -s stable --ruby
    $ source $HOME/.rvm/scripts/rvm

Install Bundler
    
    $ gem install bundler rails
