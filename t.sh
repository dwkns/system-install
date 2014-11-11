#!/bin/bash
while true; do
    read -p "Give me an answer ? y/n : " yn < /dev/tty
    case $yn in
        [Yy]* ) answer=true ; break;;
        [Nn]* ) answer=false ; break;;
        * ) echo "Please answer yes or no.";;
    esac
  done

if $answer 
  then 
    echo "Doing something as you answered yes"
      else 
    echo "Not doing anything as you answered no" 
fi


echo “first”
read SOMETHING < /dev/tty
echo $SOMETHING 

echo “second”
read SOMETHINGELSE 
echo $SOMETHINGELSE 
