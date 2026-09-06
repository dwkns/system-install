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

      # Already identical: nothing to do, and nothing to report.
      if [[ -e "$dst" ]] && cmp -s "$src" "$dst"; then
        continue
      fi

      if [[ -e "$dst" ]]; then
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
