#!/usr/bin/env bash
# SSH between your own machines. One key per machine, host aliases generated
# from the tailnet, and sshd locked to keys once they are known to work.
#
# Nothing here is written into the repo — it is public. Keys stay on the
# machine that made them; aliases are regenerated from Tailscale on demand.

source "${ROOT_DIR:-$HOME/.system-config}/lib/common.sh"

SSH_KEY="$HOME/.ssh/id_ed25519"
SSH_ALIASES="$HOME/.ssh/config.d/sys"                 # generated, safe to delete
SSHD_DROPIN="/etc/ssh/sshd_config.d/00-sys-keys-only.conf"
SSH_TEST="ssh -o BatchMode=yes -o ConnectTimeout=6 -o PasswordAuthentication=no -o KbdInteractiveAuthentication=no"

ssh_has_key()       { [[ -f "$SSH_KEY" && -f "$SSH_KEY.pub" ]]; }
ssh_keys_only()     { [[ -f "$SSHD_DROPIN" ]] && grep -q '^PasswordAuthentication no' "$SSHD_DROPIN" 2>/dev/null; }
ssh_trusted_count() { grep -cE '^(ssh-|ecdsa-|sk-)' "$HOME/.ssh/authorized_keys" 2>/dev/null || echo 0; }

# ed25519, made here, never copied anywhere. No passphrase, on purpose: the
# disks are encrypted, a headless machine has no one to type it, and the
# whole point is that `ssh mini-m1` just works.
ssh_make_key() {
  if ssh_has_key; then note "Key: already have $SSH_KEY"; return 0; fi
  doing "Making this machine's SSH key"
  run mkdir -p "$HOME/.ssh"
  run chmod 700 "$HOME/.ssh"
  run ssh-keygen -q -t ed25519 -a 100 -N "" -C "$USER@$(hostname -s)" -f "$SSH_KEY"
}

# ~/.ssh/config.d/sys: one alias per machine on the tailnet — mbp-m5 for
# dwkns-mbp-m5 — rewritten each time, so renames and new machines flow
# through. ~/.ssh/config gets one Include line at the top; the rest is yours.
ssh_write_aliases() {
  local quiet="${1:-}" generated cfg="$HOME/.ssh/config" inc="Include config.d/*"
  generated="$("$ROOT_DIR/bin/ssh-hosts" --generate 2>/dev/null)" || {
    [[ -z "$quiet" ]] && warn "Could not read the tailnet — is Tailscale running and signed in?"
    return 1
  }
  if [[ -f "$SSH_ALIASES" ]] && [[ "$(cat "$SSH_ALIASES")" == "$generated" ]]; then
    [[ -z "$quiet" ]] && note "Aliases: already current in $SSH_ALIASES"
    return 0
  fi
  doing "Writing host aliases to $SSH_ALIASES"
  if [[ "${DRY_RUN:-0}" == "1" ]]; then
    printf '%s\n' "$generated" | sed 's/^/      /'
    return 0
  fi
  mkdir -p "$HOME/.ssh/config.d" && chmod 700 "$HOME/.ssh" "$HOME/.ssh/config.d"
  printf '%s\n' "$generated" > "$SSH_ALIASES" && chmod 600 "$SSH_ALIASES"

  if [[ ! -f "$cfg" ]]; then
    printf '%s\n' "$inc" > "$cfg" && chmod 600 "$cfg"
  elif ! grep -qxF "$inc" "$cfg"; then
    # Prepend: an Include inside a Host block would only apply to that host.
    { printf '%s\n\n' "$inc"; cat "$cfg"; } > "$cfg.tmp" && mv "$cfg.tmp" "$cfg" && chmod 600 "$cfg"
  fi
  local n; n="$(grep -c '^Host ' "$SSH_ALIASES")"
  ok "$((n - 1)) alias(es) ready — 'sys ssh' lists them"
}

ssh_setup() {
  ssh_make_key || return 1
  ssh_write_aliases || return 1
  [[ "${DRY_RUN:-0}" == "1" ]] && return 0
  echo
  note "This machine's public key — safe to share, useless without the private half:"
  note "$(cat "$SSH_KEY.pub")"
  note "To let this machine into another one, run 'sys ssh trust <that-alias>' here."
}

# Put this machine's key on another machine, then prove it works.
ssh_trust() {
  [[ $# -gt 0 ]] || die "Which machine? sys ssh trust <alias> — 'sys ssh' lists them"
  ssh_has_key || die "No key here yet — run 'sys ssh setup' first"
  local host rc=0
  for host in "$@"; do
    if [[ "${DRY_RUN:-0}" == "1" ]]; then note "dry run: ssh-copy-id -i $SSH_KEY.pub $host"; continue; fi
    if $SSH_TEST "$host" true 2>/dev/null; then
      note "$host: already accepts this machine's key"; continue
    fi
    doing "Putting this machine's key on $host — you will be asked for its password"
    ssh-copy-id -i "$SSH_KEY.pub" "$host" 2>&1 | grep -vE '^(/usr/bin/ssh-copy-id|Number of key|Now try|$)' || true
    if $SSH_TEST "$host" true 2>/dev/null; then
      ok "$host: key login works — ssh $host"
    else
      # Show what the other side actually said, rather than guessing.
      local why   # `|| true`: under set -e a failing substitution would end the script here
      why="$({ $SSH_TEST "$host" true 2>&1 || true; } | grep -v '^Warning: Permanently added' | tail -1)"
      warn "$host: key login still fails — $why"
      case "$why" in
        *"tailnet policy"*) note "That machine has Tailscale SSH on, which ignores keys. On it: sudo tailscale set --ssh=false" ;;
        *"Permission denied"*) note "The key did not get on. Is Remote Login on there, and was the password right?" ;;
        *"Connection refused"*|*"timed out"*) note "Nothing is listening for SSH there, or it is asleep." ;;
      esac
      rc=1
    fi
  done
  return $rc
}

# Lock sshd to keys only. Refuses until at least one key is authorised here,
# so a headless machine can never lock itself out.
ssh_harden() {
  local n; n="$(ssh_trusted_count)"
  [[ "$n" -gt 0 ]] || die "No keys in ~/.ssh/authorized_keys yet — nothing could log in. From another machine: sys ssh trust <this one>"
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
    note "sshd: already keys only — $n key(s) can log in"; return 0
  fi

  doing "Locking sshd to keys only — $n key(s) can log in"
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
  ok "Password logins off. Only the $n key(s) in ~/.ssh/authorized_keys get in."
}
