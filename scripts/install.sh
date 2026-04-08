#!/usr/bin/env bash
set -uo pipefail

# =============================================
# Hyprland Rice Install Script
# Usage: ./scripts/install.sh <hostname>
# Example: ./scripts/install.sh system76
# =============================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"
HOST="${1:-}"

# ---- Validate ----
if [ -z "$HOST" ]; then
    echo "Usage: $0 <hostname>"
    echo "Available hosts:"
    ls "$REPO_DIR/hosts/"
    exit 1
fi

if [ ! -d "$REPO_DIR/hosts/$HOST" ]; then
    echo "Error: Host profile '$HOST' not found in hosts/"
    echo "Available hosts:"
    ls "$REPO_DIR/hosts/"
    exit 1
fi

echo "=== Hyprland Rice Installer ==="
echo "Host: $HOST"
echo "Repo: $REPO_DIR"
echo ""

# ---- Helper: read package list, strip comments and blanks ----
read_packages() {
    sed 's/#.*//; /^\s*$/d' "$1"
}

# ---- Step 1: Update system ----
echo ">>> Updating system..."
sudo pacman -Syu --noconfirm

# ---- Step 2: Install pacman packages ----
echo ">>> Installing pacman packages..."
read_packages "$REPO_DIR/packages/pacman.txt" | xargs sudo pacman -S --needed --noconfirm

# ---- Step 3: Check for paru ----
if ! command -v paru &> /dev/null; then
    echo ">>> Installing paru..."
    TEMP_DIR=$(mktemp -d)
    git clone https://aur.archlinux.org/paru.git "$TEMP_DIR/paru"
    (cd "$TEMP_DIR/paru" && makepkg -si --noconfirm)
    rm -rf "$TEMP_DIR"
fi

# ---- Step 4: Install AUR packages ----
echo ">>> Installing AUR packages..."
read_packages "$REPO_DIR/packages/aur.txt" | xargs paru -S --needed --noconfirm

# ---- Step 5: Install host-specific packages ----
if [ -f "$REPO_DIR/hosts/$HOST/packages.txt" ]; then
    echo ">>> Installing host-specific packages for $HOST..."
    read_packages "$REPO_DIR/hosts/$HOST/packages.txt" | xargs paru -S --needed --noconfirm
fi

# ---- Step 6: Cursor theme (Nordzy-cursors, installed via AUR) ----
echo ">>> Nordzy-cursors installed via AUR packages above"

# ---- Step 7: Symlink configs ----
echo ">>> Symlinking configs..."

CONFIG_DIR="$HOME/.config"
mkdir -p "$CONFIG_DIR"

# Symlink each config directory (skip items that get special handling below)
for dir in "$REPO_DIR"/configs/*/; do
    dirname=$(basename "$dir")
    [ "$dirname" = "zsh" ] && continue
    [ "$dirname" = "starship" ] && continue
    [ "$dirname" = "gtk-3.0" ] && continue
    [ "$dirname" = "gtk-4.0" ] && continue
    [ "$dirname" = "gtksourceview-4.0" ] && continue
    [ "$dirname" = "qt6ct" ] && continue
    [ "$dirname" = "kvantum" ] && continue
    [ "$dirname" = "nvim" ] && continue

    target="$CONFIG_DIR/$dirname"
    source="${dir%/}"

    if [ -d "$target" ] && [ ! -L "$target" ]; then
        echo "  Backing up existing $target to ${target}.bak"
        mv "$target" "${target}.bak"
    elif [ -L "$target" ]; then
        rm "$target"
    fi

    ln -s "$source" "$target"
    echo "  Linked $source -> $target"
done

# Symlink nvim config
NVIM_TARGET="$CONFIG_DIR/nvim"
if [ -d "$NVIM_TARGET" ] && [ ! -L "$NVIM_TARGET" ]; then
    echo "  Backing up existing $NVIM_TARGET to ${NVIM_TARGET}.bak"
    mv "$NVIM_TARGET" "${NVIM_TARGET}.bak"
elif [ -L "$NVIM_TARGET" ]; then
    rm "$NVIM_TARGET"
fi
ln -s "$REPO_DIR/configs/nvim" "$NVIM_TARGET"
echo "  Linked configs/nvim -> $NVIM_TARGET"

# Symlink host-specific monitor config
if [ -f "$REPO_DIR/hosts/$HOST/monitors.conf" ]; then
    ln -sf "$REPO_DIR/hosts/$HOST/monitors.conf" "$CONFIG_DIR/hypr/monitors.conf"
    echo "  Linked hosts/$HOST/monitors.conf -> $CONFIG_DIR/hypr/monitors.conf"
fi

# ---- Step 8: Symlink zsh and starship files ----
echo ">>> Setting up Zsh and Starship..."
ln -sf "$REPO_DIR/configs/zsh/.zshrc" "$HOME/.zshrc"
ln -sf "$REPO_DIR/configs/zsh/.zprofile" "$HOME/.zprofile"
ln -sf "$REPO_DIR/configs/starship/starship.toml" "$CONFIG_DIR/starship.toml"
echo "  Linked .zshrc, .zprofile, and starship.toml"

# ---- Step 8b: Symlink GTK3/GTK4 theme and xed color scheme ----
echo ">>> Setting up GTK3/GTK4 theme and xed syntax highlighting..."
mkdir -p "$CONFIG_DIR/gtk-3.0"
ln -sf "$REPO_DIR/configs/gtk-3.0/gtk.css" "$CONFIG_DIR/gtk-3.0/gtk.css"
echo "  Linked gtk-3.0/gtk.css"

mkdir -p "$CONFIG_DIR/gtk-4.0"
ln -sf "$REPO_DIR/configs/gtk-4.0/gtk.css" "$CONFIG_DIR/gtk-4.0/gtk.css"
echo "  Linked gtk-4.0/gtk.css"

XED_STYLES_DIR="$HOME/.local/share/gtksourceview-4.0/styles"
mkdir -p "$XED_STYLES_DIR"
ln -sf "$REPO_DIR/configs/gtksourceview-4.0/disco-elysium.xml" "$XED_STYLES_DIR/disco-elysium.xml"
echo "  Linked gtksourceview-4.0/disco-elysium.xml"

# ---- Step 8c: Symlink qt6ct config ----
echo ">>> Setting up Qt6 theme..."
mkdir -p "$CONFIG_DIR/qt6ct/colors"
# Write qt6ct.conf with resolved home path
sed "s|PLACEHOLDER_HOME|$HOME|g" "$REPO_DIR/configs/qt6ct/qt6ct.conf" > "$CONFIG_DIR/qt6ct/qt6ct.conf"
ln -sf "$REPO_DIR/configs/qt6ct/colors/disco-elysium.conf" "$CONFIG_DIR/qt6ct/colors/disco-elysium.conf"
echo "  Configured qt6ct with Disco Elysium palette"

# ---- Step 8c2: Symlink Kvantum theme ----
echo ">>> Setting up Kvantum theme..."
mkdir -p "$CONFIG_DIR/Kvantum/disco-elysium"
ln -sf "$REPO_DIR/configs/kvantum/disco-elysium/disco-elysium.kvconfig" \
  "$CONFIG_DIR/Kvantum/disco-elysium/disco-elysium.kvconfig"
kvantummanager --set disco-elysium
echo "  Configured Kvantum with Disco Elysium theme"

# ---- Step 8d: Set GTK/Qt theme via gsettings ----
echo ">>> Configuring GTK and icon themes..."
gsettings set org.gnome.desktop.wm.preferences button-layout 'close:'
gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'
gsettings set org.gnome.desktop.interface icon-theme 'Gruvbox-Plus-Dark'
gsettings set org.gnome.desktop.interface cursor-theme 'Nordzy-cursors'
gsettings set org.gnome.desktop.interface cursor-size 32
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
echo "  Set GTK theme to Adwaita-dark, icons to Gruvbox-Plus-Dark, color scheme to dark"


# ---- Step 9: Set default shell ----
if [ "$SHELL" != "/usr/bin/zsh" ]; then
    echo ">>> Setting Zsh as default shell (you may be prompted for your password)..."
    chsh -s /usr/bin/zsh || echo "  Warning: chsh failed. Run 'chsh -s /usr/bin/zsh' manually after install."
fi

# ---- Step 10: Install zinit ----
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [ ! -d "$ZINIT_HOME" ]; then
    echo ">>> Installing zinit..."
    mkdir -p "$(dirname "$ZINIT_HOME")"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# ---- Step 10b: disco-shell (Rust desktop widgets) ----
echo ">>> disco-shell is built separately from https://github.com/RobbeDelporte/disco-shell"
echo "  Clone and build: cd ~/disco-shell && cargo build --release"
echo "  Install: cp target/release/disco-shell ~/.local/bin/"

# ---- Step 11: Enable services ----
echo ">>> Enabling systemd services..."
sudo systemctl enable --now NetworkManager
sudo systemctl enable bluetooth || echo "  Warning: bluetooth service failed to enable (no BT hardware?)"

# ---- Step 12: Create Pictures directory for screenshots ----
mkdir -p "$HOME/Pictures"

echo ""
echo "=== Installation complete! ==="
echo ""
echo "Next steps:"
echo "  1. Reboot: sudo reboot"
echo "  2. Log in at TTY1 with your username and password — Hyprland starts automatically"
echo "  3. Adjust monitors: hyprctl monitors  (then edit hosts/$HOST/monitors.conf)"
echo "  4. Fine-tune theming if needed: nwg-look (GTK) or qt6ct (Qt) — already pre-configured"
echo ""
