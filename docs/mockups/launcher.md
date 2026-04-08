# App Launcher (disco-shell)

Open `launcher.html` in a browser to see the visual mockup.

## Overview

Centered overlay panel on a dimmed wallpaper backdrop. Eroded cream banner title, black glass panel, fuzzy search, and cream left-border selection.

Opens with `Super+/`, closes with `Escape`. Fuzzy search via `AstalApps`. Max 8 results. Keyboard navigation: arrow keys + Enter.

## Overlay Backdrop

| Property | Value | Implementation |
|----------|-------|----------------|
| Background | `rgba(10, 12, 11, 0.55)` | Astal.Window background with full-screen anchor |
| Click-to-dismiss | Clicking the backdrop closes the launcher | Event handler on the overlay window |

The launcher window uses `Astal.Window` with `anchor: top | bottom | left | right`, `keymode: on-demand`, and `exclusivity: normal` (non-exclusive, overlays desktop).

## Banner

The Disco Elysium eroded-edge banner — cream `#d2d2d2` paint layer over a gray `#999a95` backing, with organic noise erosion on the edges revealing the gray underneath.

| Property | Value |
|----------|-------|
| Text | "APPLICATIONS" |
| Font | Open Sans Condensed Bold, 16px, uppercase, letter-spacing 2px |
| Text color | `#171b1a` (dark on cream) |
| Cream layer | `#d2d2d2` |
| Gray backing | `#999a95` |
| Position | Flush with panel top-left corner |
| Erosion | SVG `feTurbulence` + `feDisplacementMap` (see below) |

### Banner SVG Implementation

**File location:** `configs/astal/data/banners/applications.svg`

The banner is a **pre-rendered SVG file** loaded as a `Gtk.Picture` resource. GTK4 does not support CSS SVG filters, so the erosion effect is baked into the SVG at design time.

Each widget that uses a banner gets its own SVG file with different text and a different turbulence `seed` value for natural variety:

```
configs/astal/data/banners/
  applications.svg    (seed=3)
  notifications.svg   (seed=7)
  power.svg           (seed=11)
  quicksettings.svg   (seed=15)
  ...
```

**SVG filter definition** used to generate the banners:

```xml
<filter id="erode" x="-5%" y="-5%" width="110%" height="110%">
  <feTurbulence type="turbulence" baseFrequency="0.04" numOctaves="4" seed="3" result="noise"/>
  <feDisplacementMap in="SourceGraphic" in2="noise" scale="6" xChannelSelector="R" yChannelSelector="G"/>
</filter>
```

The SVG structure is: a gray `#999a95` rectangle (full size), overlaid with a cream `#d2d2d2` rectangle that has the erosion filter applied, and the text drawn on top. **These files are intended to be manually edited** — adjust the `seed`, `scale`, `baseFrequency`, or hand-tweak paths as needed.

**GTK implementation:** Add banner SVGs to `disco-shell.gresource.xml` under `banners/`. Load with `Gtk.Picture.new_for_resource()`.

## Panel

| Property | Value | GTK/SCSS |
|----------|-------|----------|
| Background | `rgba(10, 12, 11, 0.90)` | `background-color` on `.launcher-container` |
| Blur | 20px backdrop | Hyprland `layerrule blur` on the launcher layer surface |
| Border | `1px solid rgba(54, 59, 58, 0.25)` | `border` |
| Width | 500px | `min-width: 500px` |
| Padding | 12px 10px 10px | `padding` |

**Note:** The panel is more opaque (90%) than the status bar (78%) for better text readability when scanning search results. Blur is still handled by Hyprland layer rules, not GTK4 CSS.

**GTK implementation:** `Gtk.Box` (vertical) with CSS class `.launcher-container`.

## Search Entry

| Property | Value |
|----------|-------|
| Background | `rgba(16, 19, 18, 0.60)` |
| Border | `1px solid rgba(54, 59, 58, 0.30)` |
| Focus border | `rgba(210, 210, 210, 0.25)` — subtle cream highlight |
| Font | Open Sans Condensed, 16px, weight 400 |
| Color | `#ccc8c2` |
| Caret | `#d2d2d2` |
| Placeholder | Libre Baskerville, 13px, italic, color `#4b4b4b` |
| Margin | 0 0 8px 0 |

**GTK implementation:** `Gtk.Entry` with CSS class `.launcher-entry`. Placeholder text set via `placeholder-text` property.

## Result Items

Each result row contains an app icon and text info (name + description).

### Layout

```
[3px cream border] [  icon  ] [  name (condensed uppercase)  ]
                              [  description (serif, muted)   ]
```

**GTK implementation:** `Gtk.Button` containing `Gtk.Box` (horizontal) with:
- `Gtk.Image` (32x32, icon from Gruvbox Plus Dark theme)
- `Gtk.Box` (vertical) containing `Gtk.Label` (name) + `Gtk.Label` (description)

### App Icon

| Property | Value |
|----------|-------|
| Size | 32x32px |
| Source | App's `icon_name` from Gruvbox Plus Dark theme |
| Fallback | `application-x-executable` |
| Color (symbolic) | `#999a95` |

### App Name

| Property | Value |
|----------|-------|
| Font | Open Sans Condensed Bold, 14px, uppercase, letter-spacing 1px |
| Color | `#ccc8c2` |

### App Description

| Property | Value |
|----------|-------|
| Font | Libre Baskerville, 11px |
| Color | `#999a95` |
| Max width | 80 chars, ellipsize: end |

### States

| State | Treatment |
|-------|-----------|
| Default | Transparent background, `border-left: 3px solid transparent` |
| Hover | `background: rgba(40, 44, 43, 0.5)` |
| Selected | `border-left: 3px solid #d2d2d2`, `background: rgba(40, 44, 43, 0.4)` |

**GTK implementation:** `.app-item` base class with `.selected` added to the active item. The `border-left` with transparent default ensures items don't shift when selected. Padding-left adjusts from 12px to 9px on selected to compensate for the visible border.

## Footer Hint

| Property | Value |
|----------|-------|
| Text | `esc to close · enter to launch` |
| Font | JetBrains Mono, 10px |
| Color | `#363b3a` |
| Padding | 8px 12px 0 |

**GTK implementation:** `Gtk.Label` with CSS class `.launcher-hint`.

## Behavior

| Action | Result |
|--------|--------|
| `Super+/` | Opens launcher, focuses search entry |
| `Escape` | Closes launcher |
| Typing | Fuzzy-filters app list via `AstalApps.Apps.fuzzy_query()` |
| `Up/Down` arrows | Moves selection through results |
| `Enter` | Launches selected app, closes launcher |
| Click on result | Launches that app, closes launcher |
| Click on backdrop | Closes launcher |
| Empty search | Shows all apps (first 8) |

## Style Guide Deviations

1. **Banner**: SVG noise erosion with gray backing — replaces the CSS-only eroded-edge approach from the style guide. Banner is flush (no overhang) unlike the style guide's overhang recommendation.
2. **Selection**: Cream left border — replaces the cream background inversion (primary selection) from the style guide. The banner is the only full cream element.
3. **Panel opacity**: 90% black glass — diverges from the style guide's 88% `rgba(23, 27, 26, 0.88)` panel background. Darker base color (`rgba(10, 12, 11)`) and higher opacity for readability.
4. **Search focus**: Cream border highlight — replaces intellect blue (`#5bc0d6`) focus from the style guide.
5. **Icon theme**: Gruvbox Plus Dark — replaces Papirus-Dark (consistent with status bar deviation).
