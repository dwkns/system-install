############################### Variables ###############################
SROOT="$HOME/'Library/Application Support/Sublime Text 3/'"
SD="$HOME/'Library/Application Support/Sublime Text 3/Packages/User'"
SUBCD="$HOME/'.system-config/sublime-config-files'"
SYSCD="$HOME/'.system-config/system-config-files'"

COLOR_HOST="\[\033[0;31m\]"
COLOUR_PATH="\[\033[0;33m\]"
COLOR_DEFAULT="\[\033[0;37m\]"

############################### Functions ###############################
note () {
  echo -e "\033[0;94m====> $1 \033[0m"
}
msg () {
  echo -e "\033[0;32m==============> $1 \033[0m"
}
warn () {
  echo -e "\033[0;31m====> $1 \033[0m"
}

nginxrunning () {
ps cax | grep nginx > /dev/null
if [ $? -eq 0 ]; then
  msg 'nginx is running' 
else
   warn 'nginx is not running' 
fi
}


############################### Alias' ###############################

############### System ################
alias ls="ls -l"                                                               # List files in a list
alias cd..="cd .."                                                             # Because I allways forget the space.
alias kd="msg 'Killing the Dock'; killall Dock"                                # reboot Desktop
alias kf="msg 'Killing the Finder'; killall Finder"                            # reboot Finder
alias dt="cd ~/Desktop"                                                        # cd to desktop
alias s="msg 'opening current folder in sublime'; subl ."                      # Opens current folder in sublime
alias sb="msg 'Reloading .bash_profile'; source ~/.bash_profile"               # Reload Bash Profile

# Hide and show invisibles
alias sf="msg 'Showing invisible files in finder'; defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app"
alias hf="msg 'Hiding invisible files in the finder'; defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app"


############### Git ################
alias gc="msg 'Doing git commit'; git commit"                                   # git commit
alias ga="msg 'Doing git add -A'; git add -A"                                   # git add all
alias gs="git status"                                                           # git status
alias gb="msg 'Doing git branch'; git branch"                                   # git branch
alias gp="msg 'Doing git push -- all'; git push --all"                          # git push all
alias gpa="gp"                                                                  # second alias for git push all
alias gco="msg 'Doing git checkout'; git checkout"                              # git checkout
alias gac="msg 'Doing git add -all, then git commit'; git add -A; git commit"   # git add all then commit
alias gph="msg 'Doing git push heroku master'; git push heroku master"          # git checkout


############### Editing config files ################

alias sys="msg 'Chaning to system config'; cd ~/.system-config"                 # cd to system config directory
alias ep="msg 'Editing bash profile'; subl ~/.bash_profile"                     # edit bash profile

alias esys="msg 'editing system files'; cd $HOME/.system-config; subl .;"       # Edit system fields
alias esp="warn 'Did you mean to edit system config'; echo 'Use esys'"          # Catch errors
alias esc="esp"   

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
CURRENT_DIR=`pwd`;
msg $CURRENT_DIR
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
echo 'bum'
echo  $CURRENT_DIR; 
cd $CURRENT_DIR"                                                              


############### Editing sublime files ################
alias sub="msg ''; cd $SROOT"                               # cd to sublime config directory
alias subu="msg ''; cd $SD"                                 # cd to sublime user directory
alias esub="msg ''; cd $SROOT; subl ."                      # Edit the sublime files


############### Pow and Nginx ################
alias po="msg 'launching app...'; powder open"
alias pl="msg 'linking app to ~/.pow...'; powder link"
alias pr="msg 'restarting app'; powder restart"

alias nstart="msg 'starting nginx...'; sudo nginx"
alias nstop="msg 'stopping nginx...'; sudo nginx -s stop"
alias nreload="msg 'reloading nginx config...'; sudo nginx -s reload"
alias nstatus="nginxrunning"


############### Brew ################
alias bu="msg 'doing a brew update && brew upgrade'; brew update && brew upgrade"     # update and upgrade brew


############### Rails ################
#Sometimes you don't shutdown your rails server process properly. This will sort it out.
alias kas="msg 'Killing all rails server processes'; ps aux|grep 'rails'|grep -v 'grep'|awk '{ print $2 }'|xargs kill -9"


############################### Settings ###############################
PS1="$COLOR_HOST\u $COLOUR_PATH\w $COLOR_DEFAULT\$"                   # Set the colour prompt
cd ~/Desktop                                                          # Start new windows on the desktop

# Check to see if a secrets file is present. This is not backed up to GITHUB.
# It's a useful place to store ENV variable used for usernames / passwords.
SECRETS_FILE="$HOME/.secrets.sh"
if [ -f $SECRETS_FILE ];
then
 source $SECRETS_FILE
fi

# keep the local ~/Applicaiton file hidden.
chflags hidden ~/Applications 

############### Exports ################
export LSCOLORS=ExFxCxDxBxegedabagacad                                   # Colours
export CLICOLOR=1                                                        # Colours
export TERM=xterm-256color                                               # Colours
export EDITOR='subl -w'                                                  # Set default editor
export PGDATA=/usr/local/var/postgres                                    # Set Postgres path
export HOMEBREW_CASK_OPTS="--appdir=/Applications"                       # Make the default install location for cask apps /Applications
export PATH=/usr/local/bin:$PATH                                         # Set Path Variable


[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"     # Load RVM into a shell session *as a function*


