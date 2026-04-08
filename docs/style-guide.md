# Disco Elysium Style Guide

## Design Philosophy

This rice is inspired by the visual language of *Disco Elysium* — a world that is *literary, painterly, and worn*. The desktop should feel like a detective's desk at 3 AM in Martinaise.

Key principles:
1. **Painted, not digital** — UI elements should feel like they were laid onto a canvas. The key technique is the eroded-edge banner: dark text on a cream background with rough paint-like edges.
2. **Selective roughness** — only banner backgrounds get the rough paint treatment. Everything functional (text, buttons, inputs, borders, dividers) is clean and sharp.
3. **Color restraint** — muted `#363b3a` for borders/dividers by default. Intellect blue for focus/active. Orange for actions, emphasis, and speaker names. No neon.
4. **Contrast through inversion** — the game's signature is dark text on a light banner, not light on dark. Major headers punch through the dark UI this way.
5. **Literary typography** — three tiers: bold condensed sans-serif for headers, serif for body text, condensed small-caps for labels.
6. **Semi-transparent layering** — panels float over the wallpaper at ~88% opacity. The wallpaper should breathe through.

See `docs/style-overview.html` for a visual reference of all patterns (open in browser).

---

## Core Color Palette

Colors pipetted directly from the game's UI and reference screenshots.

### Backgrounds & Surfaces

| Token | Name | Hex | Role |
|-------|------|-----|------|
| `base` | Revachol Night | `#171b1a` | Main background — neutral dark |
| `surface` | Precinct Wall | `#1e2221` | Panels, cards, input fields |
| `surface-bright` | Whirling Dust | `#282c2b` | Hover states, selected items |
| `border` | Pale Border | `#363b3a` | Borders, frames — neutral muted |
| `deep-black` | Void | `#101312` | Stat blocks, deepest dark |

### Text

| Token | Name | Hex | Role |
|-------|------|-----|------|
| `text` | Parchment | `#ccc8c2` | Primary text — neutral off-white |
| `text-cream` | Cream | `#d2d2d2` | Banner backgrounds, secondary bright |
| `text-muted` | Faded Ink | `#999a95` | Secondary/inactive text |
| `text-disabled` | Worn Lead | `#4b4b4b` | Disabled, very muted text |
| `white` | Warm White | `#ebdbb2` | Brightest emphasis — warm cream (Gruvbox bright white) |

### Accents (pipetted from the game's skill tree)

| Token | Name | Hex | Skill Category | Role |
|-------|------|-----|----------------|------|
| `accent-intellect` | Intellect Blue | `#5bc0d6` | Intellect | Focus, borders, links, interactive highlights |
| `accent-psyche` | Psyche Purple | `#7555c6` | Psyche | Tags, git branches, tertiary highlights |
| `accent-physique` | Physique Red | `#cb456a` | Physique | Category label only |
| `accent-motorics` | Motorics Yellow | `#e3ba3e` | Motorics | Warnings, battery low, attention |

### UI Action Colors

| Token | Name | Hex | Role |
|-------|------|-----|------|
| `action` | Confirm Orange | `#eb6408` | Speaker names, active icons, cursor, choices, selection borders |
| `action-hover` | Confirm Orange (hover) | `#c85507` | Hover/pressed states on action elements |
| `button-primary` | Button Red | `#912711` | Primary button backgrounds (CONTINUE, LOAD) |
| `button-primary-hover` | Button Red (hover) | `#7a2010` | Primary button hover |

### Semantic

| Token | Name | Hex | Role |
|-------|------|-----|------|
| `error` | Health Orb Red | `#b83a3a` | Errors, critical battery, failures |
| `success` | Check Success | `#0fb666` | Success states, check passed |

### RGBA Variants

| Usage | Value |
|-------|-------|
| Panel background | `rgba(23, 27, 26, 0.88)` |
| Blue hover overlay | `rgba(91, 192, 214, 0.12)` |
| Blue active overlay | `rgba(91, 192, 214, 0.22)` |
| Shadow | `rgba(23, 27, 26, 0.93)` |

---

## Light Theme — "Tequila Sunset"

A companion light palette for daytime use. The dark theme channels Martinaise at 3 AM — this is *morning in Martinaise*. Warm parchment, golden light through dirty windows, coffee-stained case files on a detective's desk. Same literary, painterly, worn philosophy — just inverted.

The accents are slightly deepened versions of the dark theme's colors to maintain contrast against light backgrounds. Same hue relationships, same warm-cool tension.

### Backgrounds & Surfaces

| Token | Name | Hex | Role |
|-------|------|-----|------|
| `base` | Parchment Dawn | `#f5f0e8` | Main background — warm aged paper |
| `surface` | Worn Linen | `#ebe5d9` | Panels, cards, input fields |
| `surface-bright` | Dust in Light | `#e0d9cb` | Hover states, selected items |
| `border` | Case File Edge | `#c4b9a8` | Borders, frames — warm tan |

### Text

| Token | Name | Hex | Role |
|-------|------|-----|------|
| `text` | Ink Dark | `#2c2825` | Primary text — warm near-black |
| `text-muted` | Faded Script | `#6b6259` | Secondary/inactive text |
| `text-disabled` | Pencil Mark | `#9a9088` | Disabled, very muted text |

### Accents (darkened for light backgrounds)

| Token | Name | Hex | Skill Category | Role |
|-------|------|-----|----------------|------|
| `accent-intellect` | Intellect Blue | `#3d8a98` | Intellect | Focus, borders, links, interactive highlights |
| `accent-psyche` | Psyche Purple | `#5a3fa0` | Psyche | Tags, git branches, tertiary highlights |
| `accent-physique` | Physique Red | `#a83555` | Physique | Category label only |
| `accent-motorics` | Motorics Yellow | `#b89830` | Motorics | Warnings, battery low, attention |

### UI Action Colors (darkened for light backgrounds)

| Token | Name | Hex | Role |
|-------|------|-----|------|
| `action` | Confirm Orange | `#c45506` | Speaker names, active icons, cursor, choices, selection borders |
| `action-hover` | Confirm Orange (hover) | `#a04505` | Hover/pressed states |
| `button-primary` | Button Red | `#7a2010` | Primary button backgrounds |
| `button-primary-hover` | Button Red (hover) | `#63190c` | Primary button hover |

### Semantic

| Token | Name | Hex | Role |
|-------|------|-----|------|
| `error` | Health Orb Red | `#a83030` | Errors, critical battery, failures |
| `success` | Check Success | `#0a9050` | Success states, check passed |

### RGBA Variants

| Usage | Value |
|-------|-------|
| Panel background | `rgba(245, 240, 232, 0.92)` |
| Blue hover overlay | `rgba(61, 138, 152, 0.10)` |
| Blue active overlay | `rgba(61, 138, 152, 0.18)` |
| Shadow | `rgba(44, 40, 37, 0.15)` |

---

## The Banner Header

The most distinctive UI element in Disco Elysium. Dark text (`#171b1a`) on a cream background (`#d2d2d2`) with rough, paint-on-canvas edges. Used for major section titles (INVENTORY, JOURNAL, SET SKILL) and sparingly as a selection indicator for active menu items and tabs.

- Padding is tight: ~3-4px vertical, ~8-12px horizontal
- 1-3 banners per screen maximum — restraint gives it impact
- SVG filter technique: `feMorphology` erode + noise threshold creates a grainy paint-on-canvas boundary
- Different `seed` values per instance for natural variety
- **Overhang**: banners on panels hang slightly outside the panel boundary (top: -6px, left: -8px), anchoring the panel to its title like a physical label attached to a clipboard or case file

See the full SVG filter definition in `docs/superpowers/specs/2026-03-26-ui-visual-language-design.md`.

---

## Typography

Three tiers, no italic anywhere.

| Tier | Font | Weight | Style | Size | Use |
|------|------|--------|-------|------|-----|
| **Header** | Open Sans Condensed | 700 | Uppercase, letter-spacing 2px | 22–38px | Section titles (on banners), menu items |
| **Body** | Libre Baskerville | 400 | Normal case, line-height 1.8 | 13–14px | Notification body, descriptions, prose |
| **Label** | Open Sans Condensed | 700 | Uppercase, letter-spacing 2–3px | 11–13px | Metadata, timestamps, status indicators |
| **Code** | JetBrains Mono NF | 400 | Normal | 12–13px | Terminal, code contexts |

### Lock Screen

- Time: Playfair Display Bold, 64pt
- Greeting: Open Sans Condensed Bold, Uppercase, 20pt

### Font Packages

```
# Official repos
ttf-opensans     # Open Sans Condensed
# AUR
ttf-playfair-display
ttf-libre-baskerville
```

---

## Borders & Dividers

All solid, clean, geometric.

| Element | Style |
|---------|-------|
| Default border | `1px solid #363b3a` |
| Focus/active | `2px solid #5bc0d6` (Hyprland window border) |
| Left accent | `2px solid #5bc0d6` (left edge only) |
| Divider | `1px solid #363b3a` |
| Panel border | `1px solid rgba(54, 59, 58, 0.3)` |

### Color Usage

- **`#363b3a`** — default for all borders, dividers, frames
- **`#5bc0d6`** (intellect blue) — focus/active states, success indicators (CHECK SUCCESS)
- **`#eb6408`** (orange) — actions, selection markers, speaker names, value highlights. The game's "attention" color.

---

## Buttons

Sharp, square corners.

| Type | Background | Text | Border |
|------|-----------|------|--------|
| Primary ("CONTINUE") | `#912711` | `#ccc8c2`, condensed bold uppercase | None |
| Secondary ("BACK") | `#1e2221` | `#999a95`, condensed bold uppercase | `1px solid rgba(54, 59, 58, 0.5)` |

Primary buttons have an arrow indicator (`▶` or `▲`) and dim to 0.9 opacity on hover.

---

## Menu / Navigation Items

From menu4 (LOAD GAME screen):

- Font: Open Sans Condensed Bold, 22–26px, uppercase
- Inactive: off-white text (`#ccc8c2`) floating directly over the wallpaper
- Active: **banner treatment** — dark text (`#171b1a`) on eroded-edge cream banner (`#d2d2d2`, inverted contrast)
- Menu floats directly over the wallpaper

---

## Selection Indicators

Two tiers of selection, used depending on prominence.

### Primary Selection — Banner

The banner doubles as the selection indicator for the most prominent items on screen (1-3 per screen):

- **Section titles**: always have the banner (INVENTORY, JOURNAL, SET SKILL)
- **Active menu item** (menu4): "LOAD GAME" gets a banner
- **Active tab** (menu5): "TASKS" gets a banner

### Secondary Selection — Orange Left Border

For less prominent items, or when banners are already present on screen:

- `4px solid #eb6408` left border on the selected item
- Text stays off-white (`#ccc8c2`), background stays dark
- Use for: bar active workspace, launcher selected item, notification toggle, sidebar active items, list selections within panels

---

## Surfaces

The primary treatment is **semi-transparent dark over the wallpaper**.

| Surface | Color | Use |
|---------|-------|-----|
| Primary panel | `rgba(23, 27, 26, 0.88)` | Most panels — wallpaper breathes through |
| Opaque base | `#171b1a` | Where fully opaque is needed |
| Elevated | `#1e2221` | Cards, input fields |
| Hover | `#282c2b` | Hover states |
| Deep black | `#101312` | Stat blocks |

### Grain Texture (Optional)

Warm-tinted SVG feTurbulence noise, blended as `::after` with `opacity: 0.25; mix-blend-mode: soft-light`. Use on large panels only.

---

## Selection

| Usage | Background | Foreground | Description |
|-------|-----------|------------|-------------|
| Row/item selection | `#7d807c` | `#171b1a` | Dusty inversion — midpoint between cream and background |
| Text selection | `#363b3a` | `#ccc8c2` | Subtle highlight — border color background |

Row selection uses a muted inversion: dark text on a dusty mid-tone, less harsh than pure cream but clearly inverted. Text selection is deliberately subtle — just enough to see the highlight without drawing attention.

---

## Black Glass Design Language

The desktop shell (disco-shell) uses a refined "black glass" surface treatment that diverges from the base palette above. This section documents the patterns used across all widgets.

### Glass Panels

Panels use a darker, more transparent base than the original `rgba(23, 27, 26, 0.88)`:

| Surface | Color | Use |
|---------|-------|-----|
| Glass panel | `rgba(10, 12, 11, 0.78)` | Status bar, notification center, quick settings, keybinds, power menu |
| Glass panel (opaque) | `rgba(10, 12, 11, 0.90)` | Launcher, switcher, overview (panels with text-heavy content) |
| Glass overlay | `rgba(10, 12, 11, 0.55)` | Dimmed backdrop behind centered overlays |

All glass panels use Hyprland `layerrule blur` for 20px backdrop blur — GTK4 does not support `backdrop-filter`.

### Directional Borders

Panels use asymmetric borders that emphasize the left edge as an anchor point:

| Edge | Style |
|------|-------|
| Left | `3px solid rgba(210, 210, 210, 0.22)` — prominent cream |
| Bottom | `2px solid rgba(210, 210, 210, 0.18)` — lighter cream |
| Top | `1px solid rgba(54, 59, 58, 0.20)` — subtle dark |
| Right | `1px solid rgba(54, 59, 58, 0.20)` — subtle dark |

### Wells

Recessed containers with side-only borders, used to group related elements in the status bar (workspaces, system modules):

| Property | Value |
|----------|-------|
| Background | `rgba(16, 19, 18, 0.45)` |
| Side borders | `1px solid rgba(54, 59, 58, 0.20)` |
| Inner glow | `inset 1px 0 0 rgba(210, 210, 210, 0.03)` both sides |
| Top/bottom | None |

### Luminous Dividers

Gradient lines that replace solid `1px` separators:

- **Vertical** (between bar sections): `linear-gradient(to bottom, transparent 0%, rgba(210,210,210,0.12) 30%, rgba(210,210,210,0.12) 70%, transparent 100%)`
- **Horizontal** (between panel sections): `linear-gradient(to right, transparent 0%, rgba(210,210,210,0.10) 20%, rgba(210,210,210,0.10) 80%, transparent 100%)`

### Eroded SVG Banners

Pre-rendered SVG files in `configs/astal/data/banners/` with `feTurbulence` + `feDisplacementMap` erosion. Each widget gets its own SVG with a unique turbulence `seed`. Banners are flush with the panel left edge (`margin-left: -17px`).

### Diamond Workspace Indicators

7x7px squares rotated 45deg with CSS `transform: rotate(45deg)`. Active state uses cream with glow: `box-shadow: 0 0 5px rgba(210,210,210,0.35)`.

### Cream Left-Border Selection

The primary selection indicator for most widgets (replaces cream background inversion):

| State | Treatment |
|-------|-----------|
| Default | `border-left: 3px solid transparent` |
| Selected | `border-left: 3px solid #d2d2d2`, `background: rgba(40, 44, 43, 0.4)` |
| Selected (danger) | `border-left: 3px solid #b83a3a` |

### Icon Theme

**Gruvbox Plus Dark** (`gruvbox-plus-icon-theme` AUR) — replaces Papirus-Dark. Includes symbolic/monochromatic variants for status bar and panel icons.

---

## Dialogue / Speaker Pattern

Maps to notification content:

- **Speaker name** (app name): condensed bold uppercase, `#eb6408`
- **Body text**: Libre Baskerville, `#999a95`
- **"YOU"**: condensed bold uppercase, `#ccc8c2`
- **Skill check names**: condensed bold uppercase, category color
- **Choices**: `#eb6408`, underline on hover

---

## CHECK SUCCESS / FAILURE

- **Success**: green `#0fb666`, condensed bold uppercase
- **Failure**: full red block `#b83a3a`, white text — entire notification becomes the alert

---

## Stat / Numeric Displays

- Large numbers: Open Sans Condensed Bold, 28-48px, `#ccc8c2`
- Category labels: label tier, category color (blue/purple/red/yellow)
- Background: `#101312` (very dark)

---

## Icons

Thin, linear, outline-only. Like technical/blueprint schematic drawings — monochrome line art with minimal stroke weight. Derived from the game's HUD icons visible in the bottom-right of gameplay screens.

- Stroke: `1.5px`, `round` linecap and linejoin
- Fill: none (outline only)
- Default color: `#ccc8c2` (primary text)
- Hover: `#999a95` (muted)
- Active/toggled: `#eb6408` (orange)
- Size: 16-20px
- Icon set: Lucide, Feather, or similar thin-line icon libraries

---

## Interaction & Motion

- Default transition: `0.2s ease-in-out`
- Hover opacity: `0.9` on primary buttons
- Hyprland animations: `bezier = disco, 0.25, 0.1, 0.25, 1.0`, duration 3

---

## Eroded Edge Usage

The SVG eroded-edge filter is applied to **banner backgrounds** only:

- Section title banners (INVENTORY, JOURNAL, SET SKILL, etc.)
- Active menu item banner
- Active tab banner

All other elements use clean, solid rendering.

---

## Per-Component Application

### Hyprland (`configs/hypr/hyprland.conf`)

| Property | Old (Catppuccin) | New (Disco Elysium) |
|----------|-----------------|---------------------|
| `border_size` | `2` | `1` |
| `col.active_border` | `rgb(89b4fa) rgb(cba6f7) 45deg` | `rgba(999a9566)` |
| `col.inactive_border` | `rgb(313244)` | `rgba(363b3a40)` |
| `rounding` | `8` | `2` |
| `shadow.color` | `rgba(1a1a2eee)` | `rgba(171b1aee)` |
| `blur.passes` | `2` | `3` |

**Rationale:** Borders are subtle — the game's panels sit on the world with barely visible edges. Active border is a neutral muted hint, not a bright accent. 1px width, low opacity.

### disco-shell (`configs/astal/src/`)

disco-shell replaces Waybar, Rofi, and swaync. All UI elements (bar, launcher, notifications, etc.) are themed via SCSS stylesheets using GTK4 CSS.

| Element | Property | Value |
|---------|----------|-------|
| Bar background | `background` | `rgba(10, 12, 11, 0.78)` (glass) |
| Bar text | `color` | `#ccc8c2` |
| Bar border | `border-bottom` | `2px solid rgba(210, 210, 210, 0.18)` |
| Workspace (inactive) | diamond | `#4b4b4b` |
| Workspace (active) | diamond | `#d2d2d2` + glow |
| Module text | `color` | `#999a95` |
| Module icons | `color` | Skill color at 70% opacity |
| Module underline | `background` | Skill color at 35% opacity |
| Launcher container | `background` | `rgba(10, 12, 11, 0.90)` (glass) |
| Launcher entry | `background` | `rgba(16, 19, 18, 0.60)` |
| Launcher selected | `border-left` | `3px solid #d2d2d2` (cream left-border) |
| Notification card | `background` | `rgba(16, 19, 18, 0.92)` |
| Notification app name | `color` | `#999a95` (muted, not orange) |
| Notification body | `color` | `#999a95`, font: Libre Baskerville |
| Notification critical | `border-left` | `3px solid #b83a3a` |
| NC/QS/KB panel | `background` | `rgba(10, 12, 11, 0.78)` + directional border |
| Power menu | `background` | `rgba(10, 12, 11, 0.78)` + directional border |
| Overview | `background` | `rgba(10, 12, 11, 0.90)` + directional border |

### Kitty (`configs/kitty/kitty.conf`)

Full 16-color terminal scheme:

| Property | Old | New |
|----------|-----|-----|
| `background` | `#1e1e2e` | `#171b1a` |
| `foreground` | `#cdd6f4` | `#ccc8c2` |
| `cursor` | `#f5e0dc` | `#ccc8c2` |
| `cursor_text_color` | `#1e1e2e` | `#171b1a` |
| `selection_foreground` | `#1e1e2e` | `#171b1a` |
| `selection_background` | `#f5e0dc` | `#5bc0d6` |
| `color0` (black) | — | `#171b1a` |
| `color8` (bright black) | — | `#363b3a` |
| `color1` (red) | — | `#cb456a` |
| `color9` (bright red) | — | `#e05577` |
| `color2` (green) | — | `#0fb666` |
| `color10` (bright green) | — | `#3dcc88` |
| `color3` (yellow) | — | `#e3ba3e` |
| `color11` (bright yellow) | — | `#eece6e` |
| `color4` (blue) | — | `#5bc0d6` |
| `color12` (bright blue) | — | `#89d4e5` |
| `color5` (magenta) | — | `#7555c6` |
| `color13` (bright magenta) | — | `#9a7ed6` |
| `color6` (cyan) | — | `#4ba89a` |
| `color14` (bright cyan) | — | `#6fc2b4` |
| `color7` (white) | — | `#ccc8c2` |
| `color15` (bright white) | — | `#ebdbb2` |

**Note:** Cyan uses a synthesized muted teal (`#4ba89a`) distinct from intellect blue. Bright white uses Gruvbox's warm cream (`#ebdbb2`). Terminal red uses the physique skill color, magenta uses psyche purple, yellow uses motorics yellow.

### Hyprlock (`configs/hypr/hyprlock.conf`)

These are NEW properties to add (most were not set in the placeholder config):

**Background:**
| Property | Value |
|----------|-------|
| `brightness` | `0.5` (darker than current 0.6 for more drama) |

**Input field:**
| Property | Value |
|----------|-------|
| `outer_color` | `rgb(91, 192, 214)` — intellect blue border |
| `inner_color` | `rgb(23, 27, 26)` — dark fill |
| `font_color` | `rgb(215, 215, 215)` — off-white text |
| `check_color` | `rgb(15, 182, 102)` — green (verifying) |
| `fail_color` | `rgb(184, 58, 58)` — red (wrong password) |
| `capslock_color` | `rgb(227, 186, 62)` — yellow (warning) |

**Labels:**
| Property | Value |
|----------|-------|
| Time label `color` | `rgb(215, 215, 215)` |
| Time label `font_family` | `Playfair Display` |
| Greeting label `color` | `rgb(153, 154, 149)` — muted |

### Starship (`configs/starship/starship.toml`)

| Section | Property | Old | New |
|---------|----------|-----|-----|
| `[directory]` | `style` | `"bold blue"` | `"bold #5bc0d6"` |
| `[git_branch]` | `style` | `"bold purple"` | `"bold #7555c6"` |
| `[git_status]` | `style` | `"bold red"` | `"bold #eb6408"` |
| `[character]` | `success_symbol` | `"[>](bold green)"` | `"[>](bold #0fb666)"` |
| `[character]` | `error_symbol` | `"[>](bold red)"` | `"[>](bold #b83a3a)"` |

### Hyprland env vars (`configs/hypr/hyprland.conf`)

No color changes needed — cursor theme and Qt platform theme remain the same.

---

## Wallpaper

Copy `references/disco-elysium/wallpaper.png` to `wallpapers/disco-elysium-sunset.png`.

The wallpaper (two figures on a rooftop against a dramatic amber sunset over a dark city) is the palette's origin. Its dominant colors — dark brown-black structures, orange-amber sky, dusty purple clouds — cohere with every color defined above.

**Wallpaper selection guidance** for additional wallpapers:
- Painterly, oil-painting quality — not sharp photography or anime
- Warm-cool contrast (orange/amber against teal/dark)
- Muted, desaturated tones
- Sense of melancholy, vastness, or urban decay
- Good sources: Disco Elysium concept art, official wallpapers from [Alpha Coders](https://alphacoders.com/disco-elysium-wallpapers)

---

## GTK/Qt Theme Guidance

| Component | Recommendation |
|-----------|---------------|
| GTK theme | Custom `~/.config/gtk-3.0/gtk.css` (GTK3) and `~/.config/gtk-4.0/gtk.css` (GTK4/libadwaita) |
| Qt theme | `qt6ct` + **Kvantum** with a dark Kvantum theme |
| Icon theme | **Gruvbox-Plus-Dark** (`gruvbox-plus-icon-theme` AUR) — warm, consistent with Disco Elysium palette |
| Cursor theme | **Nordzy-cursors** — clean, neutral cursor |

---

## Complete Replacement Table

Quick reference for mechanical search-and-replace implementation. Every color change in one table.

| File | Property | Old Value | New Value |
|------|----------|-----------|-----------|
| `hyprland.conf` | `col.active_border` | `rgb(89b4fa) rgb(cba6f7) 45deg` | `rgba(999a9566)` |
| `hyprland.conf` | `col.inactive_border` | `rgb(313244)` | `rgba(363b3a40)` |
| `hyprland.conf` | `rounding` | `8` | `2` |
| `hyprland.conf` | `shadow.color` | `rgba(1a1a2eee)` | `rgba(171b1aee)` |
| `hyprland.conf` | `blur.passes` | `2` | `3` |
| `astal/src/*.scss` | bar `background` | — | `rgba(23, 27, 26, 0.88)` |
| `astal/src/*.scss` | bar `color` | — | `#ccc8c2` |
| `astal/src/*.scss` | workspace active | — | banner or `#ccc8c2` |
| `astal/src/*.scss` | workspace inactive | — | `#999a95` |
| `astal/src/*.scss` | notification bg | — | `#171b1a` |
| `astal/src/*.scss` | notification border | — | `1px solid #363b3a` |
| `astal/src/*.scss` | notification speaker | — | `#eb6408` |
| `astal/src/*.scss` | launcher bg | — | `#171b1a` |
| `astal/src/*.scss` | launcher border | — | `1px solid #363b3a` |
| `kitty/kitty.conf` | `foreground` | — | `#ccc8c2` |
| `kitty/kitty.conf` | `background` | — | `#171b1a` |
| `kitty/kitty.conf` | `cursor` | — | `#ccc8c2` |
| `kitty/kitty.conf` | `cursor_text_color` | — | `#171b1a` |
| `kitty/kitty.conf` | `selection_foreground` | — | `#171b1a` |
| `kitty/kitty.conf` | `selection_background` | — | `#5bc0d6` |
| `kitty/kitty.conf` | `color0`-`color15` | — | (see Kitty section above) |
| `hyprlock.conf` | `brightness` | `0.6` | `0.5` |
| `hyprlock.conf` | input `outer_color` | (none) | `rgb(91, 192, 214)` |
| `hyprlock.conf` | input `inner_color` | (none) | `rgb(23, 27, 26)` |
| `hyprlock.conf` | input `font_color` | (none) | `rgb(215, 215, 215)` |
| `hyprlock.conf` | input `check_color` | (none) | `rgb(15, 182, 102)` |
| `hyprlock.conf` | input `fail_color` | (none) | `rgb(184, 58, 58)` |
| `hyprlock.conf` | input `capslock_color` | (none) | `rgb(227, 186, 62)` |
| `hyprlock.conf` | time label `font_family` | `JetBrainsMono Nerd Font` | `Playfair Display` |
| `hyprlock.conf` | greeting label `color` | (inherited) | `rgb(153, 154, 149)` |
| `starship.toml` | `[directory]` style | `"bold blue"` | `"bold #5bc0d6"` |
| `starship.toml` | `[git_branch]` style | `"bold purple"` | `"bold #7555c6"` |
| `starship.toml` | `[git_status]` style | `"bold red"` | `"bold #eb6408"` |
| `starship.toml` | `[character]` success | `"[>](bold green)"` | `"[>](bold #0fb666)"` |
| `starship.toml` | `[character]` error | `"[>](bold red)"` | `"[>](bold #b83a3a)"` |
