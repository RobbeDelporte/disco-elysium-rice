# ~/.zprofile — tracked in ~/my-dots/zsh/.zprofile (symlinked by scripts/install.sh)
#
# Auto-start a Hyprland session via UWSM on TTY1 (matches caelestia's upstream
# recommendation). Other TTYs fall through to a normal shell.

if [ -z "$WAYLAND_DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ] && command -v uwsm >/dev/null 2>&1; then
    if uwsm check may-start && uwsm select; then
        exec systemd-cat -t uwsm uwsm start default
    fi
fi
