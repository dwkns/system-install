###############################################################################
#  Configure oh-my-zsh
###############################################################################
[[ -o interactive ]] || return

export ZSH="$HOME/.oh-my-zsh"
plugins=(git)
source "$ZSH/oh-my-zsh.sh"

###############################################################################
#  Define variables
###############################################################################
SYS_FILES_ROOT="$HOME/.system-config"

###############################################################################
#  Helper functions
###############################################################################
has_cmd() { command -v "$1" >/dev/null 2>&1; }

###############################################################################
#  Import useful scripts
###############################################################################
if [[ -r "$SYS_FILES_ROOT/scripts/colours.sh" ]]; then
  source "$SYS_FILES_ROOT/scripts/colours.sh"
fi
if [[ -r "$SYS_FILES_ROOT/scripts/dotfiles.sh" ]]; then
  source "$SYS_FILES_ROOT/scripts/dotfiles.sh"
fi

###############################################################################
#  Shell behavior
###############################################################################
HISTFILE="$HOME/.zsh_history"
HISTSIZE=20000
SAVEHIST=20000
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt SHARE_HISTORY
setopt EXTENDED_GLOB
setopt PROMPT_SUBST

###############################################################################
#  Dotfiles update functions
###############################################################################
usys () {
  doing 'Getting latest system config files.'
  cd "$HOME/.system-config" || return 1
  has_cmd git && git pull
  echo

  if typeset -f installDotFiles >/dev/null; then
    installDotFiles
  else
    warn "installDotFiles not found"
  fi
  echo

  if [[ -r "$HOME/.macos" ]]; then
    source "$HOME/.macos"
  fi
  echo

  doing 'Reloading .zshrc profile'
  source "$HOME/.zshrc"

  mkdir -p "$HOME/.vscode/"
}

bsys () {
  if typeset -f backupDotFiles >/dev/null; then
    backupDotFiles
  else
    warn "backupDotFiles not found"
  fi

  doing 'Backing up system config files'
  (
    cd "$HOME/.system-config" || exit 1
    doing 'Backing up system'
    git status
    if ! git diff --quiet || ! git diff --cached --quiet; then
      git add -A
      git commit -m 'Updated Config Files'
    else
      note "No changes to commit"
    fi
    git push --all
  )
  echo ""
  doing 'Done Backing up'
}

###############################################################################
#  Alias functions
###############################################################################
dnode () {
  doing "Recursively deleting node_modules folders from current directory"
  find . \( -name 'node_modules' -o -name 'node_modules 2' -o -name 'node_modules.nosync' \) -type d -prune -exec rm -rf '{}' +
}

projects () {
  doing 'Listing current project skeletons:'
  note "$fg[yellow] rps  :$reset_color Ruby project skeleton $reset_color"
  note "$fg[yellow] nps  :$reset_color Node project skeleton $reset_color"
  note "$fg[yellow] bps  :$reset_color Executable bash file $reset_color"
  note "$fg[yellow] em   :$reset_color 11ty minimal project (11ty-minimal)$reset_color"
  note "$fg[yellow] etwm :$reset_color 11ty/tailwind minimal project (etw-minimal)$reset_color"
  note "$fg[yellow] etw  :$reset_color 11ty/tailwind basics project (etw-basics)$reset_color"
}

commands () {
  doing 'Common commands:'
  note "Kill process on port:$fg[yellow] kp <port>$reset_color"
  note "List starter projects:$fg[yellow] projects $reset_color"
  echo
  doing 'Common git commands:'
  note "Rename branch:$fg[yellow] git branch -m <old> <new> $reset_color"
  note "Delete Branch:$fg[yellow] git branch -d <old-branch> $reset_color"
  note "Push current branch:$fg[yellow] git push -u origin HEAD —>  $fg[red]gp $reset_color"
  note "Reset branch to remote/origin:"
  echo "$fg[yellow] git checkout <branch>$reset_color"
  echo "$fg[yellow] git reset --hard origin/<branch>$reset_color"
  note "List remotes:$fg[yellow] git remote -v $reset_color"
  note "Show recent branches:$fg[yellow] git branch --sort=-committerdate $reset_color"
  echo
}

aliases () {
  doing "Listing aliases"
  alias | sort
}

funcs () {
  doing "Listing functions"
  print -l ${(k)functions} | sort
}

paths () {
  doing "Listing PATH entries"
  print -l ${(s/:/)PATH}
}

kp () {
  if [[ -z "$1" ]]; then
    error "Port required: kp <port>"
    return 1
  fi
  doing "Kill port $1"
  local pids
  pids="$(lsof -t -i tcp:"$1")"
  if [[ -n "$pids" ]]; then
    kill -9 $pids
  else
    note "No process found on port $1"
  fi
}

rps () { doing 'Creating Ruby skeleton project'; . "$HOME/.system-config/scripts/ruby-project-skeleton.sh" "$1"; }
nps () { doing 'Making new node project skeleton'; . "$HOME/.system-config/scripts/node-project-skeleton.sh" "$1"; }
bps () { doing 'Making new executable bash file'; . "$HOME/.system-config/scripts/bash-executable-skeleton.sh" "$1"; }

em () {
  doing 'Making new 11ty minimal project (11ty-minimal)'
  REPO_NAME=https://github.com/dwkns/11ty-minimal.git
  PROJECT_NAME=$1
  . "$HOME/.system-config/scripts/eleventy-projects.sh" "$REPO_NAME" "$PROJECT_NAME"
}

etwm () {
  doing 'Making new 11ty/tailwind minimal project (etw-minimal)'
  REPO_NAME=https://github.com/dwkns/etw-minimal.git
  PROJECT_NAME=$1
  . "$HOME/.system-config/scripts/eleventy-projects.sh" "$REPO_NAME" "$PROJECT_NAME"
}

etw () {
  doing 'Making new 11ty/tailwind basics project (etw-basics)'
  REPO_NAME="https://github.com/dwkns/etw-basics.git"
  PROJECT_NAME=$1
  . "$HOME/.system-config/scripts/eleventy-projects.sh" "$REPO_NAME" "$PROJECT_NAME"
}

mkd () { mkdir -p "$1" && cd "$1"; }

extract () {
  if [[ -f "$1" ]]; then
    case "$1" in
      *.tar.bz2) tar xjf "$1" ;;
      *.tar.gz) tar xzf "$1" ;;
      *.bz2) bunzip2 "$1" ;;
      *.rar) unrar x "$1" ;;
      *.gz) gunzip "$1" ;;
      *.tar) tar xf "$1" ;;
      *.tbz2) tar xjf "$1" ;;
      *.tgz) tar xzf "$1" ;;
      *.zip) unzip "$1" ;;
      *.Z) uncompress "$1" ;;
      *.7z) 7z x "$1" ;;
      *) error "Cannot extract '$1'" ;;
    esac
  else
    error "'$1' is not a valid file"
  fi
}

###############################################################################
#  Aliases
###############################################################################
############### General ################
alias upkg="doing 'Update package.json dependencies'; npx npm-check-updates -u"
alias lpkg="doing 'List package.json updates'; npx npm-check-updates"
alias nd="doing 'netlify dev'; netlify dev"
alias ep="doing 'Editing zsh profile'; code ~/.zshrc"
alias rp="doing 'Reloading .zshrc'; source ~/.zshrc"
alias dev="doing 'Listing dev projects'; cd ~/dev; ls -l"
alias kd="doing 'Killing the Dock'; killall Dock"
alias kf="doing 'Killing the Finder'; killall Finder"
alias dt="doing 'Changing to Desktop'; cd ~/Desktop"
alias cd..="cd .."
alias ls="ls -lha"
alias esys="warn 'dotfiles edited in .system-config are overridden when you do a bsys'; doing 'Editing system files'; cd $HOME/.system-config; code .;"
alias cdsys="doing 'Changing to dotfiles directory'; cd $HOME/.system-config;"
alias sys-bootstrap="doing 'Running system bootstrap'; $HOME/.system-config/bin/bootstrap"
alias sys-backup="doing 'Running system backup'; $HOME/.system-config/bin/backup"
alias sys-restore="doing 'Running system restore'; $HOME/.system-config/bin/restore"
alias sys-doctor="doing 'Running system doctor'; $HOME/.system-config/bin/doctor"
alias sys-mas="doing 'Installing App Store apps'; $HOME/.system-config/bin/mas"

alias hide="doing 'Showing invisible files in finder'; defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app"
alias show="doing 'Hiding invisible files in the finder'; defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app"

alias apply-gitignore="doing 'Applying gitignore'; git ls-files -ci --exclude-standard -z | xargs -0 git rm --cached"

############### Code editors ################
alias c.="code ."

############### Brew ################
alias bu="doing 'Doing a brew update && brew upgrade'; brew update && brew upgrade"

############### Git ################
alias ga="doing 'Running git add -A'; git add -A"
alias gc="doing 'Running git commit'; git commit"
alias gs="git status"
alias gl="git log --oneline"
alias gp="doing 'Pushing current branch'; git push -u origin HEAD"

# Get macOS Software Updates, and update installed Ruby gems, Homebrew, npm, and their installed packages
alias update='sudo softwareupdate -i -a; brew update; brew upgrade; brew cleanup; npm install npm -g; npm update -g; sudo gem update --system; sudo gem update; sudo gem cleanup'

# Empty the Trash on all mounted volumes and the main HDD.
# Also, clear Apple’s System Logs to improve shell startup speed.
# Finally, clear download history from quarantine. https://mths.be/bum
alias emptytrash="sudo rm -rfv /Volumes/*/.Trashes; sudo rm -rfv ~/.Trash; sudo rm -rfv /private/var/log/asl/*.asl; sqlite3 ~/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV* 'delete from LSQuarantineEvent'"

###############################################################################
#  Prompt
###############################################################################
NEWLINE=$'\n'
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats "$reset_color on $fg[green]%b"
PROMPT='%{$fg[yellow]%}${PWD/#$HOME/~}${vcs_info_msg_0_}%{$reset_color%}$NEWLINE$ '

###############################################################################
#  Only CD to Desktop in regular interactive shells
###############################################################################
if [[ -z "$SSH_CONNECTION" && "$PWD" == "$HOME" ]]; then
  case "${TERM_PROGRAM:-}" in
    vscode|Cursor) ;;
    *) cd ~/Desktop ;;
  esac
fi

###############################################################################
#  Exports
###############################################################################
############### System wide editor ################
if has_cmd code; then
  export EDITOR='code -w'
else
  export EDITOR='vi'
fi

############### install casks in /Applications ################
export HOMEBREW_CASK_OPTS="--appdir=/Applications"

############### path ################
typeset -U path PATH

if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

if has_cmd rbenv; then
  export PATH="$HOME/.rbenv/bin:$PATH"
  eval "$(rbenv init - zsh)"
fi

export PATH="/Applications/Sublime Text.app/Contents/SharedSupport/bin:$PATH"

###############################################################################
#  Helpers
###############################################################################
n() {
  if [[ -z "$1" ]]; then
    error "Usage: n <npm-script>"
    return 1
  fi
  doing "Running npm script: $1"
  npm run "$1" || {
    echo "Failed to run npm script: $1"
    return 1
  }
}

alias python=python3
alias pip=pip3
