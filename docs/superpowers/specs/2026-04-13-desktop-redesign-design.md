# Desktop Redesign — Design Spec

Redesign the overall desktop layout to embody the Disco Elysium aesthetic
(website-driven) rather than paint a conventional tiling-WM skeleton in its
colors. The rest state is wallpaper + windows only; all UI surfaces are
summoned on demand.

This spec is paired with the earlier style-guide rework
(`docs/superpowers/specs/2026-04-13-styleguide-rework-design.md`). The
style guide defines the *language*; this spec defines the *system*.

## Goals

1. Remove all always-on desktop shell (no persistent bar, no visible corner
   widget). The desktop's rest state is wallpaper only.
2. Define a small, consistent vocabulary of summoned surfaces with shared
   visual treatment built from the website-derived assets.
3. Make "summon → act → dismiss" fast enough that nothing-always-on doesn't
   hurt daily use.
4. Treat each summoned surface as a ceremonial moment — the aesthetic
   appears *because* the user summoned it.

## Non-Goals

- Replacing Hyprland as the compositor. The desktop still runs Hyprland; the
  redesign is about what disco-shell renders on top.
- Implementing the redesign in disco-shell. This spec defines the design;
  implementation lives in the disco-shell repo and is follow-up work.
- Reworking notifications beyond a minimal toast. Notification history,
  grouping, and the notification center are explicitly out of scope for this
  pass.
- Keybinds help panel, wallpaper picker, emoji picker, calculator as a
  standalone widget. The launcher absorbs these categories where relevant.

## The Three States

Every moment of the desktop is in one of three states:

| State | What's on screen | Transition |
|-------|------------------|------------|
| **Rest** | Wallpaper + windows. Nothing else. | Default. |
| **Peek** | One side-page wing visible (info OR launcher). Windows remain interactive behind it. | Summoned by keybind, dismissed by Esc / click-away. |
| **Ceremonial** | Full-screen moment (power menu, lockscreen, overview, switcher). Focus captured. | Summoned by keybind, dismissed by action or Esc. |

Peek and Ceremonial are not mutually exclusive with each other — both wings can coexist, but a Ceremonial surface over a Peek dismisses the Peek.

## The Vocabulary

Eight surfaces. Each has a fixed shape, a fixed summon mechanism, and
belongs to one of the three states above.

### 1. Info Panel — Peek (left side-page)

- **Summon:** `Super + .`
- **Shape:** 200px-wide column slide-in from left edge, full height.
- **Surface:** painted-canvas base + `single-page-content-bg_htmvo8.png`
  as background texture. Left-edge shadow into the rest of the screen.
- **Contents (top → bottom):**
  - Banner header: "SYSTEM"
  - Time (Playfair Display) + date (Archivo Narrow label)
  - Divider
  - Status grid: battery, volume, wifi, bluetooth
  - Divider
  - Workspaces (diamond indicators, active cream + glow)
  - Divider
  - Media playing (Libre Baskerville title + Archivo Narrow label)
  - Divider
  - Power button (opens Power Menu — §3)
- **Dismissal:** Esc, click outside, or Super+. again (toggle).

### 2. Launcher — Peek (right side-page)

- **Summon:** `Super + /`
- **Shape:** 200px-wide column slide-in from right edge, full height.
- **Surface:** same as Info Panel (mirrored) — painted-canvas base +
  `single-page-content-bg_htmvo8.png`, right-edge shadow.
- **Contents (top → bottom):**
  - Banner header: "SEARCH" (or current mode name when a mode is active)
  - Search input line with orange cursor glyph
  - Mode indicator row (current mode highlighted, others shown faintly)
  - Results list — each result row:
    - Selected: 3px orange left-border + `rgba(40, 44, 43, 0.4)` bg, text
      Archivo Narrow uppercase
    - Unselected: muted text, no border
  - Hints footer: `↵ launch · ⇥ next mode · ESC close`
- **Modes** (inherited from disco-shell's existing launcher design):
  apps, windows, clipboard, calculator, files, bash.
- **Dismissal:** Esc, click outside, or Super+/ again. Ceremonial surfaces
  (power menu, overview, switcher) dismiss the launcher on open.

### 3. Power Menu — Ceremonial

- **Summon:** `Super + Shift + Esc`, OR clicking the power button inside
  the Info Panel.
- **Shape:** centered painted panel, ~320px wide, on a dimmed wallpaper.
  Film-strip frames at top and bottom of the screen
  (`film-strip-long_a5hufh.png`).
- **Surface:** painted-canvas base + `brush-bg-white_kkkkx7.png`
  optional hero background. Banner header overhang "END SESSION".
- **Contents:**
  - Primary CTA "SHUT DOWN" — rendered with the **Layered Offset CTA**
    treatment from the style guide (§8.5): `#912711` main layer, cyan
    offset, orange offset. No tilt.
  - Secondary grid (2×2): RESTART, LOG OUT, LOCK, SLEEP — plain Secondary
    button style from the style guide.
- **Dismissal:** Esc, click outside, or actioned button.

### 4. Lockscreen — Ceremonial

- **Summon:** `Super + Esc`, OR Hypridle timeout.
- **Implementation:** Hyprlock (existing). Config already applied.
- **Surface:** full-screen, wallpaper brightness 0.5, optional flare asset
  (`feld-flash-flare-0_cy51je.jpg`) composited as a subtle lower-right
  overlay at low opacity.
- **Contents (top → bottom):**
  - Time in Playfair Display with radial halo behind
  - Greeting in Archivo Narrow Bold, muted color
  - Input field framed with `rgb(91, 192, 214)` outer color, dark fill
- **Dismissal:** correct password.

### 5. Overview — Ceremonial

- **Summon:** `Super + Tab`
- **Shape:** full-screen. Brush-stroke dark background
  (`Archive_3324d46e2.png`), film-strip frames top and bottom.
- **Contents:** grid of window thumbnails, each framed with
  `frame-16-9_iqf4jq.png`. Active window highlighted with orange
  left-border on its frame. Workspace labels beneath each group
  (Archivo Narrow uppercase, diamond indicators).
- **Dismissal:** click a thumbnail, Enter on selected, Esc to cancel.

### 6. Switcher (Alt+Tab) — Ceremonial

- **Summon:** `Alt + Tab`, hold to cycle.
- **Shape:** horizontal strip centered on screen, each window a small
  thumbnail framed with `frame-16-9_iqf4jq.png`. Dimmed background
  overlay behind.
- **Contents:** visible windows in MRU order, current selection highlighted
  with banner header showing its title above the strip.
- **Dismissal:** release Alt.

### 7. OSD (Volume / Brightness) — Peek (ephemeral)

- **Summon:** hardware key press (XF86AudioRaiseVolume, XF86MonBrightnessUp,
  etc.). Fully transient — never summoned by a user-bound keybind.
- **Shape:** small toast near bottom-center, ~240×60px. Painted-canvas
  surface, banner header showing the property name ("VOLUME", "BRIGHTNESS"),
  horizontal bar underneath, muted label below.
- **Bar styling:** 2px solid `#363b3a` base, filled portion
  `#5bc0d6` (intellect blue) for volume, `#e3ba3e` (motorics yellow) for
  brightness. This is an intentional use of the functional palette.
- **Dismissal:** auto-fade after ~1.5s of no further key events.

### 8. Notification Toast — Peek (ephemeral)

- **Summon:** auto, on notification event.
- **Shape:** small frame at top-right corner, ~320×80px. Uses
  `black-tapelet_dysjoh.png` as a slim decorative strip at the top edge of
  each card.
- **Contents:** app name (Archivo Narrow uppercase, muted), body (Libre
  Baskerville). Critical notifications get orange left-border (`#eb6408`),
  errors get red (`#b83a3a`).
- **Dismissal:** auto-fade after configured timeout, click to dismiss, or
  click to open the source app where applicable.

### Summary Table

| # | Surface | State | Summon | Primary Motif |
|---|---------|-------|--------|---------------|
| 1 | Info Panel | Peek | `Super + .` | Left side-page |
| 2 | Launcher | Peek | `Super + /` | Right side-page |
| 3 | Power Menu | Ceremonial | `Super + Shift + Esc` / button in Info | Centered + film strip + layered CTA |
| 4 | Lockscreen | Ceremonial | `Super + Esc` / idle | Full-screen brush + flare |
| 5 | Overview | Ceremonial | `Super + Tab` | Full-screen brush + 16:9 frames |
| 6 | Switcher | Ceremonial | `Alt + Tab` | Centered strip of 16:9 frames |
| 7 | OSD | Peek (ephemeral) | Hardware keys | Small painted toast |
| 8 | Notification | Peek (ephemeral) | Event-driven | Small top-right frame |

## Keybind Budget

The full user-facing keybind list introduced by this spec:

| Bind | Action |
|------|--------|
| `Super + /` | Launcher (toggle) |
| `Super + .` | Info Panel (toggle) |
| `Super + Esc` | Lock screen |
| `Super + Shift + Esc` | Power menu |
| `Super + Tab` | Overview |
| `Alt + Tab` | Switcher |

Preserved from existing config: `Super + T` (terminal), Hyprland's
`Super + 1..9` workspace switching, and any existing
window-management keybinds unchanged. Existing bindings that currently open
the old bar/launcher/etc. will be updated during implementation.

## Shared Design Recipes

The repeated visual techniques. Implementation in the disco-shell repo
will reference these by name.

### Side-page surface

- Background: base panel `rgba(23, 27, 26, 0.88)` with
  `single-page-content-bg_htmvo8.png` composited at ~60% opacity, soft-light
  blend.
- Left (or right) edge shadow: `box-shadow: ±8px 0 32px rgba(0, 0, 0, 0.7)`.
- Inner padding: 16px vertical, 14px horizontal.
- Width: 200–220px default, configurable.

### Banner overhang

As defined in style guide §6. Banner anchors top-left corner, hangs
-8px / -10px outside the panel boundary.

### Layered Offset CTA

As defined in style guide §8.5. Tier-1 surfaces only. In this spec:
Power Menu's "SHUT DOWN" button.

### Film-strip frame

`film-strip-long_a5hufh.png` tiled horizontally at top and bottom of the
screen, ~16px height per strip. Used on Power Menu, Overview.

### Media frame

`frame-16-9_iqf4jq.png` or `frame-16-9-portrait_snwdsp.png` as a
`border-image` around a thumbnail. Used on Overview and Switcher.

### Radial halo

As defined in style guide §8.3. Used on Lockscreen time/greeting.

## Rest-State Guarantee

At rest, the only visible disco-shell surface is absent. The compositor
renders the wallpaper (and whatever windows the user has open). This is
load-bearing for the aesthetic:

- Wallpaper can breathe as the hero image it was designed to be.
- Every summoned surface is ceremonial by contrast.
- Screen real estate is 100% available to windows.

The implementation MUST NOT add a "minimized" bar, a hover-hint overlay, or
any visible anchor in the rest state. Discoverability is handled through
documented keybinds (and the launcher's `:help` or equivalent mode in
future work).

## Style Guide Interaction

This redesign consumes the style guide but adds no new tokens. Every color,
font, and motif referenced here is already defined in
`docs/style-guide.md`. If a surface in this spec needs a value that's not
in the style guide, that's a bug — update the style guide first.

## Out of Scope / Future Work

- **Keybinds help panel** — deferred; launcher can eventually have a `:keys`
  mode that lists bindings.
- **Notification history** — deferred; launcher mode `:notif` is a likely
  future home.
- **Wallpaper picker** — deferred.
- **Emoji picker, color picker, snippet expander** — deferred; launcher
  modes when needed.
- **disco-shell implementation** — this spec defines the design; the actual
  Rust/GPUI rewrite in the disco-shell repo is follow-up work.
- **Style-overview.html mockup regeneration** — deferred; after disco-shell
  lands, regenerate the mockups to reflect real assets and styling.

## Success Criteria

- At rest, no disco-shell widget is visible. Wallpaper and windows only.
- Each of the 8 surfaces has exactly one canonical shape and summon
  mechanism defined in this document.
- Every summoned surface references at least one asset from
  `references/disco-elysium/ui-assets/` OR uses a style-guide-defined
  treatment (banner, painted canvas, radial halo).
- Keybind list fits on one screen and conflicts nowhere with existing
  Hyprland bindings.
- Power menu appears in exactly two places: standalone (Super+Shift+Esc)
  and as the power button inside the Info Panel.

## Open Questions

None blocking. Decisions locked in brainstorming:

- Ghost-with-toggle chosen over Cinema-always-on and Detective's-Desk.
- Side-page treatment for both wings, info left, launcher right.
- Super+/, Super+., Super+Esc, Super+Shift+Esc, Super+Tab, Alt+Tab budget
  confirmed.
- Keybinds help, notification history, wallpaper picker, emoji picker all
  deferred.
- Launcher modes inherited from disco-shell's existing design: apps,
  windows, clipboard, calculator, files, bash.
