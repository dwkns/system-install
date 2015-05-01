#!/bin/bash 
######################## Time Machine ########################
echo -e "$PG Adding Time Machine Exclusion"
CURRENT_USER=`whoami`

sudo tmutil addexclusion "/Applications/"
sudo tmutil addexclusion "/Library/"
sudo tmutil addexclusion "/System/"
sudo tmutil addexclusion "/bin/"
sudo tmutil addexclusion "/cores/"
sudo tmutil addexclusion "/dev/"
sudo tmutil addexclusion "/home/"
sudo tmutil addexclusion "/net/"
sudo tmutil addexclusion "/opt/"
sudo tmutil addexclusion "/private/"
sudo tmutil addexclusion "/sbin/"
sudo tmutil addexclusion "/usr/"
sudo tmutil addexclusion "/.vol"
sudo tmutil addexclusion "/.fseventsd"

sudo tmutil addexclusion "/Users/$CURRENT_USER/Downloads/"
sudo tmutil addexclusion "/Users/$CURRENT_USER/Library/Caches/"
sudo tmutil addexclusion "/Users/$CURRENT_USER/Library/Mail/"
sudo tmutil addexclusion "/Users/$CURRENT_USER/Library/Torrents/"
sudo tmutil addexclusion "/Users/$CURRENT_USER/Library/Mail Downloads/"

open /System/Library/PreferencePanes/TimeMachine.prefPane/
