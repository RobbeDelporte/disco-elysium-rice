# Power Menu

## Layout

Centered overlay panel on dimmed wallpaper, 280px wide. Eroded-edge "SESSION" banner overhanging top-left.

## Options

| Action | Icon | Notes |
|--------|------|-------|
| Lock | Lock icon | Triggers hyprlock |
| Suspend | Sleep icon | systemctl suspend |
| Logout | Log-out icon | hyprctl dispatch exit |
| — | divider | — |
| Reboot | Refresh icon | Muted text until hovered (destructive) |
| Shutdown | Power icon | Muted text until hovered (destructive) |

## Selection

Primary selection (cream `#d2d2d2` bg, dark `#171b1a` text). The selection banner is narrower than the full row height — reduced vertical padding (5px vs 8px) with extra margin, so it floats as a tight highlight.

## Typography

- Options: Open Sans Condensed Bold 15px, uppercase, 1px letter-spacing
- Hint: JetBrains Mono 10px, `#363b3a`

## Icons

Lineart, 16px, 1.5px stroke, no fill. Inherit text color (invert on selection).

## Behavior

- Opens with `Super+Shift+E` or power icon in bar
- Keyboard navigation: arrow keys + Enter
- Escape to cancel
- Implemented as disco-shell widget

## Destructive Actions

Reboot and Shutdown are separated by a divider and displayed in muted text (`#999a95`). They brighten to primary text on hover. No confirmation dialog — the menu itself is the confirmation step.
