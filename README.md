# System Install
Highly opinionated config files for Sublime Text 3 and my OS ZSH terminal.
As with all bash scripts **read it** before you run it. And if you don't understand it. **DON'T RUN IT**.


### Install homebrew

````bash
$ /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
````

### Install Oh My Zsh
```` 
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```` 

### Tap alternates 

````bash
$ brew tap homebrew/cask && brew tap homebrew/cask-versions && brew tap homebrew/cask-fonts && brew tap homebrew/services && brew tap heroku/brew
````

### Install useful brew apps
Some of these apps are used in the install script so we install them first.
Definately need these:
````bash
$ brew install iterm2 openssl git node@14 mas rbenv pyenv ruby-build jq svn yarn netlify-cli coreutils
````

### Install system config & dot files

````bash
$ bash <(curl -s https://raw.githubusercontent.com/dwkns/system-install/master/install.sh)
````


### Install useful global node apps
Some of these apps are used in the install script so we install them first.
Definately need these:
```` 
$ npm install -g local-web-server 
````




### Install apps  
Definately 
````bash
$ brew  install --cask sublime-text dropbox typora iina google-chrome firefox-developer-edition firefox notion visual-studio-code 1Password slack soulver figma sketch grammarly postman
````
<!-- Loom? -->
<!-- sizzy google-drive-file-stream omnigraffle -->

### Initialise rbenv and install a Ruby version
List all available versions and choose the one you want to install.

````bash
$ rbenv init          // Initialise rbenv 
$ rbenv install -l    // List the ruby version available. 
$ rbenv install 2.7.2 && rbenv global  2.7.2 // Or Whatever ruby version you want
````
So shortcutting...
````bash
$ rbenv init && rbenv install 2.7.2 && rbenv global  2.7.2 
````

### Initialise pyenv and install a Python version
Shortcutting...
````bash
$ pyenv init && pyenv install 3.7.3 && pyenv global  3.7.3
````

pyenv install 3.7.3

### Install some Ruby Gems

````bash
$ gem install bundler rails htmlbeautifier 
````


### Install App Store Apps
```bash
$ source ~/.system-config/scripts/app-store-apps.sh
```

### Things you'll have to download
[Elgato Control](https://www.elgato.com/en/gaming/downloads)

[Snap Scan](http://scansnap.fujitsu.com/global/dl/mac-1100-s1300i.html)




### Syncing problems with iCloud
https://apple.stackexchange.com/questions/349082/icloud-sync-activity-log


### Probably need these
```` 
$ brew install  python heroku postgresql redis  
````
And these
````bash
$ brew install --cask sketch handbrake transmission charles sequel-pro microsoft-office grammarly postbox loom
````


