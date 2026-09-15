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
| `sys ssh` | List the machines you can reach over SSH, and what is on your tailnet |
| `sys ssh apply` | Apply `config/ssh/access` here now (`sys sync` does this anyway) |
| `sys ssh harden` | Keys only on this machine — optional; passwords stay on otherwise |
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

One file in the repo says who may log in where:

```
# config/ssh/access
# machine            account   may be logged into from
dwkns-mbp-m5         dwkns     dwkns-mbp-m1
dwkns-mbp-m1         dwkns     dwkns-mbp-m5
dwkns-mini-m1        dwkns     dwkns-mbp-m5  dwkns-mbp-m1  dwkns-mbp-ubuntu
dwkns-mbp-ubuntu     admin     dwkns-mbp-m5  dwkns-mbp-m1  dwkns-mini-m1
```

Every `sys sync` applies it. On each machine that means: make its own key if
it has none, share the public half into `config/ssh/keys/` (the one thing
sync commits by itself — a public key is safe to publish, and it is always the
machine's own), install the keys of the machines let in here, and write an
alias for every other machine. So `ssh mini-m1` just works, from anywhere
Tailscale reaches, as the right account, with no password. Passwords stay on
as a fallback unless you run `sys ssh harden`.

Private keys never leave the machine that made them. Nothing here ever types
a password or copies a key by hand.

**A new Mac** needs nothing beyond the installer. Its key is shared on the first
sync; if the machine has no GitHub login yet, sync signs you in through `gh`
once, in the browser, and carries on. Add the new machine to `config/ssh/access` on
any machine and `sys push`; every other machine follows on its next sync.

**The Ubuntu box** does not run `sys`. It runs one command instead, once to
set up and again whenever a machine is added:

```bash
curl -fsSL https://raw.githubusercontent.com/dwkns/system-install/master/bin/ssh-access | bash
```

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
lib/ssh.sh                   SSH keys, access and aliases from config/ssh/access
bin/ssh-access               the one command for a machine that does not run sys
config/ssh/access            who may log in where, and as which account
config/ssh/keys/             each machine's public key, shared by sys sync
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

