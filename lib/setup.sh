#!/usr/bin/env bash
# Everything that turns a bare Mac into a working one.

source "${ROOT_DIR:-$HOME/.system-config}/lib/common.sh"
source "${ROOT_DIR:-$HOME/.system-config}/lib/sync.sh"

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

install_app_store_apps() {
  local file="$ROOT_DIR/config/mas-apps.txt"
  [[ -r "$file" ]] || return 0
  has_cmd mas || { warn "mas not installed; skipping App Store apps"; MAS_SKIPPED=1; return 0; }

  # The App Store needs you signed in, so never assume. Default to no, so an
  # unattended run walks past it rather than stalling on a password prompt.
  if ! ask_timeout 15 n "Install App Store apps? (needs you signed in)"; then
    note "Skipped — run 'sys setup --mas' once you are signed in."
    MAS_SKIPPED=1
    return 0
  fi

  local installed
  if ! installed="$(mas list 2>/dev/null)"; then
    warn "Can't read the App Store — sign in, then: sys setup --mas"
    MAS_SKIPPED=1
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

# Remove a path completely. Several ~/Library folders carry a
# "group:everyone deny delete" ACL, so the directory itself cannot be removed
# even by its owner — empty it instead.
wipe() {
  local p="$1"
  [[ -e "$p" ]] || return 0
  rm -rf "$p" 2>/dev/null && return 0
  find "$p" -mindepth 1 -delete 2>/dev/null
  rmdir "$p" 2>/dev/null || true
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
  plan+=("~/.cursor ($(ls -1 "$HOME/.cursor/extensions" 2>/dev/null | wc -l | tr -d ' ') Cursor extensions)")
  plan+=("~/Library/Application Support/Cursor and Sublime Text")
  plan+=("~/Library/Colors")
  plan+=("preferences for Cursor, Sublime Text and Ghostty")
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
    # Some casks need sudo. Ask once here so the prompt has context, rather
    # than appearing unexplained in the middle of Homebrew's output.
    note "Some apps need your password to uninstall."
    sudo -v || warn "No sudo — some casks may fail to uninstall"
    doing "Uninstalling casks and formulae"
    brew list --cask 2>/dev/null | xargs -r brew uninstall --cask --force >/dev/null 2>&1
    brew list --formula 2>/dev/null | xargs -r brew uninstall --formula --force --ignore-dependencies >/dev/null 2>&1
    doing "Uninstalling Homebrew"
    NONINTERACTIVE=1 /bin/bash -c \
      "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)" -- --force >/dev/null 2>&1
  fi

  doing "Removing installed files"
  rm -rf "$HOME/.local/share/mise" "$HOME/.cache/mise" \
         "$ROOT_DIR/.state" "$ROOT_DIR/.drift" 2>/dev/null

  # Editors, completely — extensions live in ~/.cursor, not Application Support.
  wipe "$HOME/.cursor"
  wipe "$HOME/Library/Application Support/Cursor"
  wipe "$HOME/Library/Application Support/Sublime Text"
  wipe "$HOME/Library/Colors"
  wipe "$HOME/Library/Caches/Cursor"
  rm -f "$HOME/Library/Preferences/com.todesktop.230313mzl4w4u92.plist" \
        "$HOME/Library/Preferences/com.sublimetext.4.plist" \
        "$HOME/Library/Preferences/com.mitchellh.ghostty.plist" 2>/dev/null

  # Anything else the sync targets put on this machine.
  local repo_rel system_dir repo_dir rel
  while IFS='|' read -r repo_rel system_dir; do
    repo_dir="$ROOT_DIR/$repo_rel"
    [[ -d "$repo_dir" ]] || continue
    while IFS= read -r rel; do rm -f "$system_dir/$rel" 2>/dev/null; done < <(_tracked "$repo_dir")
  done < <(sync_targets)

  doing "Resetting the Dock and Finder"
  defaults delete com.apple.dock    >/dev/null 2>&1 || true
  defaults delete com.apple.finder  >/dev/null 2>&1 || true
  killall Dock Finder >/dev/null 2>&1 || true

  echo
  ok "Removed. The repo is still at $ROOT_DIR"
  warn "Open a new terminal now. This one still has the old shell hooks"
  warn "loaded, so it will complain that mise has gone — that is expected."
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

  # One name, used for all three, as the original did. Lowercased, spaces to
  # hyphens, other punctuation dropped — scutil rejects those in HostName and
  # LocalHostName, and keeping the three identical is the whole point.
  local clean
  clean="$(printf '%s' "$name" \
    | tr '[:upper:]' '[:lower:]' \
    | tr ' ' '-' \
    | tr -cd '[:alnum:]-' \
    | sed 's/^-*//;s/-*$//;s/--*/-/g')"
  [[ -n "$clean" ]] || { warn "Not a usable computer name: $name"; return 1; }

  doing "Setting computer name to $clean"
  run sudo scutil --set ComputerName  "$clean"
  run sudo scutil --set HostName      "$clean"
  run sudo scutil --set LocalHostName "$clean"
}


# Asked once per machine during setup. 15 seconds, then the default.
DEFAULT_MACHINE_NAME="${DEFAULT_MACHINE_NAME:-dazzas-mac}"
prompt_machine_name() {
  local current reply
  current="$(scutil --get ComputerName 2>/dev/null || echo "unknown")"

  doing "Computer name"
  note "Currently: $current"
  printf '    New name, or Return to accept "%s" (15s): ' "$DEFAULT_MACHINE_NAME"

  reply=""
  if { true </dev/tty; } 2>/dev/null; then
    read -t 15 -r reply </dev/tty || true
  fi
  echo

  reply="$(printf '%s' "${reply:-$DEFAULT_MACHINE_NAME}" | sed 's/^ *//;s/ *$//')"
  [[ -n "$reply" ]] || reply="$DEFAULT_MACHINE_NAME"
  set_machine_name "$reply"
}


# Printed at the end of setup. Only lists things that are actually still
# outstanding, checked live — a list of things you have already done is noise.
print_manual_steps() {
  local -a todo=()


  [[ "${MAS_SKIPPED:-0}" == "1" ]] && \
    todo+=("🛒  App Store apps were skipped — sign in, then ${CYAN}sys setup --mas${RESET}")

  has_cmd cursor || \
    todo+=("🧩  Open Cursor once so its command appears, then ${CYAN}sys setup${RESET} for its extensions")

  todo+=("🔐  Sign in to 1Password, Dropbox, Slack, Notion and Figma")
  todo+=("🔓  Give Ghostty Full Disk Access — System Settings ▸ Privacy & Security")
  todo+=("🔄  Log out and back in — some macOS settings only apply at login")

  # No right-hand border: emoji are double-width and terminals disagree on
  # how much, so anything padded to a fixed column ends up ragged.
  header "🎉" "All set — a few things only you can do"
  printf '  %b\n' "${todo[@]}"
  echo
  printf '  %sTip:%s %ssys doctor%s tells you if anything is still missing.\n\n' \
    "$YELLOW" "$RESET" "$CYAN" "$RESET"
}

