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


alias sf='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'

alias hf='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'

export PATH=/usr/local/bin:$PATH

#make the default install location for cask apps /Applications
export HOMEBREW_CASK_OPTS="--appdir=/Applications"

#source ~/.profile
