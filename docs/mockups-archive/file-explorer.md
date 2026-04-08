# File Explorer (Nemo)

## Overview

Nemo file manager themed via GTK3 css overrides on Adwaita-dark.

## Layout

- Header bar: nav arrows (chevron icons) + breadcrumb path + search/menu icons
- Sidebar (180px): places, devices, bookmarks
- File list: Name / Size / Modified columns
- Status bar: item count + free space

## Colors

- Window background: `#171b1a`
- Header/sidebar/statusbar: `#1e2221`
- Borders: `rgba(54, 59, 58, 0.3)`
- Text: `#ccc8c2`, muted `#999a95`, disabled `#4b4b4b`
- Directory icons: intellect blue `#5bc0d6`
- Hover: `#282c2b`

## Selection

Primary selection (cream bg, dark text) used for:
- Active sidebar item
- Selected file row

Both invert to `#d2d2d2` background with `#171b1a` text, including icons.

## Icons

All lineart: 1.5px stroke, no fill, round caps/joins. Lucide-style SVGs. Folder, file, home, download, image, search, menu, chevron arrows.

## Typography

- Sidebar sections: Open Sans Condensed Bold 10px, uppercase, 2px letter-spacing
- Sidebar items: Open Sans Condensed Bold 12px
- File names: Open Sans Condensed 12px
- Metadata: 11px muted
- Breadcrumb: JetBrains Mono 12px
- Status bar: JetBrains Mono 10px
