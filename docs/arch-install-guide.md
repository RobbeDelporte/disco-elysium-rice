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

The script will:
- Bootstrap `yay` (AUR helper) if missing
- Install host-specific packages (System76 / Tuxedo drivers) and `zsh` + `fish` (fish is needed only to run caelestia's `install.fish`)
- Clone `caelestia-dots/caelestia` to `~/.local/share/caelestia-dots/` and run its `install.fish`, which pulls the caelestia metapackage (all runtime deps: Hyprland, Quickshell, caelestia-shell, caelestia-cli, foot, fuzzel, fonts, etc.) and symlinks its own configs into `~/.config/`
- Symlink our `.zshrc`, `.zprofile`, `starship.toml` into `$HOME`
- Write a user override at `~/.config/caelestia/hypr-user.conf` that sources this host's `monitors.conf`
- Set zsh as the login shell (you'll be prompted for your password)
- Enable NetworkManager and PipeWire services

During `install.fish` you'll be prompted to back up `~/.config` (choose 2 if you want a backup) and to confirm overwrites — answer `Y` to accept caelestia's configs.

## 8. Start a Hyprland session

No display manager is installed by default. After reboot you land at a TTY.

```bash
sudo reboot
# log in at TTY1 with your username + password, then:
uwsm start hyprland-uwsm.desktop
```

(caelestia ships with `uwsm` and the matching Hyprland desktop entry.)

If you want graphical login instead, install one yourself — e.g. `greetd` + `tuigreet` (caelestia's recommendation) or `ly`. This is out of scope for the baseline install.

## 9. Post-install checklist

- [ ] **Check monitors:** `hyprctl monitors` — if layout is wrong, edit `hosts/<hostname>/monitors.conf` in this repo, then `hyprctl reload`. The caelestia config already sources your per-host file via `~/.config/caelestia/hypr-user.conf`.
- [ ] **GPU drivers (if needed):** `lspci | grep -E 'VGA|3D'`, then install the driver package for your GPU manually (e.g. `sudo pacman -S nvidia-dkms` or `mesa` variants). Not automated — GPU choice is per-machine.
- [ ] **Test notifications:** `notify-send "Hello" "Rice is working!"`
- [ ] **Test screenshot:** `Super+S` (caelestia default)
- [ ] **Test launcher:** `Super` (tap, caelestia default)
- [ ] **Test terminal:** `Super+T` (foot)
- [ ] **Session menu:** `Ctrl+Alt+Delete`

## Future work (not part of baseline)

Applying the Disco Elysium palette is a later phase — see `docs/style-guide.md` and the Roadmap in the top-level `README.md`. The baseline install leaves caelestia's stock Material You dynamic theming in place.
