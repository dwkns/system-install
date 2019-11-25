#!/usr/bin/env zsh
############################### Variables ###############################
RED="\033[0;31m"          
YELLOW="\033[0;33m"       
GREEN="\033[0;32m"          
BLUE="\033[0;94m"
RESET="\033[0m"
CYAN="\033[0;36m"



############################### Functions ###############################

success () {
  echo -e $GREEN"Success ====>$RESET $1"
}

warn () {
 echo -e $YELLOW"Warning ====>$RESET $1"
}

error () {  
 echo -e $RED"Error ====>$RESET $1"
}

note () {
  echo -e $RESET"====>$RESET $1"
}

