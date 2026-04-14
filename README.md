# Disco Elysium Rice

Arch Linux + Hyprland desktop, built on top of [caelestia-dots](https://github.com/caelestia-dots). Visual north-star: the video game *Disco Elysium* — warm dark, painterly, literary.

**Current state:** pivoted to caelestia-dots with its stock Material You dynamic theming. The Disco Elysium palette override is future work — the style guide and reference material in this repo are the source of truth for that phase.

## What this repo provides

- `scripts/install.sh <hostname>` — orchestrates: AUR helper → deps → caelestia clone + `install.fish` → zsh/starship symlinks → host monitor config
- `configs/zsh/` — zsh translation of caelestia's fish config (aliases, color sequences, OSC 133 prompt marks, user-config sourcing)
- `configs/starship/starship.toml` — caelestia's starship config, unmodified (used directly by zsh)
- `docs/style-guide.md` — Disco Elysium color palette pipetted from the game
- `docs/mockups/`, `docs/style-overview*.html` — visual references
- `references/disco-elysium/` — game screenshots
- `assets/textures/` — film-tape, scratch-bg, brush strips (will be wired into the shell during the palette override phase)
- `wallpapers/` — wallpaper collection
- `hosts/{system76,tuxedo}/monitors.conf` — per-machine monitor layouts

## Upstream

The desktop itself — bar, launcher, notifications, lock screen, OSD, terminal theming, Hyprland config — is [caelestia-dots/caelestia](https://github.com/caelestia-dots/caelestia) (Quickshell + Hyprland + foot + fuzzel). We don't vendor it; `install.fish` symlinks from a clone at `~/.local/share/caelestia-dots/` (also exposed as `~/caelestia-upstream` for convenience — edit there when forking). **Don't move or delete the clone** — all caelestia configs are symlinks into it.

Key caelestia repos:
- [caelestia-dots/caelestia](https://github.com/caelestia-dots/caelestia) — meta (installer, hyprland, foot, fish, starship)
- [caelestia-dots/shell](https://github.com/caelestia-dots/shell) — Quickshell QML shell
- [caelestia-dots/cli](https://github.com/caelestia-dots/cli) — `caelestia` command (scheme, wallpaper)

## Install

```bash
# On a fresh Arch system (see docs/arch-install-guide.md for base install)
git clone https://github.com/RobbeDelporte/disco-elysium-rice ~/disco-elysium-rice
cd ~/disco-elysium-rice
./scripts/install.sh system76    # or 'tuxedo'
sudo reboot
```

After reboot, log in at TTY1 and start a session:

```bash
uwsm start hyprland-uwsm.desktop
```

No display manager is installed by default — install `greetd`+`tuigreet` or `ly` yourself if you want graphical login. First launch may take a moment while caelestia generates its scheme from the default wallpaper.

Useful commands post-install:
```bash
caelestia --help              # CLI entry point
caelestia scheme set <name>   # change color scheme
caelestia wallpaper set <img> # change wallpaper (regenerates scheme)
qs list                       # running quickshell instances
```

## Future-work layer

The Disco Elysium palette / widget redesign is not part of the baseline install. Source of truth for that phase:

- `docs/style-guide.md` — palette, surface tiers, typography
- `docs/widgets/` — per-widget specs (info panel, launcher, lockscreen, OSD, ...)
- `docs/mockups/` — HTML mockups matching the specs
- `references/disco-elysium/` — game screenshots
- `assets/textures/` — film-tape, scratch-bg, brush strips

## Roadmap

- [ ] Apply Disco Elysium palette as a caelestia scheme (`schemes/disco-elysium.json`)
- [ ] If scheme format proves too limiting: fork `caelestia-dots/shell` and hardcode `services/Colours.qml`
- [ ] Wire `assets/textures/` (film-tape, scratch-bg) into shell decorations
- [ ] Port any remaining Disco keybinds (Super+T terminal, Super+/ launcher) into a user override include for caelestia's Hyprland config

## License

This repo: MIT. Upstream caelestia-dots components: GPL-3.0 — applies to any forks we make of their QML shell.

## Archive

The pre-pivot hand-built rice lives on branch `pre-caelestia-archive`.
