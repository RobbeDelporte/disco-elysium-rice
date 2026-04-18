# ~/.zshrc — tracked in ~/my-dots/zsh/.zshrc (symlinked by scripts/install.sh)

# XDG base dirs (mostly set by systemd user manager; belt-and-braces for
# plain ttys where the user runs zsh without logging in via UWSM).
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"

# PATH — ensure ~/.local/bin wins over /usr/bin (caelestia CLI shim lives there).
case ":$PATH:" in
    *":$HOME/.local/bin:"*) ;;
    *) export PATH="$HOME/.local/bin:$PATH" ;;
esac

# History — keep it unless it actively annoys.
HISTFILE="$XDG_STATE_HOME/zsh/history"
HISTSIZE=10000
SAVEHIST=10000
mkdir -p "${HISTFILE:h}"
setopt SHARE_HISTORY HIST_IGNORE_DUPS HIST_IGNORE_SPACE

# Completion.
autoload -Uz compinit
compinit -d "$XDG_CACHE_HOME/zsh/zcompdump"

# Starship prompt — symlinked from the caelestia-dots fork at
# ~/.config/starship.toml → ~/.local/share/caelestia-dots/starship.toml.
if command -v starship >/dev/null 2>&1; then
    eval "$(starship init zsh)"
fi
