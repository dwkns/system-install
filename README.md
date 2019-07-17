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
$ brew tap caskroom/cask && brew tap caskroom/versions && brew tap caskroom/fonts && brew tap homebrew/services && brew tap heroku/brew
````

### Install useful brew apps
Some of these apps are used in the install script so we install them first.

```` 
$ brew install  openssl git python node heroku postgresql mas rbenv ruby-build 
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
$ brew cask install sketch sublime-text iterm2 font-source-code-pro handbrake transmission charles dropbox typora codekit flash-npapi iina sequel-pro chromedriver
````

Install [Chrome](https://www.google.com/chrome/index.html) directly (the cask version doesn't play well with 1Password).

### Initialise rbenv and install a Ruby version
List all available versions and choose the one you want to install.

````bash
$ rbenv init          // Initialise rbenv 
$ rbenv install -l    // List the ruby version available. 
$ rbenv install 2.4.2 && rbenv global  2.4.2 // Or Whatever ruby version you want. 
````

### Ensure that rbenv is added to .bash_profile
Not req if using the install script

````bash
$ echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile  
$ echo 'eval "$(rbenv init -)"' >> ~/.bash_profile  
````

### Reload the bash profile

```` 
$ ~/.bash_profile 
````

### Install some Ruby Gems

````bash
$ gem install bundler rails powder foreman launchy htmlbeautifier 
````

### Install some Global Node Modules

Required for the Sublime Javascript build system to work.

```bash
$ npm install -g @babel/core @babel/node @babel/cli @babel/preset-env local-web-server rollup eslint eslint-plugin-jest prettier
```

### Install App Store Apps
```bash
$ source ~/.system-config/scripts/app-store-apps.sh
```

### Install Pow

````bash
$ curl get.pow.cx | sh
````

### Printer

[Download Printer Drivers](http://gdlp01.c-wss.com/gds/8/0100007708/04/mcpd-mac-ts8000-18_10_0_0-ea21_3.dmg) for Canon TS8050
