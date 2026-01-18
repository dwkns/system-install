ROOT_DIR="$HOME/.system-config"

# shellcheck disable=SC1090
source "$ROOT_DIR/lib/dotfiles.sh"

installDotFiles () {
  install_dotfiles
}

backupDotFiles () {
  backup_dotfiles "$ROOT_DIR/dotfiles"
}