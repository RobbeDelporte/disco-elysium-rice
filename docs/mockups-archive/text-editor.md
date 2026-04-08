# Text Editor (Neovim)

## Syntax Highlighting — 4 Skill Colors Only

| Element | Color | Skill |
|---------|-------|-------|
| Tags, types | `#5bc0d6` | Intellect — structural understanding |
| Keywords | `#7555c6` | Psyche — language constructs |
| Strings | `#cb456a` | Physique — literal values |
| Numbers | `#e3ba3e` | Motorics — precision |

Everything else is grayscale:
- Functions: `#ccc8c2` (primary text)
- Variables, attributes: `#999a95` (muted)
- Operators, punctuation: `#4b4b4b` (faded)
- Comments: `#363b3a` (very muted)

## Editor Chrome

- Background: `#171b1a`
- Current line: `#1e2221`
- Line numbers: `#363b3a`, current line number `#ccc8c2`
- Sign column git additions: `#0fb666`
- Cursor: block, `#ccc8c2`

## Statusline

- Mode indicator: cream banner (`#d2d2d2` bg, `#171b1a` text) — same for all modes (Normal, Insert, Visual)
- File path: `#999a95`
- Modified indicator `[+]`: action orange `#eb6408`
- Position/filetype: `#4b4b4b`

## Design Philosophy

The code reads like a worn document — most text is neutral gray, only structurally important tokens get color. Four colors total, mapped 1:1 to the four Disco Elysium skill categories.
