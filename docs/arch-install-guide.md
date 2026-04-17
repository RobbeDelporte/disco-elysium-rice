# Arch Linux Install Guide (for this rice)

This covers the steps from bare metal to a bootable Arch system.
After this, you'll clone the dotfiles repo and run the install script.

## Prerequisites

- USB drive (2GB+)
- Internet connection (ethernet recommended, WiFi possible)
- Backed up your data from the existing OS

## 1. Create bootable USB

Download the Arch ISO from https://archlinux.org/download/

Write to USB:
```bash
# On Linux (replace /dev/sdX with your USB device)
sudo dd bs=4M if=archlinux-*.iso of=/dev/sdX status=progress oflag=sync
```

## 2. Boot from USB

- Plug in USB, reboot, enter BIOS/UEFI (usually F2 or Del on System76/Tuxedo)
- **Disable Secure Boot** — Arch does not support Secure Boot out of the box. You can re-enable it later with a signed bootloader if needed, but for now it must be off.
- Set USB as first boot device, save and exit

## 3. Connect to internet

```bash
# Ethernet: should work automatically
ping archlinux.org

# WiFi:
iwctl
station wlan0 scan
station wlan0 get-networks
station wlan0 connect "YourNetworkName"
exit
```

## 4. Run archinstall

```bash
archinstall
```

**Settings to select:**
- **Language:** English
- **Mirror region:** Your country
- **Locales:** en_US.UTF-8
- **Timezone:** Your timezone (e.g., Europe/Brussels) — **important: wrong timezone can break package downloads**
- **Disk:** Select your target disk, use best-effort partition layout, ext4 or btrfs
- **Bootloader:** systemd-boot
- **Hostname:** `system76` or `tuxedo` (match your `hosts/` folder name)
- **Root password:** Set one
- **User account:** Create your user with sudo privileges
- **Profile:** Minimal (do NOT select a desktop)
- **Audio:** PipeWire
- **Network:** NetworkManager
- **Additional packages:** `git base-devel` (type these in the additional packages field — `base-devel` is a package group, just type it)

When ready, select Install and wait.

## 5. Reboot into Arch

```bash
reboot
```

Remove the USB drive. You'll see a text-only login screen (TTY) that looks like:

```
hostname login: _
```

## 6. Log in and clone dotfiles

Type your **username** (the one you created in archinstall), press Enter, then type your **password** (it won't show on screen — this is normal). Press Enter.

```bash
# Connect to WiFi if needed:
nmcli device wifi connect "YourNetworkName" password "yourpassword"

# Clone the rice repo (HTTPS — no SSH keys needed on fresh system)
git clone https://github.com/RobbeDelporte/disco-elysium-rice.git ~/disco-elysium-rice
cd ~/disco-elysium-rice
```

## 7. Run the install script

```bash
# For System76:
./scripts/install.sh system76

# For Tuxedo:
./scripts/install.sh tuxedo
```

The script will (every step is idempotent — safe to re-run):
- Bootstrap `yay` (AUR helper) if missing.
- Install host-specific packages (System76 / Tuxedo drivers), `zsh` + `fish` (fish is needed only to run caelestia's `install.fish`), `cmake` + `base-devel` (needed to build the shell native plugin).
- Clone the three personal forks to their canonical paths and wire up `origin` (user fork) + `upstream` (caelestia-dots) remotes:
    - `RobbeDelporte/caelestia` → `~/.local/share/caelestia-dots/`
    - `RobbeDelporte/shell` → `~/.config/quickshell/caelestia/`
    - `RobbeDelporte/cli` → `~/.local/share/caelestia-cli/`
- Run `install.fish --aur-helper=yay --noconfirm` from the dots fork. This pulls the caelestia metapackage (all runtime deps: Hyprland, Quickshell, caelestia-shell, caelestia-cli, foot, fuzzel, fonts, etc.) and symlinks the dots-fork configs into `~/.config/`.
- Build and install the shell fork's native QML plugin into `~/.local/lib/qt6/qml/Caelestia/` (cmake, incremental on re-runs).
- Write the CLI shim at `~/.local/bin/caelestia` so `caelestia` on `$PATH` resolves to the fork instead of `/usr/bin/caelestia`.
- Write `~/.config/environment.d/caelestia-plugin.conf` so `QML_IMPORT_PATH` picks up the fork plugin at login.
- Symlink our `.zshrc`, `.zprofile`, `starship.toml` into `$HOME`.
- Copy wallpapers into `~/Pictures/Wallpapers/` (copied, not symlinked — Quickshell's FileSystemModel doesn't follow symlinks).
- Write `~/.config/caelestia/hypr-user.conf` that sources this host's `monitors.conf`.
- Set zsh as the login shell (you'll be prompted for your password).
- Enable NetworkManager and PipeWire user services.

With `--noconfirm` passed to `install.fish`, there are no interactive prompts — existing configs under `~/.config/` get overwritten with dots-fork symlinks. On a fresh Arch install that's what you want. On a machine that already has its own configs, take a `cp -r ~/.config ~/.config.bak` first.

## 8. Start a Hyprland session

No display manager is installed by default. After reboot you land at a TTY.

```bash
sudo reboot
# log in at TTY1 with your username + password, then:
uwsm start hyprland-uwsm.desktop
```

(caelestia ships with `uwsm` and the matching Hyprland desktop entry.)

If you want graphical login instead, install one yourself — e.g. `greetd` + `tuigreet` (caelestia's recommendation) or `ly`. This is out of scope for the baseline install.

## 8.5 Pick a wallpaper (regenerates the colour scheme)

Caelestia's Material You scheme is derived from the current wallpaper. To use one from this repo:

```bash
caelestia wallpaper set ~/disco-elysium-rice/wallpapers/<file>
```

List built-in schemes if you'd rather not derive one from an image: `caelestia scheme list`, then `caelestia scheme set <name>`.

## 8.6 Verify the shell is running

```bash
qs list            # should list 'caelestia'
```

If the bar/launcher didn't come up, start it manually:

```bash
qs -c caelestia &
```

Shell restart keybind (useful after editing QML): `Ctrl+Super+Alt+R`.

## 9. Post-install checklist

- [ ] **Check monitors:** `hyprctl monitors` — if layout is wrong, edit `hosts/<hostname>/monitors.conf` in this repo, then `hyprctl reload`. The caelestia config already sources your per-host file via `~/.config/caelestia/hypr-user.conf`.
- [ ] **GPU drivers (if needed):** `lspci | grep -E 'VGA|3D'`, then install the driver package for your GPU manually (e.g. `sudo pacman -S nvidia-dkms` or `mesa` variants). Not automated — GPU choice is per-machine.
- [ ] **Test notifications:** `notify-send "Hello" "Rice is working!"`
- [ ] **Test screenshot:** `Super+S` (caelestia default)
- [ ] **Test launcher:** `Super` (tap, caelestia default)
- [ ] **Test terminal:** `Super+T` (foot)
- [ ] **Session menu:** `Ctrl+Alt+Delete`

### Full upstream keybind reference

| Keys | Action |
|---|---|
| `Super` | open launcher |
| `Super+T` | open terminal (foot) |
| `Super+W` | open browser (zen — only if `--zen` was passed) |
| `Super+C` | open IDE (vscodium — only if `--vscode` was passed) |
| `Super+S` | toggle special workspace |
| `Super+#` | switch to workspace `#` |
| `Super+Alt+#` | move window to workspace `#` |
| `Ctrl+Alt+Delete` | session menu |
| `Ctrl+Super+Space` | toggle media play/pause |
| `Ctrl+Super+Alt+R` | restart the caelestia shell |

## 10. Optional apps (Zen, VSCodium, Spotify, Discord)

Our `install.sh` does **not** pass optional flags to caelestia's installer. To add any of them later, rerun `install.fish` directly from the dots fork:

```bash
cd ~/.local/share/caelestia-dots    # the dots fork (also aliased as ~/caelestia-upstream)
fish ./install.fish --aur-helper=yay --vscode=codium --zen --spotify --discord
```

Each flag is independent — pass only the ones you want. Re-running is safe; it will prompt before overwriting existing configs (or pass `--noconfirm` to skip prompts).

## 11. GTK theme (optional, matches upstream screenshots)

Caelestia installs `adw-gtk-theme` and `papirus-icon-theme` but does not auto-apply them. To match the look from upstream screenshots:

```bash
gsettings set org.gnome.desktop.interface gtk-theme "adw-gtk3-dark"
gsettings set org.gnome.desktop.interface icon-theme "Papirus-Dark"
gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"
```

## Editing caelestia later

The three personal forks live at their canonical paths:

| Fork | Local clone |
|------|-------------|
| `RobbeDelporte/shell` (QML shell) | `~/.config/quickshell/caelestia/` |
| `RobbeDelporte/cli` (Python CLI) | `~/.local/share/caelestia-cli/` |
| `RobbeDelporte/caelestia` (dots configs) | `~/.local/share/caelestia-dots/` (also aliased `~/caelestia-upstream`) |

Each has `origin` = your fork and `upstream` = caelestia-dots. **Do not move or delete any of them** — live configs symlink into them, and Quickshell + the CLI shim + the native plugin all point at these paths.

To edit:

```bash
cd ~/.config/quickshell/caelestia    # shell (QML)
# or ~/.local/share/caelestia-cli    # CLI (Python)
# or ~/.local/share/caelestia-dots   # dots (hypr, foot, fish, ...)
git checkout -b <topic>
# make changes
# for Hyprland:        hyprctl reload
# for shell (QML):     Ctrl+Super+Alt+R
# for shell plugin:    cd ~/.config/quickshell/caelestia && cmake --build build && cmake --install build
git commit -am "..."
git push -u origin <topic>
```

Sync with upstream later via `~/disco-elysium-rice/meta/update.sh`.

## Future work (not part of baseline)

Applying the Disco Elysium palette is a later phase — see `docs/style-guide.md` and the Roadmap in the top-level `README.md`. The baseline install leaves caelestia's stock Material You dynamic theming in place.
