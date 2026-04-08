# Desktop Composite

## Overview

Full desktop screenshot mockup showing all elements together. This is a rough overview — individual component mockups are the authoritative reference for each element's design.

## Layout

- Bar at top (32px)
- Tiled windows with 4px inner gaps, 8px outer gaps
- Wallpaper visible through gaps and semi-transparent bar
- Windows have 2px border-radius, 1px border

## Window Borders

- Inactive: `rgba(54, 59, 58, 0.25)` — barely visible
- Active: `rgba(153, 154, 149, 0.25)` — slightly brighter, still subtle

## What's Shown

- Terminal (Kitty) with starship prompt, git output, `ls --color`
- Browser with tab bar
- Neovim with syntax-highlighted Lua code
- Dwindle tiling layout (left master, right stacked)

## Note

The bar in this composite is a simplified version. See `status-bar.md` for the authoritative bar design with skill-colored module underlines.
