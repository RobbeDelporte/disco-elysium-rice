export PATH="$HOME/.local/bin:$PATH"

# Auto-start Hyprland on TTY1 (guard against re-launch if already running)
if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ] && ! pgrep -x Hyprland > /dev/null; then
  exec Hyprland
fi
