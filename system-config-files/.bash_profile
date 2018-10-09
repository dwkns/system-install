source ~/.profile
############################### Variables ###############################
SROOT="$HOME/Library/Application Support/Sublime Text 3/"
SYSCD="$HOME/.system-config/system-config-files"

RED="\[\033[0;31m\]"          #red
YELLOW="\[\033[0;33m\]"       #yellow
WHITE="\[\033[0;37m\]"        #white
GREEN="\[\033[32m\]"          #greeen

############################### Functions ###############################
note () {
  echo -e "\033[0;94m====> $1 \033[0m"
}
msg () {
  echo -e "\033[0;32m==============> $1 \033[0m"
}

smsg () {
  echo -e "\033[0;32m======> $1 \033[0m"
}
warn () {
  echo -e "\033[0;31m====> $1 \033[0m"
}

nginxrunning () {
ps cax | grep nginx > /dev/null
if [ $? -eq 0 ]; then
  smsg 'nginx is running' 
else
   warn 'nginx is not running' 
fi
}





############################### Alias' ###############################

############### Random ################
alias wrap="smsg 'Opening Wrap Scraper'; cd $HOME/Desktop/dev/wrap-scraper; ./run.rb"


############### System ################
alias ls="ls -l"                                                               # List files in a list
alias cd..="cd .."                                                             # Because I allways forget the space.
alias kd="smsg 'Killing the Dock'; killall Dock"                                # reboot Desktop
alias kf="smsg 'Killing the Finder'; killall Finder"                            # reboot Finder
alias dt="cd ~/Desktop"                                                        # cd to desktop
alias s="smsg 'opening current folder in Sublime'; subl ."                      # Opens current folder in sublime
alias a="smsg 'opening current folder in Atom'; atom ."  
alias rp="smsg 'Reloading .bash_profile'; source ~/.bash_profile"               # Reload Bash Profile

# Hide and show invisibles
alias sf="smsg 'Showing invisible files in finder'; defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app"
alias hf="smsg 'Hiding invisible files in the finder'; defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app"


############### Git ################
alias gc="smsg 'Doing git commit'; git commit"                                   # git commit
alias gca="smsg 'Doing git commit'; git commit -a"                               # git commit all
alias ga="smsg 'Doing git add -A'; git add -A"                                   # git add all
alias gs="git status"                                                            # git status
alias gb="smsg 'Doing git branch'; git branch"                                   # git branch
alias gp="smsg 'Doing git push -- all'; git push --all"                          # git push all
alias gpa="gp"                                                                   # second alias for git push all
alias gco="smsg 'Doing git checkout'; git checkout"                              # git checkout
alias gac="smsg 'Doing git add -all, then git commit'; git add -A; git commit"   # git add all then commit
alias gph="smsg 'Doing git push heroku master'; git push heroku master"          # git push to heroku.
alias gphm="smsg 'Doing git push heroku master'; git push heroku master"         # git push to heroku.


############### Editing config files ################
alias sys="smsg 'Changing to system config'; cd ~/.system-config"                 # cd to system config directory
alias ep="smsg 'Editing bash profile'; subl ~/.bash_profile"                      # edit bash profile
alias esys="smsg 'Editing system files'; cd $HOME/.system-config; subl .;"        # Edit system fields
alias esp="warn 'Did you mean to edit system config'; echo 'Use esys'"            # Catch errors
alias esc="esp"                                                                   # Catch errors
alias sd="smsg 'Changing to dotfiles directory'; cd $HOME/.system-config;" 
alias opog="smsg 'Opening system install respoitory on Github'; open -a Safari 'https://github.com/dwkns/system-install'" 

############### Backing up / Restoring config files ################

############### Restore System/Sublime Config ################ 
# Updates latest files from GIT hub then runs install scripts

usys () {
  msg 'updating system config files.'; 
  cd "$HOME/.system-config";
  git pull;
  source "$HOME/.system-config/scripts/dotfiles.sh";
  source "$HOME/.system-config/scripts/sublime-config.sh";
  source "$HOME/.system-config/scripts/system-settings.sh";
  source "$HOME/.bash_profile";
}

alias usc="warn 'Did you mean to update system files'; echo 'Use usys'"               # Catch errors


############### Backup System/Sublime Config ################ 
# Backs up all sublime and system files to GIT

backUpSublimeConfig () {
  msg 'Backing up Sublime config'; 
  echo $CURDIR
  # (command) runs this command without chaning directory 
  (cd "$SROOT/Packages/User/dwkns-sublime-settings/"; git add -A; git commit -m 'Updated Sublime config'; gpa; );
}

backUpSystemConfig () {
  smsg 'Backing up system config files'; 
  # (command) runs this command without chaning directory 
  (cd "$HOME/.system-config/"; git add -A; git commit -m 'Updated Config Files'; gpa;);
}

DOTFILES=( 
  ".bash_profile"
  ".gemrc"
  ".gitconfig"
  ".gitignore_global"
  ".irbrc"
  ".jsbeautifyrc"
  ".rspec"
)

bsys () {
  msg 'Backing up system & sublime config';
  smsg 'Copying current dotfile files';
  for i in "${DOTFILES[@]}"
  do  
     cp -rf "$HOME/$i" "$SYSCD/$i";
  done
  backUpSublimeConfig;
  backUpSystemConfig;
}

alias bsc="warn 'Did you mean to to back up system files'; echo 'Use bsys'"        

############### Editing sublime files ################
esub () {                                                     # Edit the sublime config files
  smsg 'Opening the Sublime config files folder'
  cd "$SROOT/Packages/User";
  subl .;
}
subu () {                                                     # Open sublime config files
  smsg 'Opening the Sublime config files folder'
  cd "$SROOT/Packages/User";
  subl .;
}
bsub () {                                                     # Backup Sublime config files                           
  backUpSublimeConfig;
}


############### Pow and Nginx ################
nginxrunning () {
ps cax | grep nginx > /dev/null
if [ $? -eq 0 ]; then
  smsg 'nginx is running' 
else
   warn 'nginx is not running' 
fi
}

alias po="smsg 'launching app...'; powder open"
alias pl="smsg 'linking app to ~/.pow...'; powder link"
alias pr="smsg 'restarting app'; powder restart"

alias nstart="smsg 'starting nginx...'; sudo nginx"
alias nstop="smsg 'stopping nginx...'; sudo nginx -s stop"
alias nreload="smsg 'reloading nginx config...'; sudo nginx -s reload"
alias nstatus="nginxrunning"
alias nedit="smsg 'edit nginx config...'; subl '/usr/local/etc/nginx/nginx.conf'"


############### rbenv ################
alias rh="smsg 'doing rbenv rehash...'; rbenv rehash"


############### Brew ################
alias bu="smsg 'doing a brew update && brew upgrade'; brew update && brew upgrade"     # update and upgrade brew


############### Rails ################
#Sometimes you don't shutdown your rails server process properly. This will sort it out.
alias kas="smsg 'Killing all rails server processes'; kill -9 $(lsof -i tcp:3000 -t)"


############### Postgres ################
alias rpg="smsg 'Restarting postgres connections'; brew services restart postgresql"
alias pg-start="smsg 'Starting Postgres';launchctl load ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist"
alias pg-stop="smsg 'Stopping Postgres';launchctl unload ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist"
alias pgstart=pg-start
alias pgstop=pgstop


############################### General ###############################
parse_git_branch() {                                                        # Find out which GIT branch we're on
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

PS1="$RED\u $YELLOW\w$GREEN\$(parse_git_branch) $WHITE\$"                   # Set the colour prompt
cd ~/Desktop                                                                # Start new windows on the desktop

# Check to see if a secrets file is present. This is not backed up to GITHUB.
# It's a useful place to store ENV variable used for usernames / passwords.
SECRETS_FILE="$HOME/.secrets.sh"
if [ -f $SECRETS_FILE ];
then
 source $SECRETS_FILE
fi


chflags hidden ~/Applications                            # keep the local ~/Applicaiton file hidden.

############### Exports ################
export LSCOLORS=ExFxCxDxBxegedabagacad                   # Colours
export CLICOLOR=1                                        # Colours
export TERM=xterm-256color                               # Colours
export EDITOR='subl -w'                                  # Set default editor
export PGDATA=/usr/local/var/postgres                    # Set Postgres path
export HOMEBREW_CASK_OPTS="--appdir=/Applications"       # Default install location for cask apps
export PATH=/usr/local/bin:$PATH                         # Set Path Variable


export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"