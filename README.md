# System Install
Highly opinionated config files for Sublime Text 3 and my OS ZSH terminal.
As with all bash scripts **read it** before you run it. And if you don't understand it. **DON'T RUN IT**.


### Install homebrew

````bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
````

### Install Oh My Zsh
```` 
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```` 


### Install useful brew apps
Some of these apps are used in the install script so we install them first.
Definately need these:
````bash
brew install iterm2 openssl git mas rbenv gh jq jo node netlify-cli coreutils
````

### Install system config & dot files

````bash
bash <(curl -s https://raw.githubusercontent.com/dwkns/system-install/master/install.sh)
````



### Install apps  
Definately 
````bash
brew  install --cask sublime-text dropbox typora iina google-chrome firefox@developer-edition firefox notion visual-studio-code 1Password slack soulver figma sketch postman font-fira-code omnigraffle soulver cursor discord zoom whatsapp handbrake transmission charles  microsoft-office loom nordvpn
````
````bash
brew install chromium --no-quarantine
````

<!-- Loom? -->
<!-- sizzy google-drive-file-stream omnigraffle -->

### Initialise rbenv and install a Ruby version
List all available versions and choose the one you want to install.

````bash
$ rbenv init          // Initialise rbenv 
$ rbenv install -l    // List the ruby version available. 
$ rbenv install 3.4.8 && rbenv global  3.4.8 // Or Whatever ruby version you want
````
So shortcutting...
````bash
$ rbenv init && rbenv install 3.4.8 && rbenv global  3.4.8
````

### Initialise pyenv and install a Python version
Shortcutting...
````bash
$ pyenv init && pyenv install 3.7.3 && pyenv global  3.7.3
````

pyenv install 3.7.3

### Install some Ruby Gems

````bash
$ gem install bundler rails  
````


### Install App Store Apps
```bash
$ source ~/.system-config/scripts/app-store-apps.sh
```

### Things you'll have to download
[Elgato Control](https://www.elgato.com/en/gaming/downloads)

[Snap Scan](http://scansnap.fujitsu.com/global/dl/mac-1100-s1300i.html)


Parallels

### Syncing problems with iCloud
https://apple.stackexchange.com/questions/349082/icloud-sync-activity-log


### Probably need these
```` 
$ brew install  python heroku postgresql redis  
````



