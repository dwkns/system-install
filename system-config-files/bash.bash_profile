COLOR_HOST="\[\033[0;31m\]"
COLOUR_PATH="\[\033[0;33m\]"
COLOR_DEFAULT="\[\033[0;37m\]"

# PS1="$COLOR_HOST\u@\h $COLOUR_PATH\w $COLOR_DEFAULT\$"
PS1="$COLOR_HOST\u $COLOUR_PATH\w $COLOR_DEFAULT\$"

export LSCOLORS=ExFxCxDxBxegedabagacad
export CLICOLOR=1

export EDITOR='subl -w'
cd ~/Desktop

alias ls='ls -l'

alias gc='git commit'       # git commit
alias ga='git add -A'       # git add all
alias gs='git status'       # git status
alias gb='git branch'       # git branch
alias gp='git push --all'   # git push all
alias gco='git checkout'    # git checkout

alias gph='git push heroku master'    # git checkout

alias rsm='cscreen -d 32 -x 2560 -y 1440'
alias rd='killall Dock'     # reboot desktop

alias ep='subl ~/.bash_profile'   # edit bash profile
alias dt='cd ~/Desktop'           # cd to desktop
alias sd='cd ~/.system-config'    # cd to system config directory
# update and upgrade brew
alias bu='brew update && brew upgrade' 


# variables for update commands.
SROOT="$HOME/'Library/Application Support/Sublime Text 3/'"
SD="$HOME/'Library/Application Support/Sublime Text 3/Packages/User'"
SUBCD="$HOME/'.system-config/sublime-config-files'"
SYSCD="$HOME/'.system-config/system-config-files'"

# Edit System Config
# Opens all system config files in sublime.
alias esc="cd $HOME/.system-config; subl .;" 

# Update System Config
# Back up the current config and then downloads the latest files from GIT 
alias usc="
cd $HOME/.system-config;
git pull;
source $HOME/.system-config/scripts/dotfiles.sh
source $HOME/.system-config/scripts/sublime-config.sh
source $HOME/.bash_profile
"

# Backup System Config
# Backs up all sublime and system files to GIT
alias bsc="
cp -rf $SD/dwkns.tmTheme $SUBCD/dwkns.tmTheme; 
cp -rf $SD/SublimeLinter.sublime-settings $SUBCD/SublimeLinter.sublime-settings; 
cp -rf $SD/scope_hunter.sublime-settings $SUBCD/scope_hunter.sublime-settings; 
cp -rf $SD/Preferences.sublime-settings $SUBCD/Preferences.sublime-settings; 
cp -rf $SD/'Default (OSX).sublime-keymap' $SUBCD/'Default (OSX).sublime-keymap'; 
cp -rf $SD/'Package Control.sublime-settings' $SUBCD/'Package Control.sublime-settings'; 
cp -rf $SROOT/'Packages/HTML-CSS-JS Prettify/.jsbeautifyrc' $SYSCD/'.jsbeautifyrc';
cp -rf $HOME/'.bash_profile' $SYSCD/'bash.bash_profile';
cd $HOME/'.system-config/'; 
ga;
git commit -m 'updated theme'; 
gp"


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

