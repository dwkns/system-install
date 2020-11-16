#!/usr/bin/env zsh


############################## Script ###############################
  if [ -z ${1+x} ]; then # have we passed in a variable $1
      warn "Nothing passed in..."
      warn "You can use 'mnx <fileName>' as a shortcut."
      echo -n "Enter filename name (default -> run.sh) : "
      read PROJECTNAME
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
    echo -n "$(echo -e ${RED}"WARNING "$BLUE"'$PROJECTNAME'"${RED}" already exists Delete it y/n (default - y) : "$RESET)" 
    read DELETEIT 

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