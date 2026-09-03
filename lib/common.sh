#!/usr/bin/env bash
# Colours, logging and small helpers. Sourced by every script and by .zshrc,
# so it must stay valid in both bash and zsh (no arrays, no `read -p`).

[[ -n "${_SYSCFG_COMMON:-}" ]] && return 0
_SYSCFG_COMMON=1

ROOT_DIR="${ROOT_DIR:-$HOME/.system-config}"

RED=$'\033[0;31m'; GREEN=$'\033[0;32m'; YELLOW=$'\033[0;33m'
CYAN=$'\033[0;36m'; RESET=$'\033[0m'

doing() { printf '%s==>%s %s\n' "$GREEN" "$RESET" "$*"; }
note()  { printf '%s  ·%s %s\n'  "$CYAN"  "$RESET" "$*"; }
warn()  { printf '%s  !%s %s\n'  "$YELLOW" "$RESET" "$*" >&2; }
error() { printf '%s  ✗%s %s\n'  "$RED"   "$RESET" "$*" >&2; }
die()   { error "$*"; exit 1; }

has_cmd()   { command -v "$1" >/dev/null 2>&1; }
is_macos()  { [[ "$(uname -s)" == "Darwin" ]]; }
timestamp() { date "+%Y%m%d-%H%M%S"; }

# Run a command, or just print it when DRY_RUN=1.
run() {
  if [[ "${DRY_RUN:-0}" == "1" ]]; then
    note "dry run: $*"
  else
    "$@"
  fi
}

# Run a command with a time limit, stdin closed so it can't sit at a prompt.
# macOS has no timeout(1) and doctor must never block.
with_timeout() {
  local secs="$1"; shift
  "$@" </dev/null >/dev/null 2>&1 &
  local pid=$!
  ( sleep "$secs"; kill -9 "$pid" 2>/dev/null ) >/dev/null 2>&1 &
  local killer=$!
  wait "$pid" 2>/dev/null; local rc=$?
  kill -9 "$killer" 2>/dev/null; wait "$killer" 2>/dev/null
  return $rc
}

# Ask before doing something. ASSUME_YES=1 skips the prompt.
confirm() {
  [[ "${ASSUME_YES:-0}" == "1" ]] && return 0
  printf '%s [y/N] ' "${1:-Are you sure?}"
  local reply; read -r reply
  [[ "$reply" == [Yy]* ]]
}
