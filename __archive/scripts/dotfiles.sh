#!/usr/bin/env zsh
source "$HOME/.system-config/scripts/utils/colours.sh"
##################### Configure Sublime ######################

doing "Copying dotfiles"

# echo "Copying .bash_profile"
# cp -f "$ROOT_DIR/system-config-files/.bash_profile"  "$HOME/.bash_profile"

# echo "Copying .gemrc"
# cp -f "$ROOT_DIR/system-config-files/.gemrc" "$HOME/.gemrc"

# echo "Copying .gitconfig"
# cp -f "$ROOT_DIR/system-config-files/.gitconfig" "$HOME/.gitconfig"

# echo "Copying .gitignore"
# cp -f "$ROOT_DIR/system-config-files/.gitignore_global" "$HOME/.gitignore_global"

# echo "Copying .irbrc"
# cp -f  "$ROOT_DIR/system-config-files/.irbrc" "$HOME/.irbrc"

# # echo "Copying .jsbeautifyrc"
# # cp -f "$ROOT_DIR/system-config-files/.jsbeautifyrc"  "$HOME/.jsbeautifyrc"

# echo "Copying .rspec"
# cp -f  "$ROOT_DIR/system-config-files/.rspec" "$HOME/.rspec"

# echo "Copying .profile"
# cp -f  "$ROOT_DIR/system-config-files/.profile" "$HOME/.profile"


ROOT_DIR="$HOME/.system-config"

DOTFILES=( 
  ".bash_profile"
  ".gemrc"
  ".gitconfig"
  ".gitignore_global"
  ".irbrc"
  ".rspec"
  ".jsbeautifyrc"
  ".eslintrc.yml"
  ".zshrc"
  ".macos"
)  

installDotFiles () {
  doing 'Copying dotfiles...';
  for THISFILE in "${DOTFILES[@]}"
  do  
    echo "Installing : $THISFILE"
    cp -f "$ROOT_DIR/system-config-files/$THISFILE"  "$HOME/$THISFILE"
  done
}

installDotFiles

note "done"
