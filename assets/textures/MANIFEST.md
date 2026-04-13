# Asset Textures Manifest

Runtime textures for disco-shell. All files are copies of originals in
`references/disco-elysium/ui-assets/`, renamed to canonical, stable filenames.
disco-shell loads these via paths relative to the installed asset root; do not
rename without updating disco-shell's resource paths.

## Origin

All textures except `brush-bg-dark.png` are pulled from
[discoelysium.com](https://discoelysium.com)'s Cloudinary asset store. Originals
are kept in `references/disco-elysium/ui-assets/` with their upstream hash
suffixes for provenance; copies here are renamed for stability.

## Texture index

| Canonical filename | Source | Kind | Primary use |
|--------------------|--------|------|-------------|
| `single-page-content-bg.png` | `single-page-content-bg_htmvo8.png` | Portrait brush backdrop | Info Panel + Launcher side-page backing texture |
| `brush-bg.png` | `brush-bg_tzvypl.png` | Horizontal black brush strip with painterly edges | Header banner background on Tier 1 surfaces |
| `brush-bg-white.png` | `brush-bg-white_kkkkx7.png` | Horizontal white brush strip with painterly edges | Inverted banners; light-content ceremonial surfaces |
| `brush-bg-dark.png` | `Archive_3324d46e2.png` | Larger dark painterly field | Full-screen hero backdrop (Overview) |
| `film-tape-bottom.png` | `film-tape-bottom_pqzkmm.png` | Film tape strip with sprocket edge + frame metadata text | Top and bottom film edges on Ceremonial surfaces (Power Menu, Overview). Flip vertically for top edge. |
| `film-strip-long.png` | `film-strip-long_a5hufh.png` | Simpler film strip with sprocket perforations | Legacy; kept as an alternate film motif. Prefer `film-tape-bottom.png` for new work. |
| `flare-0.jpg` | `feld-flash-flare-0_cy51je.jpg` | Warm amber lens flare | Lockscreen / splash atmospheric overlay |
| `flare-1.jpg` | `feld-flash-flare-1_loooiz.jpg` | Warm amber lens flare alternate | Lockscreen / splash atmospheric overlay |
| `frame-16-9.png` | `frame-16-9_iqf4jq.png` | Landscape painted frame | Overview thumbnails, Switcher thumbnails (frames real images, not panels) |
| `frame-16-9-portrait.png` | `frame-16-9-portrait_snwdsp.png` | Portrait painted frame | Portrait image/wallpaper preview surrounds (frames real images, not panels) |
| `tapelet.png` | `black-tapelet_dysjoh.png` | Slim decorative black strip | Notification Toast top-edge decoration |
| `nav-bg.png` | `main-navigation-bg_pc8u1d.png` | Horizontal dark brush bar | Horizontal nav/bar surfaces if ever needed |
| `close-button.png` | `close-button_ocmdtj.png` | Painted red X on painterly square | Close / dismiss button glyph |
| `button-arrow.png` | `button-arrow_zwfkur.png` | Painted red right-pointing triangle | Play / forward / continue button glyph |

## Conventions

- **Frames** (`frame-16-9*.png`) are intended to surround **images**, not text
  panels. Do not use them as CSS panel chrome — their painted edges only read
  correctly when the frame surrounds photographic content.
- **Brush backdrops** (`brush-bg*.png`) tile horizontally well; do not stretch
  vertically.
- **Film edges** (`film-tape-bottom.png`) belong at the extreme top or bottom
  of a Ceremonial surface. Use the same asset for both edges, flipping the top
  instance vertically.
- **Flares** (`flare-*.jpg`) are photographic — composite with
  `mix-blend-mode: screen` at low opacity, not as primary backgrounds.

## Not currently staged

Reference-only assets in `references/disco-elysium/ui-assets/` that are not
used by any widget spec yet. Kept for future widgets or visual study.

| Reference file | Possible use |
|----------------|-------------|
| `Purchase-blur.png` | Blurred backdrop candidate for Overview or wallpaper picker |

If a widget spec introduces one of these, stage it into this directory with a
canonical name and add a row to the texture index above.
