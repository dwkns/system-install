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
SYSCD="$HOME/.system-config"



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

  doing 'Installing Douglas theme'; 
  VSCODE_EXTENSIONS="$HOME/.vscode/extensions"

  echo ""

  if [ -d "$VSCODE_EXTENSIONS/douglas" ]; then
  echo -e $YELLOW"Warning ========>$RESET 'douglas theme already in '$VSCODE_EXTENSIONS'. Updating... "


   (cd "$VSCODE_EXTENSIONS/douglas"; git pull;);
  else
    echo -e $GREEN"Doing ========>$RESET Cloning 'https://github.com/dwkns/douglas.git' into '$VSCODE_EXTENSIONS' " 
    (cd "$VSCODE_EXTENSIONS"; git clone https://github.com/dwkns/douglas.git;);  
    echo ""
  fi

  echo ""
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
  (cd "$HOME/.vscode/extensions/douglas/";doing 'Backing up Douglas'; git status;  git add -A; git commit -m 'Updated Config Files'; git push --all;);
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
  note "$fg[yellow] nps  :$reset_color executable bash file $reset_color";
  note "$fg[yellow] etw  :$reset_color barebones 11ty/tailwind-jit/esbuild project $reset_color";
  note "$fg[yellow] etwfs  :$reset_color full start 11ty/tailwind-jit/esbuild project $reset_color";
  note "$fg[yellow] etws  :$reset_color f11ty/tailwind/sanity project $reset_color";
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

etw () {
    doing 'making new barebones 11ty/tailwind-jit/esbuild project'; 
    . $HOME/.system-config/scripts/eleventy-tailwind-starter.sh $1;
}

etwfs () {
    doing 'making full start 11ty/tailwind-jit/esbuild project'; 
    . $HOME/.system-config/scripts/eleventy-tailwind-full-start.sh $1;
}
etws () {
    doing 'making eleventy-tailwind-sanity-starter project'; 
    . $HOME/.system-config/scripts/eleventy-tailwind-sanity-starter.sh $1;
}


############### EDIT UNDER2 SITE ################
eu2 () {
  doing 'Edit the Under2 site';
  cd "$HOME/dev/under2.global/";
  code .;
}

emambu () {
  doing 'Edit the Mambu';
  cd "$HOME/dev/mambu/";
  code .;
}




############### EDIT edgecott-house SITE ################
ech () {
  doing 'Edit the Under2 sitey';
  cd "$HOME/Desktop/ech/edgecott-house-netlify/";
  code .;
}

############### EDIT Dougals VS code extension SITE ################
ed () {
  doing 'Edit the Douglas extension';
  cd "$HOME/.vscode/extensions/douglas";
  code .;
}




###############################################################################
#  aliases                                                                    #
###############################################################################

############### General ################
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
export PATH="/opt/homebrew/opt/node@16/bin:$PATH" 

# make sure we use the Homebrew Python
export PATH="/opt/homebrew/opt/python@3.9:$PATH"

# make sure we use the Homebrew rbenv (and Ruby)
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init - zsh)"


# Sometimes we need to skip the npm/yarn version of chromium
# And force using the system one. 
# Install chromium 

# brew install chromium --no-quarantine

# skip the download and use the local one instead. 
export PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
export PUPPETEER_EXECUTABLE_PATH=`which chromium`


