# my-dots — caelestia fork glue + personal rice

This repo (`~/my-dots`) is the orchestration layer for a caelestia-based
Hyprland rice. It wires three personal caelestia forks together, holds
per-host and personal configs that aren't in the forks, and ships the
install + update scripts.

## The three forks and where they live

| Repo           | Fork                      | Local clone                      | How it wins over the AUR copy |
|----------------|---------------------------|----------------------------------|-------------------------------|
| Shell (QML)    | `RobbeDelporte/shell`     | `~/.config/quickshell/caelestia` | Quickshell checks `$XDG_CONFIG_HOME/quickshell/` before `/etc/xdg/quickshell/`, so the fork is found first. The fork also ships a native QML plugin (`Caelestia.Config/Blobs/Components/...`) built via CMake to `~/.local/lib/qt6/qml`; `~/.config/environment.d/caelestia-plugin.conf` prepends that to `QML_IMPORT_PATH` so it shadows the AUR plugin at `/usr/lib/qt6/qml/Caelestia`. |
| CLI (Python)   | `RobbeDelporte/cli`       | `~/.local/share/caelestia-cli`   | `~/.local/bin/caelestia` shim execs the fork. `~/.local/bin` precedes `/usr/bin` in `$PATH`, shadowing `/usr/bin/caelestia`. |
| Dots (configs) | `RobbeDelporte/caelestia` | `~/.local/share/caelestia-dots`  | `install.fish` (run from the fork) symlinks its subdirs into `~/.config/*`. |

Each clone has `origin` → user fork and `upstream` → caelestia-dots upstream.
`scripts/install.sh` sets that up on first clone.

## What this repo tracks on top of the forks

Per-app folders at the repo root (mirroring caelestia-dots' own layout).
`scripts/install.sh` symlinks each into its destination:

| repo path                      | → | destination                              |
|--------------------------------|---|------------------------------------------|
| `caelestia/shell.json`         | → | `~/.config/caelestia/shell.json`         |
| `caelestia/hypr-user.conf`     | → | `~/.config/caelestia/hypr-user.conf`     |
| `git/ignore`                   | → | `~/.config/git/ignore`                   |
| `mimeapps.list`                | → | `~/.config/mimeapps.list`                |
| `zsh/.zshrc`                   | → | `~/.zshrc`                               |
| `zsh/.zprofile`                | → | `~/.zprofile`                            |

Plus:

- `hosts/<hostname>/monitors.conf` — per-machine Hyprland monitor block.
  `install.sh` links `~/.config/caelestia/monitors-host.conf` to the
  current host's file. `caelestia/hypr-user.conf` sources that link.
- `wallpapers/` — copied (not symlinked) to `~/Pictures/Wallpapers/`.
  Quickshell's `FileSystemModel` doesn't follow symlinks, so the picker
  needs real files.
- `caelestia.code-workspace` — multi-root VSCode workspace covering this
  repo + the three fork clones.

## Fresh-machine install

```sh
git clone https://github.com/RobbeDelporte/my-dots.git ~/my-dots
cd ~/my-dots
./scripts/install.sh <hostname>    # system76 | tuxedo
```

What it does (idempotent — safe to re-run):

1. Installs `yay` if missing.
2. Installs bootstrap + host-hardware packages (fish/zsh/NetworkManager/cmake,
   plus system76 or tuxedo drivers).
3. Clones the three personal forks with `origin` + `upstream` remotes.
4. Runs `install.fish` from the dots fork (installs `caelestia-meta` and
   symlinks the dots' subdirs into `~/.config/*`).
5. Configures and builds the shell fork's native QML plugin into
   `~/.local/lib/qt6/qml/Caelestia/`.
6. Writes `~/.local/bin/caelestia` shim and
   `~/.config/environment.d/caelestia-plugin.conf`.
7. Symlinks this repo's tracked configs into their destinations (see
   table above).
8. Copies wallpapers into `~/Pictures/Wallpapers/`.
9. Sets zsh as login shell.
10. Enables NetworkManager + PipeWire user services.

After it runs, reboot, log in at TTY1, and `~/.zprofile` hands off to UWSM.

## Syncing the forks with upstream

```sh
yay -Syu                     # 1. system + AUR deps (hyprland, quickshell-git, ...)
./scripts/update.sh          # 2. fork sync + plugin rebuild
```

Order matters: bump `quickshell-git` first, then rebuild the native plugin
against it (the script reconfigures cmake before rebuilding so ABI bumps
are picked up).

Per-repo syncing:

```sh
./scripts/update.sh shell            # just one repo
./scripts/update.sh --force-stash    # auto-stash dirty trees before syncing
```

Per repo the script does: `git fetch upstream && git merge --ff-only
upstream/main && git push origin main`. If HEAD is on a feature branch, it
switches to `main`, syncs, switches back, and rebases the feature branch
onto the new `main` (aborting cleanly on conflict).

## Native plugin build (reference)

The shell fork imports QML modules (`Caelestia.Config`, `Caelestia.Blobs`,
`Caelestia.Components`) that the AUR `caelestia-shell` plugin does not
ship. They are built from source by `scripts/install.sh`:

```sh
cd ~/.config/quickshell/caelestia
cmake -B build -S . -G Ninja \
    -DCMAKE_BUILD_TYPE=Release \
    -DENABLE_MODULES=plugin \
    -DCMAKE_INSTALL_PREFIX="$HOME/.local" \
    -DINSTALL_QMLDIR=lib/qt6/qml \
    -DINSTALL_LIBDIR=lib/caelestia
cmake --build build -j"$(nproc)"
cmake --install build
```

`scripts/update.sh` reconfigures + rebuilds automatically after syncing
the shell repo. Session env wiring lives in
`~/.config/environment.d/caelestia-plugin.conf` (loaded by the systemd user
manager, inherited by UWSM). A re-login (not just a reload) is required
after changing it.

## Standard change workflow

Same pattern for all three forks:

```sh
git checkout main && git pull upstream main    # or run scripts/update.sh
git checkout -b <topic>                         # branch
# ... edit files, reload the relevant app ...
git commit -am "..."
git push -u origin <topic>                      # to your fork
gh pr create --repo caelestia-dots/<repo>       # optional: upstream PR
```

For this repo, just commit and push to `origin` — there is no upstream
to PR against.

## Verifying everything is still wired correctly

```sh
which caelestia
# → /home/<you>/.local/bin/caelestia  (not /usr/bin/caelestia)

ls ~/.config/quickshell/caelestia/shell.qml
# → file exists (your shell fork)

readlink ~/.config/foot/foot.ini
# → ~/.local/share/caelestia-dots/foot/foot.ini
readlink ~/.config/hypr
# → ~/.local/share/caelestia-dots/hypr
readlink ~/.zshrc
# → ~/my-dots/zsh/.zshrc

ls ~/.local/lib/qt6/qml/Caelestia/libcaelestia.so
# → file exists (native plugin built from shell fork)
```

If any of those resolve into `/usr/`, `/etc/`, or return nothing, an
override has broken — start there.

## AUR packages: why they're still installed

`pacman -Qs caelestia` lists `caelestia-cli`, `caelestia-shell`,
`caelestia-meta`, `caelestia-shell-debug`. Leave them installed:

- `caelestia-shell` installs into `/etc/xdg/quickshell/caelestia/` — shadowed by your fork at `~/.config/quickshell/caelestia/`.
- `caelestia-cli` installs `/usr/bin/caelestia` — shadowed by the shim.
- `caelestia-meta` installs no files but pulls in ~26 runtime deps (hyprland, quickshell-git, foot, fish, fonts, grim, slurp, …). Removing it would orphan all of them.

## Do not

- Don't push to any `upstream` remote.
- Don't edit files under `/etc/xdg/quickshell/caelestia/`, `/usr/bin/caelestia`, or the system Python package — they're overwritten on every AUR upgrade.
