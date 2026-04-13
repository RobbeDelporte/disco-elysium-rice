# Quickshell Pivot Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the Rust + GPUI `disco-shell` binary with a Quickshell (QML) config owned by this rice, with Power Menu implemented end-to-end as the reference widget.

**Architecture:** Quickshell config lives at `configs/quickshell/` (symlinked to `~/.config/quickshell/` by `install.sh`). A `Theme.qml` singleton exposes style-guide tokens. An `IpcHandlers.qml` exposes `shell.toggle(name)`, which flips `LazyLoader.active` on named widgets. Hyprland autostarts `qs` and binds keys to `qs ipc call shell toggle <name>`. Each widget is a single QML file under `widgets/`.

**Tech Stack:** Quickshell (AUR: `quickshell`), QML (Qt 6), Hyprland, Zsh. Dotfiles model — no build step; hot-reload via file-watch. No test framework; verification is checklist-based and run live on the machine.

---

## Spec Reference

`docs/superpowers/specs/2026-04-13-quickshell-pivot-design.md` — the spec is the source of truth for *what* we're building; this plan is the source of truth for *how*.

## File Map

**Files created by this plan:**
- `configs/quickshell/shell.qml` — root: `ShellRoot` with widget `LazyLoader`s.
- `configs/quickshell/Theme.qml` — `pragma Singleton` with colors/fonts/easings/spacing.
- `configs/quickshell/qmldir` — registers `Theme` singleton.
- `configs/quickshell/IpcHandlers.qml` — `IpcHandler { target: "shell" }` exposing `toggle(name)`.
- `configs/quickshell/widgets/PowerMenu.qml` — Power Menu widget.
- `configs/quickshell/assets` — symlink → `../../assets/textures`.

**Files modified by this plan:**
- `configs/hypr/hyprland.conf` — remove disco-shell `exec-once`, remove layer rule, rewrite keybinds to use `qs ipc call`, add Quickshell `exec-once`.
- `packages/aur.txt` — add `quickshell`.
- `scripts/install.sh` — add a quickshell-specific symlink step if needed (the existing `configs/*/` loop already picks it up; we verify).
- `CLAUDE.md` — update Technology Choices, install workflow, repo structure.
- `README.md` — update install workflow.
- `docs/widgets/README.md` — note QML is the implementation target.
- `docs/on-device-checklist.md` — Quickshell + Power Menu verification entries.

**Filesystem artifacts removed:**
- `~/.local/bin/disco-shell`
- `~/.local/share/disco-shell/`
- `~/disco-shell/` (after it's pushed)

## Execution notes

- This plan mutates the running desktop. After the cleanup tasks (Task 2, Task 3), the shell will be missing and Hyprland will have no bar/menus until Task 7. Expect a wallpaper-only desktop for the duration.
- Tasks are small and each ends with either a commit or a concrete verification. Do not batch commits across tasks.
- "TDD" here means: write the QML, reload, check it visually. No unit tests — this is a personal dotfiles repo with no harness.
- If a step's `rm` or `sed` operation feels irreversible, run `git status` / `ls -la` first to confirm you're operating on the intended path.

---

## Task 1: Archive disco-shell repo

**Files:**
- Modify: `~/disco-shell/README.md`

- [ ] **Step 1: Inspect outstanding work in ~/disco-shell**

Run:
```bash
cd ~/disco-shell && git status && git log --oneline origin/main..HEAD 2>/dev/null
```

Expected: Either clean tree + no unpushed commits, or a list of changes/commits to preserve.

- [ ] **Step 2: Commit any uncommitted work**

If `git status` showed changes:
```bash
cd ~/disco-shell
git add -A
git commit -m "chore: final state before archive"
```

If clean, skip.

- [ ] **Step 3: Add archive notice to the disco-shell README**

Prepend the following paragraph to `~/disco-shell/README.md` above the current first line:

```markdown
> **Archived 2026-04-13.** This repository is no longer developed. The Disco Elysium desktop shell has been rewritten in Quickshell (QML) and now lives inside [disco-elysium-rice](https://github.com/RobbeDelporte/disco-elysium-rice) under `configs/quickshell/`. See that repo's `docs/superpowers/specs/2026-04-13-quickshell-pivot-design.md` for context.

```

- [ ] **Step 4: Commit the archive notice**

```bash
cd ~/disco-shell
git add README.md
git commit -m "docs: mark repo archived in favor of Quickshell rewrite"
```

- [ ] **Step 5: Push to origin**

```bash
cd ~/disco-shell && git push origin HEAD
```

Expected: push succeeds. If not, investigate before continuing (don't delete unpushed work).

---

## Task 2: Remove installed disco-shell artifacts

**Files:**
- Delete: `~/.local/bin/disco-shell`
- Delete: `~/.local/share/disco-shell/`
- Delete: `~/disco-shell/`

- [ ] **Step 1: Kill any running disco-shell process**

```bash
pkill -x disco-shell 2>/dev/null; sleep 1; pgrep disco-shell
```

Expected: no output from `pgrep` (process gone).

- [ ] **Step 2: Remove installed binary and assets**

```bash
rm -f ~/.local/bin/disco-shell
rm -rf ~/.local/share/disco-shell
```

- [ ] **Step 3: Verify origin has the archive commits**

```bash
cd ~/disco-shell && git log origin/main --oneline -2
```

Expected: top commit is the archive-notice commit from Task 1.

- [ ] **Step 4: Remove the repo checkout**

```bash
rm -rf ~/disco-shell
```

- [ ] **Step 5: Verify nothing remains**

```bash
command -v disco-shell; ls -d ~/disco-shell ~/.local/share/disco-shell ~/.local/bin/disco-shell 2>&1
```

Expected: `command -v` prints nothing; `ls` reports "No such file or directory" for all three.

---

## Task 3: Strip disco-shell from Hyprland config

**Files:**
- Modify: `configs/hypr/hyprland.conf` (line 25 autostart, line 118–120 layer rules, lines 151–157 + 253 keybinds)

- [ ] **Step 1: Remove the disco-shell autostart line**

In `configs/hypr/hyprland.conf`, delete line 25:
```
exec-once = sh -c 'while true; do GSK_RENDERER=ngl disco-shell 2>>/tmp/disco-shell.log; pkill -P $$ -x disco-shell 2>/dev/null; sleep 0.5; done'
```

- [ ] **Step 2: Remove the disco-shell layer-rules block**

Delete these three lines (the block at ~118–120):
```
# =============================================
# Layer Rules — disco-shell blur
# =============================================
layerrule = match:namespace = launcher, animation slide 0
```

- [ ] **Step 3: Comment out all disco-shell toggle keybinds**

For each of these lines (numbers before re-numbering may shift — match by content), replace the bind with a commented placeholder carrying the same physical key. Leave a `# TODO (widget spec)` marker so the key isn't accidentally reassigned.

Change:
```
bind = $mod, D, exec, disco-shell toggle launcher
bind = $mod, slash, exec, disco-shell toggle launcher
bind = $mod, period, exec, disco-shell toggle info
bind = ALT, Tab, exec, disco-shell toggle switcher
bind = $mod, Tab, exec, disco-shell toggle overview
bind = $mod, M, exec, disco-shell toggle-music
```

To:
```
# bind = $mod, D, exec, qs ipc call shell toggle launcher           # TODO (launcher widget spec)
# bind = $mod, slash, exec, qs ipc call shell toggle launcher       # TODO (launcher widget spec)
# bind = $mod, period, exec, qs ipc call shell toggle info          # TODO (info-panel widget spec)
# bind = ALT, Tab, exec, qs ipc call shell toggle switcher          # TODO (switcher widget spec)
# bind = $mod, Tab, exec, qs ipc call shell toggle overview         # TODO (overview widget spec)
# bind = $mod, M, exec, qs ipc call shell toggle music              # TODO (music widget spec)
```

Change:
```
bind = $mod SHIFT, Escape, exec, disco-shell toggle powermenu
```

To (leave uncommented — Task 7 will re-enable by pointing at `qs` once the widget exists):
```
# bind = $mod SHIFT, Escape, exec, qs ipc call shell toggle powermenu   # enabled in Task 7
```

- [ ] **Step 4: Verify Hyprland config parses**

```bash
hyprland --verify-config
```

Expected: `config ok`.

- [ ] **Step 5: Reload Hyprland**

```bash
hyprctl reload
```

Expected: desktop shows wallpaper + windows only; no disco-shell bar or overlay; no error notifications. `Super+Shift+Escape` does nothing (bind is commented).

- [ ] **Step 6: Commit**

```bash
cd ~/disco-elysium-rice
git add configs/hypr/hyprland.conf
git commit -m "chore: remove disco-shell from Hyprland config"
```

---

## Task 4: Install Quickshell and add to package list

**Files:**
- Modify: `packages/aur.txt`

- [ ] **Step 1: Install quickshell from AUR**

```bash
yay -S --needed quickshell
```

Expected: package installs. If `yay` asks about conflicts, inspect and resolve — do not force.

- [ ] **Step 2: Verify quickshell command works**

```bash
qs --version
```

Expected: prints a version string, exit 0.

- [ ] **Step 3: Add quickshell to the AUR package list**

Append to `packages/aur.txt`:

```
# Desktop shell
quickshell
```

Add this block at the end of the file.

- [ ] **Step 4: Commit**

```bash
cd ~/disco-elysium-rice
git add packages/aur.txt
git commit -m "feat: install quickshell"
```

---

## Task 5: Create Quickshell directory skeleton and asset symlink

**Files:**
- Create: `configs/quickshell/` directory
- Create: `configs/quickshell/widgets/` directory
- Create: `configs/quickshell/assets` (symlink → `../../assets/textures`)

- [ ] **Step 1: Create the directory structure**

```bash
cd ~/disco-elysium-rice
mkdir -p configs/quickshell/widgets
```

- [ ] **Step 2: Create the assets symlink**

```bash
cd ~/disco-elysium-rice/configs/quickshell
ln -s ../../assets/textures assets
```

- [ ] **Step 3: Verify the symlink resolves and points at the real textures**

```bash
ls -l ~/disco-elysium-rice/configs/quickshell/assets
ls ~/disco-elysium-rice/configs/quickshell/assets/film-tape.png
```

Expected: symlink shows `assets -> ../../assets/textures`; `ls` prints the `film-tape.png` path with no error.

- [ ] **Step 4: Commit (skeleton only, no QML yet)**

Git won't track empty dirs. The next task adds files, so skip commit until content lands.

---

## Task 6: Add Theme singleton

**Files:**
- Create: `configs/quickshell/Theme.qml`
- Create: `configs/quickshell/qmldir`

The Theme tokens below are pulled from `docs/style-guide.md` and from the Power Menu spec (`docs/widgets/power-menu.md`). Only tokens needed now are included — later widgets add more as they go.

- [ ] **Step 1: Write the qmldir**

Create `configs/quickshell/qmldir` with:

```
module quickshell.disco
singleton Theme 1.0 Theme.qml
```

- [ ] **Step 2: Write Theme.qml**

Create `configs/quickshell/Theme.qml` with:

```qml
pragma Singleton

import QtQuick

QtObject {
    readonly property QtObject colors: QtObject {
        readonly property color backdrop: Qt.rgba(0, 0, 0, 0.72)
        readonly property color panelBg: "#0e1110"
        readonly property color panelBorder: Qt.rgba(54/255, 59/255, 58/255, 0.7)
        readonly property color bannerBg: "#d2d2d2"
        readonly property color bannerFg: "#171b1a"
        readonly property color rowFg: "#d2d2d2"
        readonly property color rowFgMuted: Qt.rgba(210/255, 210/255, 210/255, 0.6)
        readonly property color highlight: "#d97b3a"
        readonly property color highlightTint: Qt.rgba(217/255, 123/255, 58/255, 0.08)
    }

    readonly property QtObject fonts: QtObject {
        readonly property string serifDisplay: "Playfair Display"
        readonly property string condensed: "Archivo Narrow"
        readonly property string body: "Libre Baskerville"
    }

    readonly property QtObject easings: QtObject {
        readonly property list<real> disco: [0.25, 0.1, 0.25, 1.0]
        readonly property int ceremonialEnter: 220
        readonly property int ceremonialExit: 160
    }

    readonly property QtObject spacing: QtObject {
        readonly property int panelPadTop: 28
        readonly property int panelPadX: 26
        readonly property int panelPadBottom: 22
        readonly property int rowGap: 8
    }
}
```

- [ ] **Step 3: Commit**

```bash
cd ~/disco-elysium-rice
git add configs/quickshell/Theme.qml configs/quickshell/qmldir configs/quickshell/assets
git commit -m "feat(quickshell): add Theme singleton and assets symlink"
```

---

## Task 7: Add shell.qml root and IPC handler (with empty loader)

**Files:**
- Create: `configs/quickshell/shell.qml`
- Create: `configs/quickshell/IpcHandlers.qml`

- [ ] **Step 1: Write IpcHandlers.qml**

Create `configs/quickshell/IpcHandlers.qml` with:

```qml
import QtQuick
import Quickshell
import Quickshell.Io

IpcHandler {
    target: "shell"

    property var loaders: ({})

    function register(name, loader) {
        loaders[name] = loader
    }

    function toggle(name: string): void {
        const loader = loaders[name]
        if (!loader) {
            console.warn("shell.toggle: unknown widget", name)
            return
        }
        loader.active = !loader.active
    }
}
```

- [ ] **Step 2: Write shell.qml**

Create `configs/quickshell/shell.qml` with:

```qml
import QtQuick
import Quickshell

ShellRoot {
    IpcHandlers { id: ipc }

    LazyLoader {
        id: powermenuLoader
        active: false
        source: "widgets/PowerMenu.qml"
    }

    Component.onCompleted: {
        ipc.register("powermenu", powermenuLoader)
    }
}
```

- [ ] **Step 3: Add a temporary PowerMenu placeholder so shell.qml parses**

Create `configs/quickshell/widgets/PowerMenu.qml` with a minimal stub (full implementation lands in Task 8):

```qml
import QtQuick
import Quickshell

PanelWindow {
    visible: true
    color: "transparent"
    Rectangle { anchors.centerIn: parent; width: 200; height: 80; color: "#0e1110"
        Text { anchors.centerIn: parent; text: "PowerMenu stub"; color: "white" } }
}
```

- [ ] **Step 4: Launch qs manually and verify it loads**

```bash
qs -p ~/disco-elysium-rice/configs/quickshell/shell.qml 2>&1 | head -30
```

Expected: `qs` starts without QML errors. Ctrl-C to stop.

- [ ] **Step 5: Test IPC toggle against the running qs**

In one terminal:
```bash
qs -p ~/disco-elysium-rice/configs/quickshell/shell.qml
```

In another:
```bash
qs ipc call shell toggle powermenu
```

Expected: the "PowerMenu stub" rectangle appears. Run the call again → it disappears. Ctrl-C the first terminal.

- [ ] **Step 6: Commit**

```bash
cd ~/disco-elysium-rice
git add configs/quickshell/shell.qml configs/quickshell/IpcHandlers.qml configs/quickshell/widgets/PowerMenu.qml
git commit -m "feat(quickshell): add shell root, IPC handler, and PowerMenu stub"
```

---

## Task 8: Implement Power Menu widget

**Files:**
- Modify: `configs/quickshell/widgets/PowerMenu.qml` (replace stub with full implementation)

This implements `docs/widgets/power-menu.md` verbatim. The HTML mockup at `docs/mockups/widgets/power-menu.html` is the visual ground truth — open it side-by-side while verifying.

- [ ] **Step 1: Check the banner asset**

```bash
ls ~/disco-elysium-rice/assets/textures/ | grep -i banner
```

If there is a banner asset for "END SESSION", note its filename for Step 2. If not, the placeholder path below is used.

- [ ] **Step 2: Write the full PowerMenu.qml**

Replace `configs/quickshell/widgets/PowerMenu.qml` with:

```qml
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import "../" as Shell

PanelWindow {
    id: root

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
    exclusiveZone: -1
    anchors { top: true; bottom: true; left: true; right: true }
    color: "transparent"

    readonly property var rows: [
        { label: "Shut Down", desc: "Power off the machine.",         action: ["systemctl", "poweroff"] },
        { label: "Restart",   desc: "Reboot and return.",             action: ["systemctl", "reboot"] },
        { label: "Suspend",   desc: "Sleep the machine; resume later.", action: ["systemctl", "suspend"] },
        { label: "Hibernate", desc: "Write state to disk; power off.", action: ["systemctl", "hibernate"] },
        { label: "Lock",      desc: "Stay logged in; lock the screen.", action: ["loginctl", "lock-session"] },
        { label: "Log Out",   desc: "End Hyprland session.",          action: ["hyprctl", "dispatch", "exit"] }
    ]
    property int selected: 0

    function dismiss() {
        Quickshell.ipc.callAsync("shell", "toggle", "powermenu")
    }

    function activate(i) {
        const act = rows[i].action
        Quickshell.execDetached(act)
        dismiss()
    }

    Rectangle { // backdrop
        anchors.fill: parent
        color: Shell.Theme.colors.backdrop
        MouseArea { anchors.fill: parent; onClicked: root.dismiss() }
    }

    Image { // top film edge, flipped
        anchors { top: parent.top; left: parent.left; right: parent.right }
        height: 96
        source: "../assets/film-tape.png"
        fillMode: Image.Tile
        transform: Scale { origin.y: 48; yScale: -1 }
    }

    Image { // bottom film edge
        anchors { bottom: parent.bottom; left: parent.left; right: parent.right }
        height: 96
        source: "../assets/film-tape.png"
        fillMode: Image.Tile
    }

    Rectangle { // center panel
        id: panel
        anchors.centerIn: parent
        width: 400
        implicitHeight: panelLayout.implicitHeight
            + Shell.Theme.spacing.panelPadTop
            + Shell.Theme.spacing.panelPadBottom
        height: implicitHeight
        color: Shell.Theme.colors.panelBg
        border.color: Shell.Theme.colors.panelBorder
        border.width: 1

        Rectangle { // banner header
            id: banner
            x: -10
            y: -14
            width: bannerText.implicitWidth + 18
            height: 24
            color: Shell.Theme.colors.bannerBg
            Text {
                id: bannerText
                anchors.centerIn: parent
                text: "END SESSION"
                font.family: Shell.Theme.fonts.condensed
                font.weight: Font.Bold
                font.pixelSize: 14
                font.letterSpacing: 4
                color: Shell.Theme.colors.bannerFg
            }
        }

        ColumnLayout {
            id: panelLayout
            anchors {
                top: parent.top; left: parent.left; right: parent.right
                topMargin: Shell.Theme.spacing.panelPadTop
                leftMargin: Shell.Theme.spacing.panelPadX
                rightMargin: Shell.Theme.spacing.panelPadX
            }
            spacing: Shell.Theme.spacing.rowGap

            Repeater {
                model: root.rows
                delegate: Rectangle {
                    required property int index
                    required property var modelData
                    Layout.fillWidth: true
                    implicitHeight: rowGrid.implicitHeight + 14
                    color: index === root.selected
                        ? Shell.Theme.colors.highlightTint
                        : "transparent"
                    Rectangle { // selected left border
                        visible: index === root.selected
                        anchors { left: parent.left; top: parent.top; bottom: parent.bottom }
                        width: 2
                        color: Shell.Theme.colors.highlight
                    }

                    GridLayout {
                        id: rowGrid
                        anchors.fill: parent
                        anchors.leftMargin: 10
                        anchors.rightMargin: 10
                        anchors.topMargin: 6
                        anchors.bottomMargin: 6
                        columns: 3
                        columnSpacing: 10

                        Item { // icon slot (placeholder — thin-line SVGs added by style-guide rework)
                            Layout.preferredWidth: 24
                            Layout.preferredHeight: 24
                        }
                        Text {
                            text: modelData.label
                            font.family: Shell.Theme.fonts.condensed
                            font.pixelSize: 14
                            color: Shell.Theme.colors.rowFg
                            Layout.fillWidth: true
                        }
                        Text {
                            text: modelData.desc
                            font.family: Shell.Theme.fonts.condensed
                            font.pixelSize: 11
                            color: Shell.Theme.colors.rowFgMuted
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: root.selected = index
                        onClicked: root.activate(index)
                    }
                }
            }
        }
    }

    Keys.onEscapePressed: root.dismiss()
    Keys.onUpPressed: root.selected = (root.selected - 1 + rows.length) % rows.length
    Keys.onDownPressed: root.selected = (root.selected + 1) % rows.length
    Keys.onReturnPressed: root.activate(root.selected)
    Keys.onEnterPressed: root.activate(root.selected)
    Keys.onPressed: (e) => {
        if (e.key === Qt.Key_K) { root.selected = (root.selected - 1 + rows.length) % rows.length; e.accepted = true }
        else if (e.key === Qt.Key_J) { root.selected = (root.selected + 1) % rows.length; e.accepted = true }
    }

    Component.onCompleted: forceActiveFocus()
}
```

- [ ] **Step 3: Run qs against the shell and toggle the widget**

```bash
qs -p ~/disco-elysium-rice/configs/quickshell/shell.qml &
sleep 1
qs ipc call shell toggle powermenu
```

Expected: Power Menu appears with:
  - dark overlay,
  - film tape at top (flipped) and bottom,
  - centered 400px panel with "END SESSION" banner overhanging top-left,
  - six rows with labels and descriptions,
  - first row highlighted.

- [ ] **Step 4: Verify keyboard interaction**

In the running Power Menu:
  - Press `Down` / `j`: selection moves to the next row; wraps at bottom.
  - Press `Up` / `k`: selection moves back; wraps at top.
  - Press `Esc`: panel dismisses.

Expected: all transitions as described. If focus isn't captured, inspect `forceActiveFocus()` and `WlrKeyboardFocus.Exclusive` wiring.

- [ ] **Step 5: Verify actions (non-destructive ones first)**

Re-summon the panel, navigate to **Lock**, press Enter. Expected: screen locks (hyprlock). Unlock, re-summon, navigate to **Log Out** — do this last since it ends the session. Skip Suspend/Hibernate/Reboot/Shut Down for now; they're verified during on-device checklist runs.

- [ ] **Step 6: Kill the manual qs and commit**

```bash
kill %1 2>/dev/null; pkill -x qs
cd ~/disco-elysium-rice
git add configs/quickshell/widgets/PowerMenu.qml
git commit -m "feat(quickshell): implement Power Menu reference widget"
```

---

## Task 9: Wire Quickshell into Hyprland autostart and re-enable Power Menu keybind

**Files:**
- Modify: `configs/hypr/hyprland.conf`

- [ ] **Step 1: Add Quickshell autostart**

In `configs/hypr/hyprland.conf`, directly above the `hypridle` `exec-once` line (near line 30), add:

```
exec-once = sh -c 'while true; do qs 2>>/tmp/qs.log; sleep 0.5; done'
```

- [ ] **Step 2: Re-enable the Power Menu keybind**

Find the line from Task 3:
```
# bind = $mod SHIFT, Escape, exec, qs ipc call shell toggle powermenu   # enabled in Task 7
```

Replace with:
```
bind = $mod SHIFT, Escape, exec, qs ipc call shell toggle powermenu
```

- [ ] **Step 3: Verify config parses**

```bash
hyprland --verify-config
```

Expected: `config ok`.

- [ ] **Step 4: Reload Hyprland**

```bash
hyprctl reload
sleep 2
pgrep -x qs && echo "qs running"
```

Expected: `qs running` prints.

- [ ] **Step 5: Exercise the keybind**

Press `Super+Shift+Escape`. Expected: Power Menu appears. Press `Esc`: dismisses. Press the keybind again: reappears.

- [ ] **Step 6: Verify hot-reload**

While the menu is closed, edit `configs/quickshell/Theme.qml`: change `highlight` from `"#d97b3a"` to `"#ff0000"`. Save. Press `Super+Shift+Escape`.

Expected: the selected row's left border is now red. Revert the Theme change.

- [ ] **Step 7: Commit**

```bash
cd ~/disco-elysium-rice
git add configs/hypr/hyprland.conf
git commit -m "feat: autostart Quickshell and enable Power Menu keybind"
```

---

## Task 10: Verify install.sh handles configs/quickshell

**Files:**
- Read: `scripts/install.sh`
- Modify: `scripts/install.sh` (only if the generic loop doesn't cover the new dir)

- [ ] **Step 1: Inspect the existing config-symlink loop**

Read `scripts/install.sh` around line 81:
```bash
sed -n '75,100p' ~/disco-elysium-rice/scripts/install.sh
```

- [ ] **Step 2: Confirm coverage**

The loop iterates `$REPO_DIR/configs/*/` and symlinks each entry into `~/.config/<name>`. `configs/quickshell/` matches this glob, so no change is needed — the new dir is picked up automatically.

If the loop skips directories containing a symlink child (it shouldn't; `ln -s` on the parent just creates the `~/.config/quickshell` symlink pointing at the repo dir, and Quickshell follows the inner `assets` symlink fine), no edit is required.

Verify by dry-running the relevant section against a throwaway prefix:
```bash
grep -A 20 'for dir in' ~/disco-elysium-rice/scripts/install.sh
```

Expected: the loop unconditionally symlinks every directory in `configs/`.

- [ ] **Step 3: No commit needed**

If no change was required, skip. If a change was required, commit with:
```bash
cd ~/disco-elysium-rice
git add scripts/install.sh
git commit -m "chore(install): ensure configs/quickshell is symlinked"
```

---

## Task 11: Update project documentation

**Files:**
- Modify: `CLAUDE.md`
- Modify: `README.md`
- Modify: `docs/widgets/README.md`
- Modify: `docs/on-device-checklist.md`

- [ ] **Step 1: Update CLAUDE.md Technology Choices table**

In `CLAUDE.md`, find the line:
```
| Desktop shell | disco-shell (Rust + GPUI) | Separate repo |
```

Replace with:
```
| Desktop shell | Quickshell (QML) | `configs/quickshell/` |
```

- [ ] **Step 2: Update CLAUDE.md Desktop Shell section**

Find the `### Desktop Shell` section referencing `disco-shell`. Replace the paragraph with:

```markdown
### Desktop Shell
Desktop widgets are implemented in Quickshell (QML) at `configs/quickshell/`. The Rust + GPUI predecessor (`disco-shell`) was retired on 2026-04-13; its archived repo at [disco-shell](https://github.com/RobbeDelporte/disco-shell) is frozen and no longer developed. See `docs/superpowers/specs/2026-04-13-quickshell-pivot-design.md` for the pivot rationale and `docs/widgets/` for per-widget detail specs.
```

- [ ] **Step 3: Update CLAUDE.md install workflow**

Find the `## Install Workflow` block. Replace the numbered list with:

```
1. Boot Arch USB, run archinstall (minimal, no DE)
2. Log in, connect to WiFi: nmcli device wifi connect "SSID" password "pass"
3. git clone https://github.com/RobbeDelporte/disco-elysium-rice.git ~/disco-elysium-rice
4. cd ~/disco-elysium-rice && ./scripts/install.sh system76
5. sudo reboot → Hyprland starts automatically; `qs` runs from Quickshell config at `configs/quickshell/`
```

(i.e. drop the old step 5 "build disco-shell".)

- [ ] **Step 4: Update CLAUDE.md Repo Structure**

In the `configs/` tree block, add `quickshell/` alongside the existing entries:

```
configs/
  hypr/           # hyprland.conf, hyprlock.conf, hypridle.conf
  kitty/          # kitty.conf
  nvim/           # init.lua + lua/disco-elysium.lua
  quickshell/     # shell.qml, Theme.qml, widgets/, assets symlink
  yazi/           # yazi.toml, theme.toml, keymap.toml
  zsh/            # .zshrc, .zprofile (symlinked to ~/)
  starship/       # starship.toml (symlinked to ~/.config/starship.toml)
  fontconfig/     # fonts.conf (font rendering config)
```

- [ ] **Step 5: Update README.md install workflow**

Mirror the Step 3 changes in `README.md`'s install section (if it has one). If the README has a different workflow block, update it to remove the `cargo build` / disco-shell clone line.

Run:
```bash
grep -n "disco-shell\|cargo build" ~/disco-elysium-rice/README.md
```

Then edit each matching line to remove the disco-shell reference.

- [ ] **Step 6: Update docs/widgets/README.md**

Change the intro paragraph in `docs/widgets/README.md` from:
```
These files are the source of truth for *how* each widget looks and animates at the pixel level.
```

To:
```
These files are the source of truth for *how* each widget looks and animates at the pixel level. Implementation target is Quickshell (QML) at `configs/quickshell/widgets/`; see `docs/superpowers/specs/2026-04-13-quickshell-pivot-design.md` for the foundation and `configs/quickshell/widgets/PowerMenu.qml` as the reference example.
```

- [ ] **Step 7: Update docs/on-device-checklist.md**

Read the current file:
```bash
sed -n '1,60p' ~/disco-elysium-rice/docs/on-device-checklist.md
```

Replace any disco-shell verification entries with these Quickshell-equivalents:

```markdown
## Quickshell

- [ ] `pgrep -x qs` returns a PID.
- [ ] `qs --version` runs.
- [ ] `/tmp/qs.log` has no errors from the last session.
- [ ] Press `Super+Shift+Escape` → Power Menu appears.
- [ ] Press `Esc` → Power Menu dismisses.
- [ ] Navigate with `j`/`k` — selection moves and wraps.
- [ ] Invoke `Lock` → screen locks.
- [ ] Edit `configs/quickshell/Theme.qml` highlight color → Power Menu picks it up on next summon.
```

If there is no equivalent disco-shell block, append this one at the end.

- [ ] **Step 8: Commit**

```bash
cd ~/disco-elysium-rice
git add CLAUDE.md README.md docs/widgets/README.md docs/on-device-checklist.md
git commit -m "docs: update project docs for Quickshell pivot"
```

---

## Task 12: Final full-system verification

**Files:** none.

- [ ] **Step 1: Confirm no disco-shell residue**

```bash
grep -rni "disco-shell" ~/disco-elysium-rice --include='*.md' --include='*.conf' --include='*.sh' --include='*.txt' | grep -v 'archived\|pivot-design\|on-device-checklist'
```

Expected: no results (only historical references remain, which is fine).

- [ ] **Step 2: Clean Hyprland reload**

```bash
hyprctl reload && sleep 2 && pgrep -x qs
```

Expected: `qs` is running.

- [ ] **Step 3: Exercise Power Menu end-to-end**

Walk the on-device checklist entries from Task 11 Step 7. Each must pass.

- [ ] **Step 4: Confirm clean working tree**

```bash
cd ~/disco-elysium-rice && git status
```

Expected: nothing to commit, working tree clean.

- [ ] **Step 5: Update MEMORY.md index if relevant**

This is a reference for future sessions. If no such memory index exists, skip.

---

## Rollback

If mid-plan a step fails and rollback is needed:

1. `git revert` the pivot commits (latest first).
2. Reinstall disco-shell from the archived upstream:
   ```bash
   git clone https://github.com/RobbeDelporte/disco-shell.git ~/disco-shell
   cd ~/disco-shell && cargo build --release && ./install.sh
   ```
3. `hyprctl reload` to restart the old shell.
4. `pacman -R quickshell` optional — keeping it installed is harmless.
