#!/usr/bin/env bash
###############################################################################
# ghostty.sh - Ghostty terminal integration
###############################################################################
#
# PURPOSE:
#   Makes Ghostty the default terminal. macOS has no single "default terminal"
#   setting; the practical equivalent is the LaunchServices handler for shell
#   scripts (.command/.tool/.sh/.zsh) and bare unix executables. This registers
#   Ghostty for those types via `duti`.
#
#   Ghostty's window/appearance config is NOT handled here — it lives in
#   dotfiles/.config/ghostty/config and is synced by the normal dotfiles
#   mechanism (see config/.dotfiles).
#
# DEPENDENCIES:
#   - lib/common.sh (has_cmd, log, warn, run)
#   - duti (brew install duti)
#   - Ghostty.app installed
#
# FUNCTIONS:
#   set_ghostty_default_terminal  - Register Ghostty as the default terminal
#
###############################################################################

ROOT_DIR="${ROOT_DIR:-$HOME/.system-config}"

# shellcheck disable=SC1090
source "$ROOT_DIR/lib/common.sh"

GHOSTTY_BUNDLE_ID="${GHOSTTY_BUNDLE_ID:-com.mitchellh.ghostty}"

###############################################################################
# set_ghostty_default_terminal - Make Ghostty the default terminal
###############################################################################
# Registers Ghostty as the handler for terminal script types and unix
# executables. Skips gracefully if duti or Ghostty is missing.
#
# Note: Apple owns the com.apple.terminal.shell-script UTI and can re-claim it;
# an `lsregister -f` refresh of Ghostty.app before setting makes it stick.
###############################################################################
set_ghostty_default_terminal() {
  if ! has_cmd duti; then
    warn "duti not installed; skipping default-terminal setup (brew install duti)"
    return 0
  fi
  if [[ ! -d "/Applications/Ghostty.app" ]]; then
    warn "Ghostty.app not found; skipping default-terminal setup"
    return 0
  fi

  log "Setting Ghostty as the default terminal"

  # Refresh LaunchServices' record of Ghostty so association changes stick.
  local lsregister="/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister"
  [[ -x "$lsregister" ]] && run "$lsregister" -f /Applications/Ghostty.app

  # Shell scripts (.command) and bare executables.
  run duti -s "$GHOSTTY_BUNDLE_ID" com.apple.terminal.shell-script all
  run duti -s "$GHOSTTY_BUNDLE_ID" public.unix-executable all

  # Common script extensions.
  local ext
  for ext in command tool sh zsh csh pl; do
    run duti -s "$GHOSTTY_BUNDLE_ID" ".$ext" all 2>/dev/null || true
  done
}
