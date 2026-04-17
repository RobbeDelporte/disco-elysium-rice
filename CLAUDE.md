# Project Context for Claude

## What This Is

Personal Arch Linux + Hyprland + Quickshell desktop rice, built on top of
three **forked** caelestia-dots repos (we own the forks:
`RobbeDelporte/shell`, `RobbeDelporte/cli`, `RobbeDelporte/caelestia`).
Target machines: System76 Gazelle (gazelle) and Tuxedo (tuxedo). Long-term
visual goal: *Disco Elysium* aesthetic (warm dark, painterly).

**Current phase:** caelestia defaults (Material You dynamic palette). Disco
Elysium palette override is future work.

## Repo boundaries

**We own (this repo):**
- `scripts/install.sh` — single fresh-install entry point. Clones the three
  forks, runs install.fish, builds the shell native plugin, installs the
  CLI shim + environment.d config, symlinks zsh/starship, copies wallpapers,
  wires host monitors.
- `meta/update.sh` — syncs all three forks with upstream and rebuilds the
  shell plugin. Runtime of the fork-based workflow.
- `meta/caelestia.code-workspace` — VS Code multi-root workspace spanning
  the rice, the three forks, and the user-config dir.
- `meta/CLAUDE.md` — fork glue doc (shim, plugin, env.d, sync workflow).
- `configs/zsh/.zshrc`, `.zprofile` — port of caelestia's `fish/config.fish` to zsh.
- `configs/starship/starship.toml` — caelestia's starship config (copied verbatim; reused unchanged).
- `docs/style-guide.md`, `docs/mockups/`, `docs/style-overview*.html`, `docs/widgets/` — Disco Elysium palette + widget specs (source of truth for the future override phase).
- `references/disco-elysium/`, `assets/textures/`, `wallpapers/` — design source material.
- `hosts/{system76,tuxedo}/monitors.conf` — per-machine monitor layouts.

**The three caelestia forks (cloned into canonical paths by `install.sh`):**
- `RobbeDelporte/shell` → `~/.config/quickshell/caelestia/` — Quickshell QML shell + native plugin (built from source into `~/.local/lib/qt6/qml`).
- `RobbeDelporte/cli` → `~/.local/share/caelestia-cli/` — the `caelestia` command (scheme, wallpaper).
- `RobbeDelporte/caelestia` (dots) → `~/.local/share/caelestia-dots/` — Hyprland config, keybinds, startup, fish config, foot/fuzzel/thunar/btop/firefox/spicetify/vscode configs. Symlinked into `~/.config/` by its `install.fish`.

Each fork has `origin` = user fork and `upstream` = caelestia-dots canonical;
`scripts/install.sh` wires those remotes on first clone.

## Fork overrides — how the forks win over the AUR packages

The AUR meta `caelestia-meta` installs `caelestia-shell` and `caelestia-cli`
under `/etc/xdg/quickshell/caelestia/` and `/usr/bin/caelestia`. Our forks
shadow both via path precedence:

- **Shell fork:** Quickshell checks `$XDG_CONFIG_HOME/quickshell/` before `/etc/xdg/quickshell/`, so `~/.config/quickshell/caelestia/` wins. The fork also ships native QML modules (`Caelestia.Config`, `Caelestia.Blobs`, `Caelestia.Components`, …) built via CMake to `~/.local/lib/qt6/qml`; `~/.config/environment.d/caelestia-plugin.conf` prepends that to `QML_IMPORT_PATH` so the fork plugin shadows `/usr/lib/qt6/qml/Caelestia`.
- **CLI fork:** `~/.local/bin/caelestia` is a shim that `exec`s the fork. `~/.local/bin` precedes `/usr/bin` in `$PATH`.
- **Dots fork:** `install.fish` (run from the fork) symlinks into `~/.config/*`.

Leave the AUR packages installed — removing `caelestia-meta` would orphan
the ~26 runtime deps (hyprland, quickshell-git, fonts, …) it pulls in.

## Key files

| Path | Purpose |
|------|---------|
| `scripts/install.sh` | Fresh-install entry point. Takes hostname arg. |
| `meta/update.sh` | Sync forks with upstream, rebuild shell plugin. |
| `meta/caelestia.code-workspace` | VS Code workspace (rice + 3 forks + user config). |
| `meta/CLAUDE.md` | Fork glue doc (shim, plugin, env.d, sync workflow). |
| `configs/zsh/.zshrc` | Zsh port of caelestia fish config. |
| `configs/starship/starship.toml` | Caelestia starship config, unmodified. |
| `docs/arch-install-guide.md` | Fresh-install walkthrough. |
| `docs/style-guide.md` | Disco Elysium palette. |
| `~/.local/share/caelestia-dots/` | Dots fork (created by install). |
| `~/.config/quickshell/caelestia/` | Shell fork (created by install). |
| `~/.local/share/caelestia-cli/` | CLI fork (created by install). |
| `~/.config/caelestia/shell.json` | User-level caelestia settings (UI editable). |
| `~/.config/caelestia/user-config.zsh` | Zsh overrides (auto-sourced by our .zshrc). |

## Working conventions

- **Prefer user config to fork edits.** For any caelestia change, first check the Control Center UI / `~/.config/caelestia/shell.json` for an exposed option before editing a fork.
- **Hyprland verification:** after any change to Hyprland config, run `hyprland --verify-config`. The dots fork owns the main `hyprland.conf`; user overrides go into `~/.config/caelestia/hypr-user.conf` (sourced at the end of the upstream config; `install.sh` writes it with a `source =` pointing at this repo's `hosts/<host>/monitors.conf`).
- **Branch `pre-caelestia-archive`** preserves the pre-pivot hand-built rice. Don't delete.

## User preferences

- Login shell: zsh (not fish — fish is only installed to run caelestia's `install.fish`).
- Keybinds from old setup (Super+T terminal, Super+/ launcher) need to be re-applied in a user include once caelestia is running.
- Experienced Linux user (Ubuntu/Pop!_OS), comfortable with Arch and Hyprland.
- Concise explanations preferred.

## Install workflow

```
1. Fresh Arch install (see docs/arch-install-guide.md)
2. git clone https://github.com/RobbeDelporte/disco-elysium-rice ~/disco-elysium-rice
3. cd ~/disco-elysium-rice && ./scripts/install.sh <hostname>   # system76 | tuxedo
4. Reboot, log back in at TTY1 (re-login is needed for QML_IMPORT_PATH to take effect)
5. uwsm start hyprland-uwsm.desktop
```

Subsequent syncs (both machines):

```
yay -Syu                   # system + AUR deps
./meta/update.sh           # fork sync + plugin rebuild
```

## Future work (scoped out for now)

1. Disco Elysium palette → `schemes/disco-elysium.json` loaded via `caelestia scheme set`
2. If scheme proves insufficient: patch `services/Colours.qml` in the shell fork.
3. Wire `assets/textures/` (film-tape, scratch-bg) into Quickshell surfaces.
4. Port old keybinds into user-override Hyprland include.

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
  widgets/               # per-widget specs
hosts/
  system76/monitors.conf
  tuxedo/monitors.conf
meta/
  update.sh              # fork sync + plugin rebuild
  CLAUDE.md              # fork glue doc
  caelestia.code-workspace
references/
  disco-elysium/         # game screenshots
scripts/
  install.sh             # fresh-install entry point
wallpapers/
```
