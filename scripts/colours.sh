#!/usr/bin/env zsh
############################### colours ###############################
RED="\033[0;31m"          
YELLOW="\033[0;33m"       
GREEN="\033[0;32m"          
BLUE="\033[0;94m"
RESET="\033[0m"
CYAN="\033[0;36m"



############################### Functions ###############################

success () {
  echo -e $GREEN"Success ========>$CYAN $1 $RESET"
}

warn () {
 echo -e $YELLOW"Warning ========>$CYAN $1 $RESET"
}

error () {  
 echo -e $RED"Error ========>$CYAN $1 $RESET"
}

note () {
  echo -e $YELLOW"Note ========>$RESET $1 $RESET"
}

doing () {
  echo -e $GREEN"Doing ========>$CYAN $1 $RESET"
}

complete () {
  echo -e $GREEN"Done ========>$RESET $1 $RESET"
}

setting () {
  echo -e $GREEN"Setting ====>$RESET $1"
}