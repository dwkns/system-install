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
  ".background_colour.png"
  ".profile"

)  

installDotFiles () {
  doing 'Installing dotfiles...';
  for THISFILE in "${DOTFILES[@]}"
  do  
    echo "Installing : $THISFILE"
    cp -f "$ROOT_DIR/dotfiles/$THISFILE"  "$HOME/$THISFILE"
  done
}

backupDotFiles () {
  doing 'Backing up dotfiles...';
  echo;
  for i in "${DOTFILES[@]}"
  do  
     cp -rf "$HOME/$i" "$SYS_FILES_ROOT/dotfiles/$i";
  done
}