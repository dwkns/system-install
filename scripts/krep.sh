#!/bin/bash
######################## KREP ########################
echo -e "$PG Installing Krep"

ps cax | grep Krep > /dev/null # Is Krep running?

if [ $? -eq 0 ]; then # yep, killing it
  echo -e "$PR Krep is running. Killing it"
  killall -9 Krep

fi

if [  -d "/Applications/Krep.app" ]; then # is Krep installed
  echo -e "$PY Krep is installed, skipping"
else
  wget https://github.com/dwkns/krep/archive/master.zip -O "$HOME/Downloads/Krep.zip"
  unzip -o -q "$HOME/Downloads/Krep.zip" -d "$HOME/Downloads"
  cp -rf "$HOME/Downloads/krep-master/Krep.app" "/Applications"
  rm -rf "$HOME/Downloads/krep-master"
  rm -rf "$HOME/Downloads/Krep.zip"

  appname="Krep.app"
  appNameAndPath="/Applications/"$appname

  defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>$appNameAndPath</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>"

fi


