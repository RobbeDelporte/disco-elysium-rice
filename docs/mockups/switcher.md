# Window Switcher (disco-shell)

Open `switcher.html` in a browser to see the visual mockup.

## Overview

Centered overlay panel for switching between open windows. Structurally very similar to the app launcher but shows open Hyprland windows instead of desktop applications. Each window entry includes an app icon, class name, window title, and a workspace badge. Supports fuzzy filtering by class or title.

Opens with `disco-shell toggle-switcher`, closes with `Escape`.

## Overlay Backdrop

| Property | Value | Implementation |
|----------|-------|----------------|
| Background | `rgba(10, 12, 11, 0.55)` | Astal.Window background with full-screen anchor |
| Click-to-dismiss | Clicking the backdrop closes the switcher | Event handler on the overlay window |

The switcher window uses `Astal.Window` with `anchor: top | bottom | left | right`, `keymode: on-demand`, and `exclusivity: normal`.

## Banner

The Disco Elysium eroded-edge banner — cream `#d2d2d2` paint layer over a gray `#999a95` backing, with organic noise erosion on the edges.

| Property | Value |
|----------|-------|
| Text | "WINDOWS" |
| Font | Open Sans Condensed Bold, 16px, uppercase, letter-spacing 2px |
| Text color | `#171b1a` (dark on cream) |
| Cream layer | `#d2d2d2` |
| Gray backing | `#999a95` |
| Position | Flush with panel top-left corner |
| Erosion | SVG `feTurbulence` + `feDisplacementMap` (seed=27) |

### Banner SVG Implementation

**File location:** `configs/astal/data/banners/windows.svg`

**SVG filter definition:**

```xml
<filter id="erode" x="-5%" y="-5%" width="110%" height="110%">
  <feTurbulence type="turbulence" baseFrequency="0.04" numOctaves="4" seed="27" result="noise"/>
  <feDisplacementMap in="SourceGraphic" in2="noise" scale="6" xChannelSelector="R" yChannelSelector="G"/>
</filter>
```

**GTK implementation:** Add banner SVG to `disco-shell.gresource.xml` under `banners/`. Load with `Gtk.Picture.new_for_resource()`.

## Panel

| Property | Value | GTK/SCSS |
|----------|-------|----------|
| Background | `rgba(10, 12, 11, 0.90)` | `background-color` on panel container |
| Blur | 20px backdrop | Hyprland `layerrule blur` on the switcher layer surface |
| Border | `1px solid rgba(54, 59, 58, 0.25)` | `border` |
| Width | 500px | Same as launcher |
| Padding | 12px 10px 10px | `padding` |

**GTK implementation:** Uses the same `.launcher-container` / `.app-*` CSS classes as the launcher, with additional `.switcher-window` and `.ws-badge` classes for switcher-specific elements.

## Search Entry

| Property | Value |
|----------|-------|
| Background | `rgba(16, 19, 18, 0.60)` |
| Border | `1px solid rgba(54, 59, 58, 0.30)` |
| Focus border | `rgba(210, 210, 210, 0.25)` |
| Font | Open Sans Condensed, 16px, weight 400 |
| Color | `#ccc8c2` |
| Caret | `#d2d2d2` |
| Placeholder | Libre Baskerville, 13px, italic, color `#4b4b4b` |
| Margin | 0 0 8px 0 |

When empty, all open windows are shown. When text is entered, windows are filtered by class name and title (case-insensitive contains).

**GTK implementation:** `Gtk.Entry` with CSS class `.launcher-entry` (reuses launcher entry styling). Placeholder text: "Filter windows..."

## Window Items

Each result row contains an app icon, text info (class + title), and a workspace badge.

### Layout

```
[3px cream border] [  icon  ] [  class (condensed uppercase) ]  [ ws badge ]
                               [  title (serif, muted)        ]
```

**GTK implementation:** `Gtk.Button` (`.app-item`) containing `Gtk.Box` (horizontal) with:
- `Gtk.Image` (32x32, icon from app's `class` name, lowercased)
- `Gtk.Box` (vertical, `.app-info`) containing `Gtk.Label` (class, `.app-name`) + `Gtk.Label` (title, `.app-desc`)
- `Gtk.Label` (workspace badge, `.ws-badge`)

### App Icon

| Property | Value |
|----------|-------|
| Size | 32x32px |
| Source | `client.class.down()` icon name from theme |
| Fallback | `application-x-executable` |

### Window Class

| Property | Value |
|----------|-------|
| Font | Open Sans Condensed Bold, 14px, uppercase, letter-spacing 1px |
| Color | `#ccc8c2` |

### Window Title

| Property | Value |
|----------|-------|
| Font | Libre Baskerville, 11px |
| Color | `#999a95` |
| Max width | 60 chars, ellipsize: end |

### Workspace Badge

Small cream pill showing the workspace number where the window lives.

| Property | Value |
|----------|-------|
| Font | Open Sans Condensed Bold, 11px |
| Color | `#171b1a` (dark text on cream) |
| Background | `#d2d2d2` (cream) |
| Padding | 2px 8px |
| Border-radius | 1px |
| Min-height | 20px |
| Position | Right end of the row, `valign: center` |

When the window item is selected (cream left border), the badge inverts: `background: #171b1a`, `color: #d2d2d2`.

**GTK implementation:** `Gtk.Label` with CSS class `.ws-badge`. Badge inversion handled by `.app-item.selected .ws-badge` CSS rule.

### States

| State | Treatment |
|-------|-----------|
| Default | Transparent background, `border-left: 3px solid transparent` |
| Hover | `background: rgba(40, 44, 43, 0.5)` |
| Selected | `border-left: 3px solid #d2d2d2`, `background: rgba(40, 44, 43, 0.4)` |

**GTK implementation:** `.app-item` base class with `.selected` toggled dynamically. Padding-left adjusts from 12px to 9px on selected to compensate for the visible border.

## Scroll Container

| Property | Value |
|----------|-------|
| Min-height | 320px |
| Max-height | 460px |
| Scrollbar | Overlay style, thin |

**GTK implementation:** Results are contained in a `Gtk.ScrolledWindow` (`.switcher-scroll`) wrapping the vertical `Gtk.Box` result list.

## Footer Hint

| Property | Value |
|----------|-------|
| Text | `type to filter · enter to focus · esc to close` |
| Font | JetBrains Mono, 10px |
| Color | `#363b3a` |
| Padding | 8px 12px 0 |

**GTK implementation:** `Gtk.Label` with CSS class `.launcher-hint` (reuses launcher hint styling).

## Behavior

| Action | Result |
|--------|--------|
| `disco-shell toggle-switcher` | Opens switcher, focuses search entry, shows all windows |
| `Escape` | If search has text: clears search. If empty: closes switcher |
| Typing | Filters windows by class name and title (case-insensitive contains) |
| `Up/Down` arrows / `Tab` | Moves selection through results |
| `Enter` | Focuses selected window (switches workspace if needed), closes switcher |
| Click on result | Focuses that window, closes switcher |

## Implementation Notes

- The `SwitcherWindow` uses `AstalHyprland.Hyprland` to query all clients
- Results are rebuilt on each `search_entry.changed` signal via `rebuild_list()`
- Window focusing uses `hypr.dispatch("focuswindow", "address:<addr>")` — Hyprland handles workspace switching automatically
- Clients with empty/null titles are filtered out (hidden/unmapped windows)
- The switcher reuses most launcher CSS classes (`.app-item`, `.app-name`, `.app-desc`, `.app-icon`) plus switcher-specific `.ws-badge` and `.switcher-scroll`

## Style Guide Deviations

1. **Banner**: SVG noise erosion with gray backing — same approach as launcher
2. **Selection**: Cream left border — same as launcher (secondary selection style)
3. **Panel opacity**: 90% black glass — same as launcher
4. **Badge inversion**: Selected item inverts the workspace badge colors — mirrors the overview search behavior
5. **Shared CSS**: Reuses launcher CSS classes rather than defining separate switcher-specific classes — reduces duplication since the visual treatment is identical
