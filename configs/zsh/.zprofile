# Caelestia launches Hyprland via uwsm; see /etc/profile.d/ or the DM entry.
# Keep this minimal — caelestia's install handles desktop session setup.

# XDG defaults (safety net)
: "${XDG_CONFIG_HOME:=$HOME/.config}"
: "${XDG_DATA_HOME:=$HOME/.local/share}"
: "${XDG_STATE_HOME:=$HOME/.local/state}"
: "${XDG_CACHE_HOME:=$HOME/.cache}"
export XDG_CONFIG_HOME XDG_DATA_HOME XDG_STATE_HOME XDG_CACHE_HOME

# Local bin
export PATH="$HOME/.local/bin:$PATH"
