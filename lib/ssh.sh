#!/usr/bin/env bash
# SSH between your own machines, driven by one file in the repo.
#
#   config/ssh/access         who may log in where, and as which account
#   config/ssh/keys/NAME.pub  each machine's public key — safe to publish
#
# Every machine makes its own key once, shares the public half into the repo,
# and on every sync installs the keys the access file lets in and an alias for
# every other machine. Private keys never leave the machine that made them.
# Nothing here ever types a password.

source "${ROOT_DIR:-$HOME/.system-config}/lib/common.sh"
source "${ROOT_DIR:-$HOME/.system-config}/lib/sync.sh"

SSH_KEY="$HOME/.ssh/id_ed25519"
SSH_ACCESS="$ROOT_DIR/config/ssh/access"
SSH_KEYS_DIR="$ROOT_DIR/config/ssh/keys"
SSH_ALIASES="$HOME/.ssh/config.d/sys"                 # generated, safe to delete
SSH_AUTH="$HOME/.ssh/authorized_keys"
SSHD_DROPIN="/etc/ssh/sshd_config.d/00-sys-keys-only.conf"
SSH_MARK_START="# >>> sys ssh: from config/ssh/access — keys you add by hand go outside these lines >>>"
SSH_MARK_END="# <<< sys ssh <<<"

ssh_machine()   { hostname -s 2>/dev/null | tr '[:upper:]' '[:lower:]'; }
ssh_has_key()   { [[ -f "$SSH_KEY" && -f "$SSH_KEY.pub" ]]; }
ssh_keys_only() { [[ -f "$SSHD_DROPIN" ]] && grep -q '^PasswordAuthentication no' "$SSHD_DROPIN" 2>/dev/null; }
ssh_shared()    { ssh_has_key && cmp -s "$SSH_KEY.pub" "$SSH_KEYS_DIR/$(ssh_machine).pub" 2>/dev/null; }

# How many machines the managed block lets in here.
ssh_trusted_count() {
  [[ -f "$SSH_AUTH" ]] || { echo 0; return 0; }
  awk -v s="$SSH_MARK_START" -v e="$SSH_MARK_END" '$0==s{in_=1;next} $0==e{in_=0} in_ && /^ssh-|^ecdsa-|^sk-/{n++} END{print n+0}' "$SSH_AUTH"
}

# The access file with comments and blank lines stripped:  machine account from...
ssh_access_lines() {
  [[ -f "$SSH_ACCESS" ]] && sed 's/#.*//' "$SSH_ACCESS" | awk 'NF'
  return 0
}

# dwkns-mbp-m5 -> mbp-m5: if every machine shares the same first segment it
# is the owner's name, and the alias is what follows. Otherwise the full name.
ssh_prefix() {
  local first p
  first="$(ssh_access_lines | awk 'NR==1{print $1}')"
  [[ "$first" == *-* ]] || return 0
  p="${first%%-*}-"
  if ssh_access_lines | awk -v p="$p" 'index($1,p)!=1 || length($1)<=length(p){bad=1} END{exit bad}'; then
    printf '%s' "$p"
  fi
  return 0
}
ssh_alias() { local p; p="$(ssh_prefix)"; printf '%s' "${1#"$p"}"; }

# ed25519, made here, never copied anywhere. No passphrase, on purpose: the
# disks are encrypted, a headless machine has nobody to type one, and the
# point is that `ssh mini-m1` just works.
ssh_make_key() {
  ssh_has_key && return 0
  doing "Making this machine's SSH key"
  run mkdir -p "$HOME/.ssh"
  run chmod 700 "$HOME/.ssh"
  run ssh-keygen -q -t ed25519 -a 100 -N "" -C "$USER@$(ssh_machine)" -f "$SSH_KEY"
}

# Put this machine's public key into the repo and push it. The one thing sync
# commits on its own: a public key is safe to publish and always this
# machine's own. Committed by path, so nothing else you have edited rides along.
ssh_share_key() {
  ssh_has_key || return 0
  local me dst; me="$(ssh_machine)"; dst="$SSH_KEYS_DIR/$me.pub"
  ssh_shared && return 0
  doing "Sharing this machine's public key as config/ssh/keys/$me.pub"
  [[ "${DRY_RUN:-0}" == "1" ]] && return 0
  mkdir -p "$SSH_KEYS_DIR" && cp "$SSH_KEY.pub" "$dst"
  git -C "$ROOT_DIR" rev-parse --git-dir >/dev/null 2>&1 || return 0
  git -C "$ROOT_DIR" add -- "$dst"
  git -C "$ROOT_DIR" commit -q -m "Add SSH key for $me" -- "$dst" >/dev/null 2>&1 || true
  if push_repo; then
    ok "Key shared — other machines pick it up on their next sys sync"
  else
    note "The key is committed here and will be pushed by the next sys sync that can"
  fi
  return 0
}

# ~/.ssh/authorized_keys: one managed block holding the keys of the machines
# the access file lets in here. Anything outside the block is left alone,
# except a loose copy of a key the block now carries.
ssh_install_access() {
  local quiet="${1:-}" me row m f want="" missing="" names=""
  me="$(ssh_machine)"
  row="$(ssh_access_lines | awk -v m="$me" '$1==m')"
  if [[ -z "$row" ]]; then
    [[ -z "$quiet" ]] && note "$me is not in config/ssh/access — no machine is let in here"
    return 0
  fi
  set -- $row; shift 2
  for m in "$@"; do
    f="$SSH_KEYS_DIR/$m.pub"
    if [[ -s "$f" ]]; then
      want="$want$(head -1 "$f")"$'\n'; names="$names $(ssh_alias "$m")"
    else
      missing="$missing $(ssh_alias "$m")"
    fi
  done

  local outside="" new
  [[ -f "$SSH_AUTH" ]] && outside="$(awk -v s="$SSH_MARK_START" -v e="$SSH_MARK_END" \
      '$0==s{in_=1;next} $0==e{in_=0;next} !in_' "$SSH_AUTH")"
  if [[ -n "$want" ]]; then
    # awk -v cannot carry newlines, so pass just the key material, space-separated.
    local have; have="$(printf '%s' "$want" | awk '{print $2}' | tr '\n' ' ')"
    outside="$(printf '%s\n' "$outside" | awk -v have="$have" '
      BEGIN{n=split(have,k," "); for(i=1;i<=n;i++) if(k[i]!="") h[k[i]]=1}
      !($2 in h)')"
  fi
  outside="$(printf '%s\n' "$outside" | sed -e :a -e '/^\n*$/{$d;N;ba' -e '}')"   # trim trailing blanks
  new="$(printf '%s\n\n%s\n%s%s\n' "$outside" "$SSH_MARK_START" "$want" "$SSH_MARK_END" | sed '/./,$!d')"

  if [[ -f "$SSH_AUTH" && "$(cat "$SSH_AUTH")" == "$new" ]]; then
    [[ -z "$quiet" ]] && ok "Let in here:${names:- nobody}"
  else
    doing "Letting in:${names:- nobody}"
    if [[ "${DRY_RUN:-0}" != "1" ]]; then
      mkdir -p "$HOME/.ssh" && chmod 700 "$HOME/.ssh"
      printf '%s\n' "$new" > "$SSH_AUTH.tmp" && mv "$SSH_AUTH.tmp" "$SSH_AUTH" && chmod 600 "$SSH_AUTH"
    fi
  fi
  [[ -n "$missing" ]] && note "No key in the repo yet for:$missing — run sys sync there"
  return 0
}

# ~/.ssh/config.d/sys: an alias, address and account for every other machine
# in the access file. ~/.ssh/config gets one Include line at the top; the rest
# of it is yours.
ssh_write_aliases() {
  local quiet="${1:-}" me cfg="$HOME/.ssh/config" inc="Include config.d/*" all="" out
  me="$(ssh_machine)"
  out="# Written by sys from config/ssh/access. Do not edit — sys sync rewrites it."$'\n'
  out="$out# Hand-written hosts belong in ~/.ssh/config, which includes this file."$'\n'
  # Two routes per machine. The Match line wins when the Tailscale name
  # answers on port 22; otherwise the Host block's NAME.local is used, which
  # works on the home network with Tailscale off. HostKeyAlias makes both
  # routes share one known_hosts entry.
  local a
  while read -r m account _; do
    [[ "$m" == "$me" ]] && continue
    a="$(ssh_alias "$m")"; all="$all $a"
    out="$out"$'\n'"Match originalhost $a exec \"~/.system-config/bin/ssh-reach $m\""$'\n'"  HostName $m"$'\n'
    out="$out"$'\n'"Host $a"$'\n'"  HostName $m.local"$'\n'"  User $account"$'\n'"  HostKeyAlias $m"$'\n'
  done < <(ssh_access_lines)
  [[ -n "$all" ]] || { [[ -z "$quiet" ]] && note "No other machines in config/ssh/access"; return 0; }
  out="$out"$'\n'"Host$all"$'\n'
  # accept-new: no "authenticity can't be established" question the first
  # time, on a private tailnet; a *changed* host key is still refused.
  out="$out  IdentityFile ~/.ssh/id_ed25519"$'\n'"  IdentitiesOnly yes"$'\n'"  StrictHostKeyChecking accept-new"$'\n'"  ServerAliveInterval 30"$'\n'
  out="$out  ControlMaster auto"$'\n'"  ControlPath ~/.ssh/cm-%C"$'\n'"  ControlPersist 10m"

  # Left over from the earlier per-machine `sys ssh user`: the account now
  # comes from the access file.
  [[ -f "$HOME/.ssh/config.d/users" ]] && run rm -f "$HOME/.ssh/config.d/users"

  if [[ -f "$SSH_ALIASES" && "$(cat "$SSH_ALIASES")" == "$out" ]]; then
    [[ -z "$quiet" ]] && ok "Aliases:$all"
    return 0
  fi
  doing "Aliases:$all"
  [[ "${DRY_RUN:-0}" == "1" ]] && return 0
  mkdir -p "$HOME/.ssh/config.d" && chmod 700 "$HOME/.ssh" "$HOME/.ssh/config.d"
  printf '%s\n' "$out" > "$SSH_ALIASES" && chmod 600 "$SSH_ALIASES"
  if [[ ! -f "$cfg" ]]; then
    printf '%s\n' "$inc" > "$cfg" && chmod 600 "$cfg"
  elif ! grep -qxF "$inc" "$cfg"; then
    # Prepend: an Include inside a Host block would only apply to that host.
    { printf '%s\n\n' "$inc"; cat "$cfg"; } > "$cfg.tmp" && mv "$cfg.tmp" "$cfg" && chmod 600 "$cfg"
  fi
}

# Everything, in order. Run by setup and by every sync.
ssh_apply() {
  local quiet="${1:-}"
  if [[ ! -f "$SSH_ACCESS" ]]; then
    [[ -z "$quiet" ]] && note "No config/ssh/access in the repo — SSH access not managed"
    return 0
  fi
  ssh_make_key || warn "Could not make an SSH key"
  ssh_share_key
  ssh_install_access "$quiet"
  ssh_write_aliases "$quiet"
  return 0
}

# Lock sshd to keys only. Refuses until at least one key is let in here, so a
# headless machine can never lock itself out. Optional: passwords stay on
# unless you run this.
ssh_harden() {
  local n; n="$(ssh_trusted_count)"
  [[ "$n" -gt 0 ]] || die "No machine is let in here yet — nothing could log in. Check config/ssh/access, then sys sync"
  grep -q '^Include /etc/ssh/sshd_config.d' /etc/ssh/sshd_config 2>/dev/null \
    || die "This sshd does not include /etc/ssh/sshd_config.d — set PasswordAuthentication no in /etc/ssh/sshd_config by hand"

  local content
  content="$(cat <<'CONF'
# Written by `sys ssh harden`. Keys only — a password cannot be guessed at.
PasswordAuthentication no
KbdInteractiveAuthentication no
PubkeyAuthentication yes
PermitRootLogin no
CONF
)"
  if [[ -f "$SSHD_DROPIN" && "$(cat "$SSHD_DROPIN" 2>/dev/null)" == "$content" ]]; then
    note "sshd: already keys only — $n machine(s) can log in"; return 0
  fi
  doing "Locking sshd to keys only — $n machine(s) can log in"
  if [[ "${DRY_RUN:-0}" == "1" ]]; then note "dry run: write $SSHD_DROPIN and restart sshd"; return 0; fi
  printf '%s\n' "$content" | sudo_run tee "$SSHD_DROPIN" >/dev/null || return 1
  if ! sudo_run /usr/sbin/sshd -t; then
    sudo_run rm -f "$SSHD_DROPIN"
    die "sshd rejected that config — removed it again, nothing changed"
  fi
  if is_macos; then
    # launchd starts one sshd per connection, so open sessions are untouched.
    sudo_run launchctl kickstart -k system/com.openssh.sshd 2>/dev/null || true
  else
    sudo_run systemctl restart ssh 2>/dev/null || sudo_run systemctl restart sshd
  fi
  ok "Password logins off. Only the $n machine(s) in config/ssh/access get in."
}
