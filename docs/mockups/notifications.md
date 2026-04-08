# Notifications (disco-shell)

Open `notifications.html` in a browser to see the visual mockup. Shows both popup cards and the notification center side panel in context with the status bar.

## Overview

Three components sharing a common notification card:
1. **Popup cards** — top-right corner, auto-dismiss after 3s
2. **Notification center** — right side panel, toggled via bell icon
3. **Notification card** — shared component used by both

## Notification Card

Compact card with a single-line header combining app name and summary.

### Card Surface

| Property | Value | GTK/SCSS |
|----------|-------|----------|
| Background | `rgba(16, 19, 18, 0.92)` | `background-color` on `.notification-card` |
| Border | `1px solid rgba(54, 59, 58, 0.30)` | `border` |
| Padding | 10px 12px | `padding` |
| Margin | 0 0 6px 0 | `margin-bottom` |

### Header (single line)

All elements on one line: `APP NAME — Summary (count) timestamp [x]`

| Element | Font | Size | Color |
|---------|------|------|-------|
| App name | Open Sans Condensed Bold | 11px, uppercase, 2px spacing | `#999a95` (muted, not orange) |
| Separator | — (em dash) | 10px | `#4b4b4b` |
| Summary | Open Sans Condensed Bold | 13px | `#ccc8c2` |
| Count | Open Sans Condensed Bold | 10px | `#999a95` |
| Timestamp | Open Sans Condensed Bold | 10px, uppercase, 1px spacing | `#4b4b4b` |
| Close button | x character | 13px | `#4b4b4b`, hover: `#b83a3a` |

**GTK implementation:** `Gtk.Box` (horizontal) with all labels inline. Summary label has `hexpand: true` and `ellipsize: end` to fill available space. Close button only shown in notification center, not in popups.

### Body

| Property | Value |
|----------|-------|
| Font | Libre Baskerville, 11px |
| Color | `#999a95` |
| Line height | 1.7 |

### Action Buttons

| Property | Value |
|----------|-------|
| Font | Open Sans Condensed Bold, 10px, uppercase, 2px spacing |
| Background | `rgba(30, 34, 33, 0.8)` |
| Border | `1px solid rgba(54, 59, 58, 0.4)` |
| Color | `#999a95`, hover: `#ccc8c2` |
| Padding | 4px 10px |

### Critical Notifications

| Property | Value |
|----------|-------|
| Left border | `3px solid #b83a3a` |
| App name color | `#b83a3a` |
| Summary color | `#b83a3a` |
| Body | Stays muted `#999a95` |

## Popup Cards

| Property | Value |
|----------|-------|
| Position | Top-right corner, below status bar |
| Width | 340px |
| Max visible | 3 cards |
| Auto-dismiss | 3 seconds |
| Dismiss | Click anywhere on card |
| Close button | Not shown on popups |
| Stacking | Newest on top |

**GTK implementation:** `Astal.Window` with `anchor: top | right`, `exclusivity: normal`. Contains a vertical `Gtk.Box` with popup cards. Each card wrapped in a `Gtk.Button` for click-to-dismiss.

## Notification Center

Black glass side panel — same surface treatment as the status bar.

### Panel

| Property | Value | GTK/SCSS |
|----------|-------|----------|
| Background | `rgba(10, 12, 11, 0.78)` | Same as status bar |
| Blur | 20px backdrop | Hyprland `layerrule blur` |
| Border-left | `3px solid rgba(210, 210, 210, 0.22)` | Prominent cream left edge |
| Border-bottom | `2px solid rgba(210, 210, 210, 0.18)` | Cream bottom edge |
| Border-top | `1px solid rgba(54, 59, 58, 0.20)` | Subtle dark top edge |
| Border-right | `1px solid rgba(54, 59, 58, 0.20)` | Subtle dark right edge |
| Width | 360px | `min-width: 360px` |
| Position | Right side, full height below status bar | `anchor: top | right | bottom` |
| Padding | 14px | `padding` |

**GTK implementation:** `Astal.Window` with `anchor: top | right | bottom`. Toggle visibility from bell icon in the status bar via `disco-shell toggle-notifications`.

### Header

Eroded "NOTIFICATIONS" banner (SVG, seed=7) + DnD toggle + CLEAR ALL button.

**Banner file:** `configs/astal/data/banners/notifications.svg`

| Element | Details |
|---------|---------|
| Banner | Pre-rendered SVG, same eroded style as launcher |
| DnD toggle | Bell icon, 14px, muted. Active state: `#eb6408` |
| Clear All | Open Sans Condensed Bold, 10px, uppercase, muted button |

### Header-List Separator

Horizontal luminous divider between header and card list.

| Property | Value |
|----------|-------|
| Height | 1px |
| Background | `linear-gradient(90deg, transparent 0%, rgba(210,210,210,0.10) 20%, rgba(210,210,210,0.10) 80%, transparent 100%)` |
| Margin | 12px 0 |

**GTK implementation:** `Gtk.Box` with `.sep-h` class, `min-height: 1px`, gradient via `background-image`.

### Card List

Scrollable list of notification cards. Cards grouped by `app_name + summary` — latest shown, count displayed in header.

### Empty State

| Property | Value |
|----------|-------|
| Text | Libre Baskerville, 13px, `#4b4b4b` |
| Padding | 40px 0, centered |

## Behavior

| Action | Result |
|--------|--------|
| Bell icon in bar | Toggles notification center visibility |
| `Escape` | Closes notification center |
| DnD toggle | Suppresses popup notifications |
| CLEAR ALL | Dismisses all notifications |
| Close (x) on card | Dismisses that notification |
| Click on popup | Dismisses that popup |
| Notification arrives | Popup appears (if not DnD), bell dot shows in bar |
| Popup timeout | 3 seconds auto-dismiss |

## Style Guide Deviations

1. **App name color**: Muted `#999a95` instead of orange `#eb6408` — reduces orange overuse, orange reserved for DnD active state and bar notification dot only
2. **Card header**: Single-line layout (app + summary inline) instead of stacked
3. **NC panel surface**: Same glass as status bar (`rgba(10, 12, 11, 0.78)`) instead of opaque `rgba(23, 27, 26, 1.0)`
4. **NC border**: Directional border (3px cream left, 2px cream bottom, 1px dark top+right) instead of uniform border — emphasizes the left edge as an anchor point, consistent with quick settings panel
5. **Popup timeout**: 3s instead of 5s
6. **Banner**: SVG eroded banner instead of plain cream rectangle
