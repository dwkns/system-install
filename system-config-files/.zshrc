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

##### style the prompt.
NEWLINE=$'\n'
PROMPT="%{$fg[yellow]%}%~%{$reset_color%}$NEWLINE$ "
source "$SYSCD/scripts/utils/colours.sh"


##### functions to backup and update dotfiles & sublime-config
usys () {
  success 'updating system config files.'; 
  cd "$HOME/.system-config";
  git pull;
  source "$HOME/.system-config/scripts/dotfiles.sh";
  source "$HOME/.system-config/scripts/sublime-config.sh";
  source "$HOME/.system-config/scripts/system-settings.sh";
  source "$HOME/.zshrc";
}

backUpSublimeConfig () {
  success 'Backing up Sublime config'; 
  # (command) runs this command without chaning directory 
  (cd "$SROOT/Packages/User/dwkns-sublime-settings/"; git add -A; git commit -m 'Updated Sublime config'; git push --all; );
  echo;
  success 'Backing up A3 theme'; 
  (cd "$SROOT/Packages/A3-Theme/"; git add -A; git commit -m 'Updated Theme'; git push --all; );
  echo;
}


backUpSystemConfig () {
  echo 'Backing up system config files'; 
  # (command) runs this command without chaning directory 
  (cd "$HOME/.system-config/"; git add -A; git commit -m 'Updated Config Files'; git push --all;);
}


bsys () {
  success 'Backing up system & sublime config';
  success 'Copying current dotfile files';
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
}

ckps () {
  success 'Creating CodeKit web skeleton project';
  . $HOME/.system-config/scripts/code-kit-web-skeleton.sh $1;
}

pps () {
  success 'Creating Parcel web skeleton project';
  . $HOME/.system-config/scripts/parcel-web-skeleton.sh $1;
}

rps () {
  success 'Creating Ruby skeleton project';
  . $HOME/.system-config/scripts/ruby-project-skeleton.sh $1;
}

nps () {
  success 'making new node project skeleton'; 
  . $HOME/.system-config/scripts/node-project-skeleton.sh $1;
}


mbx () {
  success 'making new executable bash file'; 
  . $HOME/.system-config/scripts/bash-executable-skeleton.sh $1;
}


ptw () {
    success 'making new parcel/tailwind project'; 
    . $HOME/.system-config/scripts/parcel-tailwind-skeleton.sh $1;
}

##### Common commands
alias ls="ls -l"            # because the normal way is dumb                                                             
alias cd..="cd .."          # because I always miss the space. 
alias h="success 'changing to Home'; cd ~/"
alias dt="success 'changing to Desktop'; cd ~/Desktop"    

alias kd="success 'Killing the Dock'; killall Dock"                                
alias kf="success 'Killing the Finder'; killall Finder"                            
                                                     
alias s="success 'opening current folder in Sublime'; subl ."                      
alias a="success 'opening current folder in Atom'; atom ."  
 
alias cmds="success 'listing project skeletons'; projects;"

alias rp="success 'Reloading .zshrc'; source ~/.zshrc" 

alias ep="success 'Editing zsh profile'; subl ~/.zshrc"  
  

############### Editing config files ################
alias esys="success 'Editing system files'; cd $HOME/.system-config; subl .;"         
alias elint="success 'Editing .eslintrc.yaml'; subl ~/..eslintrc.yaml"
alias ebfy="success 'Editing .jsbeautifyrc'; subl ~/.jsbeautifyrc"

alias cdsys="success 'Changing to dotfiles directory'; cd $HOME/.system-config;" 
alias cdsub="success 'Changing to sublime directory'; cd '$SROOT/Packages/User';" 
alias esysgh="success 'Opening system install respoitory on Github'; open -a Safari 'https://github.com/dwkns/system-install'" 



############### Editing sublime files ################
esub () {     # Edit the sublime config files
  success 'Opening the Sublime config files folder'
  cd "$SROOT/Packages/User";
  subl .;
}
subu () {     # Open sublime config files
  success 'Opening the Sublime config files folder'
  cd "$SROOT/Packages/User";
  subl .;
}
bsub () {      # Backup Sublime config files                           
  backUpSublimeConfig;
}

esubt () {
  success 'Editing Sublime A3-Theme';
  cd "$SROOT/Packages/A3-Theme";
  subl .;
}

############### Git ################
alias gc="success 'Doing git commit'; git commit"                                   # git commit
alias gca="success 'Doing git commit'; git commit -a"                               # git commit all
alias ga="success 'Doing git add -A'; git add -A"                                   # git add all
alias gs="git status"                                                               # git status
alias gb="success 'Doing git branch'; git branch"                                   # git branch
alias gp="success 'Doing git push -- all'; git push --all"                          # git push all
alias gpa="gp"                                                                      # second alias for git push all
alias gco="success 'Doing git checkout'; git checkout"                              # git checkout
alias gac="success 'Doing git add -all, then git commit'; git add -A; git commit"   # git add all then commit
alias gph="success 'Doing git push heroku master'; git push heroku master"          # git push to heroku.
alias gphm="success 'Doing git push heroku master'; git push heroku master"         # git push to heroku.


# Merge PDF files, preserving hyperlinks
# Usage: `mergepdf input{1,2,3}.pdf`
alias mergepdf='gs -q -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile=_merged.pdf'



# Hide and show invisibles
alias hide="success 'Showing invisible files in finder'; defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app"
alias show="success 'Hiding invisible files in the finder'; defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app"



## my apps
alias wrap="success 'Opening Wrap Scraper'; cd $HOME/Dropbox/dev/wrap-scraper; ./bin/s"
alias icr="success 'Running iCalReader';dev/iCalReader/bin/s"

############### rbenv ################
alias rh="success 'doing rbenv rehash...'; rbenv rehash"


############### Brew ################
alias bu="success 'doing a brew update && brew upgrade'; brew update && brew upgrade"     # update and upgrade brew


############### Yarn ################
ya () {
  success 'Doing yarn add --dev';
  yarn add --dev $1;
}

export EDITOR='subl -w'
export HOMEBREW_CASK_OPTS="--appdir=/Applications"  
export PATH=$PATH:~/bin
export PATH="$HOME/.rbenv/bin:$PATH"


eval "$(rbenv init -)"
cd ~/Desktop  