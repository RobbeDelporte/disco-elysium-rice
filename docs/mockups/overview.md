# Workspace Overview (disco-shell)

Open `overview.html` in a browser to see the visual mockup.

## Overview

Centered overlay panel on a dimmed wallpaper backdrop. Shows a 3x2 workspace grid with open windows listed in each tile. Typing in the search entry switches to window-search mode with filterable results. Keyboard navigation with HJKL/arrows and number keys for direct workspace switching.

Opens with `Super` (tap), closes with `Escape`. Direct workspace switch with number keys `1-6`.

## Overlay Backdrop

| Property | Value | Implementation |
|----------|-------|----------------|
| Background | `rgba(10, 12, 11, 0.55)` | Astal.Window background with full-screen anchor |
| Click-to-dismiss | Clicking the backdrop closes the overview | Event handler on the overlay window |

The overview window uses `Astal.Window` with `anchor: top | bottom | left | right`, `keymode: on-demand`, and `layer: overlay`.

## Banner

The Disco Elysium eroded-edge banner — cream `#d2d2d2` paint layer over a gray `#999a95` backing, with organic noise erosion on the edges revealing the gray underneath.

| Property | Value |
|----------|-------|
| Text | "OVERVIEW" |
| Font | Open Sans Condensed Bold, 16px, uppercase, letter-spacing 2px |
| Text color | `#171b1a` (dark on cream) |
| Cream layer | `#d2d2d2` |
| Gray backing | `#999a95` |
| Position | Flush with panel top-left corner |
| Erosion | SVG `feTurbulence` + `feDisplacementMap` (seed=19) |

### Banner SVG Implementation

**File location:** `configs/astal/data/banners/overview.svg`

The banner is a **pre-rendered SVG file** loaded as a `Gtk.Picture` resource.

**SVG filter definition:**

```xml
<filter id="erode" x="-5%" y="-5%" width="110%" height="110%">
  <feTurbulence type="turbulence" baseFrequency="0.04" numOctaves="4" seed="19" result="noise"/>
  <feDisplacementMap in="SourceGraphic" in2="noise" scale="6" xChannelSelector="R" yChannelSelector="G"/>
</filter>
```

**GTK implementation:** Add banner SVG to `disco-shell.gresource.xml` under `banners/`. Load with `Gtk.Picture.new_for_resource()`.

## Panel

| Property | Value | GTK/SCSS |
|----------|-------|----------|
| Background | `rgba(10, 12, 11, 0.90)` | `background-color` on `.overview-container` |
| Blur | 20px backdrop | Hyprland `layerrule blur` on the overview layer surface |
| Border-left | `3px solid rgba(210, 210, 210, 0.22)` | Prominent cream left edge |
| Border-bottom | `2px solid rgba(210, 210, 210, 0.18)` | Cream bottom edge |
| Border-top | `1px solid rgba(54, 59, 58, 0.20)` | Subtle dark top edge |
| Border-right | `1px solid rgba(54, 59, 58, 0.20)` | Subtle dark right edge |
| Width | 680px | Sized to fit 3-column grid comfortably |
| Padding | 14px | `padding` |

**GTK implementation:** `Gtk.Box` (vertical) with CSS class `.overview-container`.

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
| Margin | 0 0 12px 0 |

When empty, the workspace grid is shown. When text is entered, the grid hides and search results appear.

**GTK implementation:** `Gtk.Entry` with CSS class `.overview-search-entry`. Placeholder text: "Type to search windows..."

## Workspace Grid (Default Mode)

3x2 grid showing workspaces 1-6.

| Property | Value | GTK/SCSS |
|----------|-------|----------|
| Layout | 3 columns, 2 rows | `Gtk.Grid` with `COLS=3`, `ROWS=2` |
| Gap | 8px | `row-spacing: 8`, `column-spacing: 8` |

**GTK implementation:** `Gtk.Grid` with CSS class attached to workspace grid.

### Workspace Tile

Each tile is a clickable container showing the workspace number and its open windows.

| Property | Value |
|----------|-------|
| Background | `#1e2221` (opaque) |
| Border | `1px solid rgba(54, 59, 58, 0.40)` |
| Padding | 14px |
| Min-height | 180px |
| Hover | `background: #282c2b` |

### Tile States

| State | Treatment |
|-------|-----------|
| Default | Standard tile appearance |
| Hover | `background: #282c2b` |
| Selected (keyboard nav) | `background: #282c2b` + `border: 1px solid rgba(210, 210, 210, 0.18)` (lighter bg + thin cream border) |
| Empty (no clients) | `opacity: 0.45`, hover: `opacity: 0.7` |

No separate "active" indicator — the currently focused workspace is not visually distinguished in the overview. The overview is for navigation, not status.

**GTK implementation:** `Gtk.Box` (vertical) with CSS class `.overview-tile`. Classes `.selected`, `.empty` toggled dynamically. Tile is wrapped in a `Gtk.GestureClick` handler for click-to-switch.

### Workspace Number (Watermark)

The workspace number is displayed as a large faded watermark behind the client list — like a case file number stamped in the background.

| Property | Value |
|----------|-------|
| Font | Open Sans Condensed Bold, 80px |
| Color | `rgba(54, 59, 58, 0.25)` |
| Position | Absolute, bottom-right of tile (`right: -5px`, `bottom: -15px`) |
| Pointer events | None (does not intercept clicks) |

**GTK implementation:** `Gtk.Label` with CSS class `.overview-ws-num-watermark`, positioned absolutely within the tile via CSS. The tile needs `overflow: hidden` to clip the oversized number.

### Client List (within tile)

Each open window in the workspace is shown as a compact row.

| Element | Font | Color |
|---------|------|-------|
| App icon | 16x16, from icon theme | `#999a95` |
| Class name | Open Sans Condensed 600, 12px, uppercase | `#ccc8c2` |
| Window title | Libre Baskerville, 11px | `#999a95` |

Client rows have subtle hover: `background: rgba(40, 44, 43, 0.5)`.

**GTK implementation:** Vertical `Gtk.Box` (`.overview-clients`) containing `Gtk.Box` rows (`.overview-client-btn`) with `Gtk.Image` (icon), `Gtk.Label` (class), `Gtk.Label` (title, ellipsized at 30 chars).

## Search Results Mode

When text is entered in the search entry, the workspace grid hides and a scrollable list of matching windows appears. Matches are filtered by window title and class name (case-insensitive contains).

### Search Item

```
[icon 28x28] [class (condensed uppercase)]  [workspace badge]
             [title (serif, muted)]
```

| Element | Font | Color |
|---------|------|-------|
| Icon | 28x28, app icon from theme | `#999a95` |
| Class name | Open Sans Condensed Bold, 13px, uppercase, 0.5px spacing | `#ccc8c2` |
| Window title | Libre Baskerville, 11px, ellipsized at 60 chars | `#999a95` |

### Search Item States

| State | Treatment |
|-------|-----------|
| Default | `background: #1e2221`, `border-left: 3px solid transparent` |
| Hover | `background: rgba(40, 44, 43, 0.5)` |
| Selected | `background: #d2d2d2`, text inverts to dark — cream inversion selection |

**GTK implementation:** `Gtk.Button` with CSS class `.overview-search-item`. Selected item gets `.selected` class. Contained in a `Gtk.ScrolledWindow` (`.overview-search-scroll`, max-height 460px) with a vertical `Gtk.Box` (`.overview-search-results`).

### Workspace Badge

Small cream pill showing the workspace number of the window.

| Property | Value |
|----------|-------|
| Font | Open Sans Condensed Bold, 11px |
| Color | `#171b1a` (dark text on cream) |
| Background | `#d2d2d2` (cream) |
| Padding | 2px 8px |
| Border-radius | 1px |

When the search item is selected (cream inversion), the badge inverts: `background: #171b1a`, `color: #d2d2d2`.

**GTK implementation:** `Gtk.Label` with CSS class `.overview-ws-badge`, `valign: center`.

## Footer Hint

| Property | Value |
|----------|-------|
| Text | `type to search · enter to switch · esc to close` |
| Font | JetBrains Mono, 10px |
| Color | `#363b3a` |
| Padding | 8px 12px 0 |

**GTK implementation:** `Gtk.Label` with CSS class `.overview-hint`.

## Behavior

| Action | Result |
|--------|--------|
| `Super` (tap) | Opens overview, focuses search entry |
| `Escape` | In search mode: clears search. In grid mode: closes overview |
| Typing | Switches to search mode, filters windows by class/title |
| `HJKL` / arrows | Moves selection through workspace grid (grid mode) |
| `Up/Down` / `Tab` | Moves selection through search results (search mode) |
| `Enter` | Switches to selected workspace (grid) or focuses selected window (search) |
| `1-6` number keys | Direct workspace switch (grid mode only) |
| Click on tile | Switches to that workspace, closes overview |
| Click on search result | Focuses that window, closes overview |

## Implementation Notes

- The `OverviewWindow` uses `AstalHyprland` to query workspace and client data
- Grid is rebuilt each time the window becomes visible via `notify["visible"]` signal
- Search mode toggled by `search_entry.changed` signal — empty text shows grid, non-empty shows search results
- Selection tracking: `selected_col`/`selected_row` for grid mode, `search_selected_idx` for search mode
- Client focusing uses `hypr.dispatch("focuswindow", "address:<addr>")` via Hyprland IPC
- Workspace switching uses `hypr.dispatch("workspace", "<id>")`

## Style Guide Deviations

1. **Banner**: SVG noise erosion with gray backing — same approach as launcher
2. **Selection (grid)**: Orange border for keyboard selection, cream border for active workspace — distinguishes "where you are" from "where you're looking"
3. **Selection (search)**: Cream background inversion — matches launcher primary selection pattern
4. **Panel opacity**: 90% black glass — same as launcher, darker for readability
5. **Tile opacity**: Empty tiles at 45% — visually de-emphasizes unused workspaces
