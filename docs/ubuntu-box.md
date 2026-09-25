# The Ubuntu box — dwkns-mbp-ubuntu

An old MacBook Pro running Ubuntu Server, on the tailnet at
`dwkns-mbp-ubuntu`. Account `admin`, with passwordless sudo. `sys` runs here,
but only does a subset — see below.

Written down because most of what is on it comes from vendor apt repositories
with their own signing keys, which `sys` deliberately does not set up. If the
disk dies, this is the rebuild list.

## What `sys sync` does here

1. Updates the repo in `~/.system-config`.
2. Installs anything missing from `config/apt-packages`.
3. Copies the shared dotfiles (`.config/tmux/tmux.conf`) — not the Mac ones,
   which are all Homebrew, macOS paths and `duti`.
4. Applies SSH access from `config/ssh/access`.

No Homebrew, no mise, no macOS defaults. Install it with:

```bash
curl -fsSL https://raw.githubusercontent.com/dwkns/system-install/master/bin/ssh-access | bash
```

## Installed by hand, from vendor repositories

Each needs its repository and signing key adding before the package exists.
Follow the vendor's current instructions rather than anything copied here —
these change, and a stale keyring command is worse than none.

- **Docker** — `docker-ce`, `docker-ce-cli`, `containerd.io`, plus the
  `buildx`, `compose` and `model` plugins. From Docker's own repository.
- **Tailscale** — `tailscale` and `tailscale-archive-keyring`, from
  Tailscale's repository. This is how every other machine reaches the box.
- **cloudflared** — Cloudflare's tunnel client, from their repository.

## Running on it

- A Docker container `deploy-web-1`, from the image `lift-backend:latest`.
  That stack belongs with the application it serves, not here.
- `openssh-server`, `avahi-daemon` and `ufw` (Ubuntu's firewall) are present
  from the base install.

## Ordinary packages

Anything from Ubuntu's own repositories goes in `config/apt-packages`, one per
line, and installs itself on the next `sys sync` here. `tmux` is there now.
