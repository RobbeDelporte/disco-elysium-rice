# Package Setup Guide

Step-by-step guide to ensure the correct packages are installed and outdated ones removed. Run this on the target Arch machine.

---

## Step 1: System Update

```bash
sudo pacman -Syu
```

---

## Step 2: Install AUR Helper (if missing)

```bash
if ! command -v paru &> /dev/null; then
    sudo pacman -S --needed base-devel git
    git clone https://aur.archlinux.org/paru.git /tmp/paru
    cd /tmp/paru && makepkg -si --noconfirm
    cd ~ && rm -rf /tmp/paru
fi
```

---

## Step 3: Remove Outdated Packages

These were part of the original plan but have been replaced by disco-shell (Astal):

```bash
# Remove if installed — these are no longer used
sudo pacman -Rns --noconfirm waybar 2>/dev/null
sudo pacman -Rns --noconfirm swaync 2>/dev/null
paru -Rns --noconfirm rofi-wayland 2>/dev/null
sudo pacman -Rns --noconfirm rofi 2>/dev/null

# Also remove old config symlinks if they exist
rm -f ~/.config/waybar
rm -f ~/.config/rofi
rm -f ~/.config/swaync
```

---

## Step 4: Install Pacman Packages

```bash
cd ~/disco-elysium-rice

# Install all official repo packages
sed 's/#.*//; /^\s*$/d' packages/pacman.txt | xargs sudo pacman -S --needed --noconfirm
```

Key packages being installed:

| Category | Packages |
|----------|----------|
| Hyprland ecosystem | `hyprland`, `hyprlock`, `hypridle`, `hyprpolkitagent`, `xdg-desktop-portal-hyprland` |
| Terminal & editor | `kitty`, `neovim`, `zsh` |
| Wallpaper & screenshots | `awww`, `grim`, `slurp` |
| Clipboard & dmenu | `cliphist`, `wl-clipboard`, `fuzzel` |
| Audio | `pipewire`, `wireplumber`, `pavucontrol` |
| File manager | `nemo` |
| Networking | `networkmanager`, `network-manager-applet`, `bluez`, `blueman` |
| Theming | `nwg-look`, `papirus-icon-theme` |
| Fonts | `ttf-opensans`, `ttf-libre-baskerville`, `noto-fonts`, `noto-fonts-emoji`, `ttf-font-awesome` |
| Astal/disco-shell deps | `gtk4`, `gtk4-layer-shell`, `meson`, `vala` |
| Shell | `starship`, `zsh-autosuggestions`, `zsh-syntax-highlighting`, `zsh-completions` |
| Utilities | `brightnessctl`, `playerctl`, `udiskie`, `udisks2` |

---

## Step 5: Install AUR Packages

```bash
sed 's/#.*//; /^\s*$/d' packages/aur.txt | xargs paru -S --needed --noconfirm
```

| Package | Purpose |
|---------|---------|
| `libastal-meta` | All Astal libraries (hyprland, tray, notifd, apps, battery, etc.) |
| `grimblast-git` | Screenshot tool (Hyprland contrib) |
| `ttf-jetbrains-mono-nerd` | Terminal font |
| `ttf-playfair-display` | Lock screen time font |
| `bibata-cursor-theme` | Cursor theme |

---

## Step 6: Install Host-Specific Packages

```bash
HOST="system76"  # or "tuxedo"

if [ -f ~/disco-elysium-rice/hosts/$HOST/packages.txt ]; then
    sed 's/#.*//; /^\s*$/d' ~/disco-elysium-rice/hosts/$HOST/packages.txt | xargs paru -S --needed --noconfirm
fi
```

---

## Step 7: Verify Installation

```bash
# Core tools
hyprland --version
disco-shell --help
kitty --version
nvim --version
awww --version
grimblast --version 2>/dev/null || which grimblast
starship --version

# Fonts
fc-list | grep -ci "open sans condensed"
fc-list | grep -ci "libre baskerville"
fc-list | grep -ci "playfair display"
fc-list | grep -ci "jetbrainsmono nerd"

# Astal libraries
pkg-config --exists astal-4.0 && echo "astal4: OK" || echo "astal4: MISSING"
pkg-config --exists astal-io-0.1 && echo "astal-io: OK" || echo "astal-io: MISSING"
pkg-config --exists astal-hyprland-0.1 && echo "astal-hyprland: OK" || echo "astal-hyprland: MISSING"
pkg-config --exists astal-notifd-0.1 && echo "astal-notifd: OK" || echo "astal-notifd: MISSING"
pkg-config --exists astal-apps-0.1 && echo "astal-apps: OK" || echo "astal-apps: MISSING"
pkg-config --exists astal-tray-0.1 && echo "astal-tray: OK" || echo "astal-tray: MISSING"

# Confirm removed packages are gone
pacman -Qi waybar 2>/dev/null && echo "WARNING: waybar still installed" || echo "waybar: removed OK"
pacman -Qi rofi 2>/dev/null && echo "WARNING: rofi still installed" || echo "rofi: removed OK"
pacman -Qi swaync 2>/dev/null && echo "WARNING: swaync still installed" || echo "swaync: removed OK"
```

---

## Step 8: Run Install Script

If you haven't already, the install script handles everything above plus symlinks:

```bash
cd ~/disco-elysium-rice && ./scripts/install.sh system76
```

This will:
1. Install all pacman and AUR packages
2. Symlink all configs to `~/.config/`
3. Set zsh as default shell
4. Install zinit plugin manager
5. Enable NetworkManager and Bluetooth

---

## Quick Reference: What Replaced What

| Old | New | Why |
|-----|-----|-----|
| Waybar | disco-shell bar | More flexible, Vala + GTK4 |
| Rofi | disco-shell launcher | Consistent theming with bar |
| swaync | disco-shell notifications | Consistent theming with bar |
| (none) | Neovim | Primary editor, highly themeable |
| Nemo (sole GUI) | Yazi (TUI, primary) + Nemo (GUI, backup) | Yazi is primary with Disco Elysium theme; Nemo kept for drag-and-drop |
