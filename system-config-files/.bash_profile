source ~/.profile
export TERM=xterm-256color
############################### Variables ###############################
SROOT="$HOME/Library/Application Support/Sublime Text 3/"
SYSCD="$HOME/.system-config/system-config-files"

############################### Variables ###############################
RED="$(tput setaf 1)"
GREEN="$(tput setaf 2)"
YELLOW="$(tput setaf 3)"
BLUE="$(tput setaf 20)"
BROWN="$(tput setaf 94)"
GREY="$(tput setaf 243)"
RESET="$(tput sgr0)"

PROMPT_RED="\[$(tput setaf 1)\]"
PROMPT_GREEN="\[$(tput setaf 2)\]"
PROMPT_YELLOW="\[$(tput setaf 3)\]"
PROMPT_BLUE="\[$(tput setaf 20)\]"
PROMPT_BROWN="\[$(tput setaf 94)\]"
PROMPT_GREY="\[$(tput setaf 243)\]"
PROMPT_RESET="\[$(tput sgr0)\]"


############################### Functions ###############################
showallcolours () {
  for C in {0..255}; do
      tput setab $C
      echo -n "$C "
  done
  tput sgr0
  echo
}

success () {
  echo -e "$GREEN====> $1 $RESET"
}

warn () {
 echo -e "${YELLOW}====> $1 ${RESET}"
}

error () {  
 echo -e "${RED}====> $1 ${RESET}"
}

note () {
  echo -e "${RESET}====> $1 ${RESET}"
}

nginxrunning () {
ps cax | grep nginx > /dev/null
if [ $? -eq 0 ]; then
  success 'nginx is running' 
else
   warn 'nginx is not running' 
fi
}

############################### Alias' ###############################

############### Random ################
alias wrap="success 'Opening Wrap Scraper'; cd $HOME/Desktop/dev/wrap-scraper; ./bin/start"
alias sketchtool="/Applications/Sketch.app/Contents/Resources/sketchtool/bin/sketchtool"


############### System ################
alias ls="ls -l"                                                               # List files in a list
alias cd..="cd .."                                                             # Because I allways forget the space.
alias kd="success 'Killing the Dock'; killall Dock"                                # reboot Desktop
alias kf="success 'Killing the Finder'; killall Finder"                            # reboot Finder
alias dt="success 'changing to Desktop'; cd ~/Desktop"                                                        # cd to desktop
alias s="success 'opening current folder in Sublime'; subl ."                      # Opens current folder in sublime
alias a="success 'opening current folder in Atom'; atom ."  
alias sp="success 'Reloading .bash_profile'; source ~/.bash_profile"               # Reload Bash Profile

alias hd="cd ~/"               


############### System ################
cws () {
  success 'Creating CodeKit web skeleton project';
  . $HOME/.system-config/scripts/code-kit-web-skeleton.sh $1;
}

pws () {
  success 'Creating Parcel web skeleton project';
  . $HOME/.system-config/scripts/parcel-web-skeleton.sh $1;
}

rps () {
  success 'Creating Ruby skeleton project';
  . $HOME/.system-config/scripts/ruby-project-skeleton.sh $1;
}

nps () {
  success 'making new node project skeleton'; 
  . $HOME/.system-config/scripts/node-project-skeleton.sh $1;
}


mbx () {
  success 'making new executable bash file'; 
  . $HOME/.system-config/scripts/bash-executable-skeleton.sh $1;
}


# Hide and show invisibles
alias sf="success 'Showing invisible files in finder'; defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app"
alias hf="success 'Hiding invisible files in the finder'; defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app"

############### Yarn ################
ya () {
  success 'Doing yarn add --dev';
  yarn add --dev $1;
}

############### Git ################
alias gc="success 'Doing git commit'; git commit"                                   # git commit
alias gca="success 'Doing git commit'; git commit -a"                               # git commit all
alias ga="success 'Doing git add -A'; git add -A"                                   # git add all
alias gs="git status"                                                            # git status
alias gb="success 'Doing git branch'; git branch"                                   # git branch
alias gp="success 'Doing git push -- all'; git push --all"                          # git push all
alias gpa="gp"                                                                   # second alias for git push all
alias gco="success 'Doing git checkout'; git checkout"                              # git checkout
alias gac="success 'Doing git add -all, then git commit'; git add -A; git commit"   # git add all then commit
alias gph="success 'Doing git push heroku master'; git push heroku master"          # git push to heroku.
alias gphm="success 'Doing git push heroku master'; git push heroku master"         # git push to heroku.


############### Editing config files ################
alias sys="success 'Changing to system config'; cd ~/.system-config"                 # cd to system config directory
alias ep="success 'Editing bash profile'; subl ~/.bash_profile"                      # edit bash profile
alias esys="success 'Editing system files'; cd $HOME/.system-config; subl .;"        # Edit system fields
alias esp="warn 'Did you mean to edit system config'; echo 'Use esys'"            # Catch errors
alias esc="esp"   
alias elint="success 'Editing .eslintrc.yaml'; subl ~/..eslintrc.yaml"
alias ebfy="success 'Editing .jsbeautifyrc'; subl ~/.jsbeautifyrc"
alias ebty=ebfy # Catch errors
alias sysd="success 'Changing to dotfiles directory'; cd $HOME/.system-config;" 
alias subd="success 'Changing to sublime directory'; cd '$SROOT/Packages/User';" 
alias opog="success 'Opening system install respoitory on Github'; open -a Safari 'https://github.com/dwkns/system-install'" 

############### Backing up / Restoring config files ################

############### Restore System/Sublime Config ################ 
# Updates latest files from GIT hub then runs install scripts

usys () {
  success 'updating system config files.'; 
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
  success 'Backing up Sublime config'; 
  # (command) runs this command without chaning directory 
  (cd "$SROOT/Packages/User/dwkns-sublime-settings/"; git add -A; git commit -m 'Updated Sublime config'; gpa; );
  echo;
  success 'Backing up A3 theme'; 
  (cd "$SROOT/Packages/A3-Theme/"; git add -A; git commit -m 'Updated Theme'; gpa; );
  echo;
}

backUpSystemConfig () {
  success 'Backing up system config files'; 
  # (command) runs this command without chaning directory 
  (cd "$HOME/.system-config/"; git add -A; git commit -m 'Updated Config Files'; gpa;);
}

DOTFILES=( 
  ".bash_profile"
  ".gemrc"
  ".gitconfig"
  ".gitignore_global"
  ".irbrc"
  ".rspec"
  ".jsbeautifyrc"
  ".eslintrc.yml"
)    

bsys () {
  success 'Backing up system & sublime config';
  success 'Copying current dotfile files';
  echo;
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
  success 'Opening the Sublime config files folder'
  cd "$SROOT/Packages/User";
  subl .;
}
subu () {                                                     # Open sublime config files
  success 'Opening the Sublime config files folder'
  cd "$SROOT/Packages/User";
  subl .;
}
bsub () {                                                     # Backup Sublime config files                           
  backUpSublimeConfig;
}

esubt () {
  success 'Editing Sublime A3-Theme';
  cd "$SROOT/Packages/A3-Theme";
  subl .;
}

############### Pow and Nginx ################
nginxrunning () {
ps cax | grep nginx > /dev/null
if [ $? -eq 0 ]; then
  success 'nginx is running' 
else
   warn 'nginx is not running' 
fi
}

alias po="success 'launching app...'; powder open"
alias pl="success 'linking app to ~/.pow...'; powder link"
alias pr="success 'restarting app'; powder restart"

alias nstart="success 'starting nginx...'; sudo nginx"
alias nstop="success 'stopping nginx...'; sudo nginx -s stop"
alias nreload="success 'reloading nginx config...'; sudo nginx -s reload"
alias nstatus="nginxrunning"
alias nedit="success 'edit nginx config...'; subl '/usr/local/etc/nginx/nginx.conf'"


############### rbenv ################
alias rh="success 'doing rbenv rehash...'; rbenv rehash"


############### Brew ################
alias bu="success 'doing a brew update && brew upgrade'; brew update && brew upgrade"     # update and upgrade brew


############### Rails ################
#Sometimes you don't shutdown your rails server process properly. This will sort it out.
alias kas="success 'Killing all rails server processes'; kill -9 $(lsof -i tcp:3000 -t)"


############### Postgres ################
alias rpg="success 'Restarting postgres connections'; brew services restart postgresql"
alias pg-start="success 'Starting Postgres';launchctl load ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist"
alias pg-stop="success 'Stopping Postgres';launchctl unload ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist"
alias pgstart=pg-start
alias pgstop=pgstop


############################### General ###############################
alias icr="success 'Running iCalReader';dev/iCalReader/bin/s"


parse_git_branch() {                                                        # Find out which GIT branch we're on
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1) /'
}


export PS1="${PROMPT_RED}\u@\h: ${PROMPT_YELLOW}\w\n${PROMPT_GREEN}\$(parse_git_branch)${PROMPT_RESET}$ " 
export PS1="${PROMPT_YELLOW}\w\n${PROMPT_RESET}$ " 


# export PS1="$ "    

              # Set the colour prompt
cd ~/Desktop                                                                # Start new windows on the desktop

# Check to see if a secrets file is present. This is not backed up to GITHUB.
# It's a useful place to store ENV variable used for usernames / passwords.
SECRETS_FILE="$HOME/.secrets.sh"
if [ -f $SECRETS_FILE ];
then
 source $SECRETS_FILE
fi

alias icr="success 'Running iCalReader';dev/iCalReader/bin/s"


chflags hidden ~/Applications                            # keep the local ~/Applicaiton file hidden.

############### Exports ################
export LSCOLORS=ExFxCxDxBxegedabagacad                   # Colours
export CLICOLOR=1                                        # Colours
export TERM=xterm-256color                               # Colours
export EDITOR='subl -w'                                  # Set default editor
export PGDATA=/usr/local/var/postgres                    # Set Postgres path
export HOMEBREW_CASK_OPTS="--appdir=/Applications"       # Default install location for cask apps
export PATH=/usr/local/bin:$PATH                         # Set Path Variable
export PATH=$PATH:~/bin
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
