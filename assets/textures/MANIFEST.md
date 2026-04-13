# Asset Textures Manifest

Runtime textures for disco-shell. All files are copies of originals in
`references/disco-elysium/ui-assets/`, renamed to canonical, stable filenames.
disco-shell loads these via paths relative to the installed asset root; do not
rename without updating disco-shell's resource paths and sweeping
`docs/widgets/` + `docs/mockups/widgets/`.

## Origin

All textures except `brush-field.png` are pulled from
[discoelysium.com](https://discoelysium.com)'s Cloudinary asset store and a
deep scrape of its subpages (home, features, buy-now, devblog, media,
disco-mobile, press, about, game). Originals are kept in
`references/disco-elysium/ui-assets/` with their upstream hash suffixes for
provenance; the copies here are renamed for stability.

`brush-field.png` was sourced separately (no upstream Cloudinary equivalent
found); see `references/disco-elysium/ui-assets/Archive_3324d46e2.png`.

## Naming scheme

- `*-bg.png` — full-surface backings (portrait-tiling or single-fill).
- `*-strip.png` — horizontal bars (tile horizontally).
- `*-field.png` — large non-tiling dark fields.
- `*-tape.png` — film tape.
- `*-edge.png` / `*-strip.png` — narrow decorative edges.
- `frame-*.png` — frames around media (not panel chrome).
- `flare-*.jpg` — photographic atmospheric overlays.
- Interactive glyphs use descriptive names (`close-x.png`, `play-arrow.png`).

## Texture index

| Canonical | Reference | Kind | Primary use |
|-----------|-----------|------|-------------|
| `page-bg.png` | `single-page-content-bg_htmvo8.png` | Portrait brush backdrop | Info Panel + Launcher side-page backing (vertical tile) |
| `brush-strip.png` | `brush-bg_tzvypl.png` | Horizontal black brush strip, painterly edges | Banner / header backgrounds on Tier 1 surfaces |
| `brush-strip-white.png` | `brush-bg-white_kkkkx7.png` | Horizontal white brush strip, painterly edges | Inverted banners; light ceremonial surfaces |
| `brush-field.png` | `Archive_3324d46e2.png` | Large dark painterly field | Full-screen hero backdrop (Overview) |
| `film-tape.png` | `film-tape-bottom_pqzkmm.png` | Film tape strip, sprocket edge + REEL text | Top + bottom edges on Ceremonial surfaces (Power Menu, Overview). Flip vertically for the top edge. |
| `film-strip.png` | `film-strip-long_a5hufh.png` | Simpler film strip with sprocket perforations | Legacy / alternate. Prefer `film-tape.png`. |
| `scratch-bg.png` | `scratch-bg_afhtpy.png` | Dark scratched / specked film-grain texture | Universal noise overlay (low opacity) |
| `nav-strip.png` | `main-navigation-bg_pc8u1d.png` | Horizontal dark brush bar | Horizontal nav/bar surfaces if ever added |
| `edge-strip.png` | `black-tapelet_dysjoh.png` | Slim decorative black strip | Notification Toast top-edge decoration |
| `flare-a.jpg` | `feld-flash-flare-0_cy51je.jpg` | Warm amber lens flare | Lockscreen / splash atmospheric overlay (blend mode: screen) |
| `flare-b.jpg` | `feld-flash-flare-1_loooiz.jpg` | Warm amber lens flare alternate | Same as flare-a |
| `frame-landscape.png` | `frame-16-9_iqf4jq.png` | 16:9 painted frame | Overview thumbnails, Switcher thumbnails (frames real images — not panels) |
| `frame-portrait.png` | `frame-16-9-portrait_snwdsp.png` | Portrait painted frame | Portrait image/wallpaper preview surrounds (frames real images — not panels) |
| `close-x.png` | `close-button_ocmdtj.png` | Painted red X glyph | Close / dismiss button icon |
| `play-arrow.png` | `button-arrow_zwfkur.png` | Painted red triangular arrow | Play / forward / continue button icon |

## Conventions

- **Frames** (`frame-*.png`) are meant to surround **images**, not text panels.
  Their painterly edges only read correctly when they frame photographic content.
- **Brush strips** tile horizontally well; do not stretch vertically.
- **Film tape** belongs at the extreme top or bottom of a Ceremonial surface.
  Reuse the same asset for both edges — flip the top instance vertically.
- **Flares** are photographic. Composite with `mix-blend-mode: screen` at low
  opacity, never as primary backgrounds.
- **Scratch-bg** is a grain overlay — apply at ~15–25% opacity with blend mode
  `overlay` or `soft-light`. Never as a base color.

## Not currently staged

Reference-only assets in `references/disco-elysium/ui-assets/` that are not
used by any widget spec yet. Kept for future widgets or visual study.

| Reference file | Possible use |
|----------------|-------------|
| `Purchase-blur.png` | Blurred backdrop candidate for Overview / wallpaper picker |
| `menu-toggle_szzcls.png` | Mobile-nav toggle corner decoration — likely not needed in a tiling WM rice |

If a widget spec introduces one of these, stage it into this directory with a
canonical name and add a row to the texture index above.
