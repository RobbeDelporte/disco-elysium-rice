# Project Context for Claude

## What This Is

Thin overlay on top of [caelestia-dots](https://github.com/caelestia-dots) — an Arch Linux + Hyprland + Quickshell desktop. Target machines: System76 (primary) and Tuxedo (secondary). Long-term visual goal: *Disco Elysium* aesthetic (warm dark, painterly).

**Current phase:** caelestia defaults (Material You dynamic palette). Disco Elysium palette override is future work.

## Repo boundaries

**We own:**
- `scripts/install.sh` — orchestration
- `configs/zsh/.zshrc`, `.zprofile` — port of caelestia's `fish/config.fish` to zsh
- `configs/starship/starship.toml` — caelestia's starship config (copied verbatim; reused unchanged)
- `docs/style-guide.md` + `docs/mockups/` + `docs/style-overview*.html` — Disco Elysium palette (source of truth for future override)
- `references/disco-elysium/` — game screenshots
- `assets/textures/` — film-tape, scratch-bg, brush strips (unused until palette phase)
- `wallpapers/`
- `hosts/{system76,tuxedo}/monitors.conf`

**Upstream (caelestia-dots) owns:**
- Hyprland config, keybinds, startup
- Quickshell QML (bar, launcher, notifications, lock, OSD, powermenu)
- Foot, fuzzel, thunar, btop, firefox, spicetify, vscode configs
- The `caelestia` CLI and scheme generation

Clone lives at `~/.local/share/caelestia-dots/` and is symlinked into `~/.config/` by `install.fish`. **Don't move or delete it.**

## Key files

| Path | Purpose |
|------|---------|
| `scripts/install.sh` | Entry point. Takes hostname arg. |
| `configs/zsh/.zshrc` | Zsh port of caelestia fish config |
| `configs/starship/starship.toml` | Caelestia starship config, unmodified |
| `docs/style-guide.md` | Disco Elysium palette |
| `docs/arch-install-guide.md` | Fresh-install walkthrough |
| `~/.local/share/caelestia-dots/` | Upstream clone (created by install) |
| `~/.config/caelestia/shell.json` | User-level caelestia settings |
| `~/.config/caelestia/user-config.zsh` | Zsh overrides (auto-sourced by our .zshrc) |

## Working conventions

- **Don't fork caelestia unless necessary.** For palette changes, try the scheme mechanism first (`caelestia scheme set`).
- **Don't vendor upstream files.** If something needs changing, either override via user config or fork the relevant caelestia sub-repo cleanly.
- **Hyprland verification:** after any change to Hyprland config, run `hyprland --verify-config`. Note: caelestia owns the main `hyprland.conf` now — user overrides go into a sourced include file.
- **Branch `pre-caelestia-archive`** preserves the pre-pivot state. Don't delete.

## User preferences

- Login shell: zsh (not fish — fish is only installed to run caelestia's `install.fish`)
- Keybinds from old setup (Super+T terminal, Super+/ launcher) need to be re-applied in a user include once caelestia is running
- Experienced Linux user (Ubuntu/Pop!_OS), newer to Arch and Hyprland
- Concise explanations preferred

## Install workflow

```
1. Fresh Arch install (see docs/arch-install-guide.md)
2. git clone https://github.com/RobbeDelporte/disco-elysium-rice ~/disco-elysium-rice
3. cd ~/disco-elysium-rice && ./scripts/install.sh <hostname>
4. Reboot, log into Hyprland
```

## Future work (scoped out for now)

1. Disco Elysium palette → `schemes/disco-elysium.json` loaded via `caelestia scheme set`
2. If that proves insufficient: fork `caelestia-dots/shell`, patch `services/Colours.qml`
3. Wire `assets/textures/` (film-tape, scratch-bg) into the Quickshell surfaces
4. Port old keybinds into user-override Hyprland include

## Repo structure

```
assets/
  textures/              # film-tape, scratch-bg, brush strips
configs/
  zsh/                   # .zshrc, .zprofile (ported from caelestia fish)
  starship/              # starship.toml (verbatim from caelestia)
docs/
  arch-install-guide.md
  style-guide.md         # Disco Elysium palette
  mockups/               # visual references
  style-overview*.html
hosts/
  system76/monitors.conf
  tuxedo/monitors.conf
references/
  disco-elysium/         # game screenshots
scripts/
  install.sh
wallpapers/
```
