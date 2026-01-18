## System Install
Highly opinionated macOS bootstrap + dotfiles repo.  
Read scripts before running. If you don’t understand it, don’t run it.

## Quick start
```bash
bash <(curl -s https://raw.githubusercontent.com/dwkns/system-install/master/install.sh)
```

## What this does
- Installs Homebrew packages from `Brewfile`
- Installs dotfiles from `dotfiles/`
- Applies macOS defaults from `dotfiles/.macos`
- Optionally installs Mac App Store apps via `config/mas-apps.txt`

## Usage
```bash
~/.system-config/bin/bootstrap --yes
~/.system-config/bin/bootstrap --no-macos
~/.system-config/bin/bootstrap --mas
~/.system-config/bin/bootstrap --machine-name "dwkns-mac"
```

## Backups and restore
```bash
~/.system-config/bin/backup
~/.system-config/bin/restore --from ~/.system-config/backups/YYYYMMDD-HHMMSS
```

## App Store apps
```bash
~/.system-config/bin/mas
```

## Dotfiles list
Dotfiles are controlled by `dotfiles/.dotfiles`. Add/remove entries there.

## Optional apps
Add any of these to `Brewfile` if you want them installed automatically:
- whatsapp, handbrake, transmission, charles, microsoft-office, loom, nordvpn
- parallels, snaps scan, elgato control

## Extras
- `~/.system-config/bin/doctor` for system checks
- `Brewfile` for CLI + app installs
