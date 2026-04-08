# Status Bar (disco-shell)

## Layout

Three-column grid, 32px height, semi-transparent (`rgba(23, 27, 26, 0.88)`) over wallpaper.

| Left | Center | Right |
|------|--------|-------|
| Workspace buttons + window title | Date & time | System modules + notification bell + power icon |

## Workspaces

- Inactive: muted text (`#999a95`), Open Sans Condensed Bold 13px
- Active: **banner treatment** — dark text (`#171b1a`) on cream background (`#d2d2d2`), inverted contrast
- Separated from window title by a 1px vertical divider

## Window Title

- JetBrains Mono 11px, muted (`#999a95`)
- Format: `app — context` (e.g. `kitty — ~/my-rice`)

## Clock

- Open Sans Condensed **Light (300)** 13px, uppercase, 2px letter-spacing
- Primary text color (`#ccc8c2`)
- Format: `Fri 28 Mar, 14:30`

## System Modules

Each module shows a label + percentage in JetBrains Mono 11px, muted text. The label has a 1px bottom border in its skill color — the percentage has no decoration.

| Module | Skill Color | Reasoning |
|--------|------------|-----------|
| CPU | Intellect Blue (`#5bc0d6`) | Processing, thinking |
| MEM | Psyche Purple (`#7555c6`) | Mental capacity |
| VOL | Physique Red (`#cb456a`) | Body, senses |
| BAT | Motorics Yellow (`#e3ba3e`) | Energy, power |

No warning/critical color overrides — modules stay visually consistent at all levels.

## Action Icons

After a divider, two icon buttons on the far right:

- **Bell** — toggles notification center. Shows a small orange dot (`#eb6408`, 5px) when unread notifications exist.
- **Power** — triggers power menu script.

Icons: 14px, 1.5px stroke, outline-only (Lucide style). Muted (`#999a95`), brighten to `#ccc8c2` on hover.

## Border

1px bottom border `rgba(54, 59, 58, 0.4)` — subtle separation from desktop content.
