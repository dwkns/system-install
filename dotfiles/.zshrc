#Timing script.
# start_ms=$(ruby -e 'puts (Time.now.to_f * 1000).to_i')

VS_CODE_VERSION="code"


export ZSH="/Users/dazza/.oh-my-zsh"
ZSH_DISABLE_COMPFIX=true
##### Check if oh-my-zsh is installed and warn if it is not. 
if [ ! -f "$ZSH/oh-my-zsh.sh" ]; then
    echo "$(tput setaf 1)Oh my zsh was not found$(tput sgr0)"
    GONOW="sh -c \"\$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)\""
    echo "$(tput setaf 14)You might want to run : $(tput sgr0)$GONOW"
    echo "$(tput setaf 14)And then : $(tput sgr0)mv -f $HOME/.zshrc.pre-oh-my-zsh $HOME/.zshrc"
    echo "$(tput setaf 14)And then : $(tput sgr0)source $HOME/.zshrc"
else
    source $ZSH/oh-my-zsh.sh
fi

# end_ms=$(ruby -e 'puts (Time.now.to_f * 1000).to_i')
# elapsed_ms=$((end_ms - start_ms))
# echo "$elapsed_ms ms to do ZSH"

PLATFORM="unknown"
arch_name="$(uname -m)"
if [ "${arch_name}" = "x86_64" ]; then
  PLATFORM="x86_64"
elif [ "${arch_name}" = "arm64" ]; then
  PLATFORM="arm64"
fi


###############################################################################
#  Deine variables                                                  #
###############################################################################


plugins=(bundler)
SROOT="$HOME/Library/Application Support/Sublime Text 3/"
SYSCD="$HOME/.system-config"
SYS_FILES_ROOT="$HOME/.system-config"

###############################################################################
#  Import useful scripts                                                      #
###############################################################################

source "$SYS_FILES_ROOT/scripts/colours.sh"
source "$SYS_FILES_ROOT/scripts/dotfiles.sh"

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
#  DOTFILES UPDATE FUCNTIONS                                                         #
###############################################################################

##### functions to backup and update dotfiles & sublime-config
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

  # if [ -d "$VSCODE_EXTENSIONS/njk" ]; then
  # echo -e $YELLOW"Warning ========>$RESET 'njk already in '$VSCODE_EXTENSIONS'. Updating... "


  #  (cd "$VSCODE_EXTENSIONS/njk"; git pull;);
  # else
  #   echo -e $GREEN"Doing ========>$RESET Cloning 'https://github.com/dwkns/vscode-njk-extension.git' into '$VSCODE_EXTENSIONS' " 
  #   (cd "$VSCODE_EXTENSIONS"; git clone https://github.com/dwkns/vscode-njk-extension.git njk;);  
  #   echo ""
  # fi


}

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


##### functions to create skeleton projects 
projects () {
  note "$fg[yellow] rps  :$reset_color Ruby project skeleton $reset_color";
  note "$fg[yellow] nps  :$reset_color node project skeleton $reset_color";
  note "$fg[yellow] mbx  :$reset_color executable bash file $reset_color";
  note "$fg[yellow] etw  :$reset_color barebones 11ty/tailwind-jit/esbuild project $reset_color";
  note "$fg[yellow] etwru  :$reset_color 11ty/tailwind/rollup project $reset_color";
}


rps () {
  doing 'Creating Ruby skeleton project';
  . $HOME/.system-config/scripts/ruby-project-skeleton.sh $1;
}

nps () {
  doing 'making new node project skeleton'; 
  . $HOME/.system-config/scripts/node-project-skeleton.sh $1;
}


mbx () {
  doing 'making new executable bash file'; 
  . $HOME/.system-config/scripts/bash-executable-skeleton.sh $1;
}

etwru () {
    doing 'making new 11ty/tailwind/rollup project'; 
    . $HOME/.system-config/scripts/eleventy-tailwind-ru-starter.sh $1;
}
etw () {
    doing 'making new barebones 11ty/tailwind-jit/esbuild project'; 
    . $HOME/.system-config/scripts/eleventy-tailwind-starter.sh $1;
}

rbic () {
    sudo rm -rfv /Library/Caches/com.apple.iconservices.store;
    sudo find /private/var/folders/ \( -name com.apple.dock.iconcache -or -name com.apple.iconservices \) -exec rm -rfv {} \; ;
    sleep 3;
    sudo touch /Applications/* ;
    killall Dock; 
    killall Finder
}


rebootbird () {
  # ask for sudo upfront
  sudo -v 
  echo "touching ~/Desktop & ~/Documents"
  touch ~/Desktop
  touch ~/Documents
  echo "Killing bird."
  sudo killall bird
  echo "Removing CloudDocs"
  cd ~/Library/Application\ Support
  sudo rm -rf CloudDocs
  echo "Deleting preferences"
  sudo rm -rf "~/Library/Caches/com.apple.cloudd"
  sudo rm -rf "~/Library/Caches/com.apple.bird"

  echo -n "Do you want to reboot right now — y/n (defaults to y in 10 secs) : "
  read -t 10 REBOOTNOW
  REBOOTNOW=${REBOOTNOW:-Y}

  if [  "$REBOOTNOW" = "Y" ] || [  "$REBOOTNOW" = "y" ] ; then
  echo "Immediately rebooting!"
  sudo shutdown -r now
  else
  echo "OK not rebooting & exiting" 
  fi
}

dnode () {
  echo "recursively deleting 'node_modules' and 'node_modules.no_sync'  folders from current directory"
  find . -name 'node_modules' -type d -prune -exec rm -rf '{}' +
  find . -name 'node_modules 2' -type d -prune -exec rm -rf '{}' +
  find . -name 'node_modules.nosync' -type d -prune -exec rm -rf '{}' +
}

viewlog () {
   brctl log -w --shorten
  }

node_sync () {
  rm -rf node_modules.nosync
  rm -rf yarn.lock
  doing 'removing existing node_modules folder'; rm -rf node_modules
  doing 'removing existing node_modules folder'; rm -rf 'node_modules 2'
  doing 'creating node_modules.nosync'; mkdir node_modules.nosync
  doing 'creating symlink '; ln -s node_modules.nosync/ node_modules
  doing 'running yarn'; yarn
}

############### EDIT UNDER2 SITE ################
eu2 () {
  doing 'Edit the Under2 sitey';
  cd "$HOME/Desktop/u2s/";
  code .;
}

############### EDIT UNDER2 SITE ################
ech () {
  doing 'Edit the Under2 sitey';
  cd "$HOME/Desktop/ech/edgecott-house-netlify/";
  code .;
}

# Edit the defaults file
emos () {
  doing 'Editing .macos';
  code ~/.macos
}

############### Yarn ################
ya () {
  doing 'Doing yarn add --dev';
  yarn add --dev $1;
}

############### EDIT UNDER2 SITE ################
ed () {
  doing 'Edit the Douglas extension';
  cd "$HOME/.vscode/extensions/douglas";
  code .;
}




# end_ms=$(ruby -e 'puts (Time.now.to_f * 1000).to_i')
# elapsed_ms=$((end_ms - start_ms))
# echo "$elapsed_ms ms functions"


##### Common commands
alias ns="doing 'stopping node_modules backing up to iCloud to Home'; node_sync"   
alias ls="ls -l"            # because the normal way is dumb                                                             
alias cd..="cd .."          # because I always miss the space. 
alias h="doing 'changing to Home'; cd ~/"
alias dt="doing 'changing to Desktop'; cd ~/Desktop"    
alias dev="doing 'listing dev projects'; cd ~/dev; ls -l"    

alias kd="doing 'Killing the Dock'; killall Dock"                                
alias kf="doing 'Killing the Finder'; killall Finder"                            
                                                     
alias s="doing 'opening current folder in Sublime'; code ."                      
alias code="doing 'opening current folder in VSCode'; code ."    
alias c="code ."                      
alias a="doing 'opening current folder in Atom'; atom ."  
 
alias cmds="doing 'listing project skeletons'; projects;"

alias rp="doing 'Reloading .zshrc'; source ~/.zshrc" 

alias ep="doing 'Editing zsh profile'; code ~/.zshrc"  
alias sd="doing 'changing to .system-config/';cd  ~/.system-config"    

############### Editing config files ################
alias esys="warn 'dotfiles edited in .system-config are overidden when you do a bsys'; doing 'Editing system files'; cd $HOME/.system-config; code .;"         
alias elint="doing 'Editing .eslintrc.yaml'; code ~/..eslintrc.yaml"
alias ebfy="doing 'Editing .jsbeautifyrc'; code ~/.jsbeautifyrc"

alias cdsys="doing 'Changing to dotfiles directory'; cd $HOME/.system-config;" 
alias cdsub="doing 'Changing to sublime directory'; cd '$SROOT/Packages/User';" 
alias esysgh="doing 'Opening system install respoitory on Github'; open -a Safari 'https://github.com/dwkns/system-install'" 




############### Git ################
alias gc="doing 'Doing git commit'; git commit"                                   # git commit
alias gca="doing 'Doing git commit'; git commit -a"                               # git commit all
alias ga="doing 'Doing git add -A'; git add -A"                                   # git add all
alias gs="git status"                                                               # git status
alias gb="doing 'Doing git branch'; git branch"                                   # git branch
alias gp="doing 'Doing git push -- all'; git push --all"                          # git push all
alias gpa="gp"                                                                      # second alias for git push all
alias gco="doing 'Doing git checkout'; git checkout"                              # git checkout
alias gac="doing 'Doing git add -all, then git commit'; git add -A; git commit"   # git add all then commit
alias gph="doing 'Doing git push heroku master'; git push heroku master"          # git push to heroku.
alias gphm="doing 'Doing git push heroku master'; git push heroku master"         # git push to heroku.





# Merge PDF files, preserving hyperlinks
# Usage: `mergepdf input{1,2,3}.pdf`
alias mergepdf='gs -q -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile=_merged.pdf'



# Hide and show invisibles
alias hide="doing 'Showing invisible files in finder'; defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app"
alias show="doing 'Hiding invisible files in the finder'; defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app"



## my apps
alias wrap="doing 'Opening Wrap Scraper'; cd $HOME/Dropbox/dev/wrap-scraper; ./bin/s"
alias icr="doing 'Running iCalReader';dev/iCalReader/bin/s"

############### rbenv ################
alias rh="doing 'doing rbenv rehash...'; rbenv rehash"


############### Brew ################
alias bu="doing 'doing a brew update && brew upgrade'; brew update && brew upgrade"     # update and upgrade brew



# end_ms=$(ruby -e 'puts (Time.now.to_f * 1000).to_i')
# elapsed_ms=$((end_ms - start_ms))
# echo "$elapsed_ms ms alias"





# set system wide editor
export EDITOR='code -w'

# brew installs casks in /Applicaitons
export HOMEBREW_CASK_OPTS="--appdir=/Applications"  

# # Install Rubies with existing SSL — don't need to rebuild each time.
export RUBY_CONFIGURE_OPTS="--with-openssl-dir=/opt/homebrew/opt/openssl@1.1" # might not even need this. 
# export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@1.1)" # this is slow to run. 


# end_ms=$(ruby -e 'puts (Time.now.to_f * 1000).to_i')
# elapsed_ms=$((end_ms - start_ms))
# echo "$elapsed_ms ms exports"




### test to see what opened the shell
### We don't want to cd to Desktop if Visual Studio opens the Shell
ARSE=`ps -o comm= -p $PPID`
if [[ $ARSE != *"Visual Studio Code - Insiders.app"*  ]]; then
 if [[ $ARSE != *"Visual Studio Code.app"*  ]]; then
    #echo "It's not there!"
    cd ~/Desktop
  fi
fi
# osascript -e "set volume input volume 40"

export PATH=/opt/homebrew/bin:/usr/local/bin:/Users/dazza/.rbenv/shims:/Users/dazza/.rbenv/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Users/dazza/bin$PATH


if [ "$PLATFORM" = "arm64" ]; then
  export PATH="/opt/homebrew/opt/node@14/bin:$PATH"
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  export PATH="/usr/local/opt/node@14/bin:$PATH"
  # echo "we're on $PLATFORM do your brew thing here"
fi
# export PATH="\$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"



# end_ms=$(ruby -e 'puts (Time.now.to_f * 1000).to_i')
# elapsed_ms=$((end_ms - start_ms))
# echo "$elapsed_ms ms passed"

