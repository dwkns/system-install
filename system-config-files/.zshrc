export ZSH="/Users/dazza/.oh-my-zsh"
# ZSH_THEME="avit"
plugins=(bundler)
source $ZSH/oh-my-zsh.sh

SROOT="$HOME/Library/Application Support/Sublime Text 3/"
SYSCD="$HOME/.system-config/system-config-files"

NEWLINE=$'\n'
PROMPT="%{$fg[yellow]%}%~%{$reset_color%}$NEWLINE$ "


source ~/.backup-profile
source ~/.projects-profile

success () {
  echo -e "$fg[green]====> $1 $reset_color"
}

warn () {
 echo -e "$fg[yellow]====> $1 $reset_color"
}

error () {  
 echo -e "$fg[red]====> $1 $reset_color"
}

note () {
  echo -e "$reset_color====> $1 $reset_color"
}

## terminal commands
alias ls="ls -l"            # because the normal way is dumb                                                             
alias cd..="cd .."          # because I always miss the space. 
alias h="success 'changing to Home'; cd ~/"
alias dt="success 'changing to Desktop'; cd ~/Desktop"         
alias kd="success 'Killing the Dock'; killall Dock"                                
alias kf="success 'Killing the Finder'; killall Finder"                            
                                                     
alias s="success 'opening current folder in Sublime'; subl ."                      
alias a="success 'opening current folder in Atom'; atom ."  
alias rp="success 'Reloading .zshrc'; source ~/.zshrc"  


## editing things
alias ep="echo 'Editing zsh profile'; subl ~/.zshrc"     

############### Editing config files ################
alias sys="success 'Changing to system config'; cd ~/.system-config"                 # cd to system config directory
alias ep="success 'Editing bash profile'; subl ~/.bash_profile"                      # edit bash profile
alias esys="success 'Editing system files'; cd $HOME/.system-config; subl .;"        # Edit system fields
alias esp="warn 'Did you mean to edit system config'; echo 'Use esys'"            # Catch errors
alias esc="esp"   
alias elint="success 'Editing .eslintrc.yaml'; subl ~/..eslintrc.yaml"
alias ebfy="success 'Editing .jsbeautifyrc'; subl ~/.jsbeautifyrc"
alias ebty=ebfy # Catch errors
alias sysd="success 'Changing to dotfiles directory'; cd $HOME/.system-config;" 
alias subd="success 'Changing to sublime directory'; cd '$SROOT/Packages/User';" 
alias opog="success 'Opening system install respoitory on Github'; open -a Safari 'https://github.com/dwkns/system-install'" 




############### Git ################
alias gc="success 'Doing git commit'; git commit"                                   # git commit
alias gca="success 'Doing git commit'; git commit -a"                               # git commit all
alias ga="success 'Doing git add -A'; git add -A"                                   # git add all
alias gs="git status"                                                            # git status
alias gb="success 'Doing git branch'; git branch"                                   # git branch
alias gp="success 'Doing git push -- all'; git push --all"                          # git push all
alias gpa="gp"                                                                   # second alias for git push all
alias gco="success 'Doing git checkout'; git checkout"                              # git checkout
alias gac="success 'Doing git add -all, then git commit'; git add -A; git commit"   # git add all then commit
alias gph="success 'Doing git push heroku master'; git push heroku master"          # git push to heroku.
alias gphm="success 'Doing git push heroku master'; git push heroku master"         # git push to heroku.


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
