#!/usr/bin/env bash
# Mirrors config between this repo and the system.
#
# Each tracked area is just "a repo directory that maps onto a system
# directory". The contents of the repo directory ARE the manifest, so there
# is no separate list to keep in step.
#
#   sync_install   repo -> system
#   sync_backup    system -> repo   (only files the repo already tracks)

source "${ROOT_DIR:-$HOME/.system-config}/lib/common.sh"

SUBLIME_USER_DIR="$HOME/Library/Application Support/Sublime Text/User"

# repo dir | system dir
sync_targets() {
  cat <<TARGETS
dotfiles|$HOME
colors|$HOME/Library/Colors
config/sublime-config|$SUBLIME_USER_DIR
config/cursor|$HOME/Library/Application Support/Cursor/User
TARGETS
}

# Files tracked in a repo dir, as paths relative to it.
_tracked() {
  local dir="$1"
  [[ -d "$dir" ]] || return 0
  find "$dir" -type f ! -name '.DS_Store' ! -name '*.sublime_license' -print0 |
    while IFS= read -r -d '' f; do printf '%s\n' "${f#"$dir"/}"; done
}

# Copy repo -> system. The repo always wins — that is what syncing means — but
# any system file that would be overwritten with different content is stashed
# in .drift/ first, so a local edit is never silently lost.
# Sets SYNC_CHANGED to the number of files it actually replaced.
sync_install() {
  local drift="$ROOT_DIR/.drift"
  SYNC_CHANGED=0
  local repo_rel system_dir repo_dir rel src dst drifted=0

  while IFS='|' read -r repo_rel system_dir; do
    repo_dir="$ROOT_DIR/$repo_rel"
    [[ -d "$repo_dir" ]] || continue

    while IFS= read -r rel; do
      src="$repo_dir/$rel"; dst="$system_dir/$rel"

      # Already identical: nothing to do, unless forced.
      local same=0
      [[ -e "$dst" ]] && cmp -s "$src" "$dst" && same=1
      [[ "$same" == "1" && "${FORCE:-0}" != "1" ]] && continue

      # Only stash a file that actually differs — forcing should not fill
      # .drift with copies of files that were already correct.
      if [[ -e "$dst" && "$same" == "0" ]]; then
        run mkdir -p "$drift/$repo_rel/$(dirname "$rel")"
        run cp -a "$dst" "$drift/$repo_rel/$rel"
        drifted=1
      fi

      run mkdir -p "$(dirname "$dst")"
      run cp -a "$src" "$dst"
      SYNC_CHANGED=$((SYNC_CHANGED + 1))
    done < <(_tracked "$repo_dir")
  done < <(sync_targets)

  if [[ "$drifted" == "1" ]]; then
    note "Replaced files that differed. The old copies are in .drift/"
    note "Keep them instead?  cp -a .drift/<path> <destination>, or 'sys push' next time."
  fi
  return 0
}

# Sign in to GitHub with the same "device flow" gh uses, but driven from here
# so gh never draws an interactive prompt: those query the terminal and the
# replies land on screen as escape codes. Prints a code, opens the browser,
# waits for approval, hands the token to gh. Nothing else touches the terminal.
github_device_login() {
  local client="178c6fc778ccc68e1d6a"   # gh's own OAuth app, so gh owns the token
  local resp device code uri interval token err waited=0
  resp="$(curl -fsS -X POST https://github.com/login/device/code \
            -d "client_id=$client" -d "scope=repo read:org gist workflow" 2>/dev/null)" || {
    warn "Could not reach GitHub to start the sign-in"; return 1; }
  field() { printf '%s' "$1" | tr '&' '\n' | sed -n "s/^$2=//p" | sed 's/%3A/:/g;s/%2F/\//g'; }
  device="$(field "$resp" device_code)"; code="$(field "$resp" user_code)"
  uri="$(field "$resp" verification_uri)"; interval="$(field "$resp" interval)"
  [[ -n "$device" && -n "$code" ]] || { warn "GitHub gave no sign-in code"; return 1; }

  printf '\n    Your code:  %s%s%s\n    Type it on the GitHub page that is opening: %s\n\n' "$BOLD" "$code" "$RESET" "$uri"
  { open "$uri" 2>/dev/null || xdg-open "$uri" 2>/dev/null; } >/dev/null 2>&1 &
  note "Waiting for you to approve it there…"

  while (( waited < 900 )); do
    sleep "${interval:-5}"; waited=$((waited + ${interval:-5}))
    resp="$(curl -fsS -X POST https://github.com/login/oauth/access_token \
              -d "client_id=$client" -d "device_code=$device" \
              -d "grant_type=urn:ietf:params:oauth:grant-type:device_code" 2>/dev/null)" || continue
    token="$(field "$resp" access_token)"
    [[ -n "$token" ]] && break
    err="$(field "$resp" error)"
    case "$err" in
      authorization_pending) ;;
      slow_down) sleep 5 ;;
      expired_token) warn "That code expired"; return 1 ;;
      access_denied) warn "You cancelled the sign-in"; return 1 ;;
    esac
  done
  [[ -n "$token" ]] || { warn "Timed out waiting for the sign-in"; return 1; }
  printf '%s\n' "$token" | gh auth login --hostname github.com --with-token >/dev/null 2>&1 \
    || { warn "gh did not accept the sign-in"; return 1; }
  ok "Signed in to GitHub"
}

# Push commits that already exist. Never stops at a bare "Username:" prompt: a
# machine with no GitHub login saved is signed in, once.
push_repo() {
  if run env GIT_TERMINAL_PROMPT=0 git -C "$ROOT_DIR" push --quiet 2>/dev/null; then return 0; fi
  [[ "${DRY_RUN:-0}" == "1" ]] && return 1

  # No login saved: sign in through gh, once, right here — it opens the
  # browser and shows a code to type — then let gh hand git its credentials.
  if has_cmd gh && { true </dev/tty; } 2>/dev/null; then
    doing "This machine needs a GitHub login to push — signing in once with gh"
    if ! gh auth status -h github.com >/dev/null 2>&1; then
      github_device_login || { warn "GitHub sign-in did not finish — run sys sync again to retry"; return 1; }
    fi
    gh auth setup-git -h github.com >/dev/null 2>&1 || true
    if env GIT_TERMINAL_PROMPT=0 git -C "$ROOT_DIR" push --quiet 2>/dev/null; then
      ok "Signed in to GitHub — pushed. You will not be asked again on this machine"
      return 0
    fi
  fi
  warn "Could not push to GitHub — this machine has no GitHub login saved"
  note "Once, on this machine:  gh auth login  then  gh auth setup-git  — then sys sync again"
  return 1
}

# Copy system -> repo, for files the repo already tracks.
sync_backup() {
  local repo_rel system_dir repo_dir rel src dst
  while IFS='|' read -r repo_rel system_dir; do
    repo_dir="$ROOT_DIR/$repo_rel"
    [[ -d "$repo_dir" && -d "$system_dir" ]] || continue

    while IFS= read -r rel; do
      src="$system_dir/$rel"; dst="$repo_dir/$rel"
      [[ -e "$src" ]] || { warn "missing on system: $src"; continue; }
      run mkdir -p "$(dirname "$dst")"
      run cp -a "$src" "$dst"
    done < <(_tracked "$repo_dir")
  done < <(sync_targets)
}
