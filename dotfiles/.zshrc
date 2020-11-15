export ZSH="/Users/dazza/.oh-my-zsh"
ZSH_DISABLE_COMPFIX=true
##### Check if oh-my-zsh is installed and warn if it is not. 
if [ ! -f "$ZSH/oh-my-zsh.sh" ]; then
    echo "$(tput setaf 1)Oh my zsh was not found$(tput sgr0)"
    GONOW="sh -c \"\$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)\""
    echo "$(tput setaf 14)You might want to run : $(tput sgr0)$GONOW"
    echo "$(tput setaf 14)And then : $(tput sgr0)mv -f $HOME/.zshrc.pre-oh-my-zsh $HOME/.zshrc"
    echo "$(tput setaf 14)And then : $(tput sgr0)source $HOME/.zshrc"
else
    source $ZSH/oh-my-zsh.sh
fi



###############################################################################
#  Deine variables                                                  #
###############################################################################


plugins=(bundler)
SROOT="$HOME/Library/Application Support/Sublime Text 3/"
SYSCD="$HOME/.system-config"
SYS_FILES_ROOT="$HOME/.system-config"

###############################################################################
#  Import useful scripts                                                      #
###############################################################################

source "$SYS_FILES_ROOT/scripts/colours.sh"
source "$SYS_FILES_ROOT/scripts/dotfiles.sh"

###############################################################################
#  Style the prompt                                                           #
###############################################################################
NEWLINE=$'\n'
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats "$reset_color on $fg[green]%b"
 
# Set up the prompt (with git branch name)
setopt PROMPT_SUBST
PROMPT='%{$fg[yellow]%}${PWD/#$HOME/~}${vcs_info_msg_0_}%{$reset_color%}$NEWLINE$ '



###############################################################################
#  DOTFILES UPDATE FUCNTIONS                                                         #
###############################################################################

##### functions to backup and update dotfiles & sublime-config
usys () {
  doing 'Getting lastest system config files.'; 
  cd "$HOME/.system-config";
  git pull;
  echo;

  source "$HOME/.system-config/scripts/dotfiles.sh"
  installDotFiles
  echo;

  source "$HOME/.macos"
  echo;

  # source "$HOME/.system-config/scripts/sublime-config.sh";
  # source "$HOME/.system-config/scripts/system-settings.sh";

   doing 'Reloading .zshrc profile'; 
  source "$HOME/.zshrc";
}

# backUpSublimeConfig () {
#   doing 'Backing up Sublime config'; 
#   # (command) runs this command without chaning directory 
#   (cd "$SROOT/Packages/User/dwkns-sublime-settings/"; git add -A; git commit -m 'Updated Sublime config'; git push --all; );
#   echo;
#   doing 'Backing up A3 theme'; 
#   (cd "$SROOT/Packages/A3-Theme/"; git add -A; git commit -m 'Updated Theme'; git push --all; );
#   echo;

  # doing 'Backing up VSCode theme'; 
  # (cd "$HOME/.vscode/extensions/dwkns-vs"; git add -A; git commit -m 'Updated Theme'; git push --all; );
  # echo;
# }


# backUpSystemConfig () {
  
# }


bsys () {
  backupDotFiles
  # backUpSublimeConfig;
  doing 'Backing up system config files'; 
  # (command) runs this command without chaning directory 
  (cd "$HOME/.system-config/"; git add -A; git commit -m 'Updated Config Files'; git push --all;);
}


##### functions to create skeleton projects 
projects () {
  note "$fg[yellow] ckps :$reset_color CodeKit project skeleton $reset_color";
  note "$fg[yellow] pps  :$reset_color Parcel project skeleton  $reset_color";
  note "$fg[yellow] rps  :$reset_color Ruby project skeleton $reset_color";
  note "$fg[yellow] nps  :$reset_color node project skeleton $reset_color";
  note "$fg[yellow] mbx  :$reset_color executable bash file $reset_color";
  note "$fg[yellow] ptw  :$reset_color making new parcel/tailwind project $reset_color";
  note "$fg[yellow] gtw  :$reset_color making new gatsby/tailwind project $reset_color";
  note "$fg[yellow] etw  :$reset_color making new 11ty/tailwind/snowpack project $reset_color";
}

ckps () {
  doing 'Creating CodeKit web skeleton project';
  . $HOME/.system-config/scripts/code-kit-web-skeleton.sh $1;
}

pps () {
  doing 'Creating Parcel web skeleton project';
  . $HOME/.system-config/scripts/parcel-web-skeleton.sh $1;
}

rps () {
  doing 'Creating Ruby skeleton project';
  . $HOME/.system-config/scripts/ruby-project-skeleton.sh $1;
}

nps () {
  doing 'making new node project skeleton'; 
  . $HOME/.system-config/scripts/node-project-skeleton.sh $1;
}


mbx () {
  doing 'making new executable bash file'; 
  . $HOME/.system-config/scripts/bash-executable-skeleton.sh $1;
}


ptw () {
    doing 'making new parcel/tailwind project'; 
    . $HOME/.system-config/scripts/parcel-tailwind-skeleton.sh $1;
}

gtw () {
    doing 'making new gatsby/tailwind project'; 
    . $HOME/.system-config/scripts/gatsby-tailwind-starter.sh $1;
}

etw () {
    doing 'making new 11ty/tailwind/snowpack project'; 
    . $HOME/.system-config/scripts/eleventy-tailwind-starter.sh $1;
}


rebootbird () {
  # ask for sudo upfront
  sudo -v 

  echo "touching ~/Desktop & ~/Documents"
  touch ~/Desktop
  touch ~/Documents
  echo "Killing bird."
  sudo killall bird
  echo "Removing CloudDocs"
  cd ~/Library/Application\ Support
  sudo rm -rf CloudDocs
  echo "Deleting preferences"
  sudo rm -rf "~/Library/Caches/com.apple.cloudd"
  sudo rm -rf "~/Library/Caches/com.apple.bird"

  echo -n "Do you want to reboot right now — y/n (defaults to y in 10 secs) : "
  read -t 10 REBOOTNOW
  REBOOTNOW=${REBOOTNOW:-Y}

  if [  "$REBOOTNOW" = "Y" ] || [  "$REBOOTNOW" = "y" ] ; then
  echo "Immediately rebooting!"
  sudo shutdown -r now
  else
  echo "OK not rebooting & exiting" 
  fi
}

viewlog () {
   brctl log -w --shorten
  }

node_sync () {
  rm -rf node_modules.nosync
  doing 'removing existing node_modules folder'; rm -rf node_modules
  doing 'creating node_modules.nosync'; mkdir node_modules.nosync
  doing 'creating symlink '; ln -s node_modules.nosync/ node_modules
  doing 'running yarn'; yarn
}

##### Common commands
alias ns="doing 'stopping node_modules backing up to iCloud to Home'; node_sync"   

alias ls="ls -l"            # because the normal way is dumb                                                             
alias cd..="cd .."          # because I always miss the space. 
alias h="doing 'changing to Home'; cd ~/"
alias dt="doing 'changing to Desktop'; cd ~/Desktop"    

alias kd="doing 'Killing the Dock'; killall Dock"                                
alias kf="doing 'Killing the Finder'; killall Finder"                            
                                                     
alias s="doing 'opening current folder in Sublime'; code ."                      
alias c="doing 'opening current folder in VSCode'; code ."                      
alias a="doing 'opening current folder in Atom'; atom ."  
 
alias cmds="doing 'listing project skeletons'; projects;"

alias rp="doing 'Reloading .zshrc'; source ~/.zshrc" 

alias ep="doing 'Editing zsh profile'; code ~/.zshrc"  
alias sd="doing 'changing to .system-config/';cd  ~/.system-config"    

############### Editing config files ################
alias esys="doing 'Editing system files'; cd $HOME/.system-config; code .;"         
alias elint="doing 'Editing .eslintrc.yaml'; code ~/..eslintrc.yaml"
alias ebfy="doing 'Editing .jsbeautifyrc'; code ~/.jsbeautifyrc"

alias cdsys="doing 'Changing to dotfiles directory'; cd $HOME/.system-config;" 
alias cdsub="doing 'Changing to sublime directory'; cd '$SROOT/Packages/User';" 
alias esysgh="doing 'Opening system install respoitory on Github'; open -a Safari 'https://github.com/dwkns/system-install'" 






############### Editing sublime files ################
esub () {     # Edit the sublime config files
  doing 'Opening the Sublime config files folder'
  cd "$SROOT/Packages/User";
  code .;
}
subu () {     # Open sublime config files
  doing 'Opening the Sublime config files folder'
  cd "$SROOT/Packages/User";
  code .;
}
bsub () {      # Backup Sublime config files                           
  backUpSublimeConfig;
}

esubt () {
  doing 'Editing Sublime A3-Theme';
  cd "$SROOT/Packages/A3-Theme";
  code .;
}

ecode () {     # Edit the sublime config files
  doing 'Opening the VSCode extensions folder'
  cd "$HOME/.vscode/extensions";
  code .;
}

emos () {
  doing 'Editing .macos';
  code ~/.macos
}
############### Git ################
alias gc="doing 'Doing git commit'; git commit"                                   # git commit
alias gca="doing 'Doing git commit'; git commit -a"                               # git commit all
alias ga="doing 'Doing git add -A'; git add -A"                                   # git add all
alias gs="git status"                                                               # git status
alias gb="doing 'Doing git branch'; git branch"                                   # git branch
alias gp="doing 'Doing git push -- all'; git push --all"                          # git push all
alias gpa="gp"                                                                      # second alias for git push all
alias gco="doing 'Doing git checkout'; git checkout"                              # git checkout
alias gac="doing 'Doing git add -all, then git commit'; git add -A; git commit"   # git add all then commit
alias gph="doing 'Doing git push heroku master'; git push heroku master"          # git push to heroku.
alias gphm="doing 'Doing git push heroku master'; git push heroku master"         # git push to heroku.


# Merge PDF files, preserving hyperlinks
# Usage: `mergepdf input{1,2,3}.pdf`
alias mergepdf='gs -q -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile=_merged.pdf'



# Hide and show invisibles
alias hide="doing 'Showing invisible files in finder'; defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app"
alias show="doing 'Hiding invisible files in the finder'; defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app"



## my apps
alias wrap="doing 'Opening Wrap Scraper'; cd $HOME/Dropbox/dev/wrap-scraper; ./bin/s"
alias icr="doing 'Running iCalReader';dev/iCalReader/bin/s"

############### rbenv ################
alias rh="doing 'doing rbenv rehash...'; rbenv rehash"


############### Brew ################
alias bu="doing 'doing a brew update && brew upgrade'; brew update && brew upgrade"     # update and upgrade brew


############### Yarn ################
ya () {
  doing 'Doing yarn add --dev';
  yarn add --dev $1;
}

export EDITOR='code -w'
export HOMEBREW_CASK_OPTS="--appdir=/Applications"  
export PATH=$PATH:~/bin
export PATH="$HOME/.rbenv/bin:$PATH"


eval "$(rbenv init -)"

### test to see what opened the shell
### We don't want to cd to Desktop if Visual Studio opens the Shell
ARSE=`ps -o comm= -p $PPID`
if [[ $ARSE != *"Visual Studio Code.app"* ]]; then
  #echo "It's not there!"
  cd ~/Desktop
fi
