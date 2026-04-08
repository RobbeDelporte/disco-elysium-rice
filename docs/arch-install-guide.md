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
- Update the system
- Install all packages (pacman + AUR, may take 10-20 minutes)
- Bootstrap paru (AUR helper, requires building Rust — takes a few minutes)
- Symlink all configs
- Set zsh as default shell (you'll be prompted for your password)
- Enable services

## 8. Reboot into Hyprland

```bash
sudo reboot
```

Log in at the TTY with your username and password (on TTY1). Hyprland starts automatically.

**If Hyprland doesn't start:** Make sure you're on TTY1 (press Ctrl+Alt+F1 if needed), then log in.

## 9. Post-install checklist

- [ ] **Check monitors:** `hyprctl monitors` — edit `hosts/<hostname>/monitors.conf` if needed, then reload with `hyprctl reload`
- [ ] **GPU drivers:** Run `lspci | grep VGA`, then uncomment the right lines in `hosts/<hostname>/packages.txt` and run `paru -S <driver-packages>`
- [ ] **Set GTK theme:** Run `nwg-look` to pick theme, icons, fonts, cursor
- [ ] **Set Qt theme:** Run `qt6ct` to match Qt apps
- [ ] **Test notifications:** `notify-send "Hello" "Rice is working!"`
- [ ] **Test screenshot:** `Super+S` to capture an area
- [ ] **Test launcher:** `Super+D` or `Super+/` to open launcher
- [ ] **Apply Disco Elysium theme:** Follow `docs/style-guide.md` replacement table to update all configs from placeholder colors
