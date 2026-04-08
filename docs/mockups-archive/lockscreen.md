# Lock Screen (Hyprlock)

## Layout

Centered content on a dimmed wallpaper (brightness 0.5). Vertical stack: time, date, password input, greeting.

## Time

- Open Sans Condensed, weight 500 (medium), 96px
- Color: cream `#d2d2d2` (not pure white — softer against dark wallpaper)
- Letter-spacing: 8px

## Date

- Open Sans Condensed Light (300), 16px, uppercase, 3px letter-spacing
- Color: muted `#999a95`

## Password Input

- 280x48px, dark semi-transparent background `rgba(23, 27, 26, 0.7)`
- Border: `1px solid #363b3a` (neutral, no focus color change)
- Password dots: 8px circles in cream `#d2d2d2`
- Placeholder: Libre Baskerville italic, disabled gray `#4b4b4b`

### Input States

| State | Border | Dots |
|-------|--------|------|
| Default / Typing | `#363b3a` (no change) | `#d2d2d2` |
| Verifying | `#0fb666` (success green) | `#0fb666` |
| Failed | `#b83a3a` (error red) | `#b83a3a` |

- No teal focus effect — border stays neutral while typing
- Caps lock: motorics yellow warning text (`#e3ba3e`) below input
- Wrong password: error red text (`#b83a3a`) below input

## Greeting

- "Good evening, robbe" — Open Sans Condensed Bold, 14px, uppercase, 2px letter-spacing
- Color: muted `#999a95`

## Font Note

The lock screen time does NOT use Playfair Display (originally planned). It uses Open Sans Condensed medium weight — consistent with the rest of the UI's header tier, just scaled up. This avoids pulling in an extra font just for one element.
