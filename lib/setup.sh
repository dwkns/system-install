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

  # `mas account` was removed in mas 7; `mas list` is the real liveness check
  # and doubles as the list of what is already installed.
  local installed
  if ! installed="$(mas list 2>/dev/null)"; then
    warn "Can't read the App Store — open App Store.app and sign in, then: sys setup --mas"
    return 0
  fi

  doing "Installing App Store apps"
  local line id
  while IFS= read -r line; do
    [[ -z "$line" || "$line" == \#* ]] && continue
    id="${line%%[^0-9]*}"
    [[ -n "$id" ]] || continue
    if printf '%s' "$installed" | awk '{print $1}' | grep -qx "$id"; then
      note "already installed: $(printf '%s' "$line" | sed 's/^[0-9]*[[:space:]]*#*[[:space:]]*//')"
    else
      run mas install "$id"
    fi
  done < "$file"
}

# Cursor has no Settings Sync (unlike VS Code, which syncs via your account),
# so its extensions are tracked here and installed explicitly.
install_editor_extensions() {
  local file="$ROOT_DIR/config/cursor-extensions.txt"
  [[ -r "$file" ]] || return 0
  has_cmd cursor || { warn "cursor CLI not on PATH; skipping its extensions"; return 0; }

  local have ext missing=0
  have="$(cursor --list-extensions 2>/dev/null)"
  while IFS= read -r ext; do
    [[ -z "$ext" || "$ext" == \#* ]] && continue
    printf '%s' "$have" | grep -qix "$ext" && continue
    run cursor --install-extension "$ext" --force >/dev/null 2>&1
    missing=$((missing + 1))
  done < "$file"
  [[ "$missing" -gt 0 ]] && doing "Installed $missing Cursor extension(s)" || note "Cursor extensions: up to date"
  return 0
}

# Rebuilds the Dock from config/dock. Anything not installed on this machine
# is skipped with a note rather than failing — the Dock lists apps that come
# from optional extras and from other machines.
configure_dock() {
  local file="$ROOT_DIR/config/dock"
  [[ -r "$file" ]] || return 0
  has_cmd dockutil || { warn "dockutil not installed; skipping the Dock"; return 0; }

  doing "Setting up the Dock"
  run dockutil --remove all --no-restart >/dev/null 2>&1

  local line path added=0 skipped=0
  while IFS= read -r line; do
    [[ -z "$line" || "$line" == \#* ]] && continue
    path="$(eval printf '%s' \""$line"\")"
    if [[ ! -e "$path" ]]; then
      skipped=$((skipped + 1)); continue
    fi
    run dockutil --add "$path" --no-restart >/dev/null 2>&1
    added=$((added + 1))
  done < "$file"

  run killall Dock >/dev/null 2>&1 || true
  note "Dock: $added added$( [[ $skipped -gt 0 ]] && printf ', %s not installed' "$skipped" )"
}

# The Dock is only built on a machine we have not set up before. Rebuilding it
# on every run would throw away any arrangement made since. `sys dock` forces it.
configure_dock_once() {
  local stamp="$ROOT_DIR/.state/dock"
  if [[ -e "$stamp" ]]; then
    note "Dock already set up — 'sys dock' rebuilds it"
    return 0
  fi
  configure_dock || return 0
  mkdir -p "$(dirname "$stamp")" && date > "$stamp"
}

# Optional extras — never run by `sys setup`, only by `sys extras`.
install_extras() {
  local bf="$ROOT_DIR/Brewfile.optional"
  if [[ -r "$bf" ]]; then
    install_homebrew
    doing "Installing optional extras"
    run brew bundle --file "$bf"
  fi

  local file="$ROOT_DIR/config/mas-apps-optional.txt"
  [[ -r "$file" ]] || return 0
  has_cmd mas || return 0
  local installed
  installed="$(mas list 2>/dev/null)" || { warn "App Store unreachable; skipping optional apps"; return 0; }

  local line id
  while IFS= read -r line; do
    [[ -z "$line" || "$line" == \#* ]] && continue
    id="${line%%[^0-9]*}"
    [[ -n "$id" ]] || continue
    if printf '%s' "$installed" | awk '{print $1}' | grep -qx "$id"; then
      note "already installed: $(printf '%s' "$line" | sed 's/^[0-9]*[[:space:]]*#*[[:space:]]*//')"
    else
      run mas install "$id"
    fi
  done < "$file"
}

apply_macos_defaults() {
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
