export PATH="$HOME/.local/bin:$PATH"

# Auto-start Hyprland on TTY1
if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ]; then
  exec Hyprland
fi
