#!/usr/bin/env bash
# Re-apply wallpaper when a monitor is hotplugged.
# Listens to Hyprland's IPC socket for monitoradded events.

WALLPAPER="$HOME/my-dots/wallpapers/martinaise.png"
SOCKET="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"

socat -u "UNIX-CONNECT:$SOCKET" - | while IFS= read -r line; do
    case "$line" in
        monitoradded*)
            sleep 0.5
            awww img "$WALLPAPER" --transition-type fade --transition-duration 1
            ;;
    esac
done
