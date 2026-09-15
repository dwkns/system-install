# system-config

macOS setup: one command on a new machine, one command to keep it in sync.

## New machine

```bash
curl -fsSL https://raw.githubusercontent.com/dwkns/system-install/master/install.sh | bash
```

Installs Homebrew and everything in the `Brewfile`, copies dotfiles into place,
installs language versions with mise, downloads and verifies MailExporter
from its GitHub release, installs App Store apps, and applies macOS defaults. It finishes by printing the
handful of steps that need a human (signing into things, granting Full Disk
Access, logging out).

It asks for your password once, at the start, and never again during the run.
It turns on Remote Login and Screen Sharing, so you can `ssh` or `vnc://` in once it finishes.
It names the Mac `dwkns-<type>-<chip>` — for example `dwkns-mbp-m1` or
`dwkns-mini-m4` — unless you type something else within fifteen seconds. When
it finishes it opens a fresh shell with the new config loaded.

## Day to day

| Command | What it does |
|---|---|
| `sys sync` | Reconcile with GitHub in either direction, then apply it here (aliased to `usys`) |
| `sys push` | Save this machine's config into the repo and push (aliased to `bsys`) |
| `sys doctor` | Check everything is installed and signed in |
| `sys edit` | Open this config folder in VS Code (aliased to `esys`) |
| `sys ssh` | List hosts you can reach over SSH (read live; nothing stored) |
| `sys ssh setup` | Make this machine's SSH key and an alias for every machine on the tailnet |
| `sys ssh user <alias> <account>` | Which account to log in as on that machine (kept locally, not in the repo) |
| `sys ssh trust <alias>` | Let this machine into another one — asks for its password once, never again |
| `sys ssh harden` | Keys only on this machine; refuses until at least one key can get in |
| `sys alias` | List your aliases, functions and project starters (aliased to `la`) |
| `sys mise` | How to use mise and uv |
| `sys extras` | Install optional extras (Office, Xcode, ollama, duckdb) |
| `sys dock` | Rebuild the Dock from `config/dock` |
| `sys hostname` | Set the computer name (asks, or `sys hostname my-mac`) |
| `sys remove` | Undo everything setup installed (asks first; `--dryrun` previews) |
| `sys setup` | Re-run setup, or part of it — see `sys` for flags |

Add `--dry-run` to any of them to see what would happen, or `--force` to
`sys sync` to reinstall everything even when nothing has changed.

Full documentation: `man sys`

## SSH between machines

Every machine makes its own key and never shares the private half. Aliases
are generated from Tailscale, so `ssh mbp-m5` works from anywhere, not just
at home. Nothing about hosts or keys is stored in this repo — it is public.

Which machine may log in where is decided by where you run `sys ssh trust`:
it puts *this* machine's key on the one you name. Run it on the machine that
should be doing the logging in.

```bash
sys ssh setup                        # once per machine: key + aliases
sys ssh trust mini-m1 mbp-ubuntu     # from the laptops: they can reach everything
sys ssh trust mbp-ubuntu             # from the mini: it can reach the Ubuntu box
sys ssh harden                       # on each machine, once a key works: no passwords
```

`sys sync` refreshes the aliases on any machine that has run `sys ssh setup`,
so a renamed or new machine shows up everywhere. `sys doctor` reports whether
this machine has a key and whether password logins are still on.

The Ubuntu box is not a Mac and does not run `sys`. It only has to accept
keys from the Macs (done from their side) and hold one key for the mini:

```bash
ssh-keygen -t ed25519 -a 100 -N "" -C "$USER@$(hostname -s)" -f ~/.ssh/id_ed25519
ssh-copy-id -i ~/.ssh/id_ed25519.pub dwkns@dwkns-mini-m1   # MagicDNS name, no alias needed
```

Once its own logins work by key, drop `PasswordAuthentication no` and
`KbdInteractiveAuthentication no` into `/etc/ssh/sshd_config.d/00-keys-only.conf`
and run `sudo systemctl restart ssh`.

## Starting over

`bin/uninstall` removes everything setup installed — Homebrew and its packages,
mise toolchains, the dotfiles it copied, editor config, and the Dock — without
erasing macOS. SSH and Screen Sharing are left alone, so a headless machine
stays reachable.

```bash
sys remove --dryrun   # list what would be removed, change nothing
sys remove            # list it, then ask before removing
```

Then run the installer again. Because it leaves your account and remote access
alone, a headless machine stays reachable throughout.

**Do not use Erase All Content and Settings on a headless Mac.** It reboots
into Setup Assistant, which needs a physical keyboard and display — you would
lose remote access until someone attaches a screen.

## Layout

```
Brewfile                     apps and CLI tools
Brewfile.optional            optional extras (`sys extras`)
bin/set-dock                 writes the Dock in one atomic operation
macos.sh                     macOS defaults
install.sh                   new-machine entry point
bin/sys                      the only command
man/man1/sys.1               man page (`man sys`)
lib/common.sh                colours, logging, helpers
lib/sync.sh                  mirrors config between repo and system
lib/setup.sh                 brew, mise, App Store, macOS, the Dock
dotfiles/                    copied into ~
config/mas-apps.txt          App Store app IDs
config/input                 keyboard and trackpad, applied on every sync
config/desktop-colour        solid desktop colour, applied once at setup
config/sublime-config/       copied into Sublime's User dir
config/cursor/               copied into Cursor's User dir
config/cursor-extensions.txt Cursor extensions, installed by `sys setup`
colors/                      .clr palettes -> ~/Library/Colors
```

## How syncing works

`lib/sync.sh` holds a three-row table:

```
dotfiles              -> ~
colors                -> ~/Library/Colors
config/sublime-config -> ~/Library/Application Support/Sublime Text/User
config/cursor         -> ~/Library/Application Support/Cursor/User
```

**The contents of each repo directory are the manifest.** To track a new file,
put it in the right directory — there's no list to update. To stop tracking one,
delete it.

`sys sync` treats the repo as the source of truth and overwrites. Before
replacing a system file whose contents differ, it copies the old version to
`.drift/` and says so — so a local edit you forgot to `sys push` is never lost,
but a legitimate update from the repo still installs. `.drift/` is overwritten
each run rather than accumulating. Git is the history; there is no `backups/`.

## Languages

mise owns Ruby, Node and Python. Global versions are in
`dotfiles/.config/mise/config.toml`; override per project with a local
`mise.toml`. Python packages and virtualenvs go through `uv`.

