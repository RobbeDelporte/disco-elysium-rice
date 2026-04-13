# Implementation Guide — Disco Elysium Rice

This guide documents how the Disco Elysium style guide (`docs/style-guide.md`) has been applied to each config file. Use it as a reference for what colors and fonts are configured where.

## Prerequisites

```bash
# Ensure all packages are installed
cd ~/disco-elysium-rice && ./scripts/install.sh system76
```

All required packages (Astal/disco-shell, Kitty, Neovim, fonts, etc.) are handled by the install script.

---

## Step 1: Color Theme — Applied Across All Configs

The Disco Elysium color palette from `docs/style-guide.md` has been applied across all config files. The key colors used:

| Token | Hex | Use |
|-------|-----|-----|
| `base` | `#171b1a` | Backgrounds |
| `text` | `#ccc8c2` | Primary text |
| `text-muted` | `#999a95` | Secondary text |
| `border` | `#363b3a` | Borders, dividers |
| `intellect` | `#5bc0d6` | Focus, links, active states |
| `action` | `#eb6408` | Speaker names, selections, cursor |
| `button` | `#912711` | Primary buttons |
| `success` | `#0fb666` | Check passed |
| `error` | `#b83a3a` | Errors, failures |

---

## Step 2: Hyprland Window Borders

Applied in `configs/hypr/hyprland.conf`:

```conf
general {
    col.active_border = rgba(999a9566)    # muted, 40% opacity
    col.inactive_border = rgba(363b3a40)  # barely visible
}

decoration {
    shadow {
        color = rgba(171b1aee)
    }
}
```

---

## Step 3: disco-shell — Bar, Launcher, Notifications

Desktop shell widgets are provided by the separate [disco-shell](https://github.com/RobbeDelporte/disco-shell) project (Rust + GPUI). See that repo's design doc for theming details.

The shell applies the same Disco Elysium palette via Rust design tokens (translated from the SCSS variables that were used in the original Astal implementation).

---

## Step 4: Hyprlock — Lock Screen

Colors applied in `configs/hypr/hyprlock.conf`:

```conf
input-field {
    outer_color = rgb(91, 192, 214)     # intellect blue
    inner_color = rgb(23, 27, 26)       # base dark
    font_color = rgb(215, 215, 215)     # off-white
    check_color = rgb(15, 182, 102)     # success green
    fail_color = rgb(184, 58, 58)       # error red
    capslock_color = rgb(227, 186, 62)  # motorics yellow
}

# Time label
label {
    color = rgb(215, 215, 215)
}

# Date label
label {
    color = rgb(153, 154, 149)
}

# Greeting label
label {
    color = rgb(153, 154, 149)
}
```

---

## Step 5: Kitty Terminal Colors

Applied in `configs/kitty/kitty.conf` — full 16-color palette from the style guide's Kitty section.

---

## Step 6: Starship Prompt

Colors applied in `configs/starship/starship.toml`:

```toml
[directory]
style = "bold #5bc0d6"

[git_branch]
style = "bold #7555c6"

[git_status]
style = "bold #eb6408"

[character]
success_symbol = "[>](bold #0fb666)"
error_symbol = "[>](bold #b83a3a)"
```

---

## Step 7: Neovim Colorscheme

A custom Disco Elysium colorscheme is implemented in `configs/nvim/lua/disco-elysium.lua` (264 lines) with lazy.nvim + treesitter configured in `configs/nvim/init.lua`.

---

## Step 8: GTK3 Theme (Nemo, xed)

Colors applied in `configs/gtk-3.0/gtk.css`:

```css
@define-color theme_bg_color #171b1a;
@define-color theme_fg_color #ccc8c2;
@define-color theme_base_color #171b1a;
@define-color theme_text_color #ccc8c2;
@define-color theme_selected_bg_color #eb6408;
@define-color theme_selected_fg_color #ccc8c2;
@define-color insensitive_bg_color #1e2221;
@define-color insensitive_fg_color #4b4b4b;
@define-color borders #363b3a;
```

Set base theme via `nwg-look` to Adwaita-dark, then the custom gtk.css overrides apply on top.

---

## Step 9: xed Syntax Highlighting

Colors applied in `configs/gtksourceview-4.0/disco-elysium.xml`:
- Comments: `#363b3a` (border)
- Keywords: `#7555c6` (psyche purple)
- Strings: `#0fb666` (success green)
- Numbers: `#e3ba3e` (motorics yellow)
- Functions/types: `#5bc0d6` (intellect blue)
- Constants: `#eb6408` (action orange)
- Errors: `#b83a3a` (error red)

---

## Step 10: Wallpaper

Already configured in hyprland.conf autostart. Verify:
```bash
awww img ~/disco-elysium-rice/wallpapers/martinaise.png --transition-type fade --transition-duration 1
```

---

## Verification Checklist

Verify each component:

- [ ] Bar: 3-column layout, active workspace highlighted, datetime centered
- [ ] Launcher: opens with Super+/, dark panel, search works
- [ ] Notifications: test with `notify-send`, dialogue pattern styling
- [ ] Hyprlock: Playfair time, condensed greeting, colored input states
- [ ] Kitty: 16-color scheme correct, Starship prompt colors match
- [ ] Neovim: colorscheme applied, syntax highlighting works
- [ ] Nemo: GTK3 theme applies, dark sidebar
- [ ] xed: syntax highlighting with DE color scheme
- [ ] Hyprland: subtle window borders, smooth animations, correct gaps
- [ ] Wallpaper: displayed via awww
- [ ] Power menu: script works for lock/suspend/logout/reboot/shutdown

## Reference

- Style guide: `docs/style-guide.md`
- Style preview: `docs/style-overview.html` (open in browser)
- Mockups: `docs/mockups/*.html` (open in browser)

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
