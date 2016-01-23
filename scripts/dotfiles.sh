source "$HOME/.system-config/scripts/colours.sh"
##################### Configure Sublime ######################

msg "Copying dotfiles"

ROOT_DIR="$HOME/.system-config"

echo "Copying .bash_profile"
cp -f "$ROOT_DIR/system-config-files/.bash_profile"  "$HOME/.bash_profile"

echo "Copying .jsbeautifyrc"
cp -f "$ROOT_DIR/system-config-files/.jsbeautifyrc"  "$HOME/.jsbeautifyrc"

echo "Copying .rspec"
cp -f  "$ROOT_DIR/system-config-files/.rspec" "$HOME/.rspec"

echo "Copying .gemrc"
cp -f "$ROOT_DIR/system-config-files/.gemrc" "$HOME/.gemrc"

echo "Copying .gitconfig"
cp -f "$ROOT_DIR/system-config-files/.gitconfig" "$HOME/.gitconfig"

echo "Copying .gitignore"
cp -f "$ROOT_DIR/system-config-files/.gitignore_global" "$HOME/.gitignore_global"
note "done"
