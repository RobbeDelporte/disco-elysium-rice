# Keybind Cheatsheet (disco-shell)

Open `keybinds.html` in a browser to see the visual mockup.

## Overview

Right-anchored floating panel showing grouped keybinds from hyprland.conf. Same position and directional border treatment as quick settings (vertically centered, slight upward bias). Not full-height — sized to content. Sections separated by luminous horizontal dividers.

Opens with `disco-shell toggle-keybinds`, closes with `Escape` or click outside panel.

## Panel

| Property | Value | GTK/SCSS |
|----------|-------|----------|
| Background | `rgba(10, 12, 11, 0.78)` | Same black glass as status bar and quick settings |
| Blur | 20px backdrop | Hyprland `layerrule blur` |
| Border-left | `3px solid rgba(210, 210, 210, 0.22)` | Prominent cream left edge |
| Border-bottom | `2px solid rgba(210, 210, 210, 0.18)` | Cream bottom edge |
| Border-top | `1px solid rgba(54, 59, 58, 0.20)` | Subtle dark top edge |
| Border-right | `1px solid rgba(54, 59, 58, 0.20)` | Subtle dark right edge |
| Width | 380px | `width-request: 380` |
| Position | Right side, vertically centered with upward bias | `anchor: top | bottom | left | right`, panel `halign: end`, `valign: start` |
| Padding | 14px | `padding` |

The panel is **not full-height** — it floats in the right half of the screen, sized to its content.

**GTK implementation:** `Astal.Window` with `anchor: top | bottom | left | right`, `layer: overlay`, `keymode: on-demand`. The outer `Gtk.Box` has `halign: end` to push the panel right. Inner panel `Gtk.Box` (`.kb-panel`) with `valign: start`. Click-to-dismiss checks if click is outside panel bounds.

## Banner

| Property | Value |
|----------|-------|
| Text | "KEYBINDS" |
| Font | Open Sans Condensed Bold, 14px, uppercase, letter-spacing 2px |
| Text color | `#171b1a` (dark on cream) |
| Cream layer | `#d2d2d2` |
| Gray backing | `#999a95` |
| Position | Flush to left edge of panel, overflows into border (`margin-left: -17px`) |
| Erosion | SVG `feTurbulence` + `feDisplacementMap` (seed=23) |

### Banner SVG Implementation

**File location:** `configs/astal/data/banners/keybinds.svg`

**SVG filter definition:**

```xml
<filter id="erode" x="-5%" y="-5%" width="110%" height="110%">
  <feTurbulence type="turbulence" baseFrequency="0.04" numOctaves="4" seed="23" result="noise"/>
  <feDisplacementMap in="SourceGraphic" in2="noise" scale="6" xChannelSelector="R" yChannelSelector="G"/>
</filter>
```

**GTK implementation:** Add banner SVG to `disco-shell.gresource.xml` under `banners/`. Load with `Gtk.Picture.new_for_resource()`. Use negative margin to flush left into the border.

## Luminous Dividers

Horizontal separator between sections.

| Property | Value |
|----------|-------|
| Height | 1px |
| Background | `linear-gradient(90deg, transparent 0%, rgba(210,210,210,0.10) 20%, rgba(210,210,210,0.10) 80%, transparent 100%)` |
| Margin | 10px 0 |

**GTK implementation:** `Gtk.Box` with `.sep-h` class, `min-height: 1px`, gradient via `background-image`. Placed between each section.

## Section Labels

| Property | Value |
|----------|-------|
| Font | Open Sans Condensed Bold, 11px, uppercase, letter-spacing 1.5px |
| Color | `#999a95` (muted) |
| Margin | 4px 0 |

**GTK implementation:** `Gtk.Label` with CSS class `.kb-section-title`, `halign: start`.

## Sections

The keybind data is **populated at build time** from the GTK UI template (`keybinds.ui`). The sections are:

| Section | Keybinds |
|---------|----------|
| WORKSPACES | Super+1-6 switch, Super+Shift+1-6 move, Super+` scratchpad, Super tap overview |
| WINDOWS | Super+Shift+HJKL move, Super+Ctrl+HJKL resize, Super+F fullscreen, Super+V float, Super+Q close |
| MONITORS | Super+Alt+H/L window to monitor, Super+Alt+Shift+H/L workspace to monitor |
| SYSTEM | Super+T terminal, Super+/ launcher, Super+Escape lock, Super+S screenshot area, Super+Shift+S screenshot screen, Super+Shift+V clipboard |

## Key Row

Each row shows a key combination and its description.

| Element | Font | Color | Width |
|---------|------|-------|-------|
| Key | JetBrains Mono, 12px | `#d2d2d2` (cream) | min-width: 200px |
| Description | Open Sans, 12px | `#999a95` (muted) | flex, right-aligned |

### Row States

| State | Treatment |
|-------|-----------|
| Default | Transparent background |
| Hover | `background: #282c2b` |

**GTK implementation:** Each row is a `Gtk.Box` (horizontal) with CSS class `.kb-row`. Contains two `Gtk.Label` children — `.kb-key` (left-aligned, min-width 200px) and `.kb-desc` (right-aligned, hexpand). The key label uses `halign: start`, description uses `halign: end`. A spacer `Gtk.Box` with `hexpand: true` sits between them.

## Footer Hint

| Property | Value |
|----------|-------|
| Text | `esc to close` |
| Font | JetBrains Mono, 10px |
| Color | `#363b3a` |
| Alignment | Right |

## Behavior

| Action | Result |
|--------|--------|
| `disco-shell toggle-keybinds` | Toggles keybind panel visibility (IPC) |
| `Escape` | Closes panel |
| Click outside panel | Closes panel |

The keybinds panel is **read-only** — no keyboard navigation or interaction beyond scrolling. It serves as a quick reference overlay.

## Implementation Notes

- The keybind data is defined directly in the GTK UI template (`keybinds.ui`) as static `Gtk.Box` rows
- In the current implementation, keybinds are **hardcoded in the UI template** rather than dynamically parsed from hyprland.conf
- The `KeybindsWindow` Vala class is minimal — just handles Escape-to-close and click-outside-to-close
- Panel is positioned with `halign: end` on the outer container, creating the right-anchored effect within the full-screen overlay window

## Style Guide Deviations

1. **Panel border**: Directional border (3px cream left, 2px cream bottom, 1px dark top+right) — same as quick settings
2. **Banner flush left**: Banner overflows into left border (`margin-left: -17px`) — same as quick settings
3. **Panel surface**: Same glass as status bar (`rgba(10, 12, 11, 0.78)`)
4. **Banner**: SVG eroded banner instead of plain cream rectangle
5. **Static content**: Keybinds are hardcoded in the UI template rather than dynamically parsed from config
