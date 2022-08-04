#!/usr/bin/env zsh
############################### colours ###############################
WHITE="\033[0;37m"
GRAY="\033[0;30m"
RED="\033[0;31m"          
YELLOW="\033[0;33m"       
GREEN="\033[0;32m"          
BLUE="\033[0;94m"
CYAN="\033[0;36m"
PURPLE="\033[0;35m"
WHITE_BOLD="\033[1;37m"
GRAY_BOLD="\033[1;30m"
RED_BOLD="\033[1;31m"          
YELLOW_BOLD="\033[1;33m"       
GREEN_BOLD="\033[1;32m"          
BLUE_BOLD="\033[1;94m"
CYAN_BOLD="\033[1;36m"
PURPLE_BOLD="\033[1;35m"
RESET="\033[0m"


# $RED colour $YELLOW colour $GREEN colour $BLUE colour $RESET colour $CYAN colour 


############################### emoji ###############################
UNICORN='\U1F984'; 
THUMBS_UP='\U1F44D';
GREEN_TICK=$GREEN'\U2714'$RESET
WARNING='\U26A0'




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
  echo -e $CYAN"Note —>$RESET $1 $RESET"
}

doing () {
  echo -e $GREEN"Doing ————> $1 $RESET"
}

complete () {
  echo -e $GREEN"Done ========>$RESET $1 $RESET"
}

setting () {
  echo -e $GREEN"Setting ====>$RESET $1"
}