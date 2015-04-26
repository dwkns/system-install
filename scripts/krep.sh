#!/bin/sh
######################## HOMEBREW ########################
 echo -e "$PG Installing Krep"
#----------------------krep-----------------------
killall -9 Krep
wget https://github.com/dwkns/krep/archive/master.zip -O "$HOME/Downloads/Krep.zip"
unzip -o -q "$downloadFile" -d "$HOME/Downloads"
cp -rf "$HOME/Downloads/krep-master/Krep.app" "/Applications"
rm -rf "$HOME/Downloads/krep-master"
rm -rf "$HOME/Downloads/Krep.zip"

appname="Krep.app"
appNameAndPath="/Applications/"$appname

defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>$appNameAndPath</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>"

