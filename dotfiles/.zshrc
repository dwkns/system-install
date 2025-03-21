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

  # doing 'Installing Douglas theme'; 
  # VSCODE_EXTENSIONS="$HOME/.vscode/extensions"

  # echo ""

  # if [ -d "$VSCODE_EXTENSIONS/douglas" ]; then
  # echo -e $YELLOW"Warning ========>$RESET 'douglas theme already in '$VSCODE_EXTENSIONS'. Updating... "


  #  (cd "$VSCODE_EXTENSIONS/douglas"; git pull;);
  # else
  #   echo -e $GREEN"Doing ========>$RESET Cloning 'https://github.com/dwkns/douglas.git' into '$VSCODE_EXTENSIONS' " 
  #   (cd "$VSCODE_EXTENSIONS"; git clone https://github.com/dwkns/douglas.git;);  
  #   echo ""
  # fi

  # echo ""
}

# backup current system files
bsys () {
  backupDotFiles
  # backUpSublimeConfig;
  doing 'Backing up system config files'; 
  # (command) runs this command without chaning directory 
  (cd "$HOME/.system-config/"; doing 'Backing up system'; git status; git add -A; git commit -m 'Updated Config Files'; git push --all;);
  # doing "THis slkdfhskdlhfskdjhfdsjkhfkdjs"
  doing 'Backing up VS code extensions'; 
  # (cd "$HOME/.vscode/extensions/douglas"; git status; git add -A; git commit -m 'Updated Config Files'; git push --all;);
  # (cd "$HOME/.vscode/extensions/douglas/";doing 'Backing up Douglas'; git status;  git add -A; git commit -m 'Updated Config Files'; git push --all;);
  # (cd "$HOME/.vscode/extensions/njk/";doing 'Backing up njk'; git status;  git add -A; git commit -m 'Updated Config Files'; git push --all;);
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
alias sr="doing 'Doing .bin/dev'; ./bin/dev"  
alias nd="doing 'Doing netlify dev'; netlify dev"  

alias nd="doing 'Doing netlify dev'; netlify dev"  
alias upkg="doing 'Update package.json dependencies'; npx npm-check-updates -u"  
alias lpkg="doing 'List package.json updates'; npx npm-check-updates "  


alias ep="doing 'Editing zsh profile'; code ~/.zshrc"  
alias rp="doing 'Reloading .zshrc'; source ~/.zshrc" 
alias dev="doing 'listing dev projects'; cd ~/dev; ls -l"
alias kd="doing 'Killing the Dock'; killall Dock"                                
alias kf="doing 'Killing the Finder'; killall Finder"  
alias dt="doing 'changing to Desktop'; cd ~/Desktop"    
alias dev="doing 'listing dev projects'; cd ~/dev; ls -l" 
alias cd..="cd .."    # because I always miss the space. 
alias ls="ls -lha"    # because the normal way is dumb   h- human readable sizes. 
alias esys="warn 'dotfiles edited in .system-config are overidden when you do a bsys'; doing 'Editing system files'; cd $HOME/.system-config; code .;"  
alias cdsys="doing 'Changing to dotfiles directory'; cd $HOME/.system-config;" 

alias hide="doing 'Showing invisible files in finder'; defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app"
alias show="doing 'Hiding invisible files in the finder'; defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app"

alias apply-gitignore="doing 'applying gitignore'; !git ls-files -ci --exclude-standard -z | xargs -0 git rm --cached"

############### Code editors ################
alias code="doing 'opening current folder in VSCode'; code ." 
alias c="code ."  



############### Brew ################
alias bu="doing 'doing a brew update && brew upgrade'; brew update && brew upgrade"   


############### Git ################
alias ga="doing 'Doing git add -A'; git add -A"                                   # git add all
alias gc="doing 'Doing git commit'; git commit"                                   # git commit

alias gs="git status"                                                             # git status
alias gb="doing 'Doing git branch'; git branch"                                   # git branch                     # git push all
alias gp="doing 'Pushing current branch'; git push -u origin HEAD"                         # git push all
alias gco="doing 'Doing git checkout'; git checkout"     

alias vgh="doing 'View repo on Github'; gh repo view --web"     





# Get macOS Software Updates, and update installed Ruby gems, Homebrew, npm, and their installed packages
alias update='sudo softwareupdate -i -a; brew update; brew upgrade; brew cleanup; npm install npm -g; npm update -g; sudo gem update --system; sudo gem update; sudo gem cleanup'


# Empty the Trash on all mounted volumes and the main HDD.
# Also, clear Apple’s System Logs to improve shell startup speed.
# Finally, clear download history from quarantine. https://mths.be/bum
alias emptytrash="sudo rm -rfv /Volumes/*/.Trashes; sudo rm -rfv ~/.Trash; sudo rm -rfv /private/var/log/asl/*.asl; sqlite3 ~/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV* 'delete from LSQuarantineEvent'"





# # Detect which `ls` flavor is in use
# if ls --color > /dev/null 2>&1; then # GNU `ls`
# 	colorflag="--color"
# 	export LS_COLORS='no=00:fi=00:di=01;31:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:'
# else # macOS `ls`
# 	colorflag="-G"
# 	export LSCOLORS='BxBxhxDxfxhxhxhxhxcxcx'
# fi

# # List all files colorized in long format
# alias l="ls -lF ${colorflag}"

# # List all files colorized in long format, excluding . and ..
# alias la="ls -lAF ${colorflag}"

# # List only directories
# alias lsd="ls -lF ${colorflag} | grep --color=never '^d'"

# # Always use color output for `ls`
# alias ls="command ls ${colorflag}"


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
#                                                                             #
#  Ensure we only CD to Desktop if it is not VS Code                          #
###############################################################################

WHAT_OPENED_SHELL==`ps -o comm= -p $PPID`
THIS='Visual Studio Code.app'
if [[ "$WHAT_OPENED_SHELL" != *"$THIS"* ]];
 then
  # echo "VS Code did not open shell. CD to Desktop"
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

# Sometimes we need to skip the npm/yarn version of chromium
# And force using the system one. 
# Install chromium 

# brew install chromium --no-quarantine

# skip the download and use the local one instead. 
export PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
export PUPPETEER_EXECUTABLE_PATH=`which chromium`