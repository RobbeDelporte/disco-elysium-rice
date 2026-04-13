# Power Menu

Ceremonial end-of-session menu. Dark full-screen overlay with film tape at top and bottom, center panel listing every end-session option.

## Summary (from parent spec)

- **State:** Ceremonial.
- **Summon:** `Super + Shift + Escape`, or clicking the "END SESSION" button in the Info Panel.
- **Dismiss:** `Esc`, click outside the panel, or action a button.

## Dimensions & Position

- Full-screen dimming overlay.
- Center panel: 400 px wide, height auto (expands to fit all rows).
- Vertically and horizontally centered on the active monitor.
- Top and bottom film edges extend across the full screen width.

## Surface Treatment

- **Backdrop:** full-screen `rgba(0, 0, 0, 0.72)`.
- **Top film edge:** `assets/textures/film-tape.png`, `background-repeat: repeat-x`, `background-size: auto 96px`, height 96 px at the top of the screen. **Flipped vertically** (`transform: scaleY(-1)`) so its sprocket side faces inward.
- **Bottom film edge:** same asset, same height, natural orientation (sprocket side facing inward).
- **Center panel:** solid `#0e1110` fill, `1px solid rgba(54, 59, 58, 0.7)` border. **No drop shadow** — the film tape + darkened backdrop carry the separation.
- **Padding:** `28px 26px 22px 26px`.
- **Banner header:** text "END SESSION", Archivo Narrow 700, 14 px, uppercase, letter-spacing 4 px. Position `top: -14px; left: -10px` overhanging the panel's top-left corner. Background `#d2d2d2`, color `#171b1a`. Erosion filter in disco-shell; `clip-path` polygon in the HTML mockup.

## Contents

A single vertical list of six rows, each a 3-column grid (`24px 1fr auto`). Selected row highlighted with orange left-border + subtle background.

| Row | Label | Description | Icon (thin-line SVG) |
|-----|-------|-------------|----------------------|
| 1 | Shut Down | Power off the machine. | power symbol (circle with top slash) |
| 2 | Restart | Reboot and return. | circular arrow |
| 3 | Suspend | Sleep the machine; resume later. | crescent moon |
| 4 | Hibernate | Write state to disk; power off. | sun-rays circle (alternate state) |
| 5 | Lock | Stay logged in; lock the screen. | padlock |
| 6 | Log Out | End Hyprland session. | arrow-out-of-box |

Row styling:

- **Default:** `padding: 12px 14px; border-left: 3px solid transparent; gap: 14px;`. Column 1 is a 20×20 SVG icon in color `#999a95` (stroke 1.8, round caps). Column 2 holds two stacked lines:
  - Label: Archivo Narrow 700, 14 px uppercase, letter-spacing 3 px, color `#ccc8c2`.
  - Description: Libre Baskerville 400, 11 px, color `#999a95`, `margin-top: 2px`.
- **Selected:** `border-left-color: #eb6408; background: rgba(40, 44, 43, 0.55)`. Icon stroke `#eb6408`. A trailing `↵` glyph in `#eb6408`, 14 px, appears in column 3.
- **Hover (when pointer is available):** `background: rgba(40, 44, 43, 0.35)`.

Initial focus: row 1 (Shut Down).

## Footer

A narrow row beneath the options:

- `border-top: 1px solid rgba(54, 59, 58, 0.5); padding-top: 10px`.
- Text "ESC to cancel", Archivo Narrow 700, 9 px uppercase, letter-spacing 3 px, color `#999a95`, center-aligned.

## Keyboard & Pointer

- `↑` / `↓` / `j` / `k` — move selection.
- `↵` — activate selected row.
- `Esc` — dismiss without action.
- Mouse click on a row — activate it.
- Click outside the panel (on the dimmed backdrop) — dismiss.

## Animation

- **Enter:**
  - Backdrop fade `opacity: 0 → 1` over 180 ms `ease-out`.
  - Film edges slide in from screen edges (`y: ±96px → 0`) + fade, 220 ms `disco`.
  - Panel fade + scale `0.96 → 1.0`, 220 ms `disco`.
- **Exit:** reverse of enter, 180 ms.
- **Selection change:** row background and left-border color crossfade over 100 ms.
- No idle motion.

## Reference

- Parent spec: `docs/superpowers/specs/2026-04-13-desktop-redesign-design.md` §3.
- Style guide: §4.1 palette, §5 typography, §6 banner, §7 painted-canvas, §9 borders, §12 selection (orange left-border), §17 icons (thin-line outline).
- Assets: `assets/textures/film-tape.png`.
- Mockup: `docs/mockups/widgets/power-menu.html`.

## Note on the removed "Layered Offset CTA"

The parent spec originally called for a Layered Offset CTA (`#912711` + cyan offset + orange offset behind "SHUT DOWN"). That pattern was dropped in brainstorming — the film tape + dark overlay already carry enough drama, and the offset-CTA composition reads too "marketing button" for a system dialog. Standard list rows (orange left-border selection) are used instead.
