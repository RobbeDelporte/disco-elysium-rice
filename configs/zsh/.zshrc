# Ported from caelestia-dots/caelestia fish/config.fish
# Keep parity with upstream; customize via ~/.config/caelestia/user-config.zsh

# History
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY HIST_IGNORE_DUPS HIST_IGNORE_SPACE

# Completions
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select

# Starship prompt
command -v starship >/dev/null && eval "$(starship init zsh)"

# Direnv
command -v direnv >/dev/null && eval "$(direnv hook zsh)"

# Zoxide (replaces cd)
command -v zoxide >/dev/null && eval "$(zoxide init zsh --cmd cd)"

# Better ls
command -v eza >/dev/null && alias ls='eza --icons --group-directories-first -1'

# Aliases (fish `abbr` → zsh `alias`; loses mid-line expansion but equivalent at run time)
alias lg='lazygit'
alias gd='git diff'
alias ga='git add .'
alias gc='git commit -am'
alias gl='git log'
alias gs='git status'
alias gst='git stash'
alias gsp='git stash pop'
alias gp='git push'
alias gpl='git pull'
alias gsw='git switch'
alias gsm='git switch main'
alias gb='git branch'
alias gbd='git branch -d'
alias gco='git checkout'
alias gsh='git show'

alias l='ls'
alias ll='ls -l'
alias la='ls -a'
alias lla='ls -la'

# Caelestia dynamic terminal colour sequences
[[ -f ~/.local/state/caelestia/sequences.txt ]] && cat ~/.local/state/caelestia/sequences.txt 2>/dev/null

# Foot terminal prompt-jump OSC 133
_caelestia_mark_prompt_start() { printf '\e]133;A\e\\'; }
autoload -Uz add-zsh-hook
add-zsh-hook precmd _caelestia_mark_prompt_start

# User overrides
[[ -f ~/.config/caelestia/user-config.zsh ]] && source ~/.config/caelestia/user-config.zsh
