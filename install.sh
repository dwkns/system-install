#!/usr/bin/env bash
# Set up a new Mac with one command:
#
#   curl -fsSL https://raw.githubusercontent.com/dwkns/system-install/master/install.sh | bash
#
# Runs start to finish. You will be asked for your password once, and to
# accept the Command Line Tools dialog if they are not installed yet.
set -euo pipefail

ROOT_DIR="${ROOT_DIR:-$HOME/.system-config}"
REPO="https://github.com/dwkns/system-install.git"

say() { printf '\033[0;32m==>\033[0m %s\n' "$*"; }

# Where to read answers from. NEVER redirect this script's own stdin: piped
# into bash, stdin IS the script, so `exec </dev/tty` makes bash try to read
# the rest of the script from the keyboard and hang forever. Redirect only
# the individual commands that prompt.
if { true </dev/tty; } 2>/dev/null; then TTY=/dev/tty; else TTY=/dev/null; fi

say "Setting up this Mac from $REPO"

# ── Xcode Command Line Tools ─────────────────────────────────────────────────
# git needs these. The installer is a GUI dialog, so wait for it rather than
# bailing out and making the user start again.
if ! xcode-select -p >/dev/null 2>&1; then
  say "Installing Xcode Command Line Tools"
  echo "    A dialog will appear — click Install and accept the licence."
  xcode-select --install >/dev/null 2>&1 || true

  printf '    Waiting for it to finish'
  for _ in $(seq 1 240); do              # up to 40 minutes
    xcode-select -p >/dev/null 2>&1 && break
    printf '.'; sleep 10
  done
  echo

  if ! xcode-select -p >/dev/null 2>&1; then
    echo "Command Line Tools did not install. Run 'xcode-select --install',"
    echo "let it finish, then run this command again."
    exit 1
  fi
  say "Command Line Tools installed"
fi

# git can exist but refuse to run until the licence is agreed.
if ! git --version >/dev/null 2>&1; then
  echo "git is not working yet. Open Terminal, run 'git --version', accept any"
  echo "prompt, then run this command again."
  exit 1
fi

# ── Password, once, up front ─────────────────────────────────────────────────
# Homebrew and the macOS defaults need it. Asking here keeps the rest unattended.
say "Your password is needed for Homebrew and system settings"
if [[ "$TTY" == /dev/tty ]]; then
  sudo -v </dev/tty
else
  echo "    No terminal available; skipping. Homebrew may prompt later."
fi
while true; do sudo -n true; sleep 60; kill -0 "$$" 2>/dev/null || exit; done 2>/dev/null &

# ── The repo ─────────────────────────────────────────────────────────────────
if [[ -d "$ROOT_DIR/.git" ]]; then
  say "Updating $ROOT_DIR"
  # Never abort the install over this — a local edit or a diverged branch
  # should not stop setup running with the copy already on disk.
  git -C "$ROOT_DIR" pull --ff-only 2>/dev/null \
    || echo "    Could not update; continuing with the existing copy."
else
  say "Cloning into $ROOT_DIR"
  if ! git clone --quiet "$REPO" "$ROOT_DIR"; then
    echo "Could not clone $REPO — check your network and try again."
    exit 1
  fi
fi

# Running this installer IS the confirmation, so do not ask again.
exec "$ROOT_DIR/bin/sys" setup --yes "$@" <"$TTY"
