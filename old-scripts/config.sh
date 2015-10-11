#!/bin/bash
msg "Config has been loaded" 
MACHINE_NAME="dwkns-mbp"
SOFTWARE_UPDATE=true
TM_DEBUG=false

TIME_MACHINE_EXCLUSION_LIST=(
  "/Applications/"
  "/Library/"
  "/System/"
  "/bin/"
  "/cores/"
  "/opt/"
  "/private/"
  "/sbin/"  "/.vol"
  "/.fseventsd"
  "$HOME/Downloads/"
  "$HOME/Library/Caches/"
  "$HOME/Documents/Torrents/"
  "$HOME/Documents/Parallels/"
  "$HOME/Dropbox/"
  "$HOME/Library/Application Support/Google/"
)

BREW_PACKAGES=(
  "wget"
  "git"
  "python"
  "dockutil"
  "postgresql"
  "node"
) 

NODE_PACKAGES=( 
  "jshint"
  "http-server"
  "gulp" )

CASKS_PACKAGES=(
  "iterm2-nightly"
  "dropbox"
  "sublime-text3"
  "things"
  "flash"
  "handbrake"
  "omnigraffle"
  "transmission"
  "mplayerx"
  "charles"
  "lightpaper"
  "fluid"
  "codekit"
  "font-source-code-pro" 
  "parallels-desktop"
  "slingplayer-desktop"
)
# add "slingbox" if the pull request is accepted.

ADD_TO_DOCK=("iterm2-nightly"
  "sublime-text3"
  "things"
  "omnigraffle"
  "transmission"
  "mplayerx"
  "lightpaper"
  "codekit"
)

GEMS=( 
  "bundler"
  "rails" 
)


if $DEBUG; then 
  CASKS_PACKAGES=(
  "iterm2-nightly"
  "sublime-text3"
  "things"
  )

  ADD_TO_DOCK=("iterm2-nightly"
  "things"
  "sublime-text3"
  )

  BREW_PACKAGES=( 
  "python"
  "dockutil"
  "postgresql"
  "node"
  )
   
  NODE_PACKAGES=( "jshint" )
  GEMS=( "bundler" )
  SOFTWARE_UPDATE=false
  TM_DEBUG=false
fi 

