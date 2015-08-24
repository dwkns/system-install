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

alias gc='git commit'
alias ga='git add -A'
alias gs='git status'
alias gb='git branch'
alias gp='git push --all'
alias gco='git checkout'
alias rsm='cscreen -d 32 -x 2560 -y 1440'
alias rd='killall Dock'
alias ep='subl ~/.bash_profile'
alias dt='cd ~/Desktop'

# variables for update commands.
SROOT="$HOME/'Library/Application Support/Sublime Text 3/'"
SD="$HOME/'Library/Application Support/Sublime Text 3/Packages/User'"
SCD="$HOME/'.system-config/sublime-config-files'"
SYSCD="$HOME/'.system-config/system-config-files'"

# update system config
# downloads the latest bash profile from GIT 
alias usc="
cd $HOME/.system-config;
git pull;
cp -rf $HOME/.system-config/system-config-files/bash.bash_profile $HOME/.bash_profile 
"

# BackupSystemConfig
# Backs up all sublime and system files to GIT
alias bsc="
cp -rf $SD/dwkns.tmTheme $SCD/dwkns.tmTheme; 
cp -rf $SD/SublimeLinter.sublime-settings $SCD/SublimeLinter.sublime-settings; 
cp -rf $SD/scope_hunter.sublime-settings $SCD/scope_hunter.sublime-settings; 
cp -rf $SD/Preferences.sublime-settings $SCD/Preferences.sublime-settings; 
cp -rf $SD/'Default (OSX).sublime-keymap' $SCD/'Default (OSX).sublime-keymap'; 
cp -rf $SD/'Package Control.sublime-settings' $SCD/'Package Control.sublime-settings'; 
cp -rf $SROOT/'Packages/HTML-CSS-JS Prettify/.jsbeautifyrc' $SYSCD/'.jsbeautifyrc';
cp -rf $HOME/'.bash_profile' $SYSCD/'bash.bash_profile';
cd $HOME/'.system-config/'; 
ga;
git commit -m 'updated theme'; 
gp"

# EditSystemConfig
alias esc="cd $HOME/.system-config; subl *;"




chflags hidden ~/Applications # keep the local ~/Applicaiton file hidden.

alias sf='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'

alias hf='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'

export PATH=/usr/local/bin:$PATH

#make the default install location for cask apps /Applications
export HOMEBREW_CASK_OPTS="--appdir=/Applications"

#source ~/.profile

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

