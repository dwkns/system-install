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
  note "If you are asked for your password here, it is the App Store installer."
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

# Run a step at most once per machine, per version of its config.
#
#   run_once <name> <fingerprint> <command...>
#
# The stamp holds the fingerprint of the config the step last succeeded with,
# so editing that config makes the step run again. The stamp is written ONLY
# on success, so a half finished install retries rather than skipping.
run_once() {
  local name="$1" fp="$2"; shift 2
  local stamp="$ROOT_DIR/.state/$name"
  if [[ -e "$stamp" && "$(cat "$stamp" 2>/dev/null)" == "$fp" ]]; then
    note "$name: already done — skipping ('sys $name' forces it)"
    return 0
  fi
  if "$@"; then
    mkdir -p "$(dirname "$stamp")" && printf '%s\n' "$fp" >"$stamp"
  else
    note "$name: not done yet, will try again next run"
  fi
  return 0
}

# Fingerprint a file so a change to it re-triggers its once-only step.
fingerprint() { shasum -a 256 "$1" 2>/dev/null | cut -d' ' -f1; }

# Rebuilds the Dock from config/dock. bin/set-dock writes the whole Dock in
# one go: separate per-app calls race against cfprefsd and silently lose
# entries. Errors are shown, never swallowed.
configure_dock() {
  local setter="$ROOT_DIR/bin/set-dock"
  [[ -x "$setter" ]] || { warn "bin/set-dock missing; skipping the Dock"; return 1; }
  [[ -r "$ROOT_DIR/config/dock" ]] || return 1

  doing "Setting up the Dock"
  if [[ "${DRY_RUN:-0}" == "1" ]]; then
    ROOT_DIR="$ROOT_DIR" "$setter" --dry-run || return 1
  else
    ROOT_DIR="$ROOT_DIR" "$setter" || { error "Could not set the Dock"; return 1; }
  fi
}

# Undoes everything setup installed, so a machine can be tested from scratch
# WITHOUT erasing macOS. Never touches the user account, SSH or Screen Sharing,
# so a headless machine stays reachable.
#
# Shows the plan, then asks. DRY_RUN=1 shows the plan and stops.
remove_everything() {
  local dry="${DRY_RUN:-0}" brew_f=0 brew_c=0
  local -a plan=()

  has_cmd brew && {
    brew_f=$(brew list --formula 2>/dev/null | wc -l | tr -d ' ')
    brew_c=$(brew list --cask 2>/dev/null | wc -l | tr -d ' ')
    plan+=("every Homebrew package ($brew_f formulae, $brew_c casks), then Homebrew itself")
  }
  plan+=("~/.local/share/mise and ~/.cache/mise (installed toolchains)")
  local rel
  while IFS= read -r rel; do plan+=("~/$rel"); done \
    < <(cd "$ROOT_DIR/dotfiles" 2>/dev/null && find . -type f ! -name '.DS_Store' | sed 's|^\./||')
  plan+=("~/Library/Application Support/Cursor")
  plan+=("~/Library/Application Support/Sublime Text")
  plan+=("~/Library/Colors")
  plan+=("the Dock and Finder settings, back to macOS defaults")
  plan+=("$ROOT_DIR/.state and $ROOT_DIR/.drift")

  doing "This will remove:"
  printf '    %s\n' "${plan[@]}"
  echo
  note "It will NOT erase macOS, your user account, SSH or Screen Sharing."
  echo

  if [[ "$dry" == "1" ]]; then
    warn "Dry run — nothing removed. Run 'sys remove' to do it."
    return 0
  fi

  confirm "Remove all of the above?" || { note "Nothing removed."; return 0; }
  echo

  if has_cmd brew; then
    doing "Uninstalling casks and formulae"
    brew list --cask 2>/dev/null | xargs -r brew uninstall --cask --force >/dev/null 2>&1
    brew list --formula 2>/dev/null | xargs -r brew uninstall --formula --force --ignore-dependencies >/dev/null 2>&1
    doing "Uninstalling Homebrew"
    NONINTERACTIVE=1 /bin/bash -c \
      "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)" -- --force >/dev/null 2>&1
  fi

  doing "Removing installed files"
  rm -rf "$HOME/.local/share/mise" "$HOME/.cache/mise"
  while IFS= read -r rel; do rm -rf "$HOME/$rel"; done \
    < <(cd "$ROOT_DIR/dotfiles" 2>/dev/null && find . -type f ! -name '.DS_Store' | sed 's|^\./||')
  rm -rf "$HOME/Library/Application Support/Cursor" \
         "$HOME/Library/Application Support/Sublime Text" \
         "$HOME/Library/Colors" "$ROOT_DIR/.state" "$ROOT_DIR/.drift"

  doing "Resetting the Dock and Finder"
  defaults delete com.apple.dock    >/dev/null 2>&1 || true
  defaults delete com.apple.finder  >/dev/null 2>&1 || true
  killall Dock Finder >/dev/null 2>&1 || true

  echo
  doing "Removed. The repo is still at $ROOT_DIR"
  print_fresh_user_steps
}

print_fresh_user_steps() {
  cat <<'STEPS'

To install again from scratch:

  curl -fsSL https://raw.githubusercontent.com/dwkns/system-install/master/install.sh | bash

STEPS
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
