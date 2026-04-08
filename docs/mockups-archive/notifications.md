# Notifications (disco-shell)

## Layout

Popup cards stacked in the top-right corner, 360px wide, 8px gap between cards.

## Notification Card

- Background: `rgba(23, 27, 26, 0.94)`, border `1px solid rgba(54, 59, 58, 0.4)`
- No border-radius (sharp corners)

### Speaker Pattern (app name)
- Open Sans Condensed Bold 12px, uppercase, 2px letter-spacing
- Color: action orange (`#eb6408`) — like a character speaking in dialogue
- Skill-check names use their category color instead (e.g. Intellect Blue for "Perception")

### Summary
- Open Sans Condensed Bold 14px, primary text (`#ccc8c2`)

### Body
- Libre Baskerville 12px, line-height 1.7, muted (`#999a95`)

### Timestamp
- Open Sans Condensed Bold 10px, uppercase, disabled gray (`#4b4b4b`)

### Dismiss Button
- Top-right corner, `×` character, muted by default
- Hover: red background (`#b83a3a`) with light text

### Action Buttons
- Open Sans Condensed Bold 11px, uppercase, 2px letter-spacing
- Background `#1e2221`, border `1px solid rgba(54, 59, 58, 0.4)`
- Hover: background `#282c2b`, text brightens to `#ccc8c2`

## Check Success
- `✓ Check Success` — Open Sans Condensed Bold 11px, success green (`#0fb666`)

## Critical Notification
- Same dark background as normal (NOT full red block)
- Red used as highlight: `3px solid #b83a3a` left border
- App name and summary text turn red (`#b83a3a`)
- Body stays muted serif

## Behavior
- Popups appear on `notify-send` or any D-Bus notification
- Auto-dismiss after timeout (configurable in disco-shell)
- Click dismiss or swipe to remove
- Bell icon in bar shows orange dot when unread
