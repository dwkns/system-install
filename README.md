# System Configuration

Highly opinionated macOS bootstrap + dotfiles repository.

**Read scripts before running. If you don't understand it, don't run it.**

---

## Table of Contents

- [Quick Start](#quick-start)
- [What This Does](#what-this-does)
- [Architecture Overview](#architecture-overview)
- [Directory Structure](#directory-structure)
- [How It All Fits Together](#how-it-all-fits-together)
- [Commands Reference](#commands-reference)
- [Making Changes](#making-changes)
- [Configuration Files](#configuration-files)
- [Troubleshooting](#troubleshooting)

---

## Quick Start

### Fresh Mac Setup

```bash
# Clone the repository
git clone https://github.com/dwkns/system-install.git ~/.system-config

# Run the bootstrap
~/.system-config/bin/bootstrap --yes
```

Or use the one-liner (downloads and runs install.sh):

```bash
bash <(curl -s https://raw.githubusercontent.com/dwkns/system-install/master/install.sh)
```

### Update Existing System

```bash
usys    # Shell alias that pulls latest config and applies it
```

---

## What This Does

The bootstrap process:

1. **Homebrew** - Installs Homebrew and all packages from `Brewfile`
2. **Dotfiles** - Copies shell configs, git settings, etc. to `~/`
3. **Preferences** - Installs macOS app preferences (`.plist` files)
4. **Colors** - Installs color palettes (`.clr` files)
5. **macOS Defaults** - Applies system preferences via `.macos` script
6. **App Store** - Optionally installs Mac App Store apps

---

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────────────────┐
│                           COMMANDS (bin/)                                │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐  │
│  │bootstrap │  │  backup  │  │ restore  │  │  doctor  │  │   mas    │  │
│  └────┬─────┘  └────┬─────┘  └────┬─────┘  └────┬─────┘  └────┬─────┘  │
└───────┼─────────────┼─────────────┼─────────────┼─────────────┼────────┘
        │             │             │             │             │
        v             v             v             v             v
┌─────────────────────────────────────────────────────────────────────────┐
│                          LIBRARIES (lib/)                                │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐  │
│  │common.sh │  │dotfiles. │  │  prefs.  │  │ colors.  │  │  brew.   │  │
│  │(base)    │  │   sh     │  │   sh     │  │   sh     │  │   sh     │  │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘  └──────────┘  │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐                              │
│  │colours.sh│  │ macos.sh │  │  mas.sh  │                              │
│  │(colors)  │  │          │  │          │                              │
│  └──────────┘  └──────────┘  └──────────┘                              │
└─────────────────────────────────────────────────────────────────────────┘
        │             │             │             │             │
        v             v             v             v             v
┌─────────────────────────────────────────────────────────────────────────┐
│                       DATA FILES (config/, dotfiles/, etc.)              │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐  │
│  │.dotfiles │  │.aliases. │  │.projects.│  │ Brewfile │  │mas-apps. │  │
│  │  list    │  │  json    │  │  json    │  │          │  │  txt     │  │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘  └──────────┘  │
└─────────────────────────────────────────────────────────────────────────┘
        │             │             │             │             │
        v             v             v             v             v
┌─────────────────────────────────────────────────────────────────────────┐
│                         SYSTEM LOCATIONS                                 │
│  ~/.zshrc        ~/Library/Preferences/     ~/Library/Colors/           │
│  ~/.gitconfig    /opt/homebrew/             Mac App Store               │
│  ~/.macos        ~/Library/Preferences/                                 │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## Directory Structure

```
~/.system-config/
├── bin/                      # Executable commands
│   ├── backup               # Create configuration backup
│   ├── bootstrap            # Full system setup
│   ├── doctor               # System health check
│   ├── mas                  # Install App Store apps
│   └── restore              # Restore from backup
│
├── lib/                      # Shared library scripts
│   ├── common.sh            # Core utilities (logging, helpers)
│   ├── colours.sh           # Terminal color definitions
│   ├── dotfiles.sh          # Dotfile install/backup
│   ├── preferences.sh       # macOS prefs install/backup
│   ├── colors.sh            # Color palette install/backup
│   ├── brew.sh              # Homebrew management
│   ├── macos.sh             # macOS system settings
│   └── mas.sh               # Mac App Store management
│
├── config/                   # Configuration data
│   ├── .dotfiles            # List of dotfiles to manage
│   ├── .aliases.json        # Shell alias definitions
│   ├── .projects.json       # Project template definitions
│   └── mas-apps.txt         # Mac App Store apps to install
│
├── dotfiles/                 # Actual dotfile contents
│   ├── .zshrc               # Zsh configuration
│   ├── .gitconfig           # Git configuration
│   ├── .macos               # macOS defaults script
│   └── ...                  # Other dotfiles
│
├── preferences/              # macOS preference files
│   └── com.googlecode.iterm2.plist
│
├── colors/                   # Color palette files
│   ├── AP.clr
│   └── Arcanix.clr
│
├── project-scripts/          # Project skeleton scripts
│   ├── common.sh            # Shared project utilities
│   ├── eleventy-projects.sh
│   ├── node-project-skeleton.sh
│   ├── ruby-project-skeleton.sh
│   └── bash-executable-skeleton.sh
│
├── backups/                  # Auto-created backup storage
│   └── YYYYMMDD-HHMMSS/
│
├── Brewfile                  # Homebrew packages
├── install.sh                # Remote installation script
└── README.md                 # This file
```

---

## How It All Fits Together

### The Library Layer (`lib/`)

All functionality is organized into library scripts that can be sourced and reused:

| Library | Purpose | Key Functions |
|---------|---------|---------------|
| `common.sh` | Base utilities | `log`, `warn`, `die`, `run`, `has_cmd`, `ensure_dir` |
| `colours.sh` | Terminal colors | Color variables (`$GREEN`, `$RED`), `doing`, `warn`, `error` |
| `dotfiles.sh` | Dotfile sync | `install_dotfiles`, `backup_dotfiles`, `read_dotfiles` |
| `preferences.sh` | Plist files | `install_preferences`, `backup_preferences` |
| `colors.sh` | Color palettes | `install_colors`, `backup_colors` |
| `brew.sh` | Homebrew | `install_homebrew`, `brew_bundle` |
| `macos.sh` | System prefs | `set_machine_name`, `apply_macos_defaults` |
| `mas.sh` | App Store | `install_mas_apps`, `mas_signed_in` |

### The Command Layer (`bin/`)

Commands are thin wrappers that source libraries and call their functions:

```bash
# Example: How bin/backup works
source "$ROOT_DIR/lib/common.sh"
source "$ROOT_DIR/lib/dotfiles.sh"
source "$ROOT_DIR/lib/preferences.sh"
source "$ROOT_DIR/lib/colors.sh"

backup_dotfiles "$backup_root/dotfiles"
backup_preferences "$backup_root/preferences"
backup_colors "$backup_root/colors"
```

### Data Flow

```
INSTALL FLOW (bootstrap, usys):
Repository Files  →  System Locations
dotfiles/.zshrc   →  ~/.zshrc
preferences/*.plist → ~/Library/Preferences/
colors/*.clr      →  ~/Library/Colors/

BACKUP FLOW (backup):
System Locations    →  Repository/Backup
~/.zshrc            →  backups/TIMESTAMP/dotfiles/
~/Library/Prefs/    →  backups/TIMESTAMP/preferences/
~/Library/Colors/   →  backups/TIMESTAMP/colors/
```

---

## Commands Reference

### `bootstrap`

Full system setup for a new Mac.

```bash
bootstrap                        # Run with defaults
bootstrap --yes                  # Skip confirmation prompts
bootstrap --dry-run              # Preview without executing
bootstrap --no-brew              # Skip Homebrew
bootstrap --no-dotfiles          # Skip dotfiles/prefs/colors
bootstrap --no-macos             # Skip macOS defaults
bootstrap --mas                  # Include App Store apps
bootstrap --machine-name "name"  # Set computer name
```

### `backup`

Create a snapshot of current configuration.

```bash
backup                           # Backup to timestamped directory
backup --target /path/to/dir     # Backup to specific location
```

### `restore`

Restore configuration from a backup.

```bash
restore --from ~/.system-config/backups/20240215-143052
```

### `doctor`

Check system health and configuration status.

```bash
doctor
```

### `mas`

Install Mac App Store applications.

```bash
mas
```

### Shell Aliases (from `.zshrc`)

```bash
usys    # Update system config (git pull + install all)
la      # List all aliases
lp      # List all project templates
```

---

## Making Changes

### Adding a New Dotfile

1. **Add the file to the list:**
   ```bash
   echo ".newconfig" >> ~/.system-config/config/.dotfiles
   ```

2. **Add the actual file:**
   ```bash
   cp ~/.newconfig ~/.system-config/dotfiles/.newconfig
   ```

3. **Apply changes:**
   ```bash
   usys
   ```

### Adding a New Preference File

Preferences use a **whitelist approach** - only files that exist in `preferences/` are managed.

1. **Find the app's plist:**
   ```bash
   ls ~/Library/Preferences/ | grep appname
   ```

2. **Copy it to the repo:**
   ```bash
   cp ~/Library/Preferences/com.app.plist ~/.system-config/preferences/
   ```

3. **Now `backup` and `install_preferences` will track it.**

### Adding Color Palettes

1. **Create colors in any app** (use the color picker)
2. **Run backup:**
   ```bash
   backup
   # or just copy manually:
   cp ~/Library/Colors/*.clr ~/.system-config/colors/
   ```

### Adding Homebrew Packages

1. **Edit the Brewfile:**
   ```bash
   # CLI tools
   brew "ripgrep"
   
   # GUI apps
   cask "visual-studio-code"
   
   # Fonts
   cask "font-fira-code"
   ```

2. **Apply:**
   ```bash
   brew bundle --file ~/.system-config/Brewfile
   ```

### Adding Mac App Store Apps

1. **Find the app ID:**
   ```bash
   mas search "app name"
   ```

2. **Add to list:**
   ```bash
   echo "497799835 Xcode" >> ~/.system-config/config/mas-apps.txt
   ```

3. **Install:**
   ```bash
   mas
   # or: bootstrap --mas
   ```

### Adding a New Shell Alias

1. **Edit `config/.aliases.json`:**
   ```json
   {
     "name": "myalias",
     "description": "Description of what it does",
     "command": "actual command here",
     "category": "general"
   }
   ```

2. **Reload shell:**
   ```bash
   source ~/.zshrc
   ```

### Adding a New Project Template

1. **Create the script in `project-scripts/`:**
   ```bash
   # project-scripts/my-template.sh
   source "$SYS_FILES_ROOT/project-scripts/common.sh"
   # ... your logic
   ```

2. **Add to `config/.projects.json`:**
   ```json
   {
     "name": "myproj",
     "description": "My project template",
     "command": "myproj",
     "category": "category",
     "repo": "https://github.com/user/template.git",
     "script": "project-scripts/my-template.sh"
   }
   ```

3. **Reload shell:**
   ```bash
   source ~/.zshrc
   ```

---

## Configuration Files

### `config/.dotfiles`

Plain text list of dotfiles to manage. One file per line, relative to home directory.

```
.zshrc
.gitconfig
.config/nvim/init.vim
# Comments start with #
```

### `config/.aliases.json`

JSON array of shell alias definitions.

```json
{
  "aliases": [
    {
      "name": "alias_name",
      "description": "What it does",
      "command": "actual command",
      "category": "category_name",
      "warning": "optional warning message"
    }
  ]
}
```

### `config/.projects.json`

JSON array of project template definitions.

```json
{
  "projects": [
    {
      "name": "function_name",
      "description": "Description",
      "command": "function_name",
      "category": "category",
      "repo": "https://github.com/user/repo.git",
      "script": "project-scripts/script-name.sh"
    }
  ]
}
```

### `config/mas-apps.txt`

Mac App Store apps to install. Format: `APP_ID APP_NAME`

```
497799835 Xcode
409183694 Keynote
# Comments start with #
```

### `Brewfile`

Homebrew packages. Uses Homebrew Bundle format.

```ruby
tap "homebrew/cask-fonts"
brew "git"
brew "node"
cask "visual-studio-code"
cask "font-fira-code"
mas "Xcode", id: 497799835
```

---

## Troubleshooting

### "command not found: usys"

The `.zshrc` hasn't been sourced yet.

```bash
source ~/.zshrc
```

### Dotfiles not updating

Make sure the file is in `config/.dotfiles`:

```bash
cat ~/.system-config/config/.dotfiles | grep filename
```

### Preferences not taking effect

Some apps cache preferences. Try:

```bash
# Restart the app, or:
killall cfprefsd
# Then restart the app
```

### mas: "Not signed in"

Open App Store.app and sign in manually, then try again.

### Bootstrap fails midway

Re-run with specific flags to skip completed steps:

```bash
bootstrap --no-brew --no-macos
```

### Changes not showing after usys

Check if there were errors during installation:

```bash
# Run manually to see output
install_dotfiles
install_preferences
install_colors
```

### Color palettes not showing in apps

1. Ensure files are in `~/Library/Colors/`
2. Restart the application
3. Open the color picker (the palettes appear in the third tab)

---

## Optional Apps

Add any of these to `Brewfile` if you want them installed automatically:

- whatsapp, handbrake, transmission, charles
- microsoft-office, loom, nordvpn
- parallels, elgato-control-center

---

## Extras

- `~/.system-config/bin/doctor` - System health checks
- `Brewfile` - CLI + app installs via Homebrew
- `config/mas-apps.txt` - App Store apps

---

## Contributing

1. Make changes to the relevant files
2. Test with `--dry-run` if available
3. Commit and push to your fork
4. The `usys` command will pull and apply changes on other machines
