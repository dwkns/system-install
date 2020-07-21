  #!/usr/bin/env zsh
  source "$HOME/.system-config/scripts/utils/colours.sh"

  #
  doing "Configure vscode"
  
  # Set up some defaults
  rm -rf "$HOME/.vscode/extensions/dwkns-vs"
  mkdir -p "$HOME/.vscode/extensions/dwkns-vs" # make sure it exists
  doing "Cloning in dwkns settings"
  git clone https://github.com/dwkns/dwkns-vs.git "$HOME/.vscode/extensions/dwkns-vs"
  note "done"