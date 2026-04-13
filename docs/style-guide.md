# Disco Elysium Style Guide

## 1. Design Philosophy

This rice is inspired by the visual language of *Disco Elysium* — a world that is *literary, painterly, and worn*. The desktop should feel like a detective's desk at 3 AM in Martinaise.

Key principles:

1. **Painted, not digital** — UI elements should feel laid onto a canvas. The signature technique is the eroded-edge banner: dark text on a cream background with rough paint-like edges.
2. **Selective roughness** — only banner backgrounds get the rough paint treatment. Everything functional (text, buttons, inputs, borders, dividers) is clean and sharp.
3. **Color restraint** — muted `#363b3a` for borders/dividers by default. Intellect blue for focus/active. Orange for actions, emphasis, and speaker names. No neon.
4. **Contrast through inversion** — dark text on a light banner, not light on dark. Major headers punch through the dark UI this way.
5. **Literary typography** — three tiers: semi-condensed sans-serif for headers, serif for body text, condensed small-caps for labels.
6. **Semi-transparent layering** — panels float over the wallpaper at ~88% opacity. The wallpaper breathes through.
7. **Surface tiers govern decorative weight.** Ceremonial surfaces (lockscreen, splash, power menu, overview) take the full painted treatment. Functional surfaces (launcher, notification center, quick settings) get one restrained motif. Ambient surfaces (bar, toasts) stay clean.

## 2. Source Material

Two sources inform this guide:

- **The game itself** (skill tree, menus, dialogue, HUD) — canonical for the **functional palette** and **core UI patterns**.
- **The official website**, [discoelysium.com](https://discoelysium.com) — canonical for **ceremonial motifs** and **decorative accents** (film strips, brush-stroke backgrounds, flares, layered CTAs).

When sources disagree: *game wins for function, website wins for ornament*.

Reference images live in `references/disco-elysium/` (game screenshots) and `references/disco-elysium/ui-assets/` (website-derived textures and frames).

## 3. Surface Tiers

Every surface in the rice falls into one of three tiers. The tier governs how much decorative treatment the surface receives.

| Tier | Surfaces | Treatment |
|------|----------|-----------|
| **1. Ceremonial** | Splash, lockscreen, power menu, overview, wallpaper picker | Full painted treatment. Film strips, flares, brush-stroke backgrounds, radial halos, layered CTAs, media frames all allowed. |
| **2. Functional** | Launcher, notification center, quick settings, keybinds panel | Painted-canvas base + banner headers. ONE restrained motif per panel (banner erosion; optional thin media frame). No flares, no film strips, no brush-stroke backgrounds. |
| **3. Ambient** | Status bar, toasts/notifications, tooltips | Clean, restrained. Banner allowed as active-item indicator. No decorative motifs. |

**Rationale:** motifs carry weight. Reserving them for moments when you are *not* trying to get work done preserves both utility and drama. A quick sanity check when designing a new surface: *"can I put a film strip on this?"* If the answer is "only if nothing important lives here," it's tier 1.

## 4. Color

### 4.1 Functional Palette (dark) — canonical

Pipetted directly from the game's UI and reference screenshots. Used everywhere: terminal colors, Hyprland borders, focus states, skill category labels.

#### Backgrounds & Surfaces

| Token | Name | Hex | Role |
|-------|------|-----|------|
| `base` | Revachol Night | `#171b1a` | Main background — neutral dark |
| `surface` | Precinct Wall | `#1e2221` | Panels, cards, input fields |
| `surface-bright` | Whirling Dust | `#282c2b` | Hover states, selected items |
| `border` | Pale Border | `#363b3a` | Borders, frames — neutral muted |
| `deep-black` | Void | `#101312` | Stat blocks, deepest dark |

#### Text

| Token | Name | Hex | Role |
|-------|------|-----|------|
| `text` | Parchment | `#ccc8c2` | Primary text — neutral off-white |
| `text-cream` | Cream | `#d2d2d2` | Banner backgrounds, secondary bright |
| `text-muted` | Faded Ink | `#999a95` | Secondary/inactive text |
| `text-disabled` | Worn Lead | `#4b4b4b` | Disabled, very muted text |
| `white` | Warm White | `#ebdbb2` | Brightest emphasis — warm cream |

#### Accents (pipetted from the skill tree)

| Token | Name | Hex | Skill Category | Role |
|-------|------|-----|----------------|------|
| `accent-intellect` | Intellect Blue | `#5bc0d6` | Intellect | Focus, borders, links, interactive highlights |
| `accent-psyche` | Psyche Purple | `#7555c6` | Psyche | Tags, git branches, tertiary highlights |
| `accent-physique` | Physique Red | `#cb456a` | Physique | Category label only |
| `accent-motorics` | Motorics Yellow | `#e3ba3e` | Motorics | Warnings, battery low, attention |

#### UI Action Colors

| Token | Name | Hex | Role |
|-------|------|-----|------|
| `action` | Confirm Orange | `#eb6408` | Speaker names, active icons, cursor, choices, selection borders |
| `action-hover` | Confirm Orange (hover) | `#c85507` | Hover/pressed states on action elements |
| `button-primary` | Button Red | `#912711` | Primary button backgrounds (CONTINUE, LOAD) |
| `button-primary-hover` | Button Red (hover) | `#7a2010` | Primary button hover |

#### Semantic

| Token | Name | Hex | Role |
|-------|------|-----|------|
| `error` | Health Orb Red | `#b83a3a` | Errors, critical battery, failures |
| `success` | Check Success | `#0fb666` | Success states, check passed |

#### RGBA Variants

| Usage | Value |
|-------|-------|
| Panel background | `rgba(23, 27, 26, 0.88)` |
| Blue hover overlay | `rgba(91, 192, 214, 0.12)` |
| Blue active overlay | `rgba(91, 192, 214, 0.22)` |
| Shadow | `rgba(23, 27, 26, 0.93)` |

### 4.2 Light Theme — "Tequila Sunset"

A companion light palette for daytime use. The dark theme channels Martinaise at 3 AM; this is *morning in Martinaise* — warm parchment, golden light through dirty windows, coffee-stained case files.

#### Backgrounds & Surfaces

| Token | Name | Hex | Role |
|-------|------|-----|------|
| `base` | Parchment Dawn | `#f5f0e8` | Main background — warm aged paper |
| `surface` | Worn Linen | `#ebe5d9` | Panels, cards, input fields |
| `surface-bright` | Dust in Light | `#e0d9cb` | Hover states, selected items |
| `border` | Case File Edge | `#c4b9a8` | Borders, frames — warm tan |

#### Text

| Token | Name | Hex | Role |
|-------|------|-----|------|
| `text` | Ink Dark | `#2c2825` | Primary text — warm near-black |
| `text-muted` | Faded Script | `#6b6259` | Secondary/inactive text |
| `text-disabled` | Pencil Mark | `#9a9088` | Disabled, very muted text |

#### Accents (darkened for light backgrounds)

| Token | Name | Hex | Skill Category |
|-------|------|-----|----------------|
| `accent-intellect` | Intellect Blue | `#3d8a98` | Intellect |
| `accent-psyche` | Psyche Purple | `#5a3fa0` | Psyche |
| `accent-physique` | Physique Red | `#a83555` | Physique |
| `accent-motorics` | Motorics Yellow | `#b89830` | Motorics |

#### UI Action Colors (darkened for light backgrounds)

| Token | Hex | Role |
|-------|-----|------|
| `action` | `#c45506` | Speaker names, cursor, selection borders |
| `action-hover` | `#a04505` | Hover/pressed |
| `button-primary` | `#7a2010` | Primary button backgrounds |
| `button-primary-hover` | `#63190c` | Primary button hover |

#### Semantic

| Token | Hex | Role |
|-------|-----|------|
| `error` | `#a83030` | Errors, failures |
| `success` | `#0a9050` | Success states |

#### RGBA Variants

| Usage | Value |
|-------|-------|
| Panel background | `rgba(245, 240, 232, 0.92)` |
| Blue hover overlay | `rgba(61, 138, 152, 0.10)` |
| Blue active overlay | `rgba(61, 138, 152, 0.18)` |
| Shadow | `rgba(44, 40, 37, 0.15)` |

### 4.3 Decorative Accent Palette — ceremonial only

Derived from the official website. **Scoped to Tier 1 surfaces only.** Never used in terminal themes, Hyprland window borders, or functional panels.

| Token | Name | Hex | Role |
|-------|------|-----|------|
| `decor-cyan` | Signal Cyan | `#7effaa` | Ceremonial focus outline (lockscreen input), layered-CTA middle layer |
| `decor-purple` | Broadcast Purple | `#7b61ff` | Layered-CTA backing layer, splash accents |
| `decor-orange-hot` | Flare Orange | `#e55023` | Flare/bokeh tint, ceremonial emphasis |
| `decor-brown` | Old Signage | `#90270f` | Website equivalent of `button-primary`; documented for parity |

Note: `decor-brown` is nearly identical to `button-primary` (`#912711`); implementations should continue to use `button-primary`. The token is listed here purely to document the website correspondence.

## 5. Typography

Three tiers, no italic anywhere.

| Tier | Font | Weight | Style | Size | Use |
|------|------|--------|-------|------|-----|
| **Header** | Archivo Narrow | 700 | Uppercase, letter-spacing 2px | 22–38px | Section titles (on banners), menu items |
| **Body** | Libre Baskerville | 400 | Normal case, line-height 1.8 | 13–14px | Notification body, descriptions, prose |
| **Label** | Archivo Narrow | 700 | Uppercase, letter-spacing 2–3px | 11–13px | Metadata, timestamps, status indicators |
| **Display** | Playfair Display | 700 | Normal case | 64pt | Lockscreen time |
| **Code** | JetBrains Mono NF | 400 | Normal | 12–13px | Terminal, code contexts |

### Dobra swap path

The official website uses **Dobra** (Fontspring/Typotheque) for headers. Archivo Narrow is the free substitute — same role, same weights, close proportions. For personal non-commercial use, Dobra may be swapped in 1:1 wherever Archivo Narrow appears.

### Font Packages

```
# AUR
ttf-archivo            # Archivo Narrow
ttf-libre-baskerville
ttf-playfair-display
ttf-jetbrains-mono-nerd
```

## 6. The Banner Header

The most distinctive UI element in Disco Elysium. Dark text (`#171b1a`) on a cream background (`#d2d2d2`) with rough, paint-on-canvas edges. Used for major section titles (INVENTORY, JOURNAL, SET SKILL) and sparingly as a selection indicator for active menu items and tabs.

- Padding is tight: ~3–4px vertical, ~8–12px horizontal
- 1–3 banners per screen maximum — restraint gives it impact
- SVG filter technique: `feMorphology` erode + noise threshold creates a grainy paint-on-canvas boundary
- Different `seed` values per instance for natural variety
- **Overhang**: banners on panels hang slightly outside the panel boundary (top: -6px, left: -8px), anchoring the panel to its title like a physical label attached to a clipboard

The banner is the one motif allowed on **all three surface tiers**. It is the shared visual through-line of the rice.

See the full SVG filter definition in `docs/superpowers/specs/2026-03-26-ui-visual-language-design.md`.

## 7. Painted-Canvas Surfaces

The single panel treatment used across the rice — semi-transparent dark over the wallpaper.

| Surface | Color | Use |
|---------|-------|-----|
| Primary panel | `rgba(23, 27, 26, 0.88)` | All tiers — wallpaper breathes through |
| Opaque base | `#171b1a` | Where full opacity is required |
| Elevated | `#1e2221` | Cards, input fields |
| Hover | `#282c2b` | Hover states |
| Deep black | `#101312` | Stat blocks |

### Grain Texture

Warm-tinted SVG `feTurbulence` noise, blended as `::after` with `opacity: 0.25; mix-blend-mode: soft-light`. Applied to all Tier 1 surfaces; optional on Tier 2. Skip on Tier 3.

### Brush-stroke Background Variant — Tier 1 only

Painterly dark surface layer using `references/disco-elysium/ui-assets/single-page-content-bg_htmvo8.png` or `Archive_3324d46e2.png` as a CSS `background-image`, sitting above the base panel color. Reserved for ceremonial hero surfaces (splash, power-menu backdrop, lockscreen content panel).

## 8. Decorative Motifs

One subsection per motif. Each specifies: visual description, allowed tier(s), when to use, when *not* to use, and the reference asset.

### 8.1 Film-strip Borders

Horizontal strip with sprocket perforations, top and bottom edges of a ceremonial surface.

- **Tier:** 1 only.
- **Asset:** `references/disco-elysium/ui-assets/film-strip-long_a5hufh.png`
- **Use on:** splash screen, optional lockscreen, overview full-screen view.
- **Do not:** tile on the bar, put on launcher, use as a divider inside functional panels.

### 8.2 Brush-stroke Backgrounds

Painterly dark (or light) surface with visible brush marks, behind the primary panel.

- **Tier:** 1 only.
- **Assets:**
  - `references/disco-elysium/ui-assets/brush-bg-white_kkkkx7.png` — light variant, use behind inverted banner-style surfaces.
  - `references/disco-elysium/ui-assets/Archive_3324d46e2.png` — dark variant, use behind hero panels.
- **Use on:** splash, power-menu backdrop, lockscreen content panel.
- **Do not:** use on launcher, notification center, quick settings, bar.

### 8.3 Radial Halos

Soft dark radial gradient behind text to guarantee legibility over busy wallpaper.

- **Tier:** any.
- **Recipe:** `radial-gradient(ellipse at center, rgba(16, 19, 18, 0.85) 0%, transparent 70%)` placed behind headlines sitting directly on the wallpaper.
- **Use on:** lockscreen time/greeting, overview labels, splash title, any floating title over imagery.

### 8.4 Cinematic Flares & Bokeh

Warm amber flares, lens bokeh, soft out-of-focus highlights.

- **Tier:** 1 only.
- **Assets:**
  - `references/disco-elysium/ui-assets/feld-flash-flare-0_cy51je.jpg`
  - `references/disco-elysium/ui-assets/feld-flash-flare-1_loooiz.jpg`
- **Use on:** splash, lockscreen background accent, power-menu background.
- **Do not:** use on any surface carrying dense information.

### 8.5 Layered Offset CTAs

Primary confirm button with 2–3 stacked color blocks behind it, slightly offset. **No rotation** — tilts are explicitly excluded from this rice.

- **Tier:** 1 only.
- **Recipe:**
  - Main button on top (`background: #912711`, text `#ccc8c2`).
  - `::before` pseudo-element: offset `+6px / +6px`, `background: #7effaa` (`decor-cyan`).
  - `::after` pseudo-element: offset `+12px / +12px`, `background: #eb6408` (`action`).
  - Drop shadow: `0 4px 0 rgba(0, 0, 0, 0.2)`.
- **Use on:** power menu "SHUT DOWN", confirm dialogs "OK", splash "CONTINUE".
- **Do not:** use on secondary buttons, list items, dense UI.

### 8.6 Media Frames

Painted dark frames around images/thumbnails.

- **Tier:** 1–2.
- **Assets:**
  - `references/disco-elysium/ui-assets/frame-16-9_iqf4jq.png` — landscape.
  - `references/disco-elysium/ui-assets/frame-16-9-portrait_snwdsp.png` — portrait.
  - `references/disco-elysium/ui-assets/black-tapelet_dysjoh.png` — slim decorative strip.
- **Use on:** overview thumbnails, notification images, wallpaper picker tiles, album art.

## 9. Borders & Dividers

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
- **`#eb6408`** (orange) — actions, selection markers, speaker names, value highlights

## 10. Buttons

Sharp, square corners.

| Type | Background | Text | Border | Scope |
|------|-----------|------|--------|-------|
| Primary ("CONTINUE") | `#912711` | `#ccc8c2`, Archivo Narrow bold uppercase | None | Any tier |
| Secondary ("BACK") | `#1e2221` | `#999a95`, Archivo Narrow bold uppercase | `1px solid rgba(54, 59, 58, 0.5)` | Any tier |
| Ceremonial CTA | `#912711` + layered offsets (§8.5) | `#ccc8c2`, Archivo Narrow bold uppercase | None | **Tier 1 only** |

Primary buttons have an arrow indicator (`▶` or `▲`) and dim to 0.9 opacity on hover.
