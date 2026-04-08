# On-Device Checklist — First Boot After Install

Run through this after `./scripts/install.sh system76` and rebooting into Hyprland.

> Desktop widgets are provided by [disco-shell](https://github.com/RobbeDelporte/disco-shell)
> (Rust + GPUI), built and installed separately. If something isn't working, check the
> output of `disco-shell` in a terminal for errors.

---

## 1. Fonts

The theme depends on specific fonts. Verify they're installed:

```bash
fc-list | grep -i "open sans"           # Condensed is a style variant, not in family name
fc-list | grep -i "libre baskerville"
fc-list | grep -i "playfair display"
fc-list | grep -i "jetbrainsmono nerd"
```

If any are missing:
```bash
paru -S ttf-playfair-display ttf-libre-baskerville ttf-jetbrains-mono-nerd ttf-opensans
```

---

## 2. Wallpaper

```bash
# Check awww daemon is running
pgrep awww-daemon || awww-daemon &

# Check wallpaper file exists
ls ~/disco-elysium-rice/wallpapers/martinaise.png
# If missing — pick any wallpaper and update the path in:
#   configs/hypr/hyprland.conf (exec-once line)
#   configs/hypr/hyprlock.conf (background path)
```

---

## 3. Monitor Config

```bash
# Check detected monitors
hyprctl monitors

# Edit host-specific config if needed
nano ~/disco-elysium-rice/hosts/system76/monitors.conf
```

---

## 4. disco-shell (Bar, Launcher, Notifications)

disco-shell starts automatically via hyprland.conf. Check:

### Bar
- [ ] Bar visible at top
- [ ] Workspaces on the left — clicking switches workspace
- [ ] Clock centered
- [ ] CPU, MEM, VOL, BAT modules on the right

If bar isn't visible: `disco-shell` in a terminal to see errors.

### Launcher
Press `Super+/` or `Super+D`:
- [ ] Launcher popup appears centered
- [ ] Search field accepts input
- [ ] Escape closes it

### Notifications
```bash
# Send test notifications
notify-send "INLAND EMPIRE" "Something about this room makes you uneasy."
notify-send -u critical "FAILED CHECK" "Electrochemistry [Godly: Failure]"
```

- [ ] Normal notification appears in top-right
- [ ] Dismiss button works

---

## 5. Kitty Terminal

Open with `Super+T`:

- [ ] Dark background (not blue-tinted)
- [ ] Run `ls --color` — directories should have distinct color
- [ ] Starship prompt shows directory and git info

---

## 6. Hyprland Window Management

- [ ] Open 2 windows — borders are subtle
- [ ] Gaps between windows (~4px inner, ~8px outer)
- [ ] Window corners are barely rounded (2px)
- [ ] Animations are smooth, not bouncy
- [ ] Focus: `Super+H/J/K/L` and arrow keys work
- [ ] Move: `Super+Shift+H/J/K/L` works
- [ ] Resize: `Super+Ctrl+H/J/K/L` works

---

## 7. Lock Screen

```bash
hyprlock
```

- [ ] Wallpaper visible but dimmed
- [ ] Large time in Playfair Display font
- [ ] Date below in condensed uppercase
- [ ] "Good evening, [user]" greeting
- [ ] Password field visible
- [ ] Wrong password → visual feedback

---

## 8. Power Menu

Press `Super+Shift+E`:

- [ ] Menu opens with Lock/Suspend/Logout/Reboot/Shutdown
- [ ] Test "Lock" — should trigger hyprlock
- [ ] Cancel with Escape

---

## 9. Neovim

```bash
nvim
```

- [ ] Opens without errors
- [ ] Line numbers visible
- [ ] Clipboard shared with system (`"+y` to yank, paste in other apps)

---

## 10. GTK3 Apps

### Nemo (file manager)
```bash
nemo &
```
- [ ] Dark background, not Adwaita light
- [ ] If light-themed: run `nwg-look`, set theme to Adwaita-dark, Apply

### xed (text editor)
```bash
xed &
```
- [ ] Dark background
- [ ] Go to Edit → Preferences → Font & Colors → select "Disco Elysium" scheme (if theme has been applied)

---

## 11. GPU Drivers

```bash
lspci | grep VGA
# Then uncomment the right driver in hosts/system76/packages.txt
# and run: sudo pacman -S <driver-package>
```

---

## Troubleshooting

| Problem | Fix |
|---------|-----|
| Bar not showing | Run `disco-shell` in a terminal to see errors |
| disco-shell crashes | Rebuild: `cd ~/disco-shell && cargo build --release` |
| Fonts look wrong | `fc-cache -fv` then restart disco-shell/kitty |
| GTK apps are light | `nwg-look` → set Adwaita-dark → Apply |
| hyprlock crashes | Check wallpaper path exists, check font is installed |
| Launcher won't open | Test: `disco-shell toggle-launcher` |
| Animations stuttery | Check GPU driver installed, reduce blur passes to 2 |

---

## After Everything Works

Compare each component visually against the mockups:
```bash
# Open mockups in a browser on the same machine
firefox ~/disco-elysium-rice/docs/mockups/desktop-composite.html &
```

Take a screenshot (`grimblast copy screen`) and compare side by side.
