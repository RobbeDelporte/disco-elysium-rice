# Quickshell Pivot — Design Spec

Replace the Rust + GPUI `disco-shell` binary with a Quickshell (QML)
configuration owned by this rice repo. Motivation: the desktop redesign
(`2026-04-13-desktop-redesign-design.md`) leans on painterly PNG assets as
first-class UI elements — background fills, borders, bg+border panels.
GPUI's styling model is too constrained for that; QML's `Image` /
`BorderImage` / tiled fills / shaders fit the art direction natively, and
hot-reload gives a much faster iteration loop for asset-driven widgets.

This spec covers the **foundation** of the pivot only:

1. Hard-cutover cleanup of the existing Rust shell.
2. Quickshell scaffold inside this repo.
3. Hyprland rewiring (autostart + IPC keybinds).
4. One reference widget (Power Menu) fully implemented end-to-end.

Every other widget from the desktop redesign gets its own follow-up
brainstorm → spec → plan cycle, using this foundation and the Power Menu
as a template.

## Goals

1. Retire `disco-shell` (binary, repo, install artifacts, Hyprland lines)
   so the system is clean of the old implementation.
2. Stand up a Quickshell config in `configs/quickshell/` that is
   symlink-installed like every other config in this rice.
3. Port the style-guide design tokens into a `Theme` QML singleton that
   all future widgets reference.
4. Establish one idiomatic per-widget pattern (single QML file, summoned
   via an IPC toggle, uses assets from `assets/textures/`) by fully
   implementing the Power Menu per `docs/widgets/power-menu.md`.
5. Preserve hot-reload: edits in `configs/quickshell/` must update the
   running shell without a rebuild.

## Non-Goals

- Porting any other widget (info panel, launcher, lockscreen, overview,
  switcher, OSD, notification toast). Each is its own spec.
- Preserving `disco-shell` Rust services. Quickshell built-ins
  (`Mpris`, `Pipewire`, `UPower`, `Bluez` via DBus, `NetworkManager` via
  DBus, `Hyprland`, `Notifications`, `DesktopEntries`) replace them.
- Reusing any disco-shell code or keeping the repo reachable from this
  one.
- Changing Hyprland, Kitty, Zsh, or any other existing config.
- Implementing the style-guide rework or film-artifact texture pipeline.
  Those are style concerns only; this pivot consumes assets as produced.
- Automated tests. Verification is checklist-based, run live.

## Architecture

### Repo layout

```
configs/quickshell/
  shell.qml          # root: imports Theme, IpcHandlers, widget LazyLoaders
  Theme.qml          # Singleton: colors, fonts, easings, spacing
  IpcHandlers.qml    # IpcHandler target "shell" with toggle(name) function
  widgets/
    PowerMenu.qml    # reference widget (this spec)
    # other widgets added by follow-up specs
  assets -> ../../assets/textures   # symlink; canonical assets live at repo root
```

`install.sh` symlinks `configs/quickshell/` to `~/.config/quickshell/`,
matching the treatment of every other config directory in this repo.
Quickshell's filesystem watcher follows symlinks, so hot-reload fires on
edits to the repo file.

### Theme singleton

`Theme.qml` is a `pragma Singleton` QML object exposing:

- `colors.*` — palette from `docs/style-guide.md`.
- `fonts.*` — family names (`Playfair Display`, `Archivo Narrow`, etc.)
  and common sizes.
- `easings.disco` — the named easing `cubic-bezier(0.25, 0.1, 0.25, 1.0)`.
- `spacing.*` — shared padding/gap constants.

Widgets reference `Theme.colors.panelBg`, `Theme.fonts.banner`, etc. This
replaces `crates/app/src/theme.rs` from the old Rust shell. Token values
are authoritative in the style guide; `Theme.qml` is the transport.

### IPC shape

One `IpcHandler { target: "shell" }` exposing a single function:

```
function toggle(name: string): void
```

Each widget is wrapped in a `LazyLoader` keyed by `name` in `shell.qml`.
`toggle(name)` flips the matching loader's `active`. This mirrors the old
`disco-shell toggle <widget>` command 1:1 so Hyprland keybind migration
is a mechanical rename.

### Hyprland wiring

- Autostart: `exec-once = sh -c 'while true; do qs 2>>/tmp/qs.log; sleep 0.5; done'`
  (same auto-restart pattern as the current disco-shell line).
- Keybinds: every `disco-shell toggle X` becomes `qs ipc call shell toggle X`.
- For widgets deferred to later specs, bindings are left commented with
  `# TODO (widget spec)` so the intent is preserved and the key isn't
  accidentally reassigned.

### Per-widget pattern (established by Power Menu, copied by later specs)

Each widget is one QML file under `widgets/`. Structure:

- `PanelWindow` (layer-shell) with layer and exclusive-zone chosen per
  widget state (Peek / Ceremonial / Ephemeral from the parent redesign
  spec).
- `visible` bound to the owning `LazyLoader.active`.
- `Theme` references for all colors/fonts/easings.
- `Image` / `BorderImage` for asset surfaces; paths relative to the
  `assets/` symlink.
- `Keys.onEscapePressed` to dismiss via `IpcHandlers.shell.toggle(name)`.

## Power Menu (reference widget)

Implements `docs/widgets/power-menu.md` verbatim. This widget validates
the entire foundation: theme tokens, asset loading, IPC toggle, keybind,
focus capture, and hot-reload — without pulling in live system services.

### Structure — `widgets/PowerMenu.qml`

- `PanelWindow`, full-screen, `WlrLayershell.layer: Overlay`,
  `exclusiveZone: -1`, grabs keyboard focus on summon.
- Backdrop `Rectangle`, `color: "#000000"`, `opacity: 0.72`.
- Top + bottom film edges: `Image { source: "../assets/film-tape.png";
  fillMode: Image.Tile; height: 96 }` anchored to each screen edge. Top
  image has `transform: Scale { yScale: -1 }` so the sprocket side faces
  inward.
- Center panel: `Rectangle`, width 400, height fit-content, `color:
  "#0e1110"`, `border.color: Qt.rgba(54/255, 59/255, 58/255, 0.7)`,
  `border.width: 1`, padding `28 26 22 26`.
- Banner header: `Image { source: "../assets/banner-end-session.png" }`
  (prebaked erosion asset), positioned `top: -14; left: -10` relative to
  the panel. If the asset does not yet exist in the MANIFEST at
  implementation time, the plan ships a flat `#d2d2d2` `Rectangle` with
  Archivo Narrow text as a placeholder and opens a follow-up TODO on the
  texture manifest.
- Row list: `Column` + `Repeater` over a six-item model (label, desc,
  icon, action). Each row = `GridLayout` with columns `24 | 1fr | auto`.
  Selected row: orange left-border (`Theme.colors.highlight`) + subtle
  background tint. Icons are thin-line SVGs loaded as `Image` sources.

### Rows

| # | Label     | Description                          | Action                          |
|---|-----------|--------------------------------------|---------------------------------|
| 1 | Shut Down | Power off the machine.               | `systemctl poweroff`            |
| 2 | Restart   | Reboot and return.                   | `systemctl reboot`              |
| 3 | Suspend   | Sleep the machine; resume later.     | `systemctl suspend`             |
| 4 | Hibernate | Write state to disk; power off.      | `systemctl hibernate`           |
| 5 | Lock      | Stay logged in; lock the screen.     | `loginctl lock-session`         |
| 6 | Log Out   | End Hyprland session.                | `hyprctl dispatch exit`         |

Actions invoked via `Quickshell.execDetached([...])`.

### Interaction

- Keyboard: `Up`/`k` and `Down`/`j` navigate; `Return` / `Enter`
  activates; `Escape` dismisses.
- Pointer: hover selects; click activates.
- Dismissing closes the `LazyLoader`, releasing keyboard focus back to
  the compositor.

### Animation

Enter/exit animation semantics come from the parent redesign spec — a
fade + slight scale using `Theme.easings.disco`. Concrete durations and
scale deltas are pulled from the style guide at implementation time.

### IPC / keybind

- IPC: `qs ipc call shell toggle powermenu`.
- Hyprland: `bind = $mod SHIFT, ESCAPE, exec, qs ipc call shell toggle powermenu`.

### Assets used

- `assets/textures/film-tape.png` (exists).
- `assets/textures/banner-end-session.png` (prebaked erosion banner —
  produce as normal asset; placeholder if missing).

## Cleanup & Migration Order

Hard cutover, in order:

1. **Archive `disco-shell`.** In `~/disco-shell`: commit outstanding
   work, push to origin, add a final README note marking the repo
   archived in favor of the Quickshell implementation.
2. **Remove installed disco-shell artifacts.**
   - Kill any running `disco-shell` process.
   - `rm ~/.local/bin/disco-shell`
   - `rm -rf ~/.local/share/disco-shell`
   - `rm -rf ~/disco-shell`
3. **Strip disco-shell from this repo.**
   - Remove the `exec-once` auto-restart line from `configs/hypr/hyprland.conf`.
   - Rewrite every `disco-shell toggle X` bind — repoint the physical
     key at `qs ipc call shell toggle X`, or comment with
     `# TODO (widget spec)` for widgets not yet implemented.
   - Remove the `disco-shell` layer-rules block.
   - Remove any `disco-shell` references from `CLAUDE.md`, `README.md`,
     `install.sh`, `docs/*`.
4. **Install Quickshell.** Add `quickshell` (AUR) to
   `packages/aur.txt`; install on the current box.
5. **Add Quickshell foundation.** Create `configs/quickshell/` with
   `shell.qml`, `Theme.qml`, `IpcHandlers.qml`, the `assets` symlink,
   and a `widgets/` directory with the Power Menu scaffold.
6. **Implement Power Menu** per the section above.
7. **Wire Hyprland.** Add Quickshell `exec-once`; bind
   `Super+Shift+Escape` to the power-menu toggle; leave other
   widget binds commented.
8. **Update `install.sh`.** Add the `configs/quickshell/` symlink step
   and ensure `quickshell` is in the AUR install loop.
9. **Verify** (see next section).

Rust toolchain stays installed — cheap rollback and used elsewhere.

## Verification

Checklist-based, run live on the machine.

- After step 2: `pgrep disco-shell` empty; `command -v disco-shell`
  empty; Hyprland reload logs no missing-binary error.
- After step 3: `hyprland --verify-config` prints `config ok`; reload
  Hyprland; desktop shows wallpaper + windows only.
- After step 4: `qs --version` works.
- After step 5: `qs` starts clean; `/tmp/qs.log` stays empty.
- After step 6–7: `Super+Shift+Escape` summons Power Menu; `Esc`
  dismisses; each of Suspend, Lock, Log Out verified by invoking it;
  Reboot and Shut Down verified last (they end the session).
- Hot-reload: edit a `Theme.qml` color token; the Power Menu updates
  without restarting `qs`.

## Docs updates

- `CLAUDE.md` — swap disco-shell for Quickshell in the Technology
  Choices table (`Desktop shell | Quickshell (QML) | configs/quickshell/`);
  update the install workflow (drop `cargo build` + disco-shell repo
  clone; add `qs` install); note that `~/disco-shell` is archived.
- `README.md` — mirror the install workflow change.
- `docs/widgets/README.md` — note QML is now the implementation target;
  asset-path convention unchanged.
- `docs/on-device-checklist.md` — replace disco-shell verification
  entries with Quickshell startup + Power Menu summon/dismiss.

## Rollback

`git revert` the pivot commits, reinstall disco-shell from its archived
repo (`cargo build --release && ./install.sh`), revert Hyprland binds.
Rust toolchain is still present so rollback takes minutes, not a
rebuild-from-scratch.

## Open Questions

- Exact filename for the prebaked erosion banner asset — resolved
  during implementation when the MANIFEST is updated.
- Whether the Power Menu's enter/exit animation uses opacity+scale or
  a slide — deferred to the implementation plan, sourced from the
  style guide at that point.
