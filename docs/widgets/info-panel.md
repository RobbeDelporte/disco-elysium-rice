# Info Panel

Summoned left-side page showing time, system vitals, connectivity, sliders, workspaces, media, and a power button. Absorbs the role of the deprecated quick-settings panel.

## Summary (from parent spec)

- **State:** Peek
- **Summon:** `Super + .` → toggle
- **Dismiss:** `Esc`, click outside, `Super + .` again

## Dimensions & Position

- Width: **240 px** fixed (revised from 220 in parent spec — the four-column vitals grid + slot value ellipsis read better at 240).
- Height: full monitor height.
- Anchor: left edge, `margin-left: 0`.
- Z-order: above windows, below Ceremonial surfaces.
- Enter: slide `-240 → 0` + fade `0 → 1` over 220 ms using the `disco` easing.
- Exit: reverse, 180 ms.

## Surface Treatment

- **Base:** `rgba(23, 27, 26, 0.88)`.
- **Texture:** `assets/textures/single-page-content-bg.png` applied as `background-image` with `background-repeat: repeat-y` and `background-size: 240px auto`. Tiling vertically avoids stretching the brush strokes; the asset's natural width of 1440 px is downscaled to the 240 px panel width.
- **Tint overlay:** a sibling div with `background: rgba(14, 17, 16, 0.32)` covering the full panel, sitting above the texture and below the content. This preserves legibility without swallowing the brush strokes.
- **Right border:** `1px solid rgba(54, 59, 58, 0.6)`.
- **Inner padding:** `22px 16px 16px 16px` (top extra for the banner overhang).
- **No drop shadow** on the right edge. The border + texture carry the edge.
- **Banner header:** text "SYSTEM", position `top: -8px; left: -6px` so it overhangs the top-left corner. Background `#d2d2d2`, color `#171b1a`. In disco-shell, apply the SVG erosion filter from the style guide. In the HTML mockup, a `clip-path` polygon is used as an approximation.

## Contents

Ordered top → bottom. Each section is separated by a label divider row: an Archivo Narrow 9 px uppercase letter-spacing 3 px muted label (`#999a95`), with a 1 px horizontal rule on each side filling the row width.

### 1. Header block (centered)

- **Time:** Playfair Display 700, 34 px, color `#d2d2d2`, line-height 1.0, `text-shadow: 0 0 10px rgba(0, 0, 0, 0.85)` for wallpaper legibility.
- **Date:** Archivo Narrow 700, 9 px uppercase letter-spacing 3 px, color `#999a95`, format `FRI · 13 APR`. `margin-top: 4px`.

### 2. Vitals

Four rows, each in a 4-column grid (`16px 36px 1fr 40px`):

| Vital | Skill | Color token | Icon | Metric |
|-------|-------|-------------|------|--------|
| BAT | Physique | `#cb456a` | battery SVG | charge % |
| CPU | Motorics | `#e3ba3e` | CPU-chip SVG | load % |
| MEM | Intellect | `#5bc0d6` | RAM-stick SVG | usage % |
| NET | Psyche | `#7555c6` | up/down arrows SVG | current throughput |

Row styling:
- Column 1: 14×14 SVG icon, stroke 1.8, `round` linecap, no fill. Stroke color is the skill's color.
- Column 2: label in Archivo Narrow 700, 9 px uppercase letter-spacing 1 px, color `#999a95`.
- Column 3: progress bar, 3 px tall, track `rgba(54, 59, 58, 0.7)`, fill in the skill's color at `opacity: 0.9`.
- Column 4: value in Archivo Narrow 700, 10 px, color `#ccc8c2`, right-aligned.

### 3. Connectivity slots

Three expandable slots (WiFi, BT, Audio Out). Each is a 4-column grid (`16px 44px 1fr 10px`), clickable, with hover and selected states:

| Slot | Icon | Label | Value (example) |
|------|------|-------|-----------------|
| WIFI | wifi-signal SVG | `WIFI` | network SSID (or "OFF") |
| BT | bluetooth-rune SVG | `BT` | active device name (or "OFF") |
| AUDIO | speaker-waves SVG | `AUDIO` | current output device name |

- Icon color: `#d2d2d2` when on, `#4b4b4b` when off.
- Label: Archivo Narrow 700, 10 px uppercase letter-spacing 1 px, color `#ccc8c2`.
- Value: Libre Baskerville 400, 10 px, color `#999a95`, right-aligned, ellipsis on overflow.
- Trailing chevron `›` in color `#999a95`.
- Default: `border-left: 3px solid transparent`; padding `7px 3px`; margin `3px -6px` (negative horizontal to stretch the row to the panel edge for the selected highlight).
- Hover: `background: rgba(40, 44, 43, 0.5)`.
- Selected/keyboard-focused: `border-left: 3px solid #eb6408`, `background: rgba(40, 44, 43, 0.55)`.
- Click behaviour: opens the corresponding **subview** — see "Submenu mechanism" below.

### 4. Controls (sliders)

Two rows, 3-column grid (`30px 1fr 30px`):

| Slider | Label | Value |
|--------|-------|-------|
| VOL | volume | 0–100 |
| BRI | brightness | 0–100 |

- Label: Archivo Narrow 700, 9 px uppercase letter-spacing 2 px, color `#999a95`.
- Track: 4 px tall, `rgba(54, 59, 58, 0.7)`.
- Fill: `#d2d2d2` solid.
- Knob: 8×8 diamond (rotated 45°), `#d2d2d2`, `box-shadow: 0 0 6px rgba(210, 210, 210, 0.35)`.
- Value: Archivo Narrow 700, 10 px, `#ccc8c2`, right-aligned.

### 5. Workspaces (centered)

Row of diamond indicators, one per Hyprland workspace that currently has windows, plus the active one. Gap 10 px. Rendered centered.

- Empty workspace (no windows): `10×10` diamond, `#4b4b4b`.
- Occupied workspace: `10×10` diamond, `#999a95`.
- Active workspace: `10×10` diamond, `#d2d2d2`, `box-shadow: 0 0 6px rgba(210, 210, 210, 0.55)`.

### 6. Playing (centered)

- **Title:** Libre Baskerville 400, 13 px, `#ccc8c2`, line-height 1.3.
- **Artist:** Archivo Narrow 700, 9 px uppercase letter-spacing 2 px, `#999a95`, `margin-top: 3px`.
- **Transport:** three glyphs `◀ ⏸ ▶` gap 18 px, color `#d2d2d2`, size 14 px. Hover tints to `#eb6408`.
- Whole section collapses when no MPRIS media is playing.

### 7. Footer — End Session button

- Text "END SESSION", Archivo Narrow 700, 11 px uppercase letter-spacing 3 px, color `#999a95`.
- Background `rgba(30, 34, 33, 0.85)`, top & bottom `1px solid rgba(54, 59, 58, 0.6)`, no side borders (stretches full panel width).
- Padding `10px 12px`, centered text.
- Pinned to the bottom of the panel via `margin-top: auto` on a flex column.
- Click behaviour: opens the Power Menu (§ power-menu) and dismisses the Info Panel.
- Hover: color `#eb6408`, background `rgba(40, 44, 43, 0.85)`.

## Submenu mechanism

Clicking WIFI / BT / AUDIO opens a **subview** that swaps the panel's content in place with a horizontal slide-left transition, within the same 240 px width. The banner "SYSTEM" animates to the subview's title ("WIFI NETWORKS", "BLUETOOTH", "AUDIO DEVICES"). A back arrow `‹` appears in the top-left of the subview content area.

- **WiFi subview:** scrollable list of in-range networks, each a row showing signal strength glyph + SSID + optional lock icon, orange left-border on the currently connected network. Click activates the connect flow.
- **BT subview:** scrollable list of paired + in-range devices. Same row structure.
- **AUDIO subview:** list of output devices (speakers, headphones, HDMI, etc.) with the active device highlighted.

Back arrow or `Esc` returns to the main info panel. `Esc` a second time dismisses the panel.

## Keyboard & Pointer

- `Super + .` — toggle (open if closed, dismiss if open).
- `Esc` — dismiss (or return from subview to main if a subview is open).
- Arrow keys / `j` `k` — navigate between interactive rows (slots, sliders, power button).
- `↵` on a slot — open its subview.
- `↵` on the power button — open Power Menu.
- Scroll wheel on a slider — adjust its value.
- Drag on a slider — adjust its value.
- Click on a slot — open its subview.
- Click outside the panel — dismiss.

No arrow-key navigation is required at MVP for the vitals rows (they are passive meters).

## Animation

- **Enter:** slide `x: -240px → 0` + fade `opacity: 0 → 1` over 220 ms with cubic-bezier(0.25, 0.1, 0.25, 1.0) (named `disco`).
- **Exit:** reverse, 180 ms.
- **Slot → Subview:** main content slides out to the left (`x: 0 → -240px`, fade `1 → 0`) over 180 ms, subview slides in from the right (`x: 240px → 0`, fade `0 → 1`) over 180 ms. The banner text cross-fades during the transition.
- **Subview → Main:** reverse.
- **Slider value change:** the fill width animates to the new value over 120 ms `ease-out`.
- **No internal idle motion** (no pulsing, no shimmer).

## Reference

- Parent spec: `docs/superpowers/specs/2026-04-13-desktop-redesign-design.md` §1.
- Style guide: §4.1 functional palette, §5 typography, §6 banner, §7 painted-canvas, §9 borders, §12 selection (orange left-border), §17 icons (thin-line outline).
- Assets: `assets/textures/single-page-content-bg.png`.
- Mockup: `docs/mockups/widgets/info-panel.html`.
