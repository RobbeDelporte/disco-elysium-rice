# Project Context for Claude

## What This Is

A dotfiles repository for a complete Arch Linux + Hyprland desktop rice, targeting two machines: a System76 laptop (primary, initial setup) and a Tuxedo laptop (secondary). The visual theme is inspired by the video game Disco Elysium.

## Current State

All configs are functional with the Disco Elysium color palette applied. Desktop shell widgets are provided by the separate [disco-shell](https://github.com/RobbeDelporte/disco-shell) project (Rust + GPUI).

### What's Done
- All configs: Hyprland, Kitty, Zsh, Starship, Hyprlock, Hypridle, Neovim, Yazi, GTK3
- Install script: `scripts/install.sh <hostname>` handles full automated setup
- Host profiles: `hosts/system76/` and `hosts/tuxedo/` with vendor packages and monitor configs
- Package lists: `packages/pacman.txt` and `packages/aur.txt`
- Arch install guide: `docs/arch-install-guide.md`
- Style guide: `docs/style-guide.md` — Disco Elysium color palette (pipetted from game)

### What's NOT Done Yet
1. **Monitor configs** — `hosts/*/monitors.conf` may need adjustment using `hyprctl monitors`.

### Desktop Shell
Desktop widgets (bar, launcher, notifications, quick settings, overview, switcher, power menu, keybinds) live in a separate repo: [disco-shell](https://github.com/RobbeDelporte/disco-shell) (Rust + GPUI).

## Technology Choices

| Component | Technology | Config Path |
|-----------|-----------|-------------|
| Window manager | Hyprland | `configs/hypr/hyprland.conf` |
| Desktop shell | disco-shell (Rust + GPUI) | Separate repo |
| Terminal | Kitty | `configs/kitty/kitty.conf` |
| Lock screen | Hyprlock | `configs/hypr/hyprlock.conf` |
| Idle manager | Hypridle | `configs/hypr/hypridle.conf` |
| Shell | Zsh | `configs/zsh/.zshrc` + `.zprofile` |
| Shell prompt | Starship | `configs/starship/starship.toml` |
| File manager (primary) | Yazi (TUI) | `configs/yazi/` |
| File manager (backup) | Nemo (GTK3) | themed via gsettings |
| Text editor (primary) | Neovim | `configs/nvim/init.lua` |
| Wallpaper | awww | (started in hyprland.conf) |
| Screenshots | Grimblast | (keybind in hyprland.conf) |
| Clipboard | Cliphist | (started in hyprland.conf) |
| GTK3 theming | `nwg-look` + Adwaita-dark (gsettings) | Nemo, native GTK3 apps |

## Key Documents

| Document | Purpose |
|----------|---------|
| `docs/arch-install-guide.md` | Step-by-step Arch install from USB to first boot |
| `docs/style-guide.md` | Disco Elysium visual design language + color palette (pipetted from game) |
| `docs/implementation-guide.md` | How the design is applied to each config |
| `docs/on-device-checklist.md` | Post-install verification checklist |
| `docs/mockups/*.html` | Visual reference mockups for each component (open in browser) |
| `docs/style-overview.html` | Complete design language visual reference |

## Install Workflow

```
1. Boot Arch USB, run archinstall (minimal, no DE)
2. Log in, connect to WiFi: nmcli device wifi connect "SSID" password "pass"
3. git clone git@github.com:RobbeDelporte/disco-elysium-rice.git ~/disco-elysium-rice
4. cd ~/disco-elysium-rice && ./scripts/install.sh system76
5. Build disco-shell: git clone git@github.com:RobbeDelporte/disco-shell.git ~/disco-shell && cd ~/disco-shell && cargo build --release && cp target/release/disco-shell ~/.local/bin/
6. sudo reboot → Hyprland starts automatically
```

## Verification

- **Hyprland config**: After any change to `configs/hypr/hyprland.conf`, always run `hyprland --verify-config` and confirm "config ok" before considering the change done.

## User Preferences

- Keybinds: Super+T for terminal, Super+/ for launcher (muscle memory from Pop!_OS)
- Dual vim (HJKL) + arrow key binds everywhere
- Experienced with Ubuntu/Pop!_OS terminal usage, new to Arch and tiling WMs
- Prefers concise explanations, not hand-holding
- Style: Disco Elysium — dark, warm, painterly, literary (NOT clean/modern/flat)

## Repo Structure

```
configs/          # Shared dotfiles (symlinked to ~/.config/)
  hypr/           # hyprland.conf, hyprlock.conf, hypridle.conf
  kitty/          # kitty.conf
  nvim/           # init.lua + lua/disco-elysium.lua
  yazi/           # yazi.toml, theme.toml, keymap.toml
  zsh/            # .zshrc, .zprofile (symlinked to ~/)
  starship/       # starship.toml (symlinked to ~/.config/starship.toml)
  fontconfig/     # fonts.conf (font rendering config)
hosts/            # Per-machine overrides
  system76/       # packages.txt, monitors.conf
  tuxedo/         # packages.txt, monitors.conf
packages/         # Shared package lists
  pacman.txt      # Official repo packages
  aur.txt         # AUR packages
scripts/
  install.sh      # Automated setup script (takes hostname arg)
references/
  disco-elysium/  # Style reference images from the game
wallpapers/       # Wallpaper collection
docs/             # Guides, style guide, mockups
```
