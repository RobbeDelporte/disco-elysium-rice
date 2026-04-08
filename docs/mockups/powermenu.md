# Power Menu (disco-shell)

Open `powermenu.html` in a browser to see the visual mockup.

## Overview

Centered overlay panel on a dimmed wallpaper backdrop, biased slightly upward (`padding-bottom: 6%`). Eroded cream banner title, black glass panel, vertical action list with cream left-border selection.

Triggered via the power icon in the status bar or `Super+Shift+E`. Closes with `Escape` or clicking outside.

## Overlay Backdrop

| Property | Value | Implementation |
|----------|-------|----------------|
| Background | `rgba(10, 12, 11, 0.55)` | Astal.Window background with full-screen anchor |
| Click-to-dismiss | Clicking the backdrop closes the power menu | Event handler on the overlay window |

The power menu window uses `Astal.Window` with `anchor: top | bottom | left | right`, `keymode: on-demand`, and `exclusivity: normal` (non-exclusive, overlays desktop).

## Banner

The Disco Elysium eroded-edge banner — cream `#d2d2d2` paint layer over a gray `#999a95` backing, with organic noise erosion on the edges revealing the gray underneath.

| Property | Value |
|----------|-------|
| Text | "SESSION" |
| Font | Open Sans Condensed Bold, 14px, uppercase, letter-spacing 2px |
| Text color | `#171b1a` (dark on cream) |
| Cream layer | `#d2d2d2` |
| Gray backing | `#999a95` |
| Position | Flush with panel top-left corner |
| Erosion | SVG `feTurbulence` + `feDisplacementMap` (seed=11) |

### Banner SVG Implementation

**File location:** `configs/astal/data/banners/session.svg`

The banner is a **pre-rendered SVG file** loaded as a `Gtk.Picture` resource. GTK4 does not support CSS SVG filters, so the erosion effect is baked into the SVG at design time.

**SVG filter definition:**

```xml
<filter id="erode" x="-5%" y="-5%" width="110%" height="110%">
  <feTurbulence type="turbulence" baseFrequency="0.04" numOctaves="4" seed="11" result="noise"/>
  <feDisplacementMap in="SourceGraphic" in2="noise" scale="6" xChannelSelector="R" yChannelSelector="G"/>
</filter>
```

**GTK implementation:** Add banner SVG to `disco-shell.gresource.xml` under `banners/`. Load with `Gtk.Picture.new_for_resource()`.

## Panel

| Property | Value | GTK/SCSS |
|----------|-------|----------|
| Background | `rgba(10, 12, 11, 0.78)` | `background-color` on `.powermenu-container` |
| Blur | 20px backdrop | Hyprland `layerrule blur` on the powermenu layer surface |
| Border-left | `3px solid rgba(210, 210, 210, 0.22)` | Prominent cream left edge |
| Border-bottom | `2px solid rgba(210, 210, 210, 0.18)` | Cream bottom edge |
| Border-top | `1px solid rgba(54, 59, 58, 0.20)` | Subtle dark top edge |
| Border-right | `1px solid rgba(54, 59, 58, 0.20)` | Subtle dark right edge |
| Min-width | 280px | `min-width: 280px` |
| Padding | 10px 8px | `padding` |

**GTK implementation:** `Gtk.Box` (vertical) with CSS class `.powermenu-container`.

## Action Items

Vertical list of session actions: Lock, Suspend, Logout, [divider], Reboot, Shutdown. The divider separates safe actions from danger actions.

### Layout

```
[3px border] [  icon  ] [  LABEL  ]
```

**GTK implementation:** `Gtk.Button` containing `Gtk.Box` (horizontal) with:
- `Gtk.Image` (16x16, symbolic icon from Gruvbox Plus Dark theme, stroke-width 1.8)
- `Gtk.Label` (action name)

### Action Icon

| Property | Value |
|----------|-------|
| Size | 16x16px |
| Source | Gruvbox Plus Dark symbolic icons |
| Color (default) | `#999a95` |
| Color (danger) | `#4b4b4b` |

### Icon Names (Gruvbox Plus Dark)

| Action | Icon Name |
|--------|-----------|
| Lock | `lock-symbolic` |
| Suspend | `suspend-symbolic` |
| Logout | `logout-symbolic` |
| Reboot | `refresh-symbolic` |
| Shutdown | `system-shutdown-symbolic` |

### Action Label

| Property | Value |
|----------|-------|
| Font | Open Sans Condensed Bold, 14px, uppercase, letter-spacing 1px |
| Color (default) | `#ccc8c2` |
| Color (danger) | `#999a95` |

### Luminous Divider

Horizontal separator between safe and danger actions.

| Property | Value |
|----------|-------|
| Height | 1px |
| Background | `linear-gradient(90deg, transparent 0%, rgba(210,210,210,0.10) 20%, rgba(210,210,210,0.10) 80%, transparent 100%)` |
| Margin | 6px 0 |

**GTK implementation:** `Gtk.Box` with `.sep-h` class, `min-height: 1px`, gradient via `background-image`.

### States

| State | Treatment |
|-------|-----------|
| Default | Transparent background, `border-left: 3px solid transparent`, padding 8px 12px |
| Hover | `background: rgba(40, 44, 43, 0.5)` |
| Selected | `border-left: 3px solid #d2d2d2`, `background: rgba(40, 44, 43, 0.4)`, `padding-left: 9px` |
| Selected + Danger | `border-left: 3px solid #b83a3a` (red border instead of cream) |

**GTK implementation:** `.pm-item` base class with `.selected` added to the active item. The `border-left` with transparent default ensures items don't shift when selected. Padding-left adjusts from 12px to 9px on selected to compensate for the visible border.

### Danger Items (Reboot, Shutdown)

Visually muted by default to discourage accidental activation. Brighten on hover.

| State | Label Color | Icon Color |
|-------|------------|------------|
| Default | `#999a95` | `#4b4b4b` |
| Hover | `#ccc8c2` | `#999a95` |
| Selected | Red left border (`#b83a3a`) instead of cream |

## Footer Hint

| Property | Value |
|----------|-------|
| Text | `esc to cancel · enter to confirm` |
| Font | JetBrains Mono, 10px |
| Color | `#363b3a` |
| Padding | 6px 12px 0 |

**GTK implementation:** `Gtk.Label` with CSS class `.powermenu-hint`.

## Behavior

| Action | Result |
|--------|--------|
| Power icon in bar | Opens power menu |
| `Super+Shift+E` | Opens power menu |
| `Escape` | Closes power menu |
| `j` / `Down` arrow | Moves selection down |
| `k` / `Up` arrow | Moves selection up |
| `Enter` | Executes selected action |
| Click on item | Executes that action |
| Click on backdrop | Closes power menu |

## Style Guide Deviations

1. **Banner**: SVG noise erosion with gray backing — replaces the CSS-only eroded-edge approach from the style guide. Banner is flush (no overhang) unlike the style guide's overhang recommendation.
2. **Selection**: Cream left border — replaces the cream background inversion (primary selection) from the style guide. The banner is the only full cream element.
3. **Panel surface**: Same glass as status bar (`rgba(10, 12, 11, 0.78)`) instead of opaque `rgba(23, 27, 26, 1.0)` — consistent with notification center and quick settings.
4. **Panel border**: Directional border (3px cream left, 2px cream bottom, 1px dark top+right) instead of uniform border — emphasizes the left edge as an anchor point, consistent with other overlay panels.
5. **Icon theme**: Gruvbox Plus Dark — replaces Papirus-Dark (consistent with status bar and launcher).
