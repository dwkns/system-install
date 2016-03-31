COLOR_HOST="\[\033[0;31m\]"
COLOUR_PATH="\[\033[0;33m\]"
COLOR_DEFAULT="\[\033[0;37m\]"

note () {
  echo -e "\033[0;94m====> $1 \033[0m"
}
msg () {
  echo -e "\033[0;32m==============> $1 \033[0m"
}
warn () {
  echo -e "\033[0;31m====> $1 \033[0m"
}



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



alias ls="ls -l"
alias cd..="cd .."
alias gc="msg 'Doing git commit'; git commit"               # git commit
alias ga="msg 'Doing git add -A'; git add -A"               # git add all
alias gs="git status"                                       # git status
alias gb="msg 'Doing git branch'; git branch"               # git branch
alias gp="msg 'Doing git push -- all'; git push --all"      # git push all
alias gpa="gp"                                              # second alias for git push all
alias gco="msg 'Doing git checkout'; git checkout"          # git checkout
alias gac="msg 'Doing git add -all, then git commit'; git add -A; git commit"   # git add all then commit
alias gph="msg 'Doing git push heroku master'; git push heroku master"          # git checkout

alias rsm="cscreen -d 32 -x 2560 -y 1440"
alias kd="msg 'Killing the Dock'; killall Dock"             # reboot desktop

alias ep="msg 'Editing bash profile'; subl ~/.bash_profile" # edit bash profile

alias dt="cd ~/Desktop"                                     # cd to desktop

# alias cdsub="cd $SROOT"                                   # cd to sublime config directory
alias sub="msg ''; cd $SROOT"                               # cd to sublime config directory
alias esub="msg ''; cd $SROOT; subl ."                      # Edit the sublime files
alias subu="msg ''; cd $SD"

alias sys='msg ''; cd ~/.system-config'                     # cd to system config directory

alias esys="msg 'editing system files'; cd $HOME/.system-config; subl .;"       # Edit system fiels
alias esp="warn 'Did you mean to edit system config'; echo 'Use esys'"
alias esc="esp"

alias s="msg 'opening current folder in sublime'; subl ."

alias po="msg 'launching app...'; powder open"
alias pl="msg 'linking app to ~/.pow...'; powder link"
alias pr="msg 'restarting app'; powder restart"

alias nstart="msg 'starting nginx...'; sudo nginx"
alias nstop="msg 'stopping nginx...'; sudo nginx -s stop"
alias nreload="msg 'reloading nginx config...'; sudo nginx -s reload"

# update and upgrade brew
alias bu="msg 'doing a brew update && brew upgrade'; brew update && brew upgrade" 
# alias ls="ls --color=auto"

# Update System Config
# Back up the current config and then downloads the latest files from GIT 
alias usc="warn 'Did you mean to update system files'; echo 'Use usys'"
alias usys="msg 'updating system config files.'; 
cd $HOME/.system-config;
git pull;
source $HOME/.system-config/scripts/dotfiles.sh
source $HOME/.system-config/scripts/sublime-config.sh
source $HOME/.bash_profile
"

# Backup System Config
# Backs up all sublime and system files to GIT
alias bsc="warn 'Did you mean to to back up system files'; echo 'Use bsys'"
alias bsys="msg 'Backing up system files'; 
CURRENT_DIR=`echo pwd`
cp -rf $SD/SublimeLinter.sublime-settings $SUBCD/SublimeLinter.sublime-settings; 
cp -rf $SD/Preferences.sublime-settings $SUBCD/Preferences.sublime-settings; 
cp -rf $SD/'Default (OSX).sublime-keymap' $SUBCD/'Default (OSX).sublime-keymap'; 
cp -rf $SD/'Package Control.sublime-settings' $SUBCD/'Package Control.sublime-settings'; 
cp -rf $HOME/'.bash_profile' $SYSCD/'.bash_profile';
cd $HOME/'.system-config/'; 
ga;
msg 'Doing git commit';
git commit -m 'update to system files'; 
gp;
cd $CURRENT_DIR"


#Sometimes you don't shutdown your rails server process properly. This will sort it out.

alias kas="msg 'Killing all rails server processes'; ps aux|grep 'rails'|grep -v 'grep'|awk '{ print $2 }'|xargs kill -9"
alias sb="msg 'Reloading .bash_profile'; source ~/.bash_profile"
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

alias sf="msg 'Showing invisible files in finder'; defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app"
alias hf="msg 'Hiding invisible files in the finder'; defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app"
export PATH=/usr/local/bin:$PATH

#make the default install location for cask apps /Applications
export HOMEBREW_CASK_OPTS="--appdir=/Applications"

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

export PGDATA=/usr/local/var/postgres
