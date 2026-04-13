# Widget Detail Specs

One file per widget from `docs/superpowers/specs/2026-04-13-desktop-redesign-design.md`.
Each spec expands the summary from the parent redesign spec into disco-shell-implementation-ready detail: exact sizes, paddings, assets, colors, animations, keyboard and pointer behavior.

The parent spec is the source of truth for *what* each widget does. These files are the source of truth for *how* each widget looks and animates at the pixel level.

## Widgets

| # | Widget | Spec | Mockup |
|---|--------|------|--------|
| 1 | Info Panel | [info-panel.md](info-panel.md) | [../mockups/widgets/info-panel.html](../mockups/widgets/info-panel.html) |
| 2 | Launcher | [launcher.md](launcher.md) | [../mockups/widgets/launcher.html](../mockups/widgets/launcher.html) |
| 3 | Power Menu | [power-menu.md](power-menu.md) | [../mockups/widgets/power-menu.html](../mockups/widgets/power-menu.html) |
| 4 | Lockscreen | [lockscreen.md](lockscreen.md) | [../mockups/widgets/lockscreen.html](../mockups/widgets/lockscreen.html) |
| 5 | Overview | [overview.md](overview.md) | [../mockups/widgets/overview.html](../mockups/widgets/overview.html) |
| 6 | Switcher | [switcher.md](switcher.md) | [../mockups/widgets/switcher.html](../mockups/widgets/switcher.html) |
| 7 | OSD | [osd.md](osd.md) | [../mockups/widgets/osd.html](../mockups/widgets/osd.html) |
| 8 | Notification Toast | [notification-toast.md](notification-toast.md) | [../mockups/widgets/notification-toast.html](../mockups/widgets/notification-toast.html) |

## Template

Every widget spec follows this structure:

```markdown
# [Widget Name]

One-line description.

## Summary (from parent spec)
- State: Peek / Ceremonial / Ephemeral
- Summon: keybind / event
- Dismiss: conditions

## Dimensions & Position
- Width, height, anchor edge, margins
- Z-order relative to windows and other widgets

## Surface Treatment
- Base color(s) with exact rgba
- Asset textures used (path relative to `assets/textures/`)
- Border / shadow specs
- Banner header (yes/no, text)

## Contents
Ordered top-to-bottom (or left-to-right) with each region's:
- Purpose
- Typography (font, size, weight, case, color)
- Spacing

## Keyboard & Pointer
- Keybinds active while summoned
- Click, hover, scroll behavior

## Animation
- Enter transition (duration, easing, initial / final state)
- Exit transition
- Any internal motion (pulse, shimmer, nothing)

## Reference
- Parent spec section
- Style guide sections referenced
- Asset files referenced
```

## Conventions

- All colors are given as hex (`#rrggbb`) or rgba — never named.
- All sizes are in CSS pixels (GPUI can convert to its own unit system).
- Font names reference what's defined in `docs/style-guide.md` §5.
- Asset paths are relative to `assets/textures/`.
- Animation durations in milliseconds, easings as cubic-bezier or the named `disco` easing (`cubic-bezier(0.25, 0.1, 0.25, 1.0)`) from the style guide.
