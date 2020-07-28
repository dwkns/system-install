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

##### Defile some variables 
plugins=(bundler)
SROOT="$HOME/Library/Application Support/Sublime Text 3/"
SYSCD="$HOME/.system-config"

DOTFILES=( 
  ".bash_profile"
  ".gemrc"
  ".gitconfig"
  ".gitignore_global"
  ".irbrc"
  ".rspec"
  ".jsbeautifyrc"
  ".eslintrc.yml"
  ".zshrc"
)  

# ##### style the prompt.
NEWLINE=$'\n'
# PROMPT="%{$fg[yellow]%}%~%{$reset_color%}$NEWLINE$ "

autoload -Uz vcs_info
precmd() { vcs_info }

# Format the vcs_info_msg_0_ variable
# zstyle ':vcs_info:git:*' formats 'on branch %b'
# zstyle ':vcs_info:git:*' formats "--[%b]--"
# zstyle ':vcs_info:git:*' formats "$reset_color on $fg[green]%b"
 
# # Set up the prompt (with git branch name)
# setopt PROMPT_SUBST
# PROMPT="$fg[yellow]${PWD/#$HOME/~}$fg[green]${vcs_info_msg_0_}$reset_color $NEWLINE$ "

# Format the vcs_info_msg_0_ variable
# zstyle ':vcs_info:git:*' formats '%b'

zstyle ':vcs_info:git:*' formats "$reset_color on $fg[green]%b"
 
# Set up the prompt (with git branch name)
setopt PROMPT_SUBST
PROMPT='%{$fg[yellow]%}${PWD/#$HOME/~}${vcs_info_msg_0_}%{$reset_color%}$NEWLINE$ '




source "$SYSCD/scripts/utils/colours.sh"


##### functions to backup and update dotfiles & sublime-config
usys () {
  doing 'updating system config files.'; 
  cd "$HOME/.system-config";
  git pull;
  source "$HOME/.system-config/scripts/dotfiles.sh";
  source "$HOME/.system-config/scripts/sublime-config.sh";
  source "$HOME/.system-config/scripts/vscode-config.sh";
  source "$HOME/.system-config/scripts/system-settings.sh";
  source "$HOME/.zshrc";
}

backUpSublimeConfig () {
  doing 'Backing up Sublime config'; 
  # (command) runs this command without chaning directory 
  (cd "$SROOT/Packages/User/dwkns-sublime-settings/"; git add -A; git commit -m 'Updated Sublime config'; git push --all; );
  echo;
  doing 'Backing up A3 theme'; 
  (cd "$SROOT/Packages/A3-Theme/"; git add -A; git commit -m 'Updated Theme'; git push --all; );
  echo;

  doing 'Backing up VSCode theme'; 
  (cd "$HOME/.vscode/extensions/dwkns-vs"; git add -A; git commit -m 'Updated Theme'; git push --all; );
  echo;
}


backUpSystemConfig () {
  doing 'Backing up system config files'; 
  # (command) runs this command without chaning directory 
  (cd "$HOME/.system-config/"; git add -A; git commit -m 'Updated Config Files'; git push --all;);
}


bsys () {
  doing 'Copying current dotfile files';
  echo;
  for i in "${DOTFILES[@]}"
  do  
     cp -rf "$HOME/$i" "$SYSCD/system-config-files/$i";
  done
  backUpSublimeConfig;
  backUpSystemConfig;
}


##### functions to create skeleton projects 
projects () {
  note "$fg[yellow] ckps :$reset_color CodeKit project skeleton $reset_color";
  note "$fg[yellow] pps  :$reset_color Parcel project skeleton  $reset_color";
  note "$fg[yellow] rps  :$reset_color Ruby project skeleton $reset_color";
  note "$fg[yellow] nps  :$reset_color node project skeleton $reset_color";
  note "$fg[yellow] mbx  :$reset_color executable bash file $reset_color";
  note "$fg[yellow] ptw  :$reset_color making new parcel/tailwind project $reset_color";
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

##### Common commands
alias ls="ls -l"            # because the normal way is dumb                                                             
alias cd..="cd .."          # because I always miss the space. 
alias h="doing 'changing to Home'; cd ~/"
alias dt="doing 'changing to Desktop'; cd ~/Desktop"    

alias kd="doing 'Killing the Dock'; killall Dock"                                
alias kf="doing 'Killing the Finder'; killall Finder"                            
                                                     
alias s="doing 'opening current folder in Sublime'; subl ."                      
alias a="doing 'opening current folder in Atom'; atom ."  
 
alias cmds="doing 'listing project skeletons'; projects;"

alias rp="doing 'Reloading .zshrc'; source ~/.zshrc" 

alias ep="doing 'Editing zsh profile'; subl ~/.zshrc"  
  

############### Editing config files ################
alias esys="doing 'Editing system files'; cd $HOME/.system-config; subl .;"         
alias elint="doing 'Editing .eslintrc.yaml'; subl ~/..eslintrc.yaml"
alias ebfy="doing 'Editing .jsbeautifyrc'; subl ~/.jsbeautifyrc"

alias cdsys="doing 'Changing to dotfiles directory'; cd $HOME/.system-config;" 
alias cdsub="doing 'Changing to sublime directory'; cd '$SROOT/Packages/User';" 
alias esysgh="doing 'Opening system install respoitory on Github'; open -a Safari 'https://github.com/dwkns/system-install'" 



############### Editing sublime files ################
esub () {     # Edit the sublime config files
  doing 'Opening the Sublime config files folder'
  cd "$SROOT/Packages/User";
  subl .;
}
subu () {     # Open sublime config files
  doing 'Opening the Sublime config files folder'
  cd "$SROOT/Packages/User";
  subl .;
}
bsub () {      # Backup Sublime config files                           
  backUpSublimeConfig;
}

esubt () {
  doing 'Editing Sublime A3-Theme';
  cd "$SROOT/Packages/A3-Theme";
  subl .;
}

ecode () {     # Edit the sublime config files
  doing 'Opening the VSCode extensions folder'
  cd "$HOME/.vscode/extensions";
  code .;
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

export EDITOR='subl -w'
export HOMEBREW_CASK_OPTS="--appdir=/Applications"  
export PATH=$PATH:~/bin
export PATH="$HOME/.rbenv/bin:$PATH"


eval "$(rbenv init -)"
cd ~/Desktop