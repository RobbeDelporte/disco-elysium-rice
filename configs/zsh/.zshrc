# =============================================
# Zsh Configuration
# =============================================

# ---- Zinit Plugin Manager ----
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [ ! -d "$ZINIT_HOME" ]; then
    mkdir -p "$(dirname $ZINIT_HOME)"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"

# ---- Plugins ----
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions

# ---- Completion ----
autoload -Uz compinit && compinit
zinit cdreplay -q

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu select

# ---- History ----
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups

# ---- Key bindings ----
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# ---- Colors ----
export LS_COLORS="di=01;34:ln=01;36:so=01;35:pi=33:ex=01;31:bd=01;33:cd=01;33:su=01;31:sg=01;31:tw=01;34:ow=01;34"

# ---- Aliases ----
alias ls='ls --color=auto'
alias ll='ls -la'
alias la='ls -a'
alias grep='grep --color=auto'

# ---- Path ----
export PATH="$HOME/.local/bin:$PATH"

# ---- Yazi (cd on quit) ----
function ya() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        builtin cd -- "$cwd"
    fi
    rm -f -- "$tmp"
}

# ---- Starship Prompt ----
eval "$(starship init zsh)"
