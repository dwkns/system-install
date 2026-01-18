#!/usr/bin/env bash

ROOT_DIR="${ROOT_DIR:-$HOME/.system-config}"
MAS_LIST="${MAS_LIST:-$ROOT_DIR/config/mas-apps.txt}"

# shellcheck disable=SC1090
source "$ROOT_DIR/lib/common.sh"

mas_signed_in() {
  mas account >/dev/null 2>&1
}

install_mas_apps() {
  if ! has_cmd mas; then
    warn "mas is not installed. Install it with brew."
    return 0
  fi

  if ! mas_signed_in; then
    warn "Not signed in to the Mac App Store. Run: mas account"
    return 0
  fi

  [[ -r "$MAS_LIST" ]] || die "MAS apps list not found: $MAS_LIST"

  while IFS= read -r line; do
    [[ -z "$line" || "$line" =~ ^# ]] && continue
    local app_id="${line%% *}"
    if [[ "$app_id" =~ ^[0-9]+$ ]]; then
      run mas install "$app_id"
    fi
  done < "$MAS_LIST"
}
