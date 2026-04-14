#!/usr/bin/env bash
# Disco Elysium Rice — caelestia-dots pivot installer
#
# Usage: ./scripts/install.sh <hostname>
#   hostname ∈ { system76, tuxedo }
#
# What this does:
#   1. Installs an AUR helper (yay) if missing
#   2. Installs caelestia + deps from AUR/official repos
#   3. Clones caelestia-dots/caelestia to ~/.local/share/caelestia-dots
#      and runs its install.fish (it symlinks configs from that clone)
#   4. Symlinks our zsh + starship configs into $HOME
#   5. Copies host-specific monitors.conf into caelestia's Hyprland include dir
#
# Upstream colors (Material You dynamic) are used as-is. Disco Elysium
# palette override is a future task (see docs/style-guide.md as the source
# of truth for that work).

set -euo pipefail

HOST="${1:-}"
if [[ -z "$HOST" ]]; then
    echo "usage: $0 <hostname>"
    echo "  hostname: system76 | tuxedo"
    exit 1
fi

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
HOST_DIR="$REPO_ROOT/hosts/$HOST"
if [[ ! -d "$HOST_DIR" ]]; then
    echo "unknown host: $HOST (expected hosts/$HOST/ to exist)"
    exit 1
fi

CAELESTIA_SRC="$HOME/.local/share/caelestia-dots"

log()   { printf '\e[36m:: %s\e[0m\n' "$*"; }
warn()  { printf '\e[33m!! %s\e[0m\n' "$*"; }

# --- 1. AUR helper ---
if ! command -v yay >/dev/null; then
    log "Installing yay (AUR helper)..."
    sudo pacman -S --needed --noconfirm base-devel git
    tmp=$(mktemp -d)
    git clone https://aur.archlinux.org/yay.git "$tmp/yay"
    (cd "$tmp/yay" && makepkg -si --noconfirm)
    rm -rf "$tmp"
fi

# --- 2. Packages ---
log "Installing packages (this may take a while)..."

# Base desktop + caelestia runtime deps
PACMAN_PKGS=(
    hyprland
    fish                         # runtime for caelestia's install.fish
    zsh
    foot
    fuzzel
    thunar
    starship
    eza
    zoxide
    direnv
    lazygit
    ddcutil
    brightnessctl
    networkmanager
    lm_sensors
    pipewire
    pipewire-pulse
    pipewire-alsa
    wireplumber
    xdg-desktop-portal-hyprland
    polkit-gnome
    grim
    slurp
    wl-clipboard
    cliphist
    qt6-wayland
    qt5-wayland
)

AUR_PKGS=(
    quickshell                   # stable; switch to quickshell-git if bleeding-edge needed
    caelestia-shell
    caelestia-cli
    ttf-material-symbols-variable-git
    ttf-caskaydia-cove-nerd
    aubio
    libcava
    hyprpicker
    grimblast-git
)

# Host-specific extras
case "$HOST" in
    system76)
        AUR_PKGS+=(system76-power system76-dkms)
        ;;
    tuxedo)
        AUR_PKGS+=(tuxedo-drivers-dkms tuxedo-control-center-bin)
        ;;
esac

sudo pacman -S --needed --noconfirm "${PACMAN_PKGS[@]}"
yay -S --needed --noconfirm "${AUR_PKGS[@]}"

# --- 3. Caelestia dotfiles ---
if [[ ! -d "$CAELESTIA_SRC/.git" ]]; then
    log "Cloning caelestia-dots/caelestia to $CAELESTIA_SRC..."
    mkdir -p "$(dirname "$CAELESTIA_SRC")"
    git clone https://github.com/caelestia-dots/caelestia "$CAELESTIA_SRC"
else
    log "Updating existing caelestia clone..."
    git -C "$CAELESTIA_SRC" pull --ff-only
fi

log "Running caelestia install.fish (symlinks configs from $CAELESTIA_SRC)..."
warn "install.fish will prompt for overwrites; answer Y to accept caelestia's configs."
(cd "$CAELESTIA_SRC" && fish ./install.fish --aur-helper=yay)

# --- 4. Our shell configs ---
log "Symlinking zsh + starship configs..."
ln -sf "$REPO_ROOT/configs/zsh/.zshrc"    "$HOME/.zshrc"
ln -sf "$REPO_ROOT/configs/zsh/.zprofile" "$HOME/.zprofile"
mkdir -p "$HOME/.config"
ln -sf "$REPO_ROOT/configs/starship/starship.toml" "$HOME/.config/starship.toml"

# Make zsh the login shell
if [[ "$(getent passwd "$USER" | cut -d: -f7)" != "$(command -v zsh)" ]]; then
    log "Setting zsh as login shell (will prompt for password)..."
    chsh -s "$(command -v zsh)"
fi

# --- 5. Host monitors ---
if [[ -f "$HOST_DIR/monitors.conf" ]]; then
    HYPR_USER_DIR="$HOME/.config/hypr"
    mkdir -p "$HYPR_USER_DIR"
    ln -sf "$HOST_DIR/monitors.conf" "$HYPR_USER_DIR/monitors.conf"
    log "Linked $HOST monitors.conf → $HYPR_USER_DIR/monitors.conf"
    warn "Ensure caelestia's hyprland.conf has: source = ~/.config/hypr/monitors.conf"
fi

# --- 6. Services ---
log "Enabling services..."
sudo systemctl enable --now NetworkManager.service
systemctl --user enable --now pipewire.service pipewire-pulse.service wireplumber.service

log "Done. Reboot, then log into Hyprland."
log "Launch caelestia shell check:  qs -c caelestia"
log "Scheme / wallpaper CLI:        caelestia --help"
