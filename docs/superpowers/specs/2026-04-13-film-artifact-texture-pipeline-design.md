# Film-Artifact Texture Pipeline — Design

**Date:** 2026-04-13
**Status:** Spec
**Scope:** Shared texture assets for the Disco Elysium rice. Generic, use-site agnostic.

## Motivation

The current theme reads as too dark, monotone, and flat. Flat hex-fill surfaces are missing the painterly, worn quality that defines the Disco Elysium visual language. The reference image `references/disco-elysium/menu3.jpg` — specifically the backdrop behind the postcard on the right — captures the target: a dark teal surface with silver-halide grain, warm halation bleeding in from the edge, faint vertical scratches, and a soft vignette. The dominant character comes not from color grading but from **film artifacts** overlaid on a simple surface.

Procedural SVG noise (`feTurbulence`) does not reach this quality, and runtime generation is not available anyway: GTK4 CSS and GPUI both require pre-rendered raster assets.

## Goal

A deterministic, reproducible pipeline that produces film-artifact PNG textures from a declarative config. Textures are produced once at build time and shipped as repo assets, consumed by any downstream surface (disco-shell widgets, hyprlock, future components) without the pipeline needing to know where they are used.

## Non-Goals

- Color palette changes to `docs/style-guide.md`
- Banner SVG changes or wallpaper swaps
- Runtime effects (shaders, live filters)
- Wiring specific widgets beyond the launcher integration contract (deferred to consumer specs)
- Hyprland/lockscreen/idle texture adoption (deferred)

## Design

### Location and Ownership

All texture assets and the generator live in the **rice repo** (`disco-elysium-rice`), not in `disco-shell`. The pipeline is consumer-agnostic: it produces named PNG files at specified dimensions. Downstream projects reference them by path or copy them into their own asset directories as needed.

```
disco-elysium-rice/
  assets/
    textures/
      textures.toml          # declarative config (one table per texture)
      .gitkeep
      <generated>.png        # build output, gitignored by default
  scripts/
    build-textures.sh        # G'MIC CLI wrapper
```

**Rationale for generating into the repo:** textures are small (a few hundred KB each), deterministic, and useful to inspect in PRs. An alternative is to gitignore outputs and rebuild on install; we commit outputs so consumers can reference them directly without a build step.

### Pipeline

Single shell script `scripts/build-textures.sh` driving **G'MIC CLI** (`pacman -S gmic`). G'MIC has the full artifact set (grain, halation, light leaks, scratches, vignette, chromatic aberration) as first-class filters. No custom image math.

**Invocation:**

```
scripts/build-textures.sh            # build all textures in textures.toml
scripts/build-textures.sh launcher   # build a single texture by name
```

The script:
1. Parses `assets/textures/textures.toml`.
2. For each entry, generates a solid-fill base at the requested dimensions.
3. Applies the configured G'MIC filter stack.
4. Writes `assets/textures/<name>.png`.
5. Logs a manifest line per output (name, dimensions, size, hash).

### Config Format

`assets/textures/textures.toml`:

```toml
[launcher]
width = 500
height = 420
base_color = "#1a2d2f"

[launcher.halation]
enabled = true
color = "#eb6408"
strength = 0.55       # 0..1, screen-blend opacity
origin = "top-right"  # top-left | top-right | bottom-left | bottom-right | center
radius = 0.7          # fraction of max(width, height)

[launcher.grain]
enabled = true
iso = 800             # maps to G'MIC grain scale
opacity = 0.25        # multiply-blend opacity
monochrome = true

[launcher.scratches]
enabled = true
density = 0.08        # 0..1
opacity = 0.10
orientation = "vertical"

[launcher.vignette]
enabled = true
strength = 0.35       # 0..1
```

Each section maps 1:1 to a G'MIC filter invocation. Omitted sections are skipped. Unknown top-level keys error loudly to prevent silent drift.

### Artifact Stack (order is load-bearing)

1. **Base fill** — `gmic … -fill <hex>` at `<width>,<height>`.
2. **Halation** — screen-blend a radial gradient (warm color) weighted toward the configured origin. G'MIC: `fx_light_relief` or a `gradient` + `blend screen` composite.
3. **Grain** — monochrome silver-halide noise, multiply blend. G'MIC: `fx_grain <preset>` with ISO→preset mapping.
4. **Scratches** — vertical noise lines, screen blend. G'MIC: `fx_scratches` or generated line overlay.
5. **Vignette** — radial darkening, multiply blend. G'MIC: `fx_vignette`.

Order matters: halation lives "in" the image (below grain), grain sits on the photographic surface, scratches are on the emulsion surface (above grain), vignette is an optical property (outermost, multiplied last).

### Launcher Integration Contract (reference consumer)

This spec does not modify `disco-shell` code, but defines the contract a consumer follows. Documented here so the first consumer spec has a known-good path.

- Consumer references `assets/textures/launcher.png` by copying or path-referencing.
- Rendered as an `img()` element behind the existing launcher container contents.
- Texture dimensions match the launcher panel (500×420 per current design).
- Glass overlay (`rgba(10,12,11,0.88)`) stays — now rendered **over** the texture rather than alone, so the panel reads as "painted surface under dim glass" rather than "flat dark panel". Overlay opacity is tunable per-widget in the consuming crate; not part of this pipeline.
- Borders, banner, and result rows are unchanged.

### Reproducibility

- G'MIC `srand <seed>` for every stochastic filter, seed derived from texture name (stable hash). Rebuilds are byte-identical on the same G'MIC version.
- `build-textures.sh` writes a `manifest.txt` with name, dimensions, file size, and SHA-256 per output, committed to the repo. Reviewers can diff the manifest to see texture changes without viewing binary PNGs.

### Dependencies

Added to `packages/pacman.txt`:
- `gmic` (pacman) — CLI image processor

Install script (`scripts/install.sh`) does not need changes; `build-textures.sh` is run manually when tuning textures.

## Risks and Trade-offs

- **G'MIC CLI surface is large and changes rarely but can change.** Mitigation: pin expected G'MIC major version in the script; fail fast with a clear error if the version differs.
- **Tuning by config alone can be slow.** Iteration requires running the script and reloading consumers. Mitigation: the script accepts a single texture name for fast rebuilds; the HTML mockup companion (brainstorming visual server) is not part of this pipeline but remains useful for pre-validation.
- **Committed binary outputs bloat git history over time.** Mitigation: textures are small (~50–300 KB); if history grows, switch to gitignoring outputs and running the build in CI/install.
- **"Too noisy" — artifacts compete with widget content.** Mitigation: per-texture opacity knobs; the consumer-side glass overlay provides a second damping layer. The first launcher iteration will deliberately start subtle and tune up.

## Open Questions

None blocking. The following are deferred to future specs:

- Which widgets beyond the launcher adopt textures, and in what order.
- Whether hyprlock / wallpaper gain texture variants.
- Whether to generate per-widget texture variants (different seeds) vs. reuse one texture across similar widgets.

## Acceptance Criteria

1. `scripts/build-textures.sh` exists, executable, invokable with or without a texture-name argument.
2. `assets/textures/textures.toml` exists with at least a `[launcher]` entry using the defaults from this spec.
3. Running the script produces `assets/textures/launcher.png` at 500×420 with visible halation, grain, scratches, and vignette layered over the base color.
4. Re-running the script produces a byte-identical output (same G'MIC version).
5. `manifest.txt` exists in `assets/textures/` and lists each generated texture.
6. `packages/pacman.txt` includes `gmic`.
7. A side-by-side comparison against `references/disco-elysium/menu3.jpg` shows the launcher texture reading in the same aesthetic family (subjective, reviewed by user).
