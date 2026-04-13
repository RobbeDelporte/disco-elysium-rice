# Launcher

Summoned right-side page. Universal search / action portal with modes (launch, clipboard, calculator, files, bash). Mirror of the Info Panel on the opposite edge. The launcher's functional behaviour already exists in disco-shell; this spec is primarily a **style transfer** — visual treatment, not mode mechanics.

## Summary (from parent spec)

- **State:** Peek.
- **Summon:** `Super + /` → toggle.
- **Dismiss:** `Esc`, click outside, `Super + /` again. Any Ceremonial surface opening dismisses the launcher.

## Dimensions & Position

- **Width:** content-driven. Base 280 px; can grow up to ~360 px for long result titles. Never exceeds 40% of monitor width. Never wider than 360 px at MVP.
- Height: full monitor height.
- Anchor: right edge, `margin-right: 0`.
- Z-order: identical to Info Panel.
- Enter: slide `+width → 0` + fade `0 → 1` over 220 ms `disco` easing.
- Exit: reverse, 180 ms.

## Surface Treatment

Mirrored version of the Info Panel surface:

- **Base:** `rgba(23, 27, 26, 0.88)`.
- **Texture:** `assets/textures/page-bg.png`, `background-repeat: repeat-y`, `background-size: <panel-width> auto`.
- **Tint overlay:** full-panel div at `rgba(14, 17, 16, 0.32)` above texture, below content.
- **Left border:** `1px solid rgba(54, 59, 58, 0.6)` (mirrored from info panel's right border).
- **Padding:** `22px 16px 16px 16px`.
- **No drop shadow** on the left edge — border + texture carry the edge.
- **Banner:** text is the current mode name in uppercase Archivo Narrow 700, 12 px, letter-spacing 3 px. Position `top: -8px; right: -6px` (mirrored overhang). Background `#d2d2d2`, color `#171b1a`. Apply erosion filter in disco-shell. Banner text animates on mode change.

## Contents

Ordered top → bottom.

### 1. Mode icon row

A horizontal row of 5 icons inside a bordered tray, representing the launcher's modes. The active mode shows a 2 px orange underline (`#eb6408`) and a cream icon stroke (`#d2d2d2`); inactive modes use muted stroke (`#999a95`).

| # | Mode | Banner text | Icon |
|---|------|-------------|------|
| 1 | Launch (windows + apps) | `LAUNCH` | star/spark glyph |
| 2 | Clipboard history | `CLIPBOARD` | clipboard glyph |
| 3 | Calculator | `CALC` | calculator glyph |
| 4 | Files | `FILES` | folder glyph |
| 5 | Bash | `BASH` | `>_` prompt glyph |

Row styling:
- Container: flex row, `justify-content: space-around`, padding `6px 4px`, border `1px solid rgba(54, 59, 58, 0.5)`, background `rgba(10, 12, 11, 0.4)`.
- Each icon cell: inline-flex centered, width 32 px, height 24 px, `border-bottom: 2px solid transparent` by default. Active: `border-bottom-color: #eb6408`.
- Clicking an icon switches mode; banner text animates accordingly.

**Launch mode merges windows and apps.** Windows are listed first in the results (prioritized over apps); apps appear below windows. A mode dedicated solely to "windows" is intentionally absent — the overview widget (Super + Tab) handles full window navigation.

### 2. Search input

- Prompt glyph `>` in color `#eb6408`, JetBrains Mono 700, 13 px.
- Query text in `#ccc8c2`, JetBrains Mono 400, 13 px.
- Cursor: 7×14 px block, background `#eb6408`, blinking at 1 Hz.
- Divider below: `border-bottom: 1px solid #363b3a`, padding `6px 0`.

### 3. Results list

Each result row is a 3-column grid (`28px 1fr auto`):

- Column 1: 24×24 monogram tile. Selected row: background `#912711`, text `#ebdbb2`. Unselected: background `#1e2221`, text `#999a95`. Font Archivo Narrow 700, 14 px.
- Column 2:
  - Primary: Archivo Narrow 700, 12 px uppercase letter-spacing 1 px, color `#ccc8c2`. Item name or window title.
  - Secondary: Libre Baskerville 400, 10 px, color `#999a95`. Subtitle / context ("Web browser", "Workspace 2 · open now", etc.).
- Column 3: action hint glyph for the selected row only (`↵` in `#eb6408`, 12 px).
- Selected row: `border-left: 3px solid #eb6408; background: rgba(40, 44, 43, 0.55)`.
- Unselected: `border-left: 3px solid transparent`.
- Padding: `7px 6px 7px 3px`. Margin `0 -6px` to stretch highlight to panel edge.

### 4. Group labels (in Launch mode)

When the Launch mode returns both windows and apps, group them with labels in skill colours. The grouping order is fixed: WINDOWS first, APPS second.

| Group | Label color | Reason |
|-------|-------------|--------|
| WINDOWS | `#7555c6` psyche | Existing state / memory of prior sessions |
| APPS | `#e3ba3e` motorics | Action / launching something new |

Labels: Archivo Narrow 700, 8 px uppercase letter-spacing 3 px. Padding `10px 0 2px 3px` (top 4 px for the first group).

Other modes do not use group labels.

### 5. Empty state

Per-mode. At MVP:

- **Launch:** if query empty → show recently-used applications (LRU). No group label needed.
- **Clipboard:** if query empty → show most recent clipboard entries (LRU).
- **Calculator:** if query empty → show nothing; hint text instead ("type an expression").
- **Files:** if query empty → show recent files.
- **Bash:** if query empty → show recent bash commands; executing a command returns output as a sticky last-result row.

Hint text: Archivo Narrow 700, 10 px, muted, centered, italic off.

### 6. Footer

**Out of scope for MVP** — no action-key footer. If added later, use the pattern: Archivo Narrow 700, 8 px muted, letter-spacing 2 px, horizontal divider above, text `↵ run  ⇥ mode  ESC close`.

## Keyboard & Pointer

- Typing: filters results.
- `↑` / `↓` / `Ctrl+k` / `Ctrl+j`: move selection.
- `↵`: activate selected result.
- `⇥`: cycle forward through modes (Launch → Clipboard → Calc → Files → Bash → Launch …).
- `⇧⇥`: cycle backward.
- `Esc`: dismiss.
- Click a row: select + activate.
- Click a mode icon: switch mode.
- Scroll wheel on results: scroll the list.

## Animation

- **Enter:** slide `x: +width → 0` + fade `0 → 1`, 220 ms `disco`.
- **Exit:** reverse, 180 ms.
- **Mode change:** banner text cross-fades (60 ms each way). Mode row underline slides along the active cell over 160 ms `ease-out`. Results list fades out and fades back in with the new contents (100 ms out / 120 ms in).
- **Width change** (when growing to accommodate long results): animate panel width with 180 ms `ease-out`.
- **Cursor blink:** 1 Hz.
- No other idle motion.

## Reference

- Parent spec: `docs/superpowers/specs/2026-04-13-desktop-redesign-design.md` §2.
- Style guide: §4.1 palette, §5 typography, §6 banner, §7 painted-canvas, §8.3 halos (optional behind banner), §9 borders, §12 selection (orange left-border).
- Existing launcher implementation (functional behaviour): `~/Documents/disco-shell/crates/app/src/widgets/launcher.rs`. This spec adopts its modes; only the visual language is new.
- Assets: `assets/textures/page-bg.png`.
- Mockup: `docs/mockups/widgets/launcher.html`.
