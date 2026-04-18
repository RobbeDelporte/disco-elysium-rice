#!/usr/bin/env bash
# caelestia fork-based installer
#
# Usage: ./scripts/install.sh <hostname>
#   hostname ∈ { system76, tuxedo }
#
# What this does (each step is idempotent — safe to re-run):
#   1. Installs an AUR helper (yay) if missing
#   2. Installs bootstrap packages (fish, zsh, networkmanager, build tools)
#      and host-specific hardware packages
#   3. Clones the three personal caelestia forks to their canonical paths,
#      wiring origin (user fork) + upstream (caelestia-dots) remotes:
#        - RobbeDelporte/caelestia → ~/.local/share/caelestia-dots
#        - RobbeDelporte/shell     → ~/.config/quickshell/caelestia
#        - RobbeDelporte/cli       → ~/.local/share/caelestia-cli
#   4. Runs caelestia's install.fish from the dots fork (installs
#      caelestia-meta + symlinks caelestia configs into ~/.config/)
#   5. Builds and installs the native QML plugin from the shell fork
#   6. Installs the CLI shim at ~/.local/bin/caelestia
#   7. Installs environment.d config that prepends the fork plugin dir
#      to QML_IMPORT_PATH
#   8. Symlinks this repo's per-app folders into their destinations
#      (zsh/, caelestia/, git/, mimeapps.list)
#   9. Copies wallpapers to ~/Pictures/Wallpapers
#  10. Wires host monitor config into caelestia's user include
#  11. Sets zsh as login shell; enables NetworkManager + PipeWire services
#
# After first run, keep things up to date with:
#   yay -Syu && ./scripts/update.sh

set -euo pipefail

HOST="${1:-}"
if [[ -z "$HOST" ]]; then
    echo "usage: $0 <hostname>"
    echo "  hostname: system76 | tuxedo"
    exit 1
fi

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
HOST_DIR="$REPO_ROOT/hosts/$HOST"
if [[ ! -d "$HOST_DIR" ]]; then
    echo "unknown host: $HOST (expected hosts/$HOST/ to exist)"
    exit 1
fi

CAELESTIA_DOTS="$HOME/.local/share/caelestia-dots"
CAELESTIA_SHELL="$HOME/.config/quickshell/caelestia"
CAELESTIA_CLI="$HOME/.local/share/caelestia-cli"

log()   { printf '\e[36m:: %s\e[0m\n' "$*"; }
warn()  { printf '\e[33m!! %s\e[0m\n' "$*"; }

# --- helper: clone a fork, or verify remotes if already present ---
clone_fork() {
    local origin_url="$1" upstream_url="$2" dest="$3"
    if [[ -d "$dest/.git" ]]; then
        local cur_origin
        cur_origin=$(git -C "$dest" remote get-url origin 2>/dev/null || echo "")
        if [[ "$cur_origin" != "$origin_url" ]]; then
            warn "$dest exists but origin is '$cur_origin' (expected '$origin_url') — leaving alone"
        fi
        if ! git -C "$dest" remote get-url upstream >/dev/null 2>&1; then
            log "Adding upstream remote to $dest"
            git -C "$dest" remote add upstream "$upstream_url"
        fi
        return 0
    fi
    log "Cloning $origin_url → $dest"
    mkdir -p "$(dirname "$dest")"
    git clone "$origin_url" "$dest"
    git -C "$dest" remote add upstream "$upstream_url"
}

# --- helper: write a file if missing or contents differ ---
write_if_changed() {
    local dest="$1" mode="$2" content="$3"
    mkdir -p "$(dirname "$dest")"
    if [[ -f "$dest" ]] && [[ "$(cat "$dest")" == "$content" ]]; then
        return 0
    fi
    printf '%s' "$content" > "$dest"
    chmod "$mode" "$dest"
    log "Wrote $dest"
}

# --- helper: atomically replace $dest with a symlink to $target,
#             backing up any pre-existing non-symlink file/dir to .bak ---
link_tracked() {
    local target="$1" dest="$2"
    # Already pointing at the right place? Noop.
    if [[ -L "$dest" ]] && [[ "$(readlink -- "$dest")" == "$target" ]]; then
        return 0
    fi
    mkdir -p "$(dirname "$dest")"
    # If the destination is a real file/dir (not a symlink), preserve it.
    if [[ -e "$dest" && ! -L "$dest" ]]; then
        warn "Backing up existing $dest → $dest.bak"
        mv -- "$dest" "$dest.bak"
    fi
    ln -sfn -- "$target" "$dest"
    log "Linked $dest → $target"
}

# --- 1. AUR helper ---
if ! command -v yay >/dev/null; then
    log "Installing yay (AUR helper)..."
    sudo pacman -S --needed --noconfirm base-devel git
    tmp=$(mktemp -d)
    git clone https://aur.archlinux.org/yay.git "$tmp/yay"
    (cd "$tmp/yay" && makepkg -si --noconfirm)
    rm -rf "$tmp"
fi

# --- 2. Packages ---
# Caelestia's install.fish installs its own metapackage (caelestia-meta),
# which pulls in all runtime deps: hyprland, quickshell, caelestia-shell,
# caelestia-cli, foot, fuzzel, fonts, pipewire, portals, etc.
# We install what caelestia does NOT cover: fish (to run install.fish),
# zsh (our login shell), networkmanager, host-specific hardware, and the
# build toolchain for the native shell plugin.
log "Installing bootstrap + host-specific packages..."

PACMAN_PKGS=(
    fish                         # runtime for caelestia's install.fish
    zsh                          # our login shell
    networkmanager               # ensure it's installed before we enable it
    cmake                        # build system for the shell native plugin
    ninja                        # faster build backend for cmake
    pkgconf                      # cmake find_package dep
    base-devel                   # make, gcc, ... for the plugin build
)

AUR_PKGS=()

case "$HOST" in
    system76)
        AUR_PKGS+=(system76-power system76-dkms)
        ;;
    tuxedo)
        AUR_PKGS+=(tuxedo-drivers-dkms tuxedo-control-center-bin)
        ;;
esac

sudo pacman -S --needed --noconfirm "${PACMAN_PKGS[@]}"
if ((${#AUR_PKGS[@]})); then
    yay -S --needed --noconfirm "${AUR_PKGS[@]}"
fi

# --- 3. Clone the three personal caelestia forks ---
log "Setting up caelestia forks..."
clone_fork \
    https://github.com/RobbeDelporte/caelestia.git \
    https://github.com/caelestia-dots/caelestia.git \
    "$CAELESTIA_DOTS"
clone_fork \
    https://github.com/RobbeDelporte/shell.git \
    https://github.com/caelestia-dots/shell.git \
    "$CAELESTIA_SHELL"
clone_fork \
    https://github.com/RobbeDelporte/cli.git \
    https://github.com/caelestia-dots/cli.git \
    "$CAELESTIA_CLI"

# Clean up the legacy ~/caelestia-upstream convenience symlink — the
# VSCode workspace in this repo already reaches the dots fork directly.
rm -f "$HOME/caelestia-upstream"

# --- 4. Run caelestia's install.fish (from the dots fork) ---
log "Running install.fish from the dots fork..."
warn "install.fish with --noconfirm will overwrite any non-fork configs under ~/.config/"
(cd "$CAELESTIA_DOTS" && fish ./install.fish --aur-helper=yay --noconfirm)

# --- 5. Build the native QML plugin from the shell fork ---
# The fork ships QML modules (Caelestia.Config / Blobs / Components / ...) that
# the AUR caelestia-shell plugin doesn't have. Configure once, then build +
# install. cmake handles incremental builds, so re-runs are fast.
log "Building shell native QML plugin..."
cmake -B "$CAELESTIA_SHELL/build" -S "$CAELESTIA_SHELL" -G Ninja \
    -DCMAKE_BUILD_TYPE=Release \
    -DENABLE_MODULES=plugin \
    -DCMAKE_INSTALL_PREFIX="$HOME/.local" \
    -DINSTALL_QMLDIR=lib/qt6/qml \
    -DINSTALL_LIBDIR=lib/caelestia
cmake --build "$CAELESTIA_SHELL/build" -j"$(nproc)"
cmake --install "$CAELESTIA_SHELL/build"

# --- 6. CLI shim so `caelestia` resolves to the fork, not /usr/bin/caelestia ---
write_if_changed "$HOME/.local/bin/caelestia" 755 "#!/usr/bin/env sh
# Wrapper: use forked caelestia CLI at ~/.local/share/caelestia-cli instead of AUR install
exec \"\$HOME/.local/share/caelestia-cli/bin/caelestia\" \"\$@\"
"

# --- 7. Environment file: prepend fork plugin dir to QML_IMPORT_PATH ---
# Loaded by the systemd user manager at login; inherited by UWSM. Requires a
# re-login (not just a reload) to take effect.
write_if_changed "$HOME/.config/environment.d/caelestia-plugin.conf" 644 "QML_IMPORT_PATH=\${HOME}/.local/lib/qt6/qml:\${QML_IMPORT_PATH}
QML2_IMPORT_PATH=\${HOME}/.local/lib/qt6/qml:\${QML2_IMPORT_PATH}
"

# --- 8. Symlink this repo's tracked configs into their destinations ---
# Per-app folders at the repo root mirror caelestia-dots' layout; each maps
# to one destination. link_tracked backs up pre-existing real files to .bak.
log "Symlinking tracked configs..."
link_tracked "$REPO_ROOT/zsh/.zshrc"               "$HOME/.zshrc"
link_tracked "$REPO_ROOT/zsh/.zprofile"            "$HOME/.zprofile"
link_tracked "$REPO_ROOT/caelestia/shell.json"     "$HOME/.config/caelestia/shell.json"
link_tracked "$REPO_ROOT/caelestia/hypr-user.conf" "$HOME/.config/caelestia/hypr-user.conf"
link_tracked "$REPO_ROOT/caelestia/hypr-vars.conf" "$HOME/.config/caelestia/hypr-vars.conf"
link_tracked "$REPO_ROOT/mimeapps.list"            "$HOME/.config/mimeapps.list"
link_tracked "$REPO_ROOT/git/ignore"               "$HOME/.config/git/ignore"

# --- 9. Wallpapers ---
# Copy (not symlink) — caelestia's Quickshell FileSystemModel doesn't follow
# symlinks, so the picker won't see linked files.
WALL_DIR="$HOME/Pictures/Wallpapers"
mkdir -p "$WALL_DIR"
for wall in "$REPO_ROOT/wallpapers"/*.png; do
    [[ -f "$wall" ]] || continue
    cp -u "$wall" "$WALL_DIR/$(basename "$wall")"
done
log "Copied wallpapers to $WALL_DIR"

# --- 10. Host monitors — link the current host's monitors.conf into the
# live caelestia config dir so the tracked hypr-user.conf can source it
# host-agnostically.
if [[ -f "$HOST_DIR/monitors.conf" ]]; then
    link_tracked "$HOST_DIR/monitors.conf" \
                 "$HOME/.config/caelestia/monitors-host.conf"
fi

# --- 11. Login shell + services ---
# Make zsh the login shell
if [[ "$(getent passwd "$USER" | cut -d: -f7)" != "$(command -v zsh)" ]]; then
    log "Setting zsh as login shell (will prompt for password)..."
    chsh -s "$(command -v zsh)"
fi

log "Enabling services..."
sudo systemctl enable --now NetworkManager.service
systemctl --user enable --now pipewire.service pipewire-pulse.service wireplumber.service

log "Done."
log "  Reboot, then log in at TTY1 (re-login is needed for QML_IMPORT_PATH to pick up)."
log "  Start a session:        uwsm start hyprland-uwsm.desktop"
log "  Sync forks later with:  $REPO_ROOT/scripts/update.sh"
log "  Shell sanity check:     qs -c caelestia"
log "  Scheme / wallpaper:     caelestia --help"
