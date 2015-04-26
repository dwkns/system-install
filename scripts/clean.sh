#!/bin/bash
######################## HOMEBREW ########################

############ FUNCTIONS ############
remove_homebrew () {
    echo -e "$PR Removing Homebrew"
    sudo rm -rf "/usr/local"
    sudo rm -rf "/Library/Caches/Homebrew"
}

remove_cask () {
    echo -e "$PR Removing Cask"

    sudo rm -rf  "/opt/homebrew-cask"
    #remove symlinks from Application folder - anoying escaping at end.
    find /Applications -maxdepth 1 -lname '*' -exec rm {} \;
}

remove_node () {
    #nothing special for
    echo
}


remove_homebrew
remove_cask
remove_node
