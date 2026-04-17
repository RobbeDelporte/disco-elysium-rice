# Disco Elysium Rice

Arch Linux + Hyprland desktop, built on top of [caelestia-dots](https://github.com/caelestia-dots). Visual north-star: the video game *Disco Elysium* — warm dark, painterly, literary.

**Current state:** pivoted to caelestia-dots with its stock Material You dynamic theming. The Disco Elysium palette override is future work — the style guide and reference material in this repo are the source of truth for that phase.

## What this repo provides

- `scripts/install.sh <hostname>` — single fresh-install entry point. Clones three personal caelestia forks, runs `install.fish`, builds the shell native plugin, installs the CLI shim + environment.d config, symlinks zsh/starship, copies wallpapers, wires host monitors.
- `meta/update.sh` — sync all three forks with upstream and rebuild the shell plugin.
- `meta/caelestia.code-workspace` — VS Code multi-root workspace (rice + 3 forks + user config dir).
- `meta/CLAUDE.md` — fork glue doc (shim, plugin, env.d, sync workflow).
- `configs/zsh/` — zsh translation of caelestia's fish config (aliases, color sequences, OSC 133 prompt marks, user-config sourcing).
- `configs/starship/starship.toml` — caelestia's starship config, unmodified (used directly by zsh).
- `docs/style-guide.md` — Disco Elysium color palette pipetted from the game.
- `docs/mockups/`, `docs/style-overview*.html` — visual references.
- `references/disco-elysium/` — game screenshots.
- `assets/textures/` — film-tape, scratch-bg, brush strips (will be wired into the shell during the palette override phase).
- `wallpapers/` — wallpaper collection.
- `hosts/{system76,tuxedo}/monitors.conf` — per-machine monitor layouts.

## Upstream (three personal forks)

The desktop itself — bar, launcher, notifications, lock screen, OSD, terminal theming, Hyprland config — comes from three **personal forks** of caelestia-dots. `scripts/install.sh` clones all three and wires up `origin` (user fork) + `upstream` (caelestia-dots) remotes automatically:

| Role | Fork (origin) | Upstream | Canonical path |
|------|---------------|----------|----------------|
| Shell (QML) | `RobbeDelporte/shell` | `caelestia-dots/shell` | `~/.config/quickshell/caelestia/` |
| CLI (Python) | `RobbeDelporte/cli` | `caelestia-dots/cli` | `~/.local/share/caelestia-cli/` |
| Dots (configs) | `RobbeDelporte/caelestia` | `caelestia-dots/caelestia` | `~/.local/share/caelestia-dots/` |

The shell fork ships native QML modules (`Caelestia.Config`, `Caelestia.Blobs`, `Caelestia.Components`) that the AUR `caelestia-shell` plugin does not — they are built from source by `install.sh` into `~/.local/lib/qt6/qml/Caelestia`. The CLI fork is exposed via a shim at `~/.local/bin/caelestia`. The dots fork's `install.fish` symlinks `hypr`, `foot`, `fish`, `fastfetch`, `uwsm`, `btop`, `starship.toml` into `~/.config/`. **Don't move or delete any of the three clones** — live configs point into them.

See `meta/CLAUDE.md` for full detail on how each fork shadows its AUR counterpart.

## Install

```bash
# On a fresh Arch system (see docs/arch-install-guide.md for base install)
git clone https://github.com/RobbeDelporte/disco-elysium-rice ~/disco-elysium-rice
cd ~/disco-elysium-rice
./scripts/install.sh system76    # or 'tuxedo'
sudo reboot
```

After reboot, log in at TTY1 (a fresh login is required — `QML_IMPORT_PATH` is set via `environment.d` and only picked up at login, not by reload) and start a session:

```bash
uwsm start hyprland-uwsm.desktop
```

No display manager is installed by default — install `greetd`+`tuigreet` or `ly` yourself if you want graphical login. First launch may take a moment while caelestia generates its scheme from the default wallpaper.

Re-running `./scripts/install.sh <hostname>` on an already-installed machine is safe; every step is idempotent (clones skip if `.git` exists, cmake does an incremental build, shim/env.d writes are diff-guarded, symlinks are `ln -sf`).

Useful commands post-install:
```bash
caelestia --help              # CLI entry point (resolves to the fork via shim)
caelestia scheme set <name>   # change color scheme
caelestia wallpaper set <img> # change wallpaper (regenerates scheme)
qs list                       # running quickshell instances
```

## Syncing with upstream

Two steps — system/AUR deps via pacman/yay, then the three forks via `meta/update.sh`:

```bash
yay -Syu                   # 1. hyprland, quickshell-git, foot, fonts, …
./meta/update.sh           # 2. fetch upstream + ff-merge + push origin (all 3 forks) + rebuild shell plugin
```

Options:

```bash
./meta/update.sh shell           # just one repo
./meta/update.sh --force-stash   # auto-stash dirty trees
```

## Verifying the forks are active

```sh
which caelestia                                    # → ~/.local/bin/caelestia (not /usr/bin)
ls ~/.config/quickshell/caelestia/shell.qml        # exists
readlink ~/.config/hypr                            # → ~/.local/share/caelestia-dots/hypr
ls ~/.local/lib/qt6/qml/Caelestia/libcaelestia.so  # exists (native plugin)
```

If any of those resolve into `/usr/` or `/etc/` instead, an override has broken — start there.

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

This repo: MIT. Caelestia-dots (and therefore our forks of it): GPL-3.0 — applies to any changes we make in `RobbeDelporte/shell`, `RobbeDelporte/cli`, and `RobbeDelporte/caelestia`.

## Archive

The pre-pivot hand-built rice lives on branch `pre-caelestia-archive`.
