# ~/.zshrc — managed by ~/.system-config
[[ -o interactive ]] || return

# ── PATH ─────────────────────────────────────────────────────────────────────
# typeset -U keeps entries unique, so re-sourcing this file can't bloat PATH.
typeset -U path PATH
[[ -x /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"
path=(
  "$HOME/.system-config/bin"
  "$HOME/.local/bin"
  "$HOME/.grok/bin"
  "/Applications/Sublime Text.app/Contents/SharedSupport/bin"
  $path
)

# ── Languages ────────────────────────────────────────────────────────────────
# mise replaces rbenv, pyenv, nvm and direnv. Versions: ~/.config/mise/config.toml
command -v mise >/dev/null && eval "$(mise activate zsh)"

# ── History ──────────────────────────────────────────────────────────────────
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt HIST_IGNORE_ALL_DUPS HIST_REDUCE_BLANKS SHARE_HISTORY
setopt EXTENDED_GLOB PROMPT_SUBST

# ── Prompt ───────────────────────────────────────────────────────────────────
# zsh has colours and git status built in — no framework needed.
autoload -Uz colors vcs_info && colors
zstyle ':vcs_info:git:*' formats " on %F{green}%b%f"
precmd() { vcs_info }
PROMPT='%F{yellow}%~%f${vcs_info_msg_0_}
$ '

# ── Completions ──────────────────────────────────────────────────────────────
fpath=(~/.grok/completions/zsh $fpath)
autoload -Uz compinit && compinit -C

# ── Environment ──────────────────────────────────────────────────────────────
export EDITOR='code -w'
# Trailing colon makes man append the system manpath, so `man sys` works.
export MANPATH="$HOME/.system-config/man:"
export HOMEBREW_CASK_OPTS="--appdir=/Applications"
export CLAUDE_CODE_OAUTH_TOKEN="$(security find-generic-password -a "$USER" -s claude-code-oauth-token -w 2>/dev/null)"

# ── Config ───────────────────────────────────────────────────────────────────
# Guarded so a missing repo degrades quietly instead of erroring every shell.
for f in "$HOME/.system-config/lib/common.sh" "$HOME/.aliases" "$HOME/.projects"; do
  [[ -r "$f" ]] && source "$f"
done

# Start new terminals on the Desktop, but not over SSH or inside an IDE.
if [[ -z "$SSH_CONNECTION" && "$PWD" == "$HOME" && "${TERM_PROGRAM:-}" != (vscode|Cursor) ]]; then
  cd ~/Desktop
fi
