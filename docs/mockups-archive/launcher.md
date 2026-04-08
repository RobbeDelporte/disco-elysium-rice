# App Launcher (disco-shell)

## Layout

Centered overlay panel on a dimmed wallpaper backdrop (`rgba(16, 19, 18, 0.65)` overlay). 480px wide.

### Banner Title
- Eroded-edge banner overhanging top-left of the panel
- "APPLICATIONS" — Open Sans Condensed Bold 16px, dark text (`#171b1a`) on cream (`#d2d2d2`)

### Search Input
- Full-width, dark background (`#1e2221`), border `1px solid #363b3a`
- Libre Baskerville 13px, italic placeholder
- Focus state: border changes to intellect blue (`#5bc0d6`)

### Result List
- Icon (28x28, outline style) + name (condensed uppercase) + description (serif, muted)
- Hover: subtle background shift to `#282c2b`

### Selection — Primary (recommended)
- **Cream background (`#d2d2d2`) with dark text (`#171b1a`)** — the Disco Elysium banner inversion
- Matches the active workspace treatment in the status bar
- Icon and description also darken to maintain contrast

### Selection — Secondary (alternative)
- Orange left border (`3px solid #eb6408`) on selected item
- Text stays light, background shifts to `#282c2b`
- Use this if the primary selection feels too heavy in practice

## Footer
- `esc to close · enter to launch` — JetBrains Mono 10px, `#363b3a`

## Behavior
- Opens with `Super+/` or `Super+D`
- Closes with `Escape`
- Fuzzy search via AstalApps
- Max 8 results shown
- Keyboard navigation: arrow keys to move selection, Enter to launch
