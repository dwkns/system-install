# Everything installed on a new machine. `sys setup` runs `brew bundle` on this.
#
# Languages are NOT here — mise owns those (see dotfiles/.config/mise/config.toml)
# so versions are pinned per-project rather than floating with Homebrew.

# ── CLI ──────────────────────────────────────────────────────────────────────
brew "git"
brew "gh"
brew "tmux"
brew "jq"
brew "mise"             # ruby / node / python versions
brew "uv"               # python packages + venvs
brew "duti"             # sets Ghostty as the default terminal
brew "mas"              # App Store installs
brew "wget"             # file retriever

# Native gem build dependencies. mise installs Ruby as a prebuilt binary, so
# these are not needed for `mise install` — but gems with C extensions
# (nokogiri, sqlite3, ffi) fail to build without them.
brew "autoconf"
brew "libyaml"
brew "libffi"
brew "pkgconf"

# ── Terminal & editors ───────────────────────────────────────────────────────
cask "ghostty"
cask "sublime-text"
cask "visual-studio-code"
cask "cursor"
cask "claude"           # Claude desktop app
cask "font-fira-code"
cask "font-inter"

# ── Network ──────────────────────────────────────────────────────────────────
cask "tailscale-app"    # mesh VPN — needed to reach anything on the tailnet

# ── Password manager ─────────────────────────────────────────────────────────
cask "1password"

# ── Browsers ─────────────────────────────────────────────────────────────────
cask "google-chrome"
cask "firefox@developer-edition"

# ── Design ───────────────────────────────────────────────────────────────────
cask "sketch"
cask "omnigraffle"
# cask "figma"

# ── Everything else ──────────────────────────────────────────────────────────
cask "typora"
cask "notion"
cask "iina"
cask "transmission"     # macos.sh configures this, so it must be installed
cask "handbrake-app"    # video transcoder
cask "soulver"          # notepad with a calculator
cask "whatsapp"
cask "nordvpn"     # .macos configures this, so it must be installed
cask "ollama-app" 

# cask "obsidian"
# cask "slack"
# cask "discord"
# cask "postman"
# cask "zoom"