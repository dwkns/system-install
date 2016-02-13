COLOR_HOST="\[\033[0;31m\]"
COLOUR_PATH="\[\033[0;33m\]"
COLOR_DEFAULT="\[\033[0;37m\]"

BLACK=$(tput setaf 0)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
LIME_YELLOW=$(tput setaf 190)
POWDER_BLUE=$(tput setaf 153)
BLUE=$(tput setaf 4)
MAGENTA=$(tput setaf 5)
CYAN=$(tput setaf 6)
WHITE=$(tput setaf 7)


# PS1="$COLOR_HOST\u@\h $COLOUR_PATH\w $COLOR_DEFAULT\$"
PS1="$COLOR_HOST\u $COLOUR_PATH\w $COLOR_DEFAULT\$"

export LSCOLORS=ExFxCxDxBxegedabagacad
export CLICOLOR=1
export TERM=xterm-256color

export EDITOR='subl -w'
cd ~/Desktop


# variables for update commands.
SROOT="$HOME/'Library/Application Support/Sublime Text 3/'"
SD="$HOME/'Library/Application Support/Sublime Text 3/Packages/User'"
SUBCD="$HOME/'.system-config/sublime-config-files'"
SYSCD="$HOME/'.system-config/system-config-files'"



alias ls='ls -l'

alias gc="echo -e $GREEN'Doing git commit'$WHITE; git commit"   # git commit
alias ga="echo -e $GREEN'Doing git add -A'$WHITE; git add -A"       # git add all
# alias gs="git status"       # git status
alias gb="echo -e $GREEN'Doing git branch'$WHITE; git branch"       # git branch
alias gp="echo -e $GREEN'Doing git push -- all'$WHITE; git push --all"   # git push all
alias gpa="echo -e $GREEN'Doing git push -- all'$WHITE; git push --all"   # git push all

alias gco="echo -e $GREEN'Doing git checkout'$WHITE; git checkout"  # git checkout

alias gac="echo -e $GREEN'Doing git add -all, then git commit'$WHITE; git add -A; git commit" # git add all then commit

alias gph="echo -e $GREEN'Doing git push heroku master'$WHITE; git push heroku master"    # git checkout

alias rsm="cscreen -d 32 -x 2560 -y 1440"
alias rd="killall Dock"     # reboot desktop

alias ep="subl ~/.bash_profile"   # edit bash profile
alias dt="cd ~/Desktop"          # cd to desktop

# alias cdsub="cd $SROOT"              # Cd to sublime config directory
alias sub="cd $SROOT"              # Cd to sublime config directory
alias esub="cd $SROOT; subl ."      # Edit the sublime files

# alias cdsys='cd ~/.system-config'    # cd to system config directory
alias sys='cd ~/.system-config'    # cd to system config directory
alias esys="cd $HOME/.system-config; subl .;" # Edit system fiels
alias esp="echo -e $RED'Did you mean '$WHITE'esys'$RED' to edit system config'$WHITE"
alias esc="echo -e $RED'Did you mean '$WHITE'esys'$RED' to edit system config'$WHITE"


# update and upgrade brew
alias bu='brew update && brew upgrade' 

# Update System Config
# Back up the current config and then downloads the latest files from GIT 
alias usc="echo -e $RED'Did you mean '$WHITE'usys'$RED' to update system files'$WHITE"
alias usys="
cd $HOME/.system-config;
git pull;
source $HOME/.system-config/scripts/dotfiles.sh
source $HOME/.system-config/scripts/sublime-config.sh
source $HOME/.bash_profile
"

# Backup System Config
# Backs up all sublime and system files to GIT
alias bsc="echo -e $RED'Did you mean '$WHITE'bsys'$RED' to back up system files'$WHITE"
alias bsys="
cp -rf $SD/SublimeLinter.sublime-settings $SUBCD/SublimeLinter.sublime-settings; 
cp -rf $SD/Preferences.sublime-settings $SUBCD/Preferences.sublime-settings; 
cp -rf $SD/'Default (OSX).sublime-keymap' $SUBCD/'Default (OSX).sublime-keymap'; 
cp -rf $SD/'Package Control.sublime-settings' $SUBCD/'Package Control.sublime-settings'; 
cp -rf $HOME/'.bash_profile' $SYSCD/'.bash_profile';
cd $HOME/'.system-config/'; 
ga;
echo -e $GREEN'Doing git commit'$WHITE;
git commit -m 'updated theme'; 
gp"

#Sometimes you don't shutdown your rails server process properly. This will sort it out.

alias kas="ps aux|grep 'rails'|grep -v 'grep'|awk '{ print $2 }'|xargs kill -9"
alias sb="source ~/.bash_profile"
##
#cp -rf $SD/scope_hunter.sublime-settings $SUBCD/scope_hunter.sublime-settings; 
#cp -rf $HOME/'.jsbeautifyrc' $SYSCD/'bash.jsbeautifyrc';
# cp -rf $SD/BeautifyRuby.sublime-settings $SUBCD/BeautifyRuby.sublime-settings; 

# Check to see if a secrets file is present. This is not backed up to GITHUB.
# It's a useful place to store ENV variable used for usernames / passwords.
SECRETS_FILE="$HOME/.secrets.sh"
if [ -f $SECRETS_FILE ];
then

 source $SECRETS_FILE
fi


chflags hidden ~/Applications # keep the local ~/Applicaiton file hidden.

alias sf='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'

alias hf='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'

export PATH=/usr/local/bin:$PATH

#make the default install location for cask apps /Applications
export HOMEBREW_CASK_OPTS="--appdir=/Applications"

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

export PGDATA=/usr/local/var/postgres
