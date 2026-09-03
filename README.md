# system-config

macOS setup: one command on a new machine, one command to keep it in sync.

## New machine

```bash
curl -fsSL https://raw.githubusercontent.com/dwkns/system-install/main/install.sh | bash
```

Installs Homebrew and everything in the `Brewfile`, copies dotfiles into place,
installs language versions with mise, pulls app licences from 1Password,
installs App Store apps, and applies macOS defaults. It finishes by printing the
handful of steps that need a human (signing into things, granting Full Disk
Access, logging out).

## Day to day

| Command | What it does |
|---|---|
| `sys sync` | Pull the latest config and apply it here (aliased to `usys`) |
| `sys push` | Save this machine's config into the repo and push (aliased to `bsys`) |
| `sys doctor` | Check everything is installed and signed in |
| `sys setup` | Re-run setup, or part of it — see `sys` for flags |

Add `--dry-run` to any of them to see what would happen.

## Layout

```
Brewfile                     apps and CLI tools
macos.sh                     macOS defaults
install.sh                   new-machine entry point
bin/sys                      the only command
lib/common.sh                colours, logging, helpers
lib/sync.sh                  mirrors config between repo and system
lib/setup.sh                 brew, mise, licences, App Store, macOS
dotfiles/                    copied into ~
config/licences              1Password references -> file paths
config/mas-apps.txt          App Store app IDs
config/sublime-config/       copied into Sublime's User dir
colors/                      .clr palettes -> ~/Library/Colors
```

## How syncing works

`lib/sync.sh` holds a three-row table:

```
dotfiles              -> ~
colors                -> ~/Library/Colors
config/sublime-config -> ~/Library/Application Support/Sublime Text/User
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

mise owns Ruby, Node, Python and pnpm. Global versions are in
`dotfiles/.config/mise/config.toml`; override per project with a local
`mise.toml`. Python packages and virtualenvs go through `uv`.

## Licences

Licences live in 1Password, not in this repo and not in the keychain — the
keychain is empty on exactly the new machine you're setting up. `config/licences`
maps a 1Password secret reference to a destination path:

```
op://Private/Sublime Text/license|$HOME/Library/.../License.sublime_license
```

Sign in with `op signin`, then `sys setup --licences`.
