#!/usr/bin/env bash

############################### Variables ###############################
RED="\033[0;31m"          
YELLOW="\033[0;33m"       
GREEN="\033[0;32m"          
BLUE="\033[0;94m"
RESET="\033[0m"

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

############################### Script ###############################
  if [ -z ${1+x} ]; then # have we passed in a variable $1
      warn "Nothing passed in..."
      warn "You can use 'mnx <fileName>' as a shortcut."
      echo
      read -p "Enter filename name (default -> run.sh) : " PROJECTNAME
      echo
      PROJECTNAME=${PROJECTNAME:-run.sh}
  else 
      PROJECTNAME=$1
  fi

  if [[  ${PROJECTNAME: -3} != ".sh" ]]; then
      PROJECTNAME=$PROJECTNAME.sh
  fi

  echo -e "${GREEN}====> Setting project name to $BLUE'$PROJECTNAME'$RESET"


  if [ -f "$PROJECTNAME" ]; then
    read -p "$(echo -e ${RED}"WARNING "$BLUE"'$PROJECTNAME'"${RED}" already exists Delete it y/n (default - y) : "$RESET)" DELETEIT

    DELETEIT=${DELETEIT:-Y}

    if [  "$DELETEIT" = "Y" ] || [  "$DELETEIT" = "y" ] ; then
     rm -rf $PROJECTNAME
    else
      warn "OK not doing anything & exiting" 
      return
    fi
  fi

  cat >$PROJECTNAME<<'EOL'
  #!/usr/bin/env bash
EOL
chmod +x $PROJECTNAME
echo -e ${GREEN}"====> "$BLUE"'$PROJECTNAME'"${GREEN}" Created and set to be Executable"$RESET
subl $PROJECTNAME