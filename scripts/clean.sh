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

remove_krep () {
    sudo rm -rf "/Applications/Krep.app"
}

remove_dotfiles () {
  echo -e "$PR Removing dotfiles"
  sudo rm -rf "$HOME/.git*"
  sudo rm -rf "$HOME/.rspec"
  sudo rm -rf "$HOME/.profile"
  sudo rm -rf "$HOME/.bash_profile"
  sudo rm -rf "$HOME/.zshrc"
  sudo rm -rf "$HOME/.zlogin"
  sudo rm -rf "$HOME/.gem"
  sudo rm -rf "$HOME/.dropbox"
  sudo rm -rf "$HOME/.subversion"
  sudo rm -rf "$HOME/.rvm"
}

remove_sublime_config () {
  echo -e "$PR Removing SublimeConfig"
  sudo rm -rf "$HOME/Library/Application Support/Sublime Text 3"
  sudo rm -rf "/usr/local/bin/ruby-iterm2.sh"
}

remove_rvm () {
  echo -e "$PR Removing rvm"
  sudo rm -rf "$HOME/.rvm"
}
remove_apps(){
  echo -e "$PR Removing Apps"
  sudo rm -rf "/usr/bin/motion"
  sudo rm -rf "/Library/RubyMotion"
  sudo rm -rf "/tmp/krep"
}

remove_homebrew
remove_cask
remove_krep
remove_dotfiles
remove_sublime_config



