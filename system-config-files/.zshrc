export ZSH="/Users/dazza/.oh-my-zsh"

###### Check if oh-my-zsh is installed and warn if it is not. 
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

###### style the prompt.
NEWLINE=$'\n'
PROMPT="%{$fg[yellow]%}%~%{$reset_color%}$NEWLINE$ "


source "$SYSCD/scripts/utils/colours.sh"

# ##### Fucitons to style shell output
# success () {
#   echo -e "$fg[green]Success ====>fg[cyan] $1 $reset_color"
# }

# warn () {
#  echo -e "$fg[yellow]Warning ====>fg[cyan] $1 $reset_color"
# }

# error () {  
#  echo -e "$fg[red]====> ====>fg[cyan] $1 $reset_color"
# }
# note () {
#    echo -e "====>$1 $reset_color "
#  }





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

twps () {
    success 'making new parcel/tailwind skeleton project'; 
    . $HOME/.system-config/scripts/tailwind-parcel-web-skeleton.sh $1;
}

alias tws="twps"

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




# Hide and show invisibles
alias sf="success 'Showing invisible files in finder'; defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app"
alias hf="success 'Hiding invisible files in the finder'; defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app"


## my apps
alias wrap="success 'Opening Wrap Scraper'; cd $HOME/Desktop/dev/wrap-scraper; ./bin/start"
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















# =========================================================

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
# export ZSH="/Users/dazza/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="avit"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
# plugins=(git)

# source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
