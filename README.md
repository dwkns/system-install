# system-config

macOS setup: one command on a new machine, one command to keep it in sync.

## New machine

```bash
curl -fsSL https://raw.githubusercontent.com/dwkns/system-install/master/install.sh | bash
```

Installs Homebrew and everything in the `Brewfile`, copies dotfiles into place,
installs language versions with mise, installs App Store apps, and applies
macOS defaults. It finishes by printing the
handful of steps that need a human (signing into things, granting Full Disk
Access, logging out).

## Day to day

| Command | What it does |
|---|---|
| `sys sync` | Pull the latest config and apply it here (aliased to `usys`) |
| `sys push` | Save this machine's config into the repo and push (aliased to `bsys`) |
| `sys doctor` | Check everything is installed and signed in |
| `sys edit` | Open this config folder in VS Code (aliased to `esys`) |
| `sys alias` | List your aliases, functions and project starters (aliased to `la`) |
| `sys mise` | How to use mise and uv |
| `sys extras` | Install optional extras (Office, Xcode, ollama, duckdb) |
| `sys dock` | Rebuild the Dock from `config/dock` |
| `sys hostname` | Set the computer name (asks, or `sys hostname my-mac`) |
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

Then run the installer again. Because it leaves your account and remote access
alone, a headless machine stays reachable throughout.

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
lib/setup.sh                 brew, mise, App Store, macOS, the Dock
dotfiles/                    copied into ~
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

