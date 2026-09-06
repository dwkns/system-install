#!/usr/bin/env bash
# Colours, logging and small helpers. Sourced by every script and by .zshrc,
# so it must stay valid in both bash and zsh (no arrays, no `read -p`).

[[ -n "${_SYSCFG_COMMON:-}" ]] && return 0
_SYSCFG_COMMON=1

ROOT_DIR="${ROOT_DIR:-$HOME/.system-config}"

RED=$'\033[0;31m'; GREEN=$'\033[0;32m'; YELLOW=$'\033[0;33m'
CYAN=$'\033[0;36m'; BOLD=$'\033[1m'; DIM=$'\033[2m'; RESET=$'\033[0m'

# One glyph per kind of message, so output can be skimmed:
#   ▸ doing something   ✓ it worked   · detail   ▲ careful   ✗ broken
doing() { printf '%s▸%s %s\n'   "$GREEN"  "$RESET" "$*"; }
ok()    { printf '%s✓%s %s\n'   "$GREEN"  "$RESET" "$*"; }
note()  { printf '%s  ·%s %s\n' "$DIM"    "$RESET" "$*"; }
warn()  { printf '%s  ▲%s %s\n' "$YELLOW" "$RESET" "$*" >&2; }
error() { printf '%s  ✗%s %s\n' "$RED"    "$RESET" "$*" >&2; }
die()   { error "$*"; exit 1; }

# A titled rule, used at the top of anything worth reading properly.
#   header "🩺" "System check"
header() {
  local rule="────────────────────────────────────────────────────────"
  printf '\n%s%s%s\n' "$DIM" "$rule" "$RESET"
  printf ' %s  %s%s%s\n' "$1" "$BOLD" "$2" "$RESET"
  printf '%s%s%s\n\n' "$DIM" "$rule" "$RESET"
}

# "4m 12s" from a number of seconds.
elapsed() {
  local s="$1"
  (( s < 60 )) && { printf '%ds' "$s"; return; }
  printf '%dm %02ds' $(( s / 60 )) $(( s % 60 ))
}

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

# Ask a yes/no question that answers itself if left alone.
#   ask_timeout <seconds> <default: y|n> <question>
ask_timeout() {
  local secs="$1" default="$2" question="$3" reply="" hint
  [[ "$default" == "y" ]] && hint="[Y/n]" || hint="[y/N]"
  printf '%s %s — %ss, then %s: ' "$question" "$hint" "$secs" \
    "$([[ "$default" == y ]] && echo yes || echo no)"
  if { true </dev/tty; } 2>/dev/null; then
    read -t "$secs" -r reply </dev/tty || true
  fi
  echo
  [[ "${reply:-$default}" == [Yy]* ]]
}

# Ask before doing something. ASSUME_YES=1 skips the prompt.
#
# Reads from /dev/tty rather than stdin: under `curl ... | bash` stdin is the
# script itself, so a plain `read` gets EOF and the answer is always no.
confirm() {
  [[ "${ASSUME_YES:-0}" == "1" ]] && return 0
  local reply
  # Actually try to open it: the device node is readable by mode even when
  # there is no controlling terminal to attach to.
  if { true </dev/tty; } 2>/dev/null; then
    printf '%s [y/N] ' "${1:-Are you sure?}" >/dev/tty
    read -r reply </dev/tty || return 1
  else
    # No terminal at all (CI, a cron job): refuse rather than guess.
    warn "No terminal for confirmation — re-run with --yes"
    return 1
  fi
  [[ "$reply" == [Yy]* ]]
}
