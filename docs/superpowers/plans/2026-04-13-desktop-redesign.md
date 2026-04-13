# Desktop Redesign Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Implement the dotfiles-side changes for the desktop redesign spec at `docs/superpowers/specs/2026-04-13-desktop-redesign-design.md`, AND produce per-widget detail specs + mockup HTML files that serve as input for future disco-shell implementation work.

**Architecture:** Two deliverables in this repo. (A) Dotfiles changes: stage ui-assets into `assets/textures/`, update Hyprland keybinds to match the new summon budget. (B) Design artifacts: eight per-widget detail specs in `docs/widgets/` and eight HTML mockups in `docs/mockups/widgets/` using the actual asset images. The disco-shell Rust/GPUI implementation is out of scope — it will consume these artifacts later.

**Tech Stack:** Hyprland config (`hyprland.conf`), Markdown, HTML/CSS for mockups, no Rust.

---

## File Map

| File | Action | Responsibility |
|------|--------|----------------|
| `assets/textures/` | Create + populate | Staged ui-asset PNGs/JPGs for disco-shell to load as runtime resources |
| `configs/hypr/hyprland.conf` | Modify | Keybind budget: add Super+., change Super+Shift+E → Super+Shift+Escape, add Super+Tab, note deprecation of Super+N |
| `docs/widgets/` | Create | New home for per-widget detail specs |
| `docs/widgets/README.md` | Create | Index + widget-spec template |
| `docs/widgets/info-panel.md` | Create | Info panel detail spec |
| `docs/widgets/launcher.md` | Create | Launcher detail spec |
| `docs/widgets/power-menu.md` | Create | Power menu detail spec |
| `docs/widgets/lockscreen.md` | Create | Lockscreen detail spec |
| `docs/widgets/overview.md` | Create | Overview detail spec |
| `docs/widgets/switcher.md` | Create | Switcher detail spec |
| `docs/widgets/osd.md` | Create | OSD detail spec |
| `docs/widgets/notification-toast.md` | Create | Notification toast detail spec |
| `docs/mockups/widgets/` | Create | HTML mockups per widget |
| `docs/mockups/widgets/*.html` | Create | One HTML file per widget, using real asset images |
| `CLAUDE.md` | Modify | Add a pointer to `docs/widgets/` |

---

## Task 1: Stage ui-assets into `assets/textures/`

Copy the website-derived textures from `references/` into a runtime-staging
directory that disco-shell will later read from as resources. The
`references/` directory is source material; `assets/textures/` is the
in-repo distribution of those assets.

**Files:**
- Create: `assets/textures/`
- Create: `assets/textures/.gitkeep` (safety — keeps dir tracked if later emptied)
- Create: `assets/textures/film-strip.png`
- Create: `assets/textures/brush-strip-white.png`
- Create: `assets/textures/brush-field.png` (renamed from `Archive_3324d46e2.png`)
- Create: `assets/textures/page-bg.png`
- Create: `assets/textures/flare-a.jpg` (renamed from `feld-flash-flare-0_cy51je.jpg`)
- Create: `assets/textures/flare-b.jpg` (renamed from `feld-flash-flare-1_loooiz.jpg`)
- Create: `assets/textures/frame-landscape.png`
- Create: `assets/textures/frame-portrait.png`
- Create: `assets/textures/edge-strip.png` (renamed from `black-tapelet_dysjoh.png`)
- Create: `assets/textures/MANIFEST.md`

- [ ] **Step 1: Create the directory and copy assets with canonical names**

```bash
mkdir -p assets/textures
touch assets/textures/.gitkeep

cp references/disco-elysium/ui-assets/film-strip-long_a5hufh.png       assets/textures/film-strip.png
cp references/disco-elysium/ui-assets/brush-bg-white_kkkkx7.png         assets/textures/brush-strip-white.png
cp references/disco-elysium/ui-assets/Archive_3324d46e2.png             assets/textures/brush-field.png
cp references/disco-elysium/ui-assets/single-page-content-bg_htmvo8.png assets/textures/page-bg.png
cp references/disco-elysium/ui-assets/feld-flash-flare-0_cy51je.jpg     assets/textures/flare-a.jpg
cp references/disco-elysium/ui-assets/feld-flash-flare-1_loooiz.jpg     assets/textures/flare-b.jpg
cp references/disco-elysium/ui-assets/frame-16-9_iqf4jq.png             assets/textures/frame-landscape.png
cp references/disco-elysium/ui-assets/frame-16-9-portrait_snwdsp.png    assets/textures/frame-portrait.png
cp references/disco-elysium/ui-assets/black-tapelet_dysjoh.png          assets/textures/edge-strip.png
```

- [ ] **Step 2: Write the manifest**

Create `assets/textures/MANIFEST.md`:

```markdown
# Asset Textures Manifest

Runtime textures for disco-shell. Copied from `references/disco-elysium/ui-assets/` with canonical, stable filenames. disco-shell loads these via paths relative to the installed asset root; do not rename without updating disco-shell's resource paths.

| File | Source | Purpose |
|------|--------|---------|
| `film-strip.png` | `film-strip-long_a5hufh.png` | Film-strip frame for Power Menu, Overview |
| `brush-strip-white.png` | `brush-bg-white_kkkkx7.png` | Painterly light hero bg (inverted surfaces) |
| `brush-field.png` | `Archive_3324d46e2.png` | Painterly dark hero bg |
| `page-bg.png` | `single-page-content-bg_htmvo8.png` | Side-page backing texture (info panel, launcher) |
| `flare-a.jpg` | `feld-flash-flare-0_cy51je.jpg` | Warm amber flare for Lockscreen / splash |
| `flare-b.jpg` | `feld-flash-flare-1_loooiz.jpg` | Warm amber flare alternate |
| `frame-landscape.png` | `frame-16-9_iqf4jq.png` | Landscape media frame for Overview, Switcher thumbnails |
| `frame-portrait.png` | `frame-16-9-portrait_snwdsp.png` | Portrait media frame |
| `edge-strip.png` | `black-tapelet_dysjoh.png` | Slim decorative strip for Notification Toast top edge |
```

- [ ] **Step 3: Verify all files landed**

Run:
```bash
ls -1 assets/textures/
```
Expected: 11 entries — `.gitkeep`, `MANIFEST.md`, and 9 texture files.

Run:
```bash
for f in film-strip.png brush-strip-white.png brush-field.png page-bg.png flare-a.jpg flare-b.jpg frame-landscape.png frame-portrait.png edge-strip.png; do
  test -s "assets/textures/$f" && echo "OK  $f" || echo "MISS $f"
done
```
Expected: nine `OK` lines.

- [ ] **Step 4: Commit**

```bash
git add assets/textures/
git commit -m "assets: stage website-derived textures with canonical filenames"
```

---

## Task 2: Update Hyprland keybinds

Apply the keybind budget from the redesign spec: add `Super + .` (info
panel), change `Super + Shift + E` → `Super + Shift + Escape` (power menu),
add `Super + Tab` (overview), keep existing `Super + /` (launcher) and
`Super + Escape` (lock), keep `Alt + Tab` (switcher). Do NOT delete other
existing binds — only add/change per spec. The disco-shell-side commands
(`disco-shell toggle info`, etc.) will be a no-op until disco-shell is
implemented; that's fine.

**Files:**
- Modify: `configs/hypr/hyprland.conf`

- [ ] **Step 1: Read current relevant binds**

Run:
```bash
grep -n "^bind\s*=" configs/hypr/hyprland.conf | grep -iE "period|Escape|Tab|slash|, D,|, O,|, N,|SHIFT, E"
```
Expected output includes (existing binds at the top of the file):
```
bind = $mod, slash, exec, disco-shell toggle launcher
bind = ALT, Tab, exec, disco-shell toggle switcher
bind = $mod, O, exec, disco-shell toggle overview
bind = $mod, N, exec, disco-shell toggle quicksettings
bind = SUPER, Escape, exec, hyprlock
bind = $mod SHIFT, E, exec, disco-shell toggle powermenu
```

Note the exact line numbers — they will be referenced by the edits below.

- [ ] **Step 2: Add Super+. → info panel toggle**

Use the Edit tool. Find the existing line:

```
bind = $mod, slash, exec, disco-shell toggle launcher
```

Replace it with two lines (launcher kept, info panel appended directly
below so related binds live together):

```
bind = $mod, slash, exec, disco-shell toggle launcher
bind = $mod, period, exec, disco-shell toggle info
```

- [ ] **Step 3: Change Super+Shift+E → Super+Shift+Escape for power menu**

Find the existing line:

```
bind = $mod SHIFT, E, exec, disco-shell toggle powermenu
```

Replace it with:

```
bind = $mod SHIFT, Escape, exec, disco-shell toggle powermenu
```

Rationale: `Shift+Escape` pairs with `Escape` (lock) — the shift indicates
"go harder than lock" which matches power-off semantics.

- [ ] **Step 4: Change Super+O → Super+Tab for overview**

Find the existing line:

```
bind = $mod, O, exec, disco-shell toggle overview
```

Replace it with:

```
bind = $mod, Tab, exec, disco-shell toggle overview
```

- [ ] **Step 5: Deprecate Super+N quick settings (info panel absorbs this)**

Find the existing line:

```
bind = $mod, N, exec, disco-shell toggle quicksettings
```

Replace it with a comment (preserve history of the binding so a reader
understands why it's absent):

```
# bind = $mod, N, exec, disco-shell toggle quicksettings  # deprecated 2026-04-13: absorbed into info panel (Super+.)
```

- [ ] **Step 6: Verify the config parses**

Run:
```bash
hyprland --verify-config
```
Expected: `config ok` on the last line. If not, inspect the error, fix, and
re-run. Do NOT proceed if the config does not validate.

If `hyprland` is not available on the development machine (e.g. dev on
Pop!_OS, target is Arch), skip the binary check and instead confirm
syntactically that each edit changed only the intended line:

```bash
grep -n "^bind\s*=.*period\|^bind\s*=.*SHIFT, Escape\|^bind\s*=.*Tab, exec, disco-shell" configs/hypr/hyprland.conf
```
Expected: three lines matching the three new/changed binds.

- [ ] **Step 7: Commit**

```bash
git add configs/hypr/hyprland.conf
git commit -m "hyprland(keybinds): align with desktop-redesign summon budget"
```

---

## Task 3: Create `docs/widgets/` with index and template

Establish the home for per-widget detail specs. Provides a shared template
so every widget spec has the same structure.

**Files:**
- Create: `docs/widgets/README.md`

- [ ] **Step 1: Write the index + template**

Create `docs/widgets/README.md`:

````markdown
# Widget Detail Specs

One file per widget from `docs/superpowers/specs/2026-04-13-desktop-redesign-design.md`.
Each spec expands the summary from the parent redesign spec into disco-shell-implementation-ready detail: exact sizes, paddings, assets, colors, animations, keyboard and pointer behavior.

The parent spec is the source of truth for *what* each widget does. These files are the source of truth for *how* each widget looks and animates at the pixel level.

## Widgets

| # | Widget | Spec | Mockup |
|---|--------|------|--------|
| 1 | Info Panel | [info-panel.md](info-panel.md) | [../mockups/widgets/info-panel.html](../mockups/widgets/info-panel.html) |
| 2 | Launcher | [launcher.md](launcher.md) | [../mockups/widgets/launcher.html](../mockups/widgets/launcher.html) |
| 3 | Power Menu | [power-menu.md](power-menu.md) | [../mockups/widgets/power-menu.html](../mockups/widgets/power-menu.html) |
| 4 | Lockscreen | [lockscreen.md](lockscreen.md) | [../mockups/widgets/lockscreen.html](../mockups/widgets/lockscreen.html) |
| 5 | Overview | [overview.md](overview.md) | [../mockups/widgets/overview.html](../mockups/widgets/overview.html) |
| 6 | Switcher | [switcher.md](switcher.md) | [../mockups/widgets/switcher.html](../mockups/widgets/switcher.html) |
| 7 | OSD | [osd.md](osd.md) | [../mockups/widgets/osd.html](../mockups/widgets/osd.html) |
| 8 | Notification Toast | [notification-toast.md](notification-toast.md) | [../mockups/widgets/notification-toast.html](../mockups/widgets/notification-toast.html) |

## Template

Every widget spec follows this structure:

```markdown
# [Widget Name]

One-line description.

## Summary (from parent spec)
- State: Peek / Ceremonial / Ephemeral
- Summon: keybind / event
- Dismiss: conditions

## Dimensions & Position
- Width, height, anchor edge, margins
- Z-order relative to windows and other widgets

## Surface Treatment
- Base color(s) with exact rgba
- Asset textures used (path relative to `assets/textures/`)
- Border / shadow specs
- Banner header (yes/no, text)

## Contents
Ordered top-to-bottom (or left-to-right) with each region's:
- Purpose
- Typography (font, size, weight, case, color)
- Spacing

## Keyboard & Pointer
- Keybinds active while summoned
- Click, hover, scroll behavior

## Animation
- Enter transition (duration, easing, initial / final state)
- Exit transition
- Any internal motion (pulse, shimmer, nothing)

## Reference
- Parent spec section
- Style guide sections referenced
- Asset files referenced
```

## Conventions

- All colors are given as hex (`#rrggbb`) or rgba — never named.
- All sizes are in CSS pixels (GPUI can convert to its own unit system).
- Font names reference what's defined in `docs/style-guide.md` §5.
- Asset paths are relative to `assets/textures/`.
- Animation durations in milliseconds, easings as cubic-bezier or the named `disco` easing (`cubic-bezier(0.25, 0.1, 0.25, 1.0)`) from the style guide.
````

- [ ] **Step 2: Verify**

Run: `test -s docs/widgets/README.md && echo OK`
Expected: `OK`.

- [ ] **Step 3: Commit**

```bash
git add docs/widgets/README.md
git commit -m "docs(widgets): add index and template for per-widget specs"
```

---

## Task 4: Write Peek widget specs — Info Panel and Launcher

These are the two persistent Peek surfaces — mirrored side pages. They
share the most visual language, so they're written together to keep
proportions and tokens consistent.

**Files:**
- Create: `docs/widgets/info-panel.md`
- Create: `docs/widgets/launcher.md`

- [ ] **Step 1: Write `docs/widgets/info-panel.md`**

Write the file using the template from `docs/widgets/README.md`. Fill in
sections with the values below (these are authoritative; deviations from
them are plan failures unless they flow from the style guide).

- **State:** Peek.
- **Summon:** `Super + .` → toggle.
- **Dismiss:** `Esc`, click outside, `Super + .` again.
- **Dimensions:**
  - Width: 220 px (fixed).
  - Height: full monitor height.
  - Anchor: left edge, `margin-left: 0`.
  - Enter animation: slide in `-220px → 0` over 220 ms with `disco` easing + fade `0 → 1`.
  - Exit: reverse, 180 ms.
  - Z-order: above windows, below Ceremonial surfaces.
- **Surface:**
  - Base: `rgba(23, 27, 26, 0.88)`.
  - Texture: `assets/textures/page-bg.png`, tiled or stretched along the panel's full height, composited at `opacity: 0.6; mix-blend-mode: soft-light`.
  - Right-edge shadow: `box-shadow: 8px 0 32px rgba(0, 0, 0, 0.7)`.
  - Right border: `1px solid rgba(54, 59, 58, 0.5)`.
  - Padding: `16px 14px`.
- **Contents top → bottom:**
  1. Banner "SYSTEM" — Archivo Narrow 700, 12px, uppercase, letter-spacing 2px, overhang `top: -8px; left: -10px`, background `#d2d2d2`, color `#171b1a`, erosion filter applied.
  2. Vertical spacer 14 px.
  3. Time — Playfair Display 700, 30 px, color `#d2d2d2`, line-height 1.0.
  4. Date — Archivo Narrow 700, 9 px uppercase, letter-spacing 2 px, color `#999a95`, format "FRI · 13 APR".
  5. Divider — `1px solid #363b3a`, vertical margin 14 px.
  6. Status grid — 2-column grid, gap `6px 10px`. Each cell: label (Archivo Narrow 9 px, muted) + value (Archivo Narrow 10 px, `#ccc8c2` or skill-category color for icons). Rows: battery `%`, volume `%`, wifi indicator (cyan dot `#5bc0d6` when connected, muted when off), bluetooth (same pattern).
  7. Divider.
  8. Workspaces label + diamonds row. Diamond: 8×8 px square rotated 45°. Active: `#d2d2d2` + `box-shadow: 0 0 5px rgba(210, 210, 210, 0.5)`. Inactive with windows: `#999a95`. Inactive empty: `#4b4b4b`.
  9. Divider.
  10. Media section — label "PLAYING" (Archivo Narrow 9 px muted) + title (Libre Baskerville 11 px `#ccc8c2`, single line with ellipsis). Show nothing (collapse the section) when no media.
  11. Divider.
  12. Power button — full-width, height 32 px, `#1e2221` background, `#999a95` text, Archivo Narrow 11 px uppercase, `1px solid rgba(54, 59, 58, 0.5)`. Hover: text → `#eb6408`. Click: opens Power Menu (§power-menu) and dismisses Info Panel.
- **Keyboard:** `Esc` dismisses. `Super + .` toggles (re-pressing while open dismisses). No arrow-key navigation — this widget is read-only at MVP.
- **Pointer:** click on power button (only interactive element at MVP). Click outside panel dismisses.
- **Animation:** see Dimensions. No internal motion (no pulsing, no shimmer).
- **Reference:**
  - Parent spec §"1. Info Panel — Peek (left side-page)".
  - Style guide §4 (colors), §5 (fonts), §6 (banner), §7 (painted-canvas), §8.3 optional radial halos behind time if legibility suffers over a busy wallpaper, §9 (borders), §12 (selection indicators — not applicable since no list at MVP).
  - Assets: `assets/textures/page-bg.png`.

- [ ] **Step 2: Write `docs/widgets/launcher.md`**

Same structure, values below.

- **State:** Peek.
- **Summon:** `Super + /` → toggle.
- **Dismiss:** `Esc`, click outside, `Super + /` again. Any Ceremonial surface opening dismisses the launcher.
- **Dimensions:**
  - Width: 220 px (fixed, matches Info Panel for symmetry).
  - Height: full monitor height.
  - Anchor: right edge, `margin-right: 0`.
  - Enter: slide `+220px → 0` over 220 ms `disco` easing + fade.
  - Exit: reverse, 180 ms.
  - Z-order: identical to Info Panel.
- **Surface:** identical tokens to Info Panel, mirrored:
  - Base `rgba(23, 27, 26, 0.88)`, same texture composited same way.
  - Left-edge shadow: `box-shadow: -8px 0 32px rgba(0, 0, 0, 0.7)`.
  - Left border: `1px solid rgba(54, 59, 58, 0.5)`.
  - Padding: `16px 14px`.
- **Contents top → bottom:**
  1. Banner — text is the current mode's name uppercase (`SEARCH` default, `WINDOWS`, `CLIPBOARD`, `CALC`, `FILES`, `BASH`). Same treatment as Info Panel banner, overhang `top: -8px; left: -10px`.
  2. Vertical spacer 12 px.
  3. Search input line — JetBrains Mono 11 px, prompt glyph `>` in `#eb6408`, query text `#ccc8c2`, border-bottom `1px solid #363b3a`, padding `4px 0`.
  4. Results list — flex column, gap 2 px, margin-top 8 px. Each row:
     - Selected: `padding: 6px 8px; border-left: 3px solid #eb6408; background: rgba(40, 44, 43, 0.4); color: #ccc8c2`. Text: Archivo Narrow 11 px uppercase letter-spacing 1 px.
     - Unselected: `padding: 6px 8px; border-left: 3px solid transparent; color: #999a95`. Same typography.
     - Mode prefix (e.g. `Files:`) in muted Archivo Narrow, followed by the item name.
  5. Footer — pinned to bottom of panel. Horizontal divider `1px solid #363b3a`, then hint row: `↵ launch · ⇥ next mode · ESC close`, Archivo Narrow 8 px muted, letter-spacing 2 px.
- **Keyboard:**
  - Typing: filters results.
  - `↑` / `↓` / `Ctrl+k` / `Ctrl+j`: move selection.
  - `↵`: activate selected result.
  - `⇥`: cycle to next mode (apps → windows → clipboard → calculator → files → bash → apps …).
  - `Esc`: dismiss.
- **Pointer:** click on a row selects + activates. Scroll wheel scrolls the list.
- **Animation:** see Dimensions. No internal motion.
- **Reference:**
  - Parent spec §"2. Launcher — Peek (right side-page)".
  - Style guide §6 (banner), §7 (painted-canvas), §8.3 halos optional, §9 borders, §12 selection (orange left-border).
  - Assets: `assets/textures/page-bg.png`.
  - Existing disco-shell launcher implementation at `~/Documents/disco-shell/crates/app/src/widgets/launcher.rs` (reference only — this spec does not dictate its internal architecture, only its appearance).

- [ ] **Step 3: Verify both files exist and contain all template sections**

Run:
```bash
for f in info-panel launcher; do
  echo "=== $f ==="
  grep -c "^## " "docs/widgets/$f.md"
done
```
Expected: for each, a count of at least `7` (Summary, Dimensions & Position, Surface Treatment, Contents, Keyboard & Pointer, Animation, Reference).

- [ ] **Step 4: Commit**

```bash
git add docs/widgets/info-panel.md docs/widgets/launcher.md
git commit -m "docs(widgets): add info-panel and launcher detail specs"
```

---

## Task 5: Write Ceremonial widget specs — Power Menu, Lockscreen, Overview, Switcher

The four full-focus surfaces.

**Files:**
- Create: `docs/widgets/power-menu.md`
- Create: `docs/widgets/lockscreen.md`
- Create: `docs/widgets/overview.md`
- Create: `docs/widgets/switcher.md`

- [ ] **Step 1: Write `docs/widgets/power-menu.md`**

Follow the template. Key values:

- **State:** Ceremonial.
- **Summon:** `Super + Shift + Escape` OR power button in Info Panel.
- **Dismiss:** `Esc`, click outside the panel, or actioned button.
- **Dimensions:** centered on monitor. Panel width 320 px, height auto. Wallpaper dimmed by a full-screen backdrop `rgba(0, 0, 0, 0.55)`.
- **Surface:**
  - Full-screen film strips top and bottom: `assets/textures/film-strip.png` tiled horizontally, height 16 px each, z above backdrop below panel.
  - Panel: `linear-gradient(135deg, #1a1c1b, #0e1110)` base + optional `assets/textures/brush-strip-white.png` at `opacity: 0.15; mix-blend-mode: soft-light` composited on top.
  - Panel padding: 24 px.
  - Panel shadow: `0 12px 48px rgba(0, 0, 0, 0.8)`.
  - Banner "END SESSION" overhang `top: -8px; left: -10px`.
- **Contents:**
  1. Banner (above panel top-left corner).
  2. 12 px spacer.
  3. Primary CTA "SHUT DOWN" — layered offset, 40 px tall:
     - Layer C (back): offset `top: +4px; left: +4px`, background `#eb6408`.
     - Layer B (middle): offset `top: +2px; left: +2px`, background `#7effaa`.
     - Button (top): full-size, `background: #912711; color: #ccc8c2; padding: 0 18px; font: Archivo Narrow 700 13px uppercase letter-spacing 3px`. Border none.
     - Hover: button background `#7a2010`.
  4. 10 px spacer.
  5. Secondary grid — 2×2, gap 8 px. Buttons: RESTART, LOG OUT, LOCK, SLEEP. Each: `background: #1e2221; color: #999a95; border: 1px solid rgba(54, 59, 58, 0.5); padding: 8px; font: Archivo Narrow 700 11px uppercase letter-spacing 2px`. Hover: color `#ccc8c2`.
- **Keyboard:** arrow keys / `h j k l` navigate between buttons (primary + 4 secondary as a 5-cell grid with the primary occupying the top row). `↵` activates. `Esc` dismisses. First focus is SHUT DOWN.
- **Pointer:** click a button to activate.
- **Animation:** backdrop fades `0 → 1` over 180 ms. Panel scales `0.96 → 1.0` with fade `0 → 1` over 220 ms `disco` easing. Exit mirrors.
- **Reference:** parent spec §3, style guide §8.5 (layered CTA), §8.1 (film strip), §10 (buttons ceremonial row). Assets: `film-strip.png`, optional `brush-strip-white.png`.

- [ ] **Step 2: Write `docs/widgets/lockscreen.md`**

- **State:** Ceremonial. Implemented by **Hyprlock**, not disco-shell. This spec guides Hyprlock config rather than custom Rust code.
- **Summon:** `Super + Escape` (`bind = SUPER, Escape, exec, hyprlock`) OR Hypridle timeout.
- **Dismiss:** correct password entered.
- **Dimensions:** full monitor.
- **Surface:**
  - Wallpaper at `brightness: 0.5`.
  - Flare overlay: `assets/textures/flare-a.jpg` positioned bottom-right, `opacity: 0.35; mix-blend-mode: screen; blur: 4px`. Optional — enable with a Hyprlock `background` layer.
- **Contents (center stack):**
  1. Time — Playfair Display 700 at 64 pt, color `rgb(215, 215, 215)`. Behind it: radial halo `radial-gradient(ellipse at center, rgba(16, 19, 18, 0.85) 0%, transparent 70%)` sized 1.6× time bounding box.
  2. Greeting — Archivo Narrow 700 at 20 pt, uppercase, color `rgb(153, 154, 149)`. Content driven by hour of day (existing Hyprlock config).
  3. Input field — 300 px wide, height 44 px, outer border `rgb(91, 192, 214)` (`#5bc0d6`), inner `rgb(23, 27, 26)`, font Archivo Narrow 16 pt `rgb(215, 215, 215)`. States use existing color tokens: `check_color: rgb(15, 182, 102)`, `fail_color: rgb(184, 58, 58)`, `capslock_color: rgb(227, 186, 62)`.
- **Keyboard:** typed characters go into password input. `↵` submits.
- **Pointer:** none (Wayland session lock captures everything).
- **Animation:** Hyprlock handles its own fade-in. No custom animation for MVP.
- **Reference:** parent spec §4, style guide §20 (wallpaper), §4.1 color tokens, `docs/implementation-guide.md` Hyprlock section. Assets: `flare-a.jpg` optional.

- [ ] **Step 3: Write `docs/widgets/overview.md`**

- **State:** Ceremonial.
- **Summon:** `Super + Tab`.
- **Dismiss:** click a thumbnail, `↵` on selected, `Esc`.
- **Dimensions:** full monitor.
- **Surface:**
  - Backdrop: `assets/textures/brush-field.png` stretched to full monitor at `opacity: 0.9`, on top of dimmed wallpaper (`brightness: 0.3`).
  - Film strips top and bottom: `film-strip.png`, 16 px each.
  - Padding: 48 px.
- **Contents:**
  1. Workspace groups — horizontal flow. Each group has:
     - Label above: Archivo Narrow 700 16 px uppercase, letter-spacing 3 px, color `#d2d2d2`. Workspace number prefixed with diamond indicator.
     - Grid of window thumbnails, gap 16 px, max 4 per row.
  2. Each window thumbnail:
     - Fixed size 240×135 (16:9).
     - Border: `assets/textures/frame-landscape.png` as `border-image`, slice appropriate to the frame's painted edges.
     - Inner content: live capture (disco-shell responsibility) scaled to fit inside frame.
     - Label below: Archivo Narrow 700 10 px uppercase muted, title (single line ellipsis).
     - Active (focused) window: orange 3 px left-border on the frame, glow `box-shadow: 0 0 16px rgba(235, 100, 8, 0.4)`.
- **Keyboard:** arrow keys navigate between thumbnails. `↵` focuses the selected window. `Esc` dismisses without changing focus.
- **Pointer:** click thumbnail → focus that window.
- **Animation:** backdrop + film strips fade 200 ms. Thumbnails stagger-in at 20 ms per thumbnail (max 200 ms cap).
- **Reference:** parent spec §5, style guide §8.1 (film strip), §8.2 (brush-bg-dark), §8.6 (media frames), §12 (selection). Assets: `brush-field.png`, `film-strip.png`, `frame-landscape.png`.

- [ ] **Step 4: Write `docs/widgets/switcher.md`**

- **State:** Ceremonial (lightweight — doesn't claim the whole screen, but captures focus).
- **Summon:** `Alt + Tab` pressed, held to cycle.
- **Dismiss:** release `Alt`.
- **Dimensions:** horizontal strip centered on monitor, panel width `min(80vw, 960px)`, height 180 px.
- **Surface:**
  - Backdrop dim: `rgba(0, 0, 0, 0.4)` full screen.
  - Strip background: `rgba(23, 27, 26, 0.88)`, padding 16 px.
  - Border: `1px solid rgba(54, 59, 58, 0.5)`.
- **Contents:**
  1. Banner above the strip — title of currently-selected window, Archivo Narrow 700 14 px uppercase, `#d2d2d2` on `#171b1a` with erosion filter, overhang.
  2. Horizontal row of thumbnails — each 160×90 (16:9), framed with `frame-landscape.png` border-image, gap 12 px. Selected: orange 3 px left-border + glow.
  3. No labels under thumbnails (too much text for Alt+Tab speed).
- **Keyboard:** `Alt` held + `Tab` cycles forward, `Alt + Shift + Tab` cycles backward. Releasing `Alt` commits the selection.
- **Pointer:** none at MVP.
- **Animation:** strip enters with a subtle slide (`+8px → 0` y) + fade over 120 ms. Thumbnail selection changes via border-color transition 80 ms. Exit snap (no animation).
- **Reference:** parent spec §6, style guide §8.6 (media frames), §12. Assets: `frame-landscape.png`.

- [ ] **Step 5: Verify all four files have all template sections**

Run:
```bash
for f in power-menu lockscreen overview switcher; do
  cnt=$(grep -c "^## " "docs/widgets/$f.md")
  echo "$f: $cnt sections"
done
```
Expected: each ≥ 7.

- [ ] **Step 6: Commit**

```bash
git add docs/widgets/power-menu.md docs/widgets/lockscreen.md docs/widgets/overview.md docs/widgets/switcher.md
git commit -m "docs(widgets): add ceremonial widget detail specs"
```

---

## Task 6: Write ephemeral widget specs — OSD and Notification Toast

Small transient widgets.

**Files:**
- Create: `docs/widgets/osd.md`
- Create: `docs/widgets/notification-toast.md`

- [ ] **Step 1: Write `docs/widgets/osd.md`**

- **State:** Peek (ephemeral).
- **Summon:** hardware key events — `XF86AudioRaiseVolume`, `XF86AudioLowerVolume`, `XF86AudioMute`, `XF86MonBrightnessUp`, `XF86MonBrightnessDown`. Never user-keybind-summoned.
- **Dismiss:** auto-fade 1500 ms after last relevant key event.
- **Dimensions:** 240 × 60 px, anchored bottom-center, `margin-bottom: 64 px`.
- **Surface:**
  - Background: `rgba(23, 27, 26, 0.88)`.
  - Border: `1px solid rgba(54, 59, 58, 0.5)`.
  - Padding: `10px 14px`.
  - Radial halo optional at `opacity: 0.4` behind the widget (§8.3).
- **Contents:**
  1. Property name banner — Archivo Narrow 700 10 px uppercase letter-spacing 2 px, color `#171b1a` on `#d2d2d2` banner, overhang `top: -6px; left: -8px`. Text: "VOLUME" or "BRIGHTNESS".
  2. Horizontal bar — track 2 px height, background `#363b3a`, full width. Filled portion (percentage): volume uses `#5bc0d6`, brightness uses `#e3ba3e`. Transition: `width 120 ms ease-out` when level changes.
  3. Label under bar — current value (e.g. "50%"), Archivo Narrow 700 11 px, muted.
- **Keyboard:** none.
- **Pointer:** none.
- **Animation:** enter: fade `0 → 1` + slide `+6px → 0` y over 120 ms. Exit: fade `1 → 0` over 220 ms after the 1500 ms hold.
- **Reference:** parent spec §7, style guide §4.1 (accent tokens), §6 (banner), §9 (borders). Assets: none required at MVP.

- [ ] **Step 2: Write `docs/widgets/notification-toast.md`**

- **State:** Peek (ephemeral).
- **Summon:** auto, on DBus notification event.
- **Dismiss:** auto timeout (default 5000 ms, `Urgency::Critical` persists until dismissed), click to dismiss, click to open source app if `default` action exists.
- **Dimensions:** 320 × min-80 px (auto-height for multi-line body). Anchored top-right, first toast `margin-top: 16px; margin-right: 16px`. Stack grows downward with 8 px gap between toasts.
- **Surface:**
  - Background: `rgba(16, 19, 18, 0.92)`.
  - Top decorative strip: `assets/textures/edge-strip.png` positioned at the top edge of each card, height 10 px, full card width, `opacity: 0.85`.
  - Border: `1px solid rgba(54, 59, 58, 0.5)`.
  - Padding: `10px 12px` (top extended to `20px` to clear the tapelet).
  - Left accent border (by urgency):
    - Normal: none.
    - Critical: `3px solid #eb6408` (orange left-border).
    - Error: `3px solid #b83a3a` (red).
- **Contents:**
  1. App name — Archivo Narrow 700 10 px uppercase letter-spacing 2 px, color `#999a95`.
  2. 4 px spacer.
  3. Summary — Libre Baskerville 400 14 px, color `#ccc8c2`, single line ellipsis.
  4. Body — Libre Baskerville 400 12 px, color `#999a95`, up to 3 lines with ellipsis.
- **Keyboard:** none (notifications are not focusable at MVP).
- **Pointer:** click anywhere on the card → activate default action (or dismiss if none). `Middle-click` → dismiss without action.
- **Animation:** enter: slide `+40px → 0` x + fade over 220 ms `disco` easing. Exit: slide `0 → +40px` x + fade over 180 ms.
- **Reference:** parent spec §8, style guide §14 (dialogue pattern), §8.6 (tapelet as slim frame), §12 (orange/red left-border). Assets: `edge-strip.png`.

- [ ] **Step 3: Verify**

Run:
```bash
for f in osd notification-toast; do
  cnt=$(grep -c "^## " "docs/widgets/$f.md")
  echo "$f: $cnt sections"
done
```
Expected: each ≥ 7.

- [ ] **Step 4: Commit**

```bash
git add docs/widgets/osd.md docs/widgets/notification-toast.md
git commit -m "docs(widgets): add osd and notification-toast detail specs"
```

---

## Task 7: Create per-widget HTML mockups

Eight mockup files, one per widget, using real asset images via
`<img>` / `background-image`. These are visual references that a human can
open in a browser; they are not interactive. Copy asset files into the
mockups directory or reference them by relative path — use relative path
(`../../../assets/textures/<file>`) so there's a single source of truth.

**Files:**
- Create: `docs/mockups/widgets/_shared.css`
- Create: `docs/mockups/widgets/info-panel.html`
- Create: `docs/mockups/widgets/launcher.html`
- Create: `docs/mockups/widgets/power-menu.html`
- Create: `docs/mockups/widgets/lockscreen.html`
- Create: `docs/mockups/widgets/overview.html`
- Create: `docs/mockups/widgets/switcher.html`
- Create: `docs/mockups/widgets/osd.html`
- Create: `docs/mockups/widgets/notification-toast.html`

- [ ] **Step 1: Write shared CSS**

Create `docs/mockups/widgets/_shared.css`:

```css
@import url('https://fonts.googleapis.com/css2?family=Archivo+Narrow:wght@700&family=Libre+Baskerville&family=Playfair+Display:wght@700&display=swap');

:root {
  --base: #171b1a;
  --surface: #1e2221;
  --border: #363b3a;
  --text: #ccc8c2;
  --text-muted: #999a95;
  --text-cream: #d2d2d2;
  --accent-intellect: #5bc0d6;
  --action: #eb6408;
  --button-primary: #912711;
  --decor-cyan: #7effaa;
  --decor-purple: #7b61ff;
}

body {
  margin: 0;
  background: #0a0a0a url('../../../wallpapers/disco-elysium-sunset.png') center/cover no-repeat fixed;
  min-height: 100vh;
  font-family: 'Archivo Narrow', sans-serif;
  color: var(--text);
}

.stage { position: relative; min-height: 100vh; }

.banner {
  display: inline-block;
  background: var(--text-cream);
  color: var(--base);
  padding: 3px 12px;
  font-family: 'Archivo Narrow', sans-serif;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 2px;
  font-size: 12px;
}

.lbl { font-family: 'Archivo Narrow', sans-serif; font-weight: 700; font-size: 9px; text-transform: uppercase; letter-spacing: 2px; color: var(--text-muted); }
.val { font-family: 'Archivo Narrow', sans-serif; font-weight: 700; font-size: 10px; color: var(--text); letter-spacing: 1px; }
.body { font-family: 'Libre Baskerville', serif; font-size: 12px; }
.time { font-family: 'Playfair Display', serif; font-weight: 700; color: var(--text-cream); }

hr.div { border: none; border-top: 1px solid var(--border); margin: 12px 0; }
```

- [ ] **Step 2: Write `info-panel.html`**

Full document with `<!DOCTYPE>`, `<link rel="stylesheet" href="_shared.css">`, and a `<div class="stage">` containing the info panel visual. Use the `page-bg.png` as a `background-image` layer on the panel (not stretched — tiled or covered; the asset is designed to tile vertically). Include realistic sample data: time 12:34, date FRI · 13 APR, battery 78%, volume 50, wifi on, bluetooth off, 4 workspaces (3 active), media "Tequila Sunset". Power button at bottom.

Layout HTML:

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <title>Info Panel — Disco Elysium Rice</title>
  <link rel="stylesheet" href="_shared.css">
</head>
<body>
  <div class="stage">
    <div style="
      position: fixed; top: 0; left: 0; bottom: 0; width: 220px;
      background: linear-gradient(rgba(23,27,26,0.88), rgba(23,27,26,0.88)), url('../../../assets/textures/page-bg.png') left top / cover no-repeat;
      box-shadow: 8px 0 32px rgba(0,0,0,0.7);
      border-right: 1px solid rgba(54,59,58,0.5);
      padding: 16px 14px;
      box-sizing: border-box;
      display: flex; flex-direction: column;
    ">
      <div style="position: relative;">
        <span class="banner" style="position: absolute; top: -24px; left: -22px;">SYSTEM</span>
      </div>
      <div style="margin-top: 14px;">
        <div class="time" style="font-size: 30px; line-height: 1;">12:34</div>
        <div class="lbl" style="margin-top: 2px;">FRI · 13 APR</div>
      </div>
      <hr class="div">
      <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 6px 10px;">
        <div><span class="lbl">BAT</span> <span class="val">78%</span></div>
        <div><span class="lbl">VOL</span> <span class="val">50</span></div>
        <div><span class="lbl">WIFI</span> <span class="val" style="color: var(--accent-intellect);">●</span></div>
        <div><span class="lbl">BT</span> <span class="val" style="color: var(--text-muted);">○</span></div>
      </div>
      <hr class="div">
      <div class="lbl">WORKSPACES</div>
      <div style="display: flex; gap: 6px; margin-top: 6px;">
        <span style="width:8px;height:8px;background:var(--text-muted);display:inline-block;transform:rotate(45deg);"></span>
        <span style="width:8px;height:8px;background:var(--text-muted);display:inline-block;transform:rotate(45deg);"></span>
        <span style="width:8px;height:8px;background:var(--text-cream);display:inline-block;transform:rotate(45deg);box-shadow:0 0 5px rgba(210,210,210,0.5);"></span>
        <span style="width:8px;height:8px;background:#4b4b4b;display:inline-block;transform:rotate(45deg);"></span>
      </div>
      <hr class="div">
      <div class="lbl">PLAYING</div>
      <div class="body" style="color: var(--text); margin-top: 4px;">Tequila Sunset</div>
      <div style="flex: 1;"></div>
      <hr class="div">
      <button style="
        width: 100%; height: 32px;
        background: var(--surface); color: var(--text-muted);
        border: 1px solid rgba(54,59,58,0.5);
        font-family: 'Archivo Narrow', sans-serif; font-weight: 700; font-size: 11px; text-transform: uppercase; letter-spacing: 2px;
        cursor: pointer;
      " onmouseover="this.style.color='var(--action)'" onmouseout="this.style.color='var(--text-muted)'">END SESSION</button>
    </div>
  </div>
</body>
</html>
```

- [ ] **Step 3: Write `launcher.html`**

Full document mirroring info-panel.html but anchored to the right edge,
with a search input showing `> fire`, and three mock results: Firefox
(selected with orange left-border), "Files: firefox-config.toml" (muted),
"Window: Firefox — gh.com" (muted). Footer row with hints. Use the same
`page-bg.png` texture and mirrored `-8px 0 32px` shadow.

- [ ] **Step 4: Write `power-menu.html`**

Full document. Dimmed backdrop, film-strip top and bottom (using
`assets/textures/film-strip.png` as `background-image: repeat-x`), centered
panel with banner overhang, layered CTA "SHUT DOWN" (three stacked
`::before` / `::after` blocks at the specified offsets), 2×2 secondary
button grid.

- [ ] **Step 5: Write `lockscreen.html`**

Full-screen mockup. Dimmed wallpaper (`filter: brightness(0.5)`),
optional flare positioned bottom-right using `assets/textures/flare-a.jpg`
as a blended overlay. Centered stack: time (Playfair 64px with radial-halo
background), greeting (muted Archivo Narrow 20pt), password input field
with cyan outer border and dark fill.

- [ ] **Step 6: Write `overview.html`**

Full-screen mockup. Background: dimmed wallpaper + `assets/textures/brush-field.png`
stretched and at 0.9 opacity. Film strips top and bottom. Two mock workspace groups,
each with a label and a grid of 3 window thumbnails. Each thumbnail uses
`assets/textures/frame-landscape.png` as a `border-image`. Active window gets
orange left-border + glow.

- [ ] **Step 7: Write `switcher.html`**

Full-screen mockup. Dimmed backdrop. Centered horizontal strip containing
5 thumbnails (all framed with `frame-landscape.png`), current selection (index 2)
highlighted with orange border + glow. Banner above the strip showing the
selected window's title ("FIREFOX — github.com").

- [ ] **Step 8: Write `osd.html`**

Centered-bottom 240×60 widget. Background `rgba(23,27,26,0.88)`, banner
"VOLUME" overhanging, horizontal bar (track `#363b3a`, fill 50% width
`#5bc0d6`), label "50%" below.

- [ ] **Step 9: Write `notification-toast.html`**

Top-right stack of 3 mock toasts at different urgencies: normal (Spotify
"Now playing"), critical (Battery "Low — 12%"), error (System "Update
failed"). Each 320×~80 with `edge-strip.png` decorative strip at top, app
name row, body row. Critical has orange left-border, error has red.

- [ ] **Step 10: Verify all 8 mockup files exist and reference the right assets**

Run:
```bash
ls docs/mockups/widgets/
```
Expected: 9 files (`_shared.css` + 8 `.html`).

Run:
```bash
for f in info-panel launcher power-menu lockscreen overview switcher osd notification-toast; do
  test -s "docs/mockups/widgets/$f.html" && echo "OK  $f" || echo "MISS $f"
done
```
Expected: all `OK`.

Run:
```bash
grep -l "assets/textures/page-bg.png" docs/mockups/widgets/info-panel.html docs/mockups/widgets/launcher.html >/dev/null && echo "side-page asset referenced in both side widgets"
```
Expected: the echo line.

Run:
```bash
grep -l "assets/textures/film-strip.png" docs/mockups/widgets/power-menu.html docs/mockups/widgets/overview.html >/dev/null && echo "film-strip asset referenced"
grep -l "assets/textures/frame-landscape.png" docs/mockups/widgets/overview.html docs/mockups/widgets/switcher.html >/dev/null && echo "frame asset referenced"
grep -l "assets/textures/edge-strip.png" docs/mockups/widgets/notification-toast.html >/dev/null && echo "tapelet asset referenced"
grep -l "assets/textures/flare-a.jpg" docs/mockups/widgets/lockscreen.html >/dev/null && echo "flare asset referenced"
grep -l "assets/textures/brush-field.png" docs/mockups/widgets/overview.html >/dev/null && echo "brush-bg-dark asset referenced"
```
Expected: five echo confirmations.

- [ ] **Step 11: Commit**

```bash
git add docs/mockups/widgets/
git commit -m "docs(mockups): add per-widget HTML mockups using real asset textures"
```

---

## Task 8: Cross-reference updates

Wire the new `docs/widgets/` directory into the project's top-level docs.

**Files:**
- Modify: `CLAUDE.md`

- [ ] **Step 1: Add a `docs/widgets/` pointer to CLAUDE.md**

Open `CLAUDE.md`, find the `## Key Documents` table. Add a new row after
the `docs/mockups/*.html` row:

Find this row in the table:

```
| `docs/mockups/*.html` | Visual reference mockups for each component (open in browser) |
```

Insert immediately after it:

```
| `docs/widgets/*.md` | Per-widget detail specs (input for disco-shell implementation) |
| `docs/mockups/widgets/*.html` | Per-widget visual mockups using real asset textures |
```

- [ ] **Step 2: Verify the edit**

Run:
```bash
grep -c "docs/widgets" CLAUDE.md
```
Expected: `2` (the two new rows).

- [ ] **Step 3: Commit**

```bash
git add CLAUDE.md
git commit -m "docs: add pointers to widgets/ and per-widget mockups in CLAUDE.md"
```

---

## Task 9: Final verification

Pure verification — no edits.

- [ ] **Step 1: Confirm all 8 widget specs exist**

```bash
for f in info-panel launcher power-menu lockscreen overview switcher osd notification-toast; do
  test -s "docs/widgets/$f.md" && echo "OK  spec: $f" || echo "MISS spec: $f"
done
```
Expected: 8 `OK`.

- [ ] **Step 2: Confirm all 8 mockups exist**

```bash
for f in info-panel launcher power-menu lockscreen overview switcher osd notification-toast; do
  test -s "docs/mockups/widgets/$f.html" && echo "OK  mock: $f" || echo "MISS mock: $f"
done
```
Expected: 8 `OK`.

- [ ] **Step 3: Confirm all 9 texture assets are staged**

```bash
for f in film-strip.png brush-strip-white.png brush-field.png page-bg.png flare-a.jpg flare-b.jpg frame-landscape.png frame-portrait.png edge-strip.png; do
  test -s "assets/textures/$f" && echo "OK  asset: $f" || echo "MISS asset: $f"
done
```
Expected: 9 `OK`.

- [ ] **Step 4: Confirm Hyprland keybinds changed**

```bash
grep -E "^bind\s*=\s*\\\$mod,\s*(period|Tab),\s*exec" configs/hypr/hyprland.conf
grep -E "^bind\s*=\s*\\\$mod SHIFT,\s*Escape,\s*exec" configs/hypr/hyprland.conf
grep -E "^#\s*bind\s*=\s*\\\$mod,\s*N" configs/hypr/hyprland.conf
```
Expected: four matching lines.

- [ ] **Step 5: Confirm CLAUDE.md has the new pointers**

```bash
grep -c "docs/widgets" CLAUDE.md
```
Expected: `2`.

---

## Self-Review

**Spec coverage:**

- Spec §"Goals" 1 (no always-on shell) → Task 2 removes Super+N quicksettings, keybinds are all toggle-on-demand.
- Spec §"Goals" 2 (small consistent vocabulary) → Tasks 4–6 produce 8 per-widget specs sharing the README template.
- Spec §"Goals" 3 (summon fast) → Task 2 keybind wiring.
- Spec §"Goals" 4 (each surface ceremonial) → Tasks 4–6 fully detail treatment per widget.
- Spec §"Non-Goals" disco-shell Rust work → respected; plan is dotfiles + design only.
- Spec §"The Three States" table → reflected in Tasks 4/5/6 grouping.
- Spec §"The Vocabulary" 8 entries → Tasks 4 (2 widgets), 5 (4 widgets), 6 (2 widgets).
- Spec §"Keybind Budget" → Task 2 covers every row.
- Spec §"Shared Design Recipes" → each referenced by name inside the widget specs.
- Spec §"Rest-State Guarantee" → enforced by Task 2 Step 5 deprecating Super+N and Task 2 not adding any always-on widgets.
- Spec §"Out of Scope" (keybinds help, notif history, wallpaper picker, emoji, disco-shell, mockup regen) → this plan does NOT include any of those.

**Placeholder scan:** no TBDs. Every widget spec task enumerates the exact values to write. Every mockup task lists exactly which asset to reference. Verification commands have explicit expected outputs.

**Consistency:**

- Panel width 220 px used for both info-panel and launcher.
- Banner overhang `top: -8px; left: -10px` quoted consistently.
- Asset filenames consistent across MANIFEST, widget specs, mockups (canonical short names: `film-strip.png`, not `film-strip-long_a5hufh.png`).
- `disco` easing referenced as the named cubic-bezier from the style guide in all animation sections.
- Selection indicator (orange 3 px left-border + `rgba(40, 44, 43, 0.4)` bg) consistent with style guide §12.

**Known risks:**

- `frame-landscape.png` may not work cleanly as a CSS `border-image` depending on its actual paint slice. The mockup tasks (overview, switcher) should visually confirm this; if the border-image slice looks wrong, the mockup task can adjust the `border-image-slice` values without needing a plan revision.
- The HTML mockups load fonts from Google Fonts over the network. This is acceptable for preview but will fail offline. Not a plan concern (mockups are for visual review, not production).
