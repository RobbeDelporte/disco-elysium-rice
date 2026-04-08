# disco-elysium-rice

Hyprland rice on Arch Linux — Disco Elysium inspired. Tiling Wayland compositor with a complete desktop environment.

## Stack

| Component | Tool |
|-----------|------|
| OS | Arch Linux |
| Compositor | Hyprland |
| Desktop shell | [disco-shell](https://github.com/RobbeDelporte/disco-shell) (Rust + GPUI) |
| Terminal | Kitty |
| Shell | Zsh + Starship |
| Lock screen | Hyprlock |
| Idle manager | Hypridle |
| Editor | Neovim + xed (fallback) |
| File manager | Yazi (TUI) + Nemo (GUI) |
| Wallpaper | awww |
| Screenshots | Grimblast |
| Clipboard | Cliphist + fuzzel |

## Quick Start

1. Install Arch Linux following [docs/arch-install-guide.md](docs/arch-install-guide.md)
2. Clone this repo: `git clone git@github.com:RobbeDelporte/disco-elysium-rice.git ~/disco-elysium-rice`
3. Run: `./scripts/install.sh <hostname>`
4. Build disco-shell: `git clone git@github.com:RobbeDelporte/disco-shell.git ~/disco-shell && cd ~/disco-shell && cargo build --release && cp target/release/disco-shell ~/.local/bin/`
5. Reboot

See [docs/package-setup-guide.md](docs/package-setup-guide.md) for detailed package management.

## Theme

Visual style based on **Disco Elysium** — dark, warm, painterly, literary. Colors pipetted from the game's UI. See [docs/style-guide.md](docs/style-guide.md) for the complete palette and [docs/style-overview.html](docs/style-overview.html) for a visual reference.

## Supported Machines

- `system76` — System76 laptop (primary)
- `tuxedo` — Tuxedo laptop (secondary)

## Key Bindings

| Action | Bind |
|--------|------|
| Terminal | Super+Return / Super+T |
| Launcher | Super+D / Super+/ |
| Close window | Super+Q |
| Toggle float | Super+V |
| Fullscreen | Super+F |
| Focus | Super+HJKL / Arrows |
| Move window | Super+Shift+HJKL / Arrows |
| Resize | Super+Ctrl+HJKL / Arrows |
| Workspaces | Super+1-9 |
| Screenshot | Super+S (area) / Super+Shift+S (full) |
| Clipboard | Super+Shift+V |
| Lock | Super+Ctrl+L |
| Power menu | Super+Shift+E |
| Notifications | Super+N |
