#!/usr/bin/env bash
# Switch workspace and dismiss scratchpad if it's open.
# Usage: workspace.sh <id>

# Hide special workspace only if it's currently visible
if hyprctl monitors -j | grep -q '"name":"special:magic"'; then
    hyprctl dispatch togglespecialworkspace magic
fi

hyprctl dispatch workspace "$1"
