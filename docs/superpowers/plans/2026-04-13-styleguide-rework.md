# Style Guide Rework Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Rewrite `docs/style-guide.md` per the new structure in `docs/superpowers/specs/2026-04-13-styleguide-rework-design.md` — restructure, fold in website-derived motifs, delete black-glass, and move per-component implementation tables into `docs/implementation-guide.md`.

**Architecture:** Documentation refactor. The style guide becomes purely design-language (philosophy → surface tiers → color → typography → motifs → components). Implementation mapping (exact hex values per config file) lives in the implementation guide. Font package for Archivo Narrow added to AUR list. No code changes beyond package list and scripts/install.sh note.

**Tech Stack:** Markdown docs, Arch `pacman`/AUR package lists, grep-based verification.

---

## File Map

| File | Action | Responsibility |
|------|--------|----------------|
| `docs/style-guide.md` | Rewrite | Design language only — 20 numbered sections per spec |
| `docs/implementation-guide.md` | Extend | Absorb per-component tables (Hyprland, Kitty, Hyprlock, Starship, Complete Replacement) |
| `packages/aur.txt` | Modify | Add `ttf-archivo`, add `ttf-libre-baskerville` |
| `scripts/install.sh` | Read only (no edits) | Existing `ttf-opensans -Rdd` line stays; Archivo replaces Open Sans in docs |
| `CLAUDE.md` | Read only (no edits) | Already points to `docs/style-guide.md` generically — no section-anchor updates needed |

---

## Task 1: Add font packages

**Files:**
- Modify: `packages/aur.txt`

- [ ] **Step 1: Add Archivo and Libre Baskerville to AUR list**

Open `packages/aur.txt`. Replace the `# Fonts` block:

```
# Fonts
ttf-jetbrains-mono-nerd
ttf-playfair-display
```

with:

```
# Fonts
ttf-jetbrains-mono-nerd
ttf-playfair-display
ttf-archivo          # Archivo Narrow (headers/labels — replaces Open Sans Condensed)
ttf-libre-baskerville  # Body text (serif)
```

- [ ] **Step 2: Verify package names exist in AUR**

Run: `paru -Ss '^ttf-archivo$' 2>/dev/null | head -5`
Expected: returns a line matching `aur/ttf-archivo`. If empty, fall back to `ttf-archivo-narrow` or check `https://aur.archlinux.org/packages?K=archivo`.

Run: `paru -Ss '^ttf-libre-baskerville$' 2>/dev/null | head -5`
Expected: returns a line matching `aur/ttf-libre-baskerville`.

If either package name resolves to a different slug, update `packages/aur.txt` to use the correct slug and note in this task's commit message.

- [ ] **Step 3: Commit**

```bash
git add packages/aur.txt
git commit -m "packages: add Archivo Narrow and Libre Baskerville fonts"
```

---

## Task 2: Rewrite `docs/style-guide.md` — header through §7

**Files:**
- Rewrite: `docs/style-guide.md` (replace entire file contents across Tasks 2, 3, 4)

This task writes the first half. Tasks 3 and 4 append the rest.

- [ ] **Step 1: Replace the file with the new header and §§1–7**

Overwrite `docs/style-guide.md` with exactly the following content:

````markdown
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
````

- [ ] **Step 2: Verify the file ends mid-document as expected**

Run: `tail -1 docs/style-guide.md`
Expected: the last line of the brush-stroke section, ending with `(splash, power-menu backdrop, lockscreen content panel).`

- [ ] **Step 3: Commit**

```bash
git add docs/style-guide.md
git commit -m "docs(style-guide): rewrite §§1-7 with surface tiers and unified painted-canvas"
```

---

## Task 3: Append §§8–10 (Decorative Motifs, Borders, Buttons)

**Files:**
- Modify: `docs/style-guide.md` (append)

- [ ] **Step 1: Append sections 8, 9, and 10**

Append exactly this content to `docs/style-guide.md`:

````markdown

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
````

- [ ] **Step 2: Verify section 8 landed cleanly**

Run: `grep -c "^### 8\." docs/style-guide.md`
Expected: `6` (six subsections — 8.1 through 8.6).

- [ ] **Step 3: Commit**

```bash
git add docs/style-guide.md
git commit -m "docs(style-guide): add §8 decorative motifs, §9 borders, §10 buttons"
```

---

## Task 4: Append §§11–20 and close the document

**Files:**
- Modify: `docs/style-guide.md` (append)

- [ ] **Step 1: Append the remaining sections**

Append exactly this content to `docs/style-guide.md`:

````markdown

## 11. Menu / Navigation Items

From the LOAD GAME screen (menu4):

- Font: Archivo Narrow Bold, 22–26px, uppercase
- Inactive: off-white text (`#ccc8c2`) floating directly over the wallpaper
- Active: **banner treatment** — dark text (`#171b1a`) on eroded-edge cream banner (`#d2d2d2`, inverted contrast)
- Menu floats directly over the wallpaper

## 12. Selection Indicators

Two tiers of selection, used depending on prominence.

### Primary Selection — Banner

The banner doubles as the selection indicator for the most prominent items on screen (1–3 per screen):

- **Section titles**: always have the banner (INVENTORY, JOURNAL, SET SKILL)
- **Active menu item** (menu4): "LOAD GAME" gets a banner
- **Active tab** (menu5): "TASKS" gets a banner

### Secondary Selection — Orange Left Border

For less prominent items, or when banners are already present on screen:

- `4px solid #eb6408` left border on the selected item
- Text stays off-white (`#ccc8c2`), background stays dark
- Use for: bar active workspace, launcher selected item, notification toggle, sidebar active items, list selections within panels

## 13. Selection (Row / Text)

| Usage | Background | Foreground | Description |
|-------|-----------|------------|-------------|
| Row/item selection | `#7d807c` | `#171b1a` | Dusty inversion — midpoint between cream and background |
| Text selection | `#363b3a` | `#ccc8c2` | Subtle highlight — border color background |

Row selection uses a muted inversion: dark text on a dusty mid-tone, less harsh than pure cream but clearly inverted. Text selection is deliberately subtle — just enough to see the highlight without drawing attention.

## 14. Dialogue / Speaker Pattern

Maps to notification content:

- **Speaker name** (app name): Archivo Narrow bold uppercase, `#eb6408`
- **Body text**: Libre Baskerville, `#999a95`
- **"YOU"**: Archivo Narrow bold uppercase, `#ccc8c2`
- **Skill check names**: Archivo Narrow bold uppercase, skill category color
- **Choices**: `#eb6408`, underline on hover

## 15. Check Success / Failure

- **Success**: green `#0fb666`, Archivo Narrow bold uppercase
- **Failure**: full red block `#b83a3a`, white text — entire notification becomes the alert

## 16. Stat / Numeric Displays

- Large numbers: Archivo Narrow Bold, 28–48px, `#ccc8c2`
- Category labels: label tier, skill category color (blue/purple/red/yellow)
- Background: `#101312` (very dark)

## 17. Icons

Thin, linear, outline-only. Like technical/blueprint schematic drawings — monochrome line art with minimal stroke weight. Derived from the game's HUD icons.

- Stroke: `1.5px`, `round` linecap and linejoin
- Fill: none (outline only)
- Default color: `#ccc8c2` (primary text)
- Hover: `#999a95` (muted)
- Active/toggled: `#eb6408` (orange)
- Size: 16–20px
- Icon set: Lucide, Feather, or similar thin-line icon libraries

## 18. Interaction & Motion

- Default transition: `0.2s ease-in-out`
- Hover opacity: `0.9` on primary buttons
- Hyprland animations: `bezier = disco, 0.25, 0.1, 0.25, 1.0`, duration 3
- **No rotation on functional UI.** Tilted widgets are explicitly excluded.

## 19. Eroded Edge Usage

The SVG eroded-edge filter is applied to **banner backgrounds** only:

- Section title banners (INVENTORY, JOURNAL, SET SKILL, etc.)
- Active menu item banner
- Active tab banner

All other elements use clean, solid rendering.

## 20. Wallpaper & GTK Theme

### Wallpaper

`references/disco-elysium/wallpaper.png` → `wallpapers/disco-elysium-sunset.png`.

Two figures on a rooftop against a dramatic amber sunset over a dark city — the palette's origin. Its dominant colors (dark brown-black structures, orange-amber sky, dusty purple clouds) cohere with every color defined above.

**Wallpaper selection guidance** for additional wallpapers:

- Painterly, oil-painting quality — not sharp photography or anime
- Warm-cool contrast (orange/amber against teal/dark)
- Muted, desaturated tones
- Sense of melancholy, vastness, or urban decay
- Good sources: Disco Elysium concept art, official wallpapers from [Alpha Coders](https://alphacoders.com/disco-elysium-wallpapers)

### GTK Theme

| Component | Recommendation |
|-----------|---------------|
| GTK theme | Adwaita-dark (set via gsettings) |
| Icon theme | Papirus-Dark (or Gruvbox-Plus-Dark AUR for a warmer match) |
| Cursor theme | Nordzy-cursors — clean, neutral |

---

## Implementation Mapping

Per-component hex-value tables and search-and-replace references have moved to `docs/implementation-guide.md`. This file covers the design language; the implementation guide covers where each value appears in each config.
````

- [ ] **Step 2: Verify the full document structure**

Run: `grep -c "^## " docs/style-guide.md`
Expected: `20` (section headers §1 through §20) plus `1` for "Implementation Mapping" footer = `21`.

Run: `grep -c "Black Glass" docs/style-guide.md`
Expected: `0`.

Run: `grep -c "Open Sans" docs/style-guide.md`
Expected: `0`.

- [ ] **Step 3: Commit**

```bash
git add docs/style-guide.md
git commit -m "docs(style-guide): add §§11-20 and close with implementation-mapping pointer"
```

---

## Task 5: Extend `docs/implementation-guide.md` with per-component tables

**Files:**
- Modify: `docs/implementation-guide.md` (append new sections)

- [ ] **Step 1: Append per-component tables**

Append the following to `docs/implementation-guide.md`:

````markdown

---

## Per-Component Application Tables

Ported from the previous `docs/style-guide.md`. These are the mechanical mappings — exact values per config file.

### Hyprland (`configs/hypr/hyprland.conf`)

| Property | Old (Catppuccin) | New (Disco Elysium) |
|----------|-----------------|---------------------|
| `border_size` | `2` | `1` |
| `col.active_border` | `rgb(89b4fa) rgb(cba6f7) 45deg` | `rgba(999a9566)` |
| `col.inactive_border` | `rgb(313244)` | `rgba(363b3a40)` |
| `rounding` | `8` | `2` |
| `shadow.color` | `rgba(1a1a2eee)` | `rgba(171b1aee)` |
| `blur.passes` | `2` | `3` |

**Rationale:** borders are subtle — the game's panels sit on the world with barely visible edges. Active border is a neutral muted hint, not a bright accent.

### Kitty (`configs/kitty/kitty.conf`)

Full 16-color terminal scheme:

| Property | Value |
|----------|-------|
| `background` | `#171b1a` |
| `foreground` | `#ccc8c2` |
| `cursor` | `#ccc8c2` |
| `cursor_text_color` | `#171b1a` |
| `selection_foreground` | `#171b1a` |
| `selection_background` | `#5bc0d6` |
| `color0` (black) | `#171b1a` |
| `color8` (bright black) | `#363b3a` |
| `color1` (red) | `#cb456a` |
| `color9` (bright red) | `#e05577` |
| `color2` (green) | `#0fb666` |
| `color10` (bright green) | `#3dcc88` |
| `color3` (yellow) | `#e3ba3e` |
| `color11` (bright yellow) | `#eece6e` |
| `color4` (blue) | `#5bc0d6` |
| `color12` (bright blue) | `#89d4e5` |
| `color5` (magenta) | `#7555c6` |
| `color13` (bright magenta) | `#9a7ed6` |
| `color6` (cyan) | `#4ba89a` |
| `color14` (bright cyan) | `#6fc2b4` |
| `color7` (white) | `#ccc8c2` |
| `color15` (bright white) | `#ebdbb2` |

**Notes:** cyan uses a synthesized muted teal (`#4ba89a`) distinct from intellect blue. Bright white uses Gruvbox's warm cream (`#ebdbb2`). Terminal red uses physique, magenta uses psyche, yellow uses motorics.

### Hyprlock (`configs/hypr/hyprlock.conf`)

**Background:**

| Property | Value |
|----------|-------|
| `brightness` | `0.5` |

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
| Greeting label `color` | `rgb(153, 154, 149)` |
| Greeting label `font_family` | `Archivo Narrow` |

### Starship (`configs/starship/starship.toml`)

| Section | Property | Value |
|---------|----------|-------|
| `[directory]` | `style` | `"bold #5bc0d6"` |
| `[git_branch]` | `style` | `"bold #7555c6"` |
| `[git_status]` | `style` | `"bold #eb6408"` |
| `[character]` | `success_symbol` | `"[>](bold #0fb666)"` |
| `[character]` | `error_symbol` | `"[>](bold #b83a3a)"` |

### Complete Replacement Table

Quick reference for mechanical search-and-replace implementation across all configs.

| File | Property | Value |
|------|----------|-------|
| `hyprland.conf` | `col.active_border` | `rgba(999a9566)` |
| `hyprland.conf` | `col.inactive_border` | `rgba(363b3a40)` |
| `hyprland.conf` | `rounding` | `2` |
| `hyprland.conf` | `shadow.color` | `rgba(171b1aee)` |
| `hyprland.conf` | `blur.passes` | `3` |
| `kitty/kitty.conf` | `foreground` | `#ccc8c2` |
| `kitty/kitty.conf` | `background` | `#171b1a` |
| `kitty/kitty.conf` | `cursor` | `#ccc8c2` |
| `kitty/kitty.conf` | `cursor_text_color` | `#171b1a` |
| `kitty/kitty.conf` | `selection_foreground` | `#171b1a` |
| `kitty/kitty.conf` | `selection_background` | `#5bc0d6` |
| `kitty/kitty.conf` | `color0`–`color15` | See Kitty section above |
| `hyprlock.conf` | `brightness` | `0.5` |
| `hyprlock.conf` | input `outer_color` | `rgb(91, 192, 214)` |
| `hyprlock.conf` | input `inner_color` | `rgb(23, 27, 26)` |
| `hyprlock.conf` | input `font_color` | `rgb(215, 215, 215)` |
| `hyprlock.conf` | input `check_color` | `rgb(15, 182, 102)` |
| `hyprlock.conf` | input `fail_color` | `rgb(184, 58, 58)` |
| `hyprlock.conf` | input `capslock_color` | `rgb(227, 186, 62)` |
| `hyprlock.conf` | time label `font_family` | `Playfair Display` |
| `hyprlock.conf` | greeting label `color` | `rgb(153, 154, 149)` |
| `starship.toml` | `[directory]` style | `"bold #5bc0d6"` |
| `starship.toml` | `[git_branch]` style | `"bold #7555c6"` |
| `starship.toml` | `[git_status]` style | `"bold #eb6408"` |
| `starship.toml` | `[character]` success | `"[>](bold #0fb666)"` |
| `starship.toml` | `[character]` error | `"[>](bold #b83a3a)"` |

### disco-shell (external repo — `RobbeDelporte/disco-shell`)

disco-shell provides all desktop widgets (bar, launcher, notifications, etc.). It is themed via SCSS. When reworking its theme to match this style guide:

- Drop any "black glass" tokens (`rgba(10, 12, 11, 0.78)`) — use the painted-canvas base `rgba(23, 27, 26, 0.88)` instead.
- Drop the cream left-border selection pattern in favour of the orange left-border selection from §12.
- Banner headers (§6) remain on functional panels (launcher, NC, QS) — that's the one motif allowed at Tier 2.
- No flares, film strips, or brush-stroke backgrounds on disco-shell surfaces (all Tier 2 or Tier 3).

This work lives in the disco-shell repo and is not part of this dotfiles rework.
````

- [ ] **Step 2: Verify the implementation guide grew the expected sections**

Run: `grep -c "^## Per-Component Application Tables\|^### Hyprland\|^### Kitty\|^### Hyprlock\|^### Starship\|^### Complete Replacement Table\|^### disco-shell" docs/implementation-guide.md`
Expected: `7`.

- [ ] **Step 3: Commit**

```bash
git add docs/implementation-guide.md
git commit -m "docs(implementation-guide): absorb per-component tables from style guide"
```

---

## Task 6: Final verification and cross-reference check

**Files:** read-only verification; no edits expected.

- [ ] **Step 1: Confirm black glass is gone from style-guide.md**

Run: `grep -n "Black Glass\|black-glass\|black glass" docs/style-guide.md`
Expected: no output (exit code 1).

- [ ] **Step 2: Confirm Open Sans Condensed is gone from style-guide.md**

Run: `grep -n "Open Sans" docs/style-guide.md`
Expected: no output (exit code 1).

- [ ] **Step 3: Confirm Archivo Narrow is in style-guide.md**

Run: `grep -c "Archivo Narrow" docs/style-guide.md`
Expected: a number ≥ `5`.

- [ ] **Step 4: Confirm each motif references at least one asset file**

Run:
```bash
for asset in film-strip-long single-page-content-bg Archive_3324d46e2 brush-bg-white feld-flash-flare frame-16-9 black-tapelet; do
  grep -q "$asset" docs/style-guide.md && echo "OK  $asset" || echo "MISS $asset"
done
```
Expected: seven `OK` lines, zero `MISS`.

- [ ] **Step 5: Confirm all referenced assets exist on disk**

Run:
```bash
for f in \
  references/disco-elysium/ui-assets/film-strip-long_a5hufh.png \
  references/disco-elysium/ui-assets/brush-bg-white_kkkkx7.png \
  references/disco-elysium/ui-assets/Archive_3324d46e2.png \
  references/disco-elysium/ui-assets/single-page-content-bg_htmvo8.png \
  references/disco-elysium/ui-assets/feld-flash-flare-0_cy51je.jpg \
  references/disco-elysium/ui-assets/feld-flash-flare-1_loooiz.jpg \
  references/disco-elysium/ui-assets/frame-16-9_iqf4jq.png \
  references/disco-elysium/ui-assets/frame-16-9-portrait_snwdsp.png \
  references/disco-elysium/ui-assets/black-tapelet_dysjoh.png; do
  test -f "$f" && echo "OK  $f" || echo "MISS $f"
done
```
Expected: all `OK`, zero `MISS`.

- [ ] **Step 6: Confirm tables removed from style-guide.md exist in implementation-guide.md**

Run: `grep -l "col.active_border" docs/*.md`
Expected: `docs/implementation-guide.md` only (NOT `docs/style-guide.md`).

Run: `grep -l "color0.*#171b1a" docs/*.md`
Expected: `docs/implementation-guide.md` only.

- [ ] **Step 7: Confirm CLAUDE.md link still resolves**

Run: `grep -n "style-guide" CLAUDE.md`
Expected: the existing entry `\`docs/style-guide.md\` | Disco Elysium visual design language...`. No section anchors referenced, so the link remains valid after restructuring.

- [ ] **Step 8: Final tag commit**

No source changes in this task. If all checks passed, move on. If any check failed, fix in place and amend the offending task's commit rather than amending here.

---

## Self-Review

**Spec coverage** — every spec section maps to a task:

- Spec §"Goals" 1 (restructure) → Tasks 2, 3, 4
- Spec §"Goals" 2 (surface tiers) → Task 2, §3
- Spec §"Goals" 3 (motifs folded in) → Task 3, §8
- Spec §"Goals" 4 (Archivo Narrow) → Task 1 (packages) + Task 2 (§5 typography)
- Spec §"Goals" 5 (decorative accent palette) → Task 2 (§4.3)
- Spec §"Goals" 6 (remove black glass) → Task 2 (§7 single surface system), Task 6 Step 1 (verify gone)
- Spec §"Goals" 7 (move tables out) → Task 5
- Spec §"Non-Goals" → respected; disco-shell rework noted in Task 5 as out-of-scope
- Spec §"Surface Tiers" table → Task 2, §3
- Spec §"Detailed Content Changes" → Tasks 2, 3, 4 reproduce each change verbatim
- Spec §"Success Criteria" → Task 6 verification steps 1–6

**Placeholder scan:** no TBDs, no "add appropriate error handling," no "similar to Task N" without content. Every `grep` command has expected output. Every file append is full content, not a reference.

**Type / name consistency:** token names match across spec and plan (`decor-cyan`, `decor-purple`, `decor-orange-hot`, `decor-brown`). Asset filenames match on-disk names (verified via `ls` earlier). Archivo Narrow spelled consistently. "Painted-canvas" hyphenation consistent.

**Known risk:** AUR package slugs (`ttf-archivo`, `ttf-libre-baskerville`) may not exist under those exact names. Task 1 Step 2 verifies and allows substitution with a note in the commit.
