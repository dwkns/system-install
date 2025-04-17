###############################################################################
#  Confitgure oh-my-zsh                                                       #
###############################################################################
export ZSH="$HOME/.oh-my-zsh"
plugins=(git)
source $ZSH/oh-my-zsh.sh

###############################################################################
#  Deine variables                                                            #
###############################################################################
SYS_FILES_ROOT="$HOME/.system-config"

###############################################################################
#  Import useful scripts                                                      #
###############################################################################
source "$SYS_FILES_ROOT/scripts/colours.sh"  # imports colours & functions for printing to terminal
source "$SYS_FILES_ROOT/scripts/dotfiles.sh" # backup/restore dotFiles

###############################################################################
#  DOTFILES UPDATE FUCNTIONS                                                  #
#  Backup and update dotfiles & sublime-config                                #
###############################################################################

# update current system files to latest
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
  doing 'Reloading .zshrc profile'; 
  source "$HOME/.zshrc";

  mkdir -p "$HOME/.vscode/"

  
}

# backup current system files
bsys () {
  backupDotFiles
  # backUpSublimeConfig;
  doing 'Backing up system config files'; 
  # (command) runs this command without chaning directory 
  (cd "$HOME/.system-config/"; doing 'Backing up system'; git status; git add -A; git commit -m 'Updated Config Files'; git push --all;);
  echo ""
  doing 'Done Backing up'; 
}

###############################################################################
#  alias fuctions (aliases that do more than a one liner )                    #
###############################################################################

# delete all node folders from current location
dnode () {
  doing "recursively deleting 'node_modules' and 'node_modules.no_sync'  folders from current directory"
  find . -name 'node_modules' -type d -prune -exec rm -rf '{}' +
  find . -name 'node_modules 2' -type d -prune -exec rm -rf '{}' +
  find . -name 'node_modules.nosync' -type d -prune -exec rm -rf '{}' +
}


projects () {
  doing 'Listing current project skeletons:'
  note "$fg[yellow] rps  :$reset_color Ruby project skeleton $reset_color";
  note "$fg[yellow] nps  :$reset_color node project skeleton $reset_color";
  note "$fg[yellow] bps  :$reset_color executable bash file $reset_color";

  note "$fg[yellow] em  :$reset_color 11ty minimal project (11ty-minimal)$reset_color";
  note "$fg[yellow] etwm  :$reset_color 11ty/tailwind minimal project (etw-minimal)$reset_color";
  note "$fg[yellow] etw  :$reset_color 11ty/tailwind basics project (etw-basics)$reset_color";
}

commands () {
  doing 'Common commands:';
  note "Kill process on port:$fg[yellow] kp <port>$reset_color";
  note "List starter projects:$fg[yellow] projects $reset_color";
  echo
  doing 'Common git commands:';
  note "Rename branch:$fg[yellow] git branch -m <old> <new> $reset_color";
  note "Delete Branch:$fg[yellow] git branch -d <old-branch> $reset_color";
  note "Push current branch:$fg[yellow] git push -u origin HEAD —>  $fg[red]gp $reset_color";
  note "Reset branch to remote/origin:"
  echo "$fg[yellow] git checkout <branch>$reset_color"
  echo "$fg[yellow] git reset --hard origin/<branch>$reset_color"
  note "List remotes:$fg[yellow] git remote -v $reset_color";
  note "Show recent branches:$fg[yellow] git branch --sort=-committerdate $reset_color";
  echo
}

kp () { 
  doing "Kill port $1";
  lsof -t -i tcp:$1 | xargs kill -9;
}

rps () {
  doing 'Creating Ruby skeleton project';
  . $HOME/.system-config/scripts/ruby-project-skeleton.sh $1;
}

nps () {
  doing 'making new node project skeleton'; 
  . $HOME/.system-config/scripts/node-project-skeleton.sh $1;
}


bps () {
  doing 'making new executable bash file'; 
  . $HOME/.system-config/scripts/bash-executable-skeleton.sh $1;
}


em () {
   doing 'Making new 11ty minimal project (11ty-minimal)'; 
    REPO_NAME=https://github.com/dwkns/11ty-minimal.git
    PROJECT_NAME=$1
    . $HOME/.system-config/scripts/eleventy-projects.sh $REPO_NAME $PROJECT_NAME;
}

etwm () {
    doing 'Making new 11ty/tailwind minimal project (etw-minimal)'; 
    REPO_NAME=https://github.com/dwkns/etw-minimal.git
    PROJECT_NAME=$1
    . $HOME/.system-config/scripts/eleventy-projects.sh $REPO_NAME $PROJECT_NAME;
}


etw () {
    doing 'Making new 11ty/tailwind basics project (etw-basics)'; 
    REPO_NAME="https://github.com/dwkns/etw-basics.git"
    PROJECT_NAME=$1
    . $HOME/.system-config/scripts/eleventy-projects.sh $REPO_NAME $PROJECT_NAME;
}




###############################################################################
#  aliases                                                                    #
###############################################################################

############### General ################
# alias sr="doing 'Running .bin/dev'; ./bin/dev"  
# alias nd="doing 'Running netlify dev'; netlify dev"  

# alias nd="doing 'Running netlify dev'; netlify dev"  
alias upkg="doing 'Update package.json dependencies'; npx npm-check-updates -u"  
alias lpkg="doing 'List package.json updates'; npx npm-check-updates "  

alias ep="doing 'Editing zsh profile'; code ~/.zshrc"  
alias rp="doing 'Reloading .zshrc'; source ~/.zshrc" 
alias dev="doing 'Listing dev projects'; cd ~/dev; ls -l"
alias kd="doing 'Killing the Dock'; killall Dock"                                
alias kf="doing 'Killing the Finder'; killall Finder"  
alias dt="doing 'Changing to Desktop'; cd ~/Desktop"    
alias dev="doing 'Listing dev projects'; cd ~/dev; ls -l" 
alias cd..="cd .."    # because I always miss the space. 
alias ls="ls -lha"    # because the normal way is dumb   h- human readable sizes. 
alias esys="warn 'dotfiles edited in .system-config are overidden when you do a bsys'; doing 'Editing system files'; cd $HOME/.system-config; code .;"  
alias cdsys="doing 'Changing to dotfiles directory'; cd $HOME/.system-config;" 

alias hide="doing 'Showing invisible files in finder'; defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app"
alias show="doing 'Hiding invisible files in the finder'; defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app"

alias apply-gitignore="doing 'Applying gitignore'; !git ls-files -ci --exclude-standard -z | xargs -0 git rm --cached"

############### Code editors ################
alias code="doing 'Opening current folder in VSCode'; code ." 


############### Brew ################
alias bu="doing 'Doing a brew update && brew upgrade'; brew update && brew upgrade"   

############### Git ################
alias ga="doing 'Running git add -A'; git add -A"                   # git add all
alias gc="doing 'Running git commit'; git commit"                   # git commit
alias gs="git status"                                               # git status
alias gp="doing 'Pushing current branch'; git push -u origin HEAD"  # git push all
 

  

# Get macOS Software Updates, and update installed Ruby gems, Homebrew, npm, and their installed packages
alias update='sudo softwareupdate -i -a; brew update; brew upgrade; brew cleanup; npm install npm -g; npm update -g; sudo gem update --system; sudo gem update; sudo gem cleanup'


# Empty the Trash on all mounted volumes and the main HDD.
# Also, clear Apple’s System Logs to improve shell startup speed.
# Finally, clear download history from quarantine. https://mths.be/bum
alias emptytrash="sudo rm -rfv /Volumes/*/.Trashes; sudo rm -rfv ~/.Trash; sudo rm -rfv /private/var/log/asl/*.asl; sqlite3 ~/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV* 'delete from LSQuarantineEvent'"


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
#  Ensure we only CD to Desktop if it is not VS Code                          #
###############################################################################
# echo "Checking if VS Code opened shell"
# echo `ps -o comm= -p $PPID`
WHAT_OPENED_SHELL=`ps -o comm= -p $PPID`
# echo $WHAT_OPENED_SHELL


if [[ "$WHAT_OPENED_SHELL" == *"Visual Studio Code.app"* ]]; then
  #  echo "Visual Studio Code.app opened the shell"
elif [[ "$WHAT_OPENED_SHELL" == *"Cursor Helper: terminal pty-host"* ]]; then
  #  echo "Cursor Helper: terminal pty-host opened the shell"
else
  #  echo "Normal shell"
   cd ~/Desktop
fi


###############################################################################
#  exports                                                                       #
###############################################################################

############### System wide editor ################ 
export EDITOR='code -w'


############### install casks in /Applicaitons ################ 
export HOMEBREW_CASK_OPTS="--appdir=/Applications"  


############### path ################ 
# add node to path
export PATH="/opt/homebrew/opt/node@20/bin:$PATH"

# make sure we use the Homebrew Python
export PATH="/opt/homebrew/opt/python@3.9:$PATH"

# make sure we use the Homebrew rbenv (and Ruby)
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init - zsh)"


export PATH="/Applications/Sublime Text.app/Contents/SharedSupport/bin:$PATH"