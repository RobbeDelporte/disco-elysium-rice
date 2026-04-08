# Status Bar (disco-shell)

Open `status-bar.html` in a browser to see the visual mockup.

## Overview

Top-anchored black glass bar spanning the full screen width. Three-column layout (left / center / right) using a `CenterBox`. Bar height: **36px**.

## Bar Surface

| Property | Value | GTK4/SCSS |
|----------|-------|-----------|
| Background | `rgba(10, 12, 11, 0.78)` | `background-color` on `window.bar` |
| Blur | 20px backdrop blur | Hyprland `layerrule blur` on the bar layer surface |
| Bottom border | `2px solid rgba(210, 210, 210, 0.18)` | `border-bottom` |
| Height | 36px | `min-height: 36px` |

**Note:** GTK4 does not natively support `backdrop-filter`. The blur effect is achieved via Hyprland layer rules applied to the Astal window's layer surface. The bar window should use `Astal.Window` with `anchor: top | left | right` and `exclusivity: exclusive`.

## Layout

```
[ws-well] | sep | window-title |  sep | ── clock ── | sep  | [module-well] | sep | icons
└──── bar-left ─────────────────┘     └─ bar-center ─┘     └────────── bar-right ────────┘
```

GTK structure: `CenterBox > [start] Box > ... | [center] Box > ... | [end] Box > ...`

## Luminous Dividers

Vertical 1px lines between all major sections. Gradient fades at top and bottom for a soft seam effect.

| Property | Value |
|----------|-------|
| Width | 1px |
| Height | 36px (full bar height) |
| Background | `linear-gradient(to bottom, transparent 0%, rgba(210,210,210,0.12) 30%, rgba(210,210,210,0.12) 70%, transparent 100%)` |
| Margin | 0 10px |

**GTK implementation:** `Gtk.Box` with CSS class `.sep-light`, `min-width: 1px`, `min-height: 36px`. The gradient is applied via `background-image` in SCSS.

## Workspaces (Left)

Diamond-shaped indicators (7x7px squares rotated 45deg) inside a recessed **well** container.

### Well Container

| Property | Value |
|----------|-------|
| Background | `rgba(16, 19, 18, 0.45)` |
| Border | `1px solid rgba(54, 59, 58, 0.20)` left and right only |
| Inner glow | `inset 1px 0 0 rgba(210,210,210,0.03)` both sides |
| Height | 36px (full bar height) |
| Border-radius | 0 (flush with bar edges) |

**GTK implementation:** `Gtk.Box` with CSS class `.ws-well`. No top/bottom border so the well merges with the bar's own edges.

### Diamond Indicators

| State | Color | Effect |
|-------|-------|--------|
| Inactive | `#4b4b4b` | — |
| Hover | `#999a95` | — |
| Active | `#d2d2d2` | `box-shadow: 0 0 5px rgba(210,210,210,0.35)` |

**GTK implementation:** Each workspace is a `Gtk.Button` containing a small `Gtk.Box` (7x7px). The diamond rotation is achieved with CSS `transform: rotate(45deg)` on the inner box. GTK4 CSS supports transforms on widgets. The active glow uses `box-shadow`.

## Window Title

| Property | Value |
|----------|-------|
| Font | Libre Baskerville, weight 500 (Medium) |
| Size | 11px |
| Color | `#999a95` |
| Max width | 280px, ellipsize: end |

**GTK implementation:** `Gtk.Label` with CSS class `.window-title`, `ellipsize: end`, `max-width-chars: 40`.

## Clock (Center)

No well container. The clock floats between two ornamental fade-lines.

| Property | Value |
|----------|-------|
| Font | Open Sans, weight 300 (Light) |
| Size | 14px |
| Letter spacing | 1.5px |
| Transform | Uppercase |
| Color | `#ccc8c2` |
| Format | `%a %d %b, %H:%M` uppercased (e.g. `WED 02 APR, 14:30`) |

### Ornamental Lines

Horizontal 1px lines flanking the clock, 30px wide, fading from transparent to `rgba(210,210,210,0.20)`.

**GTK implementation:** `Gtk.Box` (horizontal) containing: fade-line `Gtk.Box` (30x1px) + `Gtk.Label` + fade-line `Gtk.Box`. The fade is a `background-image: linear-gradient(...)`.

## System Modules (Right)

Four modules inside a recessed well (same well style as workspaces). Each module has a skill-colored icon and a percentage value, with a skill-colored underline at the bottom.

### Module Well

Same CSS as workspace well (`.module-well`).

### Modules

| Module | Skill | Icon | Icon Color |
|--------|-------|------|------------|
| CPU | Intellect | Chip/processor | `rgba(91, 192, 214, 0.7)` |
| MEM | Psyche | Hexagon/cube | `rgba(117, 85, 198, 0.7)` |
| VOL | Physique | Speaker | `rgba(203, 69, 106, 0.7)` |
| BAT | Motorics | Battery | `rgba(227, 186, 62, 0.7)` |

| Property | Value |
|----------|-------|
| Value font | JetBrains Mono, 11px |
| Value color | `#999a95` |
| Icon size | 14x14px |
| Underline | 2px, `border-radius: 1px`, at `bottom: 4px`, skill color at 35% opacity |

**GTK implementation:** Each module is a `Gtk.Box` (horizontal) with CSS classes `.module` and the skill class (`.intellect`, `.psyche`, `.physique`, `.motorics`). Contains a `Gtk.Image` (icon) and `Gtk.Label` (value). The underline is a child `Gtk.Box` positioned at the bottom, or achieved via a CSS `border-bottom` on a nested element with appropriate margin. Since GTK4 CSS does not support `::after`, use a small `Gtk.Box` (height: 2px) as the last child of a vertical container wrapping each module.

**Icons:** Use Gruvbox Plus Dark symbolic icon theme (`gruvbox-plus-icon-theme` AUR package). The icons shown are approximations — actual symbolic icons from the theme will be used. Icon names: `cpu-symbolic`, `memory-symbolic`, `audio-volume-high-symbolic`, `battery-good-symbolic` (or equivalent from the theme).

## Action Icons (Right)

Three bare icon buttons, no well container.

| Button | Action | Icon |
|--------|--------|------|
| Settings | Toggle quick settings panel | `settings-symbolic` |
| Bell | Toggle notification center | `notification-symbolic` |
| Power | Toggle power menu | `system-shutdown-symbolic` |

| Property | Value |
|----------|-------|
| Size | 30x36px (click target) |
| Icon size | 16x16px |
| Color | `#999a95`, hover: `#ccc8c2` |

### Notification Dot

Orange dot overlay on the bell icon when unread notifications exist.

| Property | Value |
|----------|-------|
| Size | 5x5px |
| Color | `#eb6408` |
| Position | Top-right of icon (absolute overlay) |

**GTK implementation:** `Gtk.Button` with `Gtk.Overlay` containing the icon `Gtk.Image` and a small `Gtk.Box` (the dot) positioned via CSS margin. The dot's visibility is toggled based on notification count from `AstalNotifd`.

## Style Guide Deviations

These changes diverge from the current `docs/style-guide.md` and should be updated there:

1. **Active workspace:** Cream bottom border replaced with diamond indicator + glow (no banner treatment)
2. **Module skill colors:** Underlines at 35% opacity inside a well, with skill-colored icons — replaces the 3px bottom-border approach
3. **Bar opacity:** 78% black glass with backdrop blur — replaces the 88% semi-transparent panel
4. **Bar border:** 2px cream bottom border — replaces `1px solid rgba(54, 59, 58, 0.4)`
5. **Clock font:** Open Sans Light (300) — replaces Open Sans Condensed Bold (700)
6. **Window title font:** Libre Baskerville Medium — replaces JetBrains Mono
7. **Icon theme:** Gruvbox Plus Dark (`gruvbox-plus-icon-theme`) — replaces Papirus-Dark
8. **Keybinds button:** Removed from bar (accessed via keyboard shortcut only)
9. **Wells:** New UI pattern — recessed dark containers with side-only borders for grouping bar elements
10. **Luminous dividers:** New UI pattern — gradient vertical lines between sections, replacing solid `1px` separators
11. **Ornamental clock lines:** New UI pattern — fading horizontal lines flanking the clock
