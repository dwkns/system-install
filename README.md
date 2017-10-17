# System Install
Highly opinionated config files for Sublime Text 3 and my OS X Bash terminal.
As with all bash scripts **read it** before you run it. And if you don't understand it. **DON'T RUN IT**.

Here is what you do...

### Install homebrew

```` 
$ ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```` 

### Tap alternates 

````bash
$ brew tap caskroom/cask && brew tap caskroom/versions && brew tap caskroom/fonts && brew tap homebrew/services && brew tap homebrew/php
````

### Install useful brew apps
Some of these apps are used in the install script so we install them first.

```` 
$ brew install  openssl git python node phantomjs heroku postgresql mas rbenv ruby-build 
```` 

### Install system config & dot files

```` 
$ bash <(curl -s https://raw.githubusercontent.com/dwkns/system-install/master/install.sh)
```` 

### Reload the bash profile

```` 
$ ~/.bash_profile 
```` 

### Install apps  

````bash
$ brew cask install sketch sublime-text iterm2 font-source-code-pro handbrake transmission mpv charles dropbox typora codekit flash-npapi steam
````

Install [Sketch](https://www.sketchapp.com), [Chrome](https://www.google.com/chrome/index.html) directly.

### Initialise rbenv and install a Ruby version
List all available versions and choose the one you want to install.

````bash
$ rbenv init          // Initialise rbenv 
$ rbenv install -l    // List the ruby version available. 
$ rbenv install 2.4.2 // Or Whatever ruby version you want. 
$ rbenv global  2.4.2 // Set this to be the global ruby version.
```` 

### Ensure that rbenv is added to .bash_profile

````bash
$ echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile  
$ echo 'eval "$(rbenv init -)"' >> ~/.bash_profile  
```` 

### Install some Ruby Gems Bundler, Rails and Powder

````bash
$ gem install bundler rails powder
```` 
 
### Install Pow

````bash
$ curl get.pow.cx | sh
```` 

### Copy Messages from another machine.

1. Open **Message** on both machines and ensure you're signed out of iCloud. `Messages > Preferences > Accounts > <Your Account> > Sign Out`
2. Quit **Messages** on both machines.
3. Copy `~/Library/Messages` and `~/Library/Containers/com.apple.iChat` from the old machine replacing these folders on the new one. ***Be careful!!! Get them the right way round***
4. Restart your machine.
5. Open **Messages** on the new machine and sign in `Messages > Preferences > Accounts > <Your Account> > Sign In`
