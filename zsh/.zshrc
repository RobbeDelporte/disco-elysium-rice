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

# Caelestia palette — the scheme switcher writes OSC escape sequences here;
# emitting them repaints the terminal's ANSI 0-15 / fg / bg / cursor to match.
# Fish's config.fish does the same via `cat ...sequences.txt`.
[[ -r "$XDG_STATE_HOME/caelestia/sequences.txt" ]] && \
    cat "$XDG_STATE_HOME/caelestia/sequences.txt"

# OSC 133 prompt markers — lets foot jump between prompts
# (Ctrl+Shift+Z / X in caelestia's foot config).
autoload -Uz add-zsh-hook
_caelestia_prompt_mark() { print -Pn '\e]133;A\e\\' }
add-zsh-hook precmd _caelestia_prompt_mark

# Better ls — matches caelestia's fish default (icons + dirs first).
if command -v eza >/dev/null 2>&1; then
    alias ls='eza --icons --group-directories-first -1'
fi

# Interactive greeting — mirrors fish_greeting from the caelestia-dots fork.
if [[ -o interactive ]]; then
    printf '\e[38;5;16m'
    print -r -- '     ______           __          __  _       '
    print -r -- '    / ____/___ ____  / /__  _____/ /_(_)___ _ '
    print -r -- '   / /   / __ `/ _ \/ / _ \/ ___/ __/ / __ `/ '
    print -r -- '  / /___/ /_/ /  __/ /  __(__  ) /_/ / /_/ /  '
    print -r -- '  \____/\__,_/\___/_/\___/____/\__/_/\__,_/   '
    printf '\e[0m'
    command -v fastfetch >/dev/null 2>&1 && fastfetch --key-padding-left 5
fi
