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
