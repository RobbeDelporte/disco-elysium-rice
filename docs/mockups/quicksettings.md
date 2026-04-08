# Quick Settings (disco-shell)

Open `quicksettings.html` in a browser to see the visual mockup.

## Overview

Right-anchored floating panel (not full-height), vertically centered with upward bias. Toggled via settings icon in the status bar or `disco-shell toggle-quicksettings`. Contains connectivity toggles, system controls, brightness slider, and media player.

## Panel

| Property | Value | GTK/SCSS |
|----------|-------|----------|
| Background | `rgba(10, 12, 11, 0.78)` | Same as status bar |
| Blur | 20px backdrop | Hyprland `layerrule blur` |
| Border-left | `3px solid rgba(210, 210, 210, 0.22)` | Prominent cream left edge |
| Border-bottom | `2px solid rgba(210, 210, 210, 0.18)` | Cream bottom edge |
| Border-top | `1px solid rgba(54, 59, 58, 0.20)` | Subtle dark top edge |
| Border-right | `1px solid rgba(54, 59, 58, 0.20)` | Subtle dark right edge |
| Width | 340px | `min-width: 340px` |
| Position | Right side, vertically centered with upward bias (padding-bottom ~8%) | `anchor: right`, centered vertically |
| Padding | 14px | `padding` |

The panel is **not full-height** — it floats in the right half of the screen, sized to its content. This differs from the notification center which is a full-height scrollable list.

**GTK implementation:** `Astal.Window` with `anchor: right`. The window uses a vertical `Gtk.Box` as the panel container with CSS class `.qs-panel`. Vertical centering with upward bias achieved via `valign: center` with margin/padding adjustment.

## Banner

The Disco Elysium eroded-edge banner — cream `#d2d2d2` paint layer over a gray `#999a95` backing, with organic noise erosion on the edges revealing the gray underneath.

| Property | Value |
|----------|-------|
| Text | "QUICK SETTINGS" |
| Font | Open Sans Condensed Bold, 14px, uppercase, letter-spacing 2px |
| Text color | `#171b1a` (dark on cream) |
| Cream layer | `#d2d2d2` |
| Gray backing | `#999a95` |
| Position | Flush to left edge of panel, overflows into the border (`margin-left: -17px`) |
| Erosion | SVG `feTurbulence` + `feDisplacementMap` (seed=15) |

### Banner SVG Implementation

**File location:** `configs/astal/data/banners/quicksettings.svg`

The banner is a **pre-rendered SVG file** loaded as a `Gtk.Picture` resource. GTK4 does not support CSS SVG filters, so the erosion effect is baked into the SVG at design time.

**SVG filter definition** used to generate the banner:

```xml
<filter id="erode" x="-5%" y="-5%" width="110%" height="110%">
  <feTurbulence type="turbulence" baseFrequency="0.04" numOctaves="4" seed="15" result="noise"/>
  <feDisplacementMap in="SourceGraphic" in2="noise" scale="6" xChannelSelector="R" yChannelSelector="G"/>
</filter>
```

**GTK implementation:** Add banner SVG to `disco-shell.gresource.xml` under `banners/`. Load with `Gtk.Picture.new_for_resource()`. Use negative margin to flush left into the border.

## Header-Content Separator

Luminous horizontal divider separating the banner header from the card grid.

| Property | Value |
|----------|-------|
| Height | 1px |
| Background | `linear-gradient(90deg, transparent 0%, rgba(210,210,210,0.10) 20%, rgba(210,210,210,0.10) 80%, transparent 100%)` |
| Margin | 12px 0 |

**GTK implementation:** `Gtk.Box` with `.sep-h` class, `min-height: 1px`, gradient via `background-image`.

## Section Labels

| Property | Value |
|----------|-------|
| Font | Open Sans Condensed Bold, 10px, uppercase, letter-spacing 2px |
| Color | `#4b4b4b` |
| Margin | 0 0 6px 0 |
| Sections | CONNECTIONS, SYSTEM |

**GTK implementation:** `Gtk.Label` with CSS class `.section-label`.

## Card Grid

2x2 grid layout with 6px gap between cards.

| Property | Value | GTK/SCSS |
|----------|-------|----------|
| Layout | 2 columns, auto rows | `Gtk.Grid` with 2 columns |
| Gap | 6px | `row-spacing: 6`, `column-spacing: 6` |
| Margin-bottom | 8px | `margin-bottom` |

**GTK implementation:** `Gtk.Grid` with CSS class `.card-grid`. Each card is a `Gtk.Button` child.

### Card Surface

| Property | Value |
|----------|-------|
| Background | `#1e2221` (opaque) |
| Border | `1px solid rgba(54, 59, 58, 0.40)` |
| Padding | 10px 12px |
| Hover | `background: #282c2b` |

### Active Card

| Property | Value |
|----------|-------|
| Background | `#282c2b` |
| Left border | `3px solid` (color depends on skill) |
| Padding-left | 10px (adjusted for border) |
| Icon color | `#999a95` (brighter than inactive `#4b4b4b`) |
| Title color | `#ccc8c2` (brighter than inactive `#999a95`) |
| Subtitle color | `#999a95` (brighter than inactive `#4b4b4b`) |

### Skill-Colored Left Borders (Active)

| Card | Skill | Border Color |
|------|-------|-------------|
| WiFi | Intellect | `rgba(91, 192, 214, 0.6)` |
| Bluetooth | Psyche | `rgba(117, 85, 198, 0.6)` |
| Audio | Physique | `rgba(203, 69, 106, 0.6)` |
| Power | None | Default cream `#d2d2d2` (if active) |

### Card Inner Layout

```
[icon 16x16] [title (condensed uppercase)]  [chevron or cycle arrows]
             [subtitle (mono, muted)]
```

| Element | Font | Size | Color |
|---------|------|------|-------|
| Icon | SVG | 16x16 | `#4b4b4b` (inactive), `#999a95` (active) |
| Title | Open Sans Condensed Bold | 11px, uppercase, 1px spacing | `#999a95` (inactive), `#ccc8c2` (active) |
| Subtitle | JetBrains Mono | 10px | `#4b4b4b` (inactive), `#999a95` (active) |

### Card Types

**Toggle** — Plain card, click to toggle on/off. No extra controls.

**Drilldown** — Large `›` chevron on the right side. Clicking opens a sub-view.

| Property | Value |
|----------|-------|
| Chevron character | `›` |
| Font | Open Sans Condensed Bold, 22px |
| Color | `#4b4b4b` (default), `#999a95` (hover/active) |

**Cycle** — Large `‹` `›` arrows on the right side. Clicking arrows cycles through options.

| Property | Value |
|----------|-------|
| Arrow characters | `‹` `›` |
| Font | Open Sans Condensed Bold, 20px |
| Color | `#4b4b4b` (default), `#ccc8c2` (hover) |
| Gap | 2px between arrows |

### Cards

| Card | Type | Skill | Subtitle (example) |
|------|------|-------|-------------------|
| WiFi | Drilldown | Intellect | `Home_5G` |
| Bluetooth | Drilldown | Psyche | `WH-1000XM5` |
| Audio | Drilldown | Physique | `Speakers 72%` |
| Power | Cycle | None | `balanced` |

DND is **not** in quick settings — it is handled via the notification center's DnD toggle.

**GTK implementation:** Each card is a `Gtk.Button` containing a horizontal `Gtk.Box` (`.card-inner`) with `Gtk.Image` (icon), vertical `Gtk.Box` (`.card-info` with title + subtitle labels), and either a chevron `Gtk.Label` or a `Gtk.Box` with two arrow `Gtk.Button`s.

## Brightness Slider

| Property | Value |
|----------|-------|
| Container | Same card surface as toggle cards |
| Icon | Sun icon, 14x14, `#4b4b4b` |
| Trough | `#101312` (dark), 4px height |
| Fill | `#999a95` (muted cream) |
| Thumb | 10px round, `#d2d2d2` (cream) |
| Value | JetBrains Mono, 10px, `#999a95`, right-aligned |

**GTK implementation:** `Gtk.Box` (horizontal) with CSS class `.slider-row` containing `Gtk.Image` (icon), `Gtk.Scale` (horizontal, `.brightness-slider`), and `Gtk.Label` (value). The `Gtk.Scale` trough and slider styled via SCSS — `trough { background: #101312; min-height: 4px; }`, `slider { background: #d2d2d2; min-width: 10px; min-height: 10px; border-radius: 5px; }`.

## Media Player

| Property | Value |
|----------|-------|
| Container | Same card surface as toggle cards |
| Layout | Album art left, info + controls stacked right |

### Album Art

| Property | Value |
|----------|-------|
| Size | 42x42 |
| Background | `linear-gradient(135deg, rgba(117,85,198,0.15), rgba(91,192,214,0.10))` — skill-gradient tint |
| Border | `1px solid rgba(54, 59, 58, 0.30)` |
| Placeholder | Disc icon, 18x18, `#4b4b4b` |

### Track Info

| Element | Font | Color |
|---------|------|-------|
| Title | Open Sans Condensed Bold, 12px | `#ccc8c2` |
| Artist | Libre Baskerville, 10px | `#999a95` |

### Controls

| Element | Size | Color |
|---------|------|-------|
| Prev/Next buttons | 22x22, icon 14x14 | `#4b4b4b` |
| Play/Pause button | 22x22, icon 14x14 | `#999a95` (brighter) |

**GTK implementation:** `Gtk.Box` (horizontal) with CSS class `.media-row`. Contains `Gtk.Picture` or `Gtk.Image` for album art (42x42), and a vertical `Gtk.Box` with track info labels and a horizontal `Gtk.Box` for prev/play/next `Gtk.Button`s. Album art sourced from MPRIS metadata via `AstalMpris`.

## Sub-Views (Drilldown)

WiFi, Bluetooth, and Audio cards open sub-views when clicked. The panel uses a `Gtk.Stack` to switch between the main view and sub-views.

### Sub-View Behavior

| Action | Result |
|--------|--------|
| Click drilldown card | Stack transitions to sub-view |
| Back arrow | Stack transitions back to main view |
| Escape | If in sub-view, goes back to main view. If on main view, closes panel. |

### Sub-View Header

When a sub-view is active:
- Banner text changes to match the sub-view (e.g., "WIFI", "BLUETOOTH", "AUDIO")
- A back arrow appears to the left of the banner
- The eroded banner SVG swaps (each sub-view gets its own SVG file or the banner text is rendered dynamically)

### Sub-View Content

Scrollable list of available items (networks, devices, sinks/sources). Each item is a row similar to card layout.

| Property | Value |
|----------|-------|
| Connected item | Cream left border `3px solid #d2d2d2` |
| Item background | Same `#1e2221` card surface |
| Item padding | 8px 12px |
| Item gap | 4px |

**GTK implementation:** `Gtk.Stack` with `transition-type: slide-left-right`. Main view and each sub-view are stack children. Sub-view contains a `Gtk.ScrolledWindow` with a vertical `Gtk.Box` listing items as `Gtk.Button` rows.

## Behavior

| Action | Result |
|--------|--------|
| Settings icon in bar | Toggles quick settings panel |
| `disco-shell toggle-quicksettings` | Toggles quick settings panel (IPC) |
| `Escape` | Closes panel (or goes back from sub-view first) |
| Click outside panel | Closes panel |
| Click toggle card | Toggles service on/off |
| Click drilldown card | Opens sub-view |
| Click cycle arrows | Cycles through options (e.g., power profiles) |
| Brightness slider | Adjusts screen brightness via `AstalBacklight` or `brightnessctl` |
| Media controls | Prev/play-pause/next via `AstalMpris` |

## Style Guide Deviations

1. **Panel border**: Directional border (3px cream left, 2px cream bottom, 1px dark top+right) instead of uniform border — emphasizes the left edge as an anchor point
2. **Banner flush left**: Banner overflows into the left border (`margin-left: -17px`) — creates a sense of the label being part of the panel edge rather than floating inside it
3. **Cards opaque**: Cards use opaque `#1e2221` instead of translucent glass — provides clear visual separation between cards and the glass panel background
4. **Skill-colored borders**: Active cards get skill-colored left borders (intellect blue, psyche purple, physique red) instead of uniform cream — ties each system function to a Disco Elysium skill attribute
5. **No DND toggle**: DND removed from quick settings — handled exclusively via notification center to avoid duplication
6. **Panel not full-height**: Floats vertically centered instead of anchored top-to-bottom — matches the "floating panel" feel, only notification center is full-height (because it has a scrollable list)
7. **Panel surface**: Same glass as status bar (`rgba(10, 12, 11, 0.78)`) instead of opaque `rgba(23, 27, 26, 1.0)` from style guide
8. **Banner**: SVG eroded banner instead of plain cream rectangle
