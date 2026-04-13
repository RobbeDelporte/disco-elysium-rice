# Style Guide Rework — Design

Rework `docs/style-guide.md` to (a) integrate motifs surfaced by the official
website [discoelysium.com](https://discoelysium.com) and new reference assets
in `references/disco-elysium/ui-assets/`, (b) restructure the document into
clearer sections, and (c) make the desktop-rice translation rules explicit so
the dramatic new motifs don't degrade functional surfaces.

## Goals

1. Replace the current monolithic guide with a restructured document that
   separates design language from implementation mapping.
2. Introduce a **Surface Tiers** principle that scopes where dramatic motifs
   are allowed.
3. Fold in website-derived motifs: film-strip borders, brush-stroke
   backgrounds, radial halos, cinematic flares, layered offset CTAs, media
   frames.
4. Swap header typeface from Open Sans Condensed to **Archivo Narrow** (free
   substitute for the website's Dobra).
5. Add a **Decorative Accent Palette** from the website, scoped to ceremonial
   surfaces only. Keep the skill-tree functional palette canonical.
6. Remove the "Black Glass Design Language" section — it was an approximation
   and diverges from the true painted-canvas treatment.
7. Move per-component implementation tables out of the style guide into
   `docs/implementation-guide.md`.

## Non-Goals

- Re-theming disco-shell (separate repo). This spec defines the design
  language; updating disco-shell's SCSS to match is follow-up work.
- Reworking the functional skill-tree palette. It is pipetted, internally
  coherent, and stays canonical.
- Adding tilt/rotation motifs from the website. Explicitly excluded —
  functional desktop UI must not be rotated.

## Source Material Policy

Two sources inform the style guide:

- **The game itself** (skill tree, menus, dialogue, HUD) — source of truth
  for the **functional palette** and **core UI patterns**.
- **The official website** (discoelysium.com) — source of truth for
  **ceremonial motifs** and **decorative accents**.

When sources disagree: *game wins for function, website wins for ornament*.

## New Principle: Surface Tiers

Every surface in the rice falls into one of three tiers, which governs how
much decorative treatment it receives.

| Tier | Surfaces | Treatment |
|------|----------|-----------|
| **1. Ceremonial** | Splash, lockscreen, power menu, overview, wallpaper picker | Full painted treatment. Film strips, flares, brush-stroke backgrounds, radial halos, layered CTAs, media frames all allowed. |
| **2. Functional** | Launcher, notification center, quick settings, keybinds panel | Painted-canvas base + banner headers. ONE restrained motif per panel (banner erosion; optional thin media frame). No flares, no film strips, no brush-stroke backgrounds. |
| **3. Ambient** | Status bar, toasts/notifications, tooltips | Clean, restrained. Banner allowed as active-item indicator. No decorative motifs. |

**Rationale:** motifs carry weight. Putting them everywhere turns signal into
noise; reserving them for moments when you're *not* trying to get work done
preserves both utility and drama.

## Document Structure

Section order for the new `docs/style-guide.md`:

1. **Design Philosophy** — six existing principles + a seventh: "Surface
   tiers govern decorative weight."
2. **Source Material** — game vs. website policy above.
3. **Surface Tiers** — the table above, expanded with examples.
4. **Color**
   - 4.1 Functional Palette (dark) — pipetted from skill tree. Unchanged.
   - 4.2 Light Theme "Tequila Sunset" — unchanged.
   - 4.3 Decorative Accent Palette — website-derived, ceremonial only.
5. **Typography** — Archivo Narrow replaces Open Sans Condensed.
6. **The Banner Header** — unchanged. Shared motif; allowed on all tiers.
7. **Painted-Canvas Surfaces** — single unified surface system.
8. **Decorative Motifs** — NEW section, one subsection per motif with scope.
9. **Borders & Dividers** — unchanged.
10. **Buttons** — Primary/Secondary unchanged; NEW Ceremonial CTA variant.
11. **Menu / Navigation** — unchanged.
12. **Selection Indicators** — unchanged. Black-glass cream left-border
    variant removed.
13. **Selection (row/text)** — unchanged.
14. **Dialogue / Speaker Pattern** — unchanged.
15. **Check Success / Failure** — unchanged.
16. **Stat / Numeric Displays** — unchanged.
17. **Icons** — unchanged.
18. **Interaction & Motion** — unchanged.
19. **Eroded Edge Usage** — unchanged.
20. **Wallpaper & GTK Theme** — unchanged.

### Removed from the style guide

- **Black Glass Design Language** section — deleted entirely. The
  painted-canvas surface system (§7) is now the one panel treatment.
- **Per-Component Application** section — moved to
  `docs/implementation-guide.md`.
- **Complete Replacement Table** — moved to `docs/implementation-guide.md`.

## Detailed Content Changes

### §1 Design Philosophy — add a seventh principle

> **7. Surface tiers govern decorative weight.** Ceremonial surfaces
> (lockscreen, splash, power menu, overview) take the full painted treatment.
> Functional surfaces (launcher, notification center, quick settings) get one
> restrained motif. Ambient surfaces (bar, toasts) stay clean.

### §4.3 Decorative Accent Palette (NEW)

Scoped to Tier 1 ceremonial surfaces only. Not used in terminal themes,
Hyprland borders, or functional panels.

| Token | Name | Hex | Role |
|-------|------|-----|------|
| `decor-cyan` | Signal Cyan | `#7effaa` | Ceremonial focus outline (lockscreen input), layered-CTA middle layer |
| `decor-purple` | Broadcast Purple | `#7b61ff` | Layered-CTA backing layer, splash accents |
| `decor-orange-hot` | Flare Orange | `#e55023` | Flare/bokeh tint, ceremonial emphasis |
| `decor-brown` | Old Signage | `#90270f` | ≈ existing `button-primary`; documents website equivalence |

Note: `decor-brown` is nearly identical to the existing `button-primary`
(`#912711`). Listed for documentation; implementations should continue to
use `button-primary`.

### §5 Typography — font swap

| Tier | Old | New | Notes |
|------|-----|-----|-------|
| Header | Open Sans Condensed 700 | **Archivo Narrow 700** | AUR: `ttf-archivo` (via Google Fonts). Semi-condensed humanist grotesque, close to the website's Dobra. |
| Label | Open Sans Condensed 700 | **Archivo Narrow 700** | Same family. |
| Body | Libre Baskerville | Libre Baskerville | Unchanged. |
| Display | Playfair Display | Playfair Display | Unchanged (lockscreen time). |
| Code | JetBrains Mono NF | JetBrains Mono NF | Unchanged. |

**Dobra swap path:** Dobra is proprietary but licensed for non-commercial
use. For personal rice use it may be substituted for Archivo Narrow
1:1 — same roles, same weights. The style guide documents this as an
optional upgrade.

### §7 Painted-Canvas Surfaces

Replaces the two-system "base palette + black glass" structure with one
unified surface system.

| Surface | Color | Use |
|---------|-------|-----|
| Primary panel | `rgba(23, 27, 26, 0.88)` | All tiers — wallpaper breathes through |
| Opaque base | `#171b1a` | Where full opacity is required |
| Elevated | `#1e2221` | Cards, input fields |
| Hover | `#282c2b` | Hover states |
| Deep black | `#101312` | Stat blocks |

**Grain texture** (existing): warm-tinted SVG feTurbulence, 25% opacity,
soft-light blend. Applied to all tier 1 and optionally tier 2.

**Brush-stroke background variant** (NEW): painterly dark surface layer
using `references/disco-elysium/ui-assets/single-page-content-bg_htmvo8.png`
or `Archive_3324d46e2.png` as a CSS `background-image`, sitting above the
base panel color. **Tier 1 only.**

### §8 Decorative Motifs (NEW)

One subsection per motif. Each subsection specifies: visual description,
allowed tier, when to use, when *not* to use, asset reference.

#### 8.1 Film-strip Borders

Horizontal strip with sprocket perforations, top and bottom edges of a
ceremonial surface.

- **Tier:** 1 only.
- **Asset:** `references/disco-elysium/ui-assets/film-strip-long_a5hufh.png`
- **Use on:** splash screen, lockscreen (optional), overview full-screen
  view.
- **Do not use on:** anything functional. Do not tile on the bar.

#### 8.2 Brush-stroke Backgrounds

Painterly dark surface with visible brush marks, behind the primary panel.

- **Tier:** 1 only.
- **Assets:** `brush-bg-white_kkkkx7.png` (light variant — for inverted
  banner-style surfaces), `Archive_3324d46e2.png` (dark variant).
- **Use on:** ceremonial hero surfaces.
- **Do not use on:** launcher, NC, QS, bar.

#### 8.3 Radial Halos

Soft dark radial gradient behind text to guarantee legibility over busy
wallpaper.

- **Tier:** any.
- **Recipe:** `radial-gradient(ellipse at center, rgba(16,19,18,0.85) 0%,
  transparent 70%)`, placed behind headlines sitting directly on the
  wallpaper.
- **Use on:** lockscreen time/greeting, overview labels, splash title.

#### 8.4 Cinematic Flares & Bokeh

Warm amber flares, lens bokeh.

- **Tier:** 1 only.
- **Asset:** `feld-flash-flare-0_cy51je.jpg`, `feld-flash-flare-1_loooiz.jpg`
- **Use on:** splash, lockscreen background accent, power-menu background.
- **Do not use on:** any surface with dense information.

#### 8.5 Layered Offset CTAs

Primary confirm button with 2–3 stacked color blocks behind it, slightly
offset and rotated 0° (no tilt — we rejected tilts).

- **Tier:** 1 only.
- **Recipe:** main button on top; `::before` pseudo-element offset +6px/+6px
  `decor-cyan`; `::after` pseudo-element offset +12px/+12px `action`
  (orange). Drop-shadow 4px 20% black.
- **Use on:** power menu "SHUT DOWN", confirm dialogs "OK".
- **Do not use on:** secondary buttons, lists, dense UI.

#### 8.6 Media Frames

Painted dark frames around images/thumbnails.

- **Tier:** 1–2.
- **Assets:** `frame-16-9_iqf4jq.png` (landscape),
  `frame-16-9-portrait_snwdsp.png` (portrait), `black-tapelet_dysjoh.png`
  (slim).
- **Use on:** overview thumbnails, notification images, wallpaper picker
  tiles.

### §10 Buttons — add Ceremonial CTA row

| Type | Background | Text | Border | Notes |
|------|-----------|------|--------|-------|
| Primary | `#912711` | `#ccc8c2` cond. bold upper | None | Existing |
| Secondary | `#1e2221` | `#999a95` cond. bold upper | `1px solid rgba(54,59,58,0.5)` | Existing |
| **Ceremonial CTA** | `#912711` + layered offsets | `#ccc8c2` | None | Tier 1 only (§8.5) |

## Migration Notes

Consequences of this rework that surface in downstream work (not this spec):

- **disco-shell SCSS** references black-glass tokens and cream-left-border
  selection. These will need re-theming against the painted-canvas surface
  system. Out of scope here; tracked as follow-up.
- **`docs/implementation-guide.md`** grows to absorb the per-component tables
  moved out of the style guide. The plan spec will define what moves where.
- **Font packages**: `ttf-opensans` stays (still used elsewhere?); add
  `ttf-archivo` to `packages/pacman.txt` or `packages/aur.txt` depending on
  which repo carries it.
- **Mockups** (`docs/mockups/*.html`, `docs/style-overview.html`) reflect
  the old guide. They'll need regeneration to show surface tiers, motif
  scope, and Archivo Narrow. Tracked as follow-up.

## Open Questions

- None blocking. Decisions locked in brainstorming:
  - Archivo Narrow now, Dobra swap path documented.
  - Skill-tree palette canonical, website accents decorative-only.
  - Black glass deleted.
  - Tilts explicitly rejected.
  - Motifs 1, 2, 3, 4, 6, 7, 8, 9 from the website adopted; 5 (tilts)
    rejected.

## Success Criteria

- `docs/style-guide.md` rewritten with the section order above.
- No mention of "Black Glass" remains in the style guide.
- Per-component tables live in `docs/implementation-guide.md`, not the
  style guide.
- Each decorative motif subsection references at least one concrete asset
  in `references/disco-elysium/ui-assets/`.
- Surface tier rules are stated clearly enough that a reader can answer
  "can I put a film strip on the bar?" by looking at the guide alone.
- Typography table lists Archivo Narrow with the Dobra swap path noted.
