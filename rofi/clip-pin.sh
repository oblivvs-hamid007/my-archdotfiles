#!/usr/bin/env bash

PIN_FILE="$HOME/.config/rofi/pinned_clip.txt"
TOUCH_FILE=$(touch "$PIN_FILE")

# Show menu options: 1. Pin selected item, 2. View pinned items, 3. Unpin item
ACTION=$(echo -e "Pin Last Copied Item\nView Pinned Items\nUnpin an Item" | rofi -dmenu -p " " -theme ~/.config/rofi/clipboard.rasi)

case "$ACTION" in
    "Pin Last Copied Item")
        # Grab the top item from cliphist and add it to pinned file if not already present
        ITEM=$(cliphist list | head -n 1 | sed 's/^[0-9]*[[:space:]]*//')
        if [ -n "$ITEM" ]; then
            grep -qxF "$ITEM" "$PIN_FILE" || echo "$ITEM" >> "$PIN_FILE"
            notify-send "Clipboard" "Pinned: $ITEM"
        fi
        ;;
    "View Pinned Items")
        # Select from pinned items and copy to clipboard
        SELECTED=$(cat "$PIN_FILE" | rofi -dmenu -p " " -theme ~/.config/rofi/clipboard.rasi)
        if [ -n "$SELECTED" ]; then
            echo -n "$SELECTED" | wl-copy
            notify-send "Clipboard" "Copied pinned item to clipboard!"
        fi
        ;;
    "Unpin an Item")
        # Remove selected item from pinned file
        SELECTED=$(cat "$PIN_FILE" | rofi -dmenu -p " " -theme ~/.config/rofi/clipboard.rasi)
        if [ -n "$SELECTED" ]; then
            sed -i "\|^$(echo "$SELECTED" | sed 's/[^^]/[&]/g')\$|d" "$PIN_FILE"
            notify-send "Clipboard" "Unpinned item!"
        fi
        ;;
esac
