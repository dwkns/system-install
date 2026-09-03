#!/usr/bin/env bash
# Everything that turns a bare Mac into a working one.

source "${ROOT_DIR:-$HOME/.system-config}/lib/common.sh"

install_homebrew() {
  has_cmd brew && return 0
  doing "Installing Homebrew"
  run /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  [[ -x /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"
}

install_packages() {
  install_homebrew
  doing "Installing packages from Brewfile"
  run brew bundle --file "$ROOT_DIR/Brewfile"
}

# mise reads dotfiles/.config/mise/config.toml, so dotfiles must be synced first.
install_languages() {
  has_cmd mise || { warn "mise not installed; skipping languages"; return 0; }
  doing "Installing language versions with mise"
  run mise install
}

# Licences live in the macOS keychain, never in this repo. A fresh machine has
# an empty keychain, so if one is missing we say exactly how to add it rather
# than skipping silently.
install_licences() {
  local file="$ROOT_DIR/config/licences"
  [[ -r "$file" ]] || return 0

  local service dst b64 missing=0
  while IFS='|' read -r service dst; do
    [[ -z "$service" || "$service" == \#* ]] && continue
    dst="$(eval printf '%s' \""$dst"\")"

    b64="$(security find-generic-password -a "$USER" -s "$service" -w 2>/dev/null || true)"
    if [[ -z "$b64" ]]; then
      warn "No licence in the keychain for '$service'. Add it with:"
      printf '    openssl base64 -A -in <licence file> | \\\n'
      printf '      security add-generic-password -U -a "$USER" -s %s -w "$(cat)"\n' "$service"
      missing=1
      continue
    fi

    [[ "${DRY_RUN:-0}" == "1" ]] && { note "dry run: write $dst"; continue; }
    mkdir -p "$(dirname "$dst")"
    printf '%s' "$b64" | openssl base64 -A -d > "$dst"
    chmod 600 "$dst"
    note "Installed $(basename "$dst")"
  done < "$file"

  [[ "$missing" == "1" ]] && note "Then re-run: sys setup --licences"
  return 0
}

install_app_store_apps() {
  local file="$ROOT_DIR/config/mas-apps.txt"
  [[ -r "$file" ]] || return 0
  has_cmd mas || { warn "mas not installed; skipping App Store apps"; return 0; }
  if ! with_timeout 10 mas account; then
    warn "Not signed in to the App Store — open App Store.app, then 'sys setup --mas'"
    return 0
  fi

  doing "Installing App Store apps"
  local line id
  while IFS= read -r line; do
    [[ -z "$line" || "$line" == \#* ]] && continue
    id="${line%%[^0-9]*}"
    [[ -n "$id" ]] && run mas install "$id"
  done < "$file"
}

apply_macos_defaults() {
  doing "Applying macOS defaults"
  run bash "$ROOT_DIR/macos.sh"
}

set_default_terminal() {
  has_cmd duti || { warn "duti not installed; skipping default terminal"; return 0; }
  [[ -d /Applications/Ghostty.app ]] || { warn "Ghostty not installed; skipping"; return 0; }

  doing "Making Ghostty the default terminal"
  local id="com.mitchellh.ghostty" ext
  run duti -s "$id" com.apple.terminal.shell-script all
  run duti -s "$id" public.unix-executable all
  for ext in command tool sh zsh; do
    run duti -s "$id" ".$ext" all 2>/dev/null || true
  done
}

set_machine_name() {
  local name="$1"
  [[ -n "$name" ]] || return 0
  doing "Setting machine name to $name"
  run sudo scutil --set ComputerName "$name"
  run sudo scutil --set HostName "$name"
  run sudo scutil --set LocalHostName "$name"
}

# The steps a human has to do; printed at the end of setup.
print_manual_steps() {
  cat <<'STEPS'

Things this script can't do for you:

  1. Add any licences to the keychain — 'sys doctor' lists what's missing
     and prints the command. Then:   sys setup --licences
  2. Sign in to the App Store, then:   sys setup --mas
  3. Sign in to 1Password, Dropbox, Slack, Notion, Figma
  4. System Settings > Privacy & Security > Full Disk Access > add Ghostty
     (needed for the Safari defaults in macos.sh)
  5. Log out and back in — some macOS defaults only apply at login

STEPS
}
