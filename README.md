# system-config

macOS setup: one command on a new machine, one command to keep it in sync.

## New machine

```bash
curl -fsSL https://raw.githubusercontent.com/dwkns/system-install/master/install.sh | bash
```

Installs Homebrew and everything in the `Brewfile`, copies dotfiles into place,
installs language versions with mise, restores app licences from the keychain,
installs App Store apps, and applies macOS defaults. It finishes by printing the
handful of steps that need a human (signing into things, granting Full Disk
Access, logging out).

## Day to day

| Command | What it does |
|---|---|
| `sys sync` | Pull the latest config and apply it here (aliased to `usys`) |
| `sys push` | Save this machine's config into the repo and push (aliased to `bsys`) |
| `sys doctor` | Check everything is installed and signed in |
| `sys alias` | List your aliases, functions and project starters (aliased to `la`) |
| `sys mise` | How to use mise and uv |
| `sys extras` | Install optional extras (Office, Xcode, ollama, duckdb) |
| `sys dock` | Rebuild the Dock from `config/dock` |
| `sys remove` | Undo everything setup installed (asks first; `--dryrun` previews) |
| `sys setup` | Re-run setup, or part of it — see `sys` for flags |

Add `--dry-run` to any of them to see what would happen.

Full documentation: `man sys`

## Starting over

`bin/uninstall` removes everything setup installed — Homebrew and its packages,
mise toolchains, the dotfiles it copied, editor config, and the Dock — without
erasing macOS. SSH and Screen Sharing are left alone, so a headless machine
stays reachable.

```bash
sys remove --dryrun   # list what would be removed, change nothing
sys remove            # list it, then ask before removing
```

Afterwards it prints the commands to create a fresh admin user with remote
login and Screen Sharing enabled — the way to start over on a headless Mac.

**Do not use Erase All Content and Settings on a headless Mac.** It reboots
into Setup Assistant, which needs a physical keyboard and display — you would
lose remote access until someone attaches a screen.

## Layout

```
Brewfile                     apps and CLI tools
Brewfile.optional            optional extras (`sys extras`)
macos.sh                     macOS defaults
install.sh                   new-machine entry point
bin/sys                      the only command
man/man1/sys.1               man page (`man sys`)
lib/common.sh                colours, logging, helpers
lib/sync.sh                  mirrors config between repo and system
lib/setup.sh                 brew, mise, licences, App Store, macOS
dotfiles/                    copied into ~
config/licences              keychain service names -> file paths
config/mas-apps.txt          App Store app IDs
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

## Licences

Licences live in the macOS keychain, never in this repo. `config/licences` maps
a keychain service name to a destination path:

```
sublime-text-license|$HOME/Library/.../License.sublime_license
```

Add one to the keychain:

```bash
openssl base64 -A -in License.sublime_license |
  security add-generic-password -U -a "$USER" -s sublime-text-license -w "$(cat)"
```

Then `sys setup --licences` writes it into place. The keychain does not follow
you to a new Mac, so on a fresh machine setup will tell you which licences are
missing and print the exact command to add each one. `sys doctor` reports the
same thing.
