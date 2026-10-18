#!/usr/bin/env bash

PIN_FILE="$HOME/.config/rofi/pinned_clip.txt"
touch "$PIN_FILE"

ROFI_THEME="$HOME/.config/rofi/clipboard.rasi"

main_menu() {
    while true; do
        ACTION=$(echo -e "➜ Select Item to Pin\n➜ View Pinned Items\n➜ Unpin an Item" | rofi -dmenu -p " " -theme "$ROFI_THEME")

        case "$ACTION" in
            "➜ Select Item to Pin")
                pin_menu
                ;;
            "➜ View Pinned Items")
                view_menu
                ;;
            "➜ Unpin an Item")
                unpin_menu
                ;;
            *)
                # Exit when ESC is pressed or Rofi toggled off
                exit 0
                ;;
        esac
    done
}

pin_menu() {
    while true; do
        # Fetch clipboard items without IDs, adding a Back option at the top
        CHOICE=$( { echo "|| Back"; cliphist list | sed 's/^[0-9]*[[:space:]]*//'; } | rofi -dmenu -p "Pin Item: " -theme "$ROFI_THEME" )

        if [ -z "$CHOICE" ] || [ "$CHOICE" = "|| Back" ]; then
            return
        fi

        # Add to pinned file if not already present
        if ! grep -qxF "$CHOICE" "$PIN_FILE"; then
            echo "$CHOICE" >> "$PIN_FILE"
            notify-send "Clipboard" "Pinned item!"
        fi
    done
}

view_menu() {
    while true; do
        if [ ! -s "$PIN_FILE" ]; then
            notify-send "Clipboard" "No pinned items yet!"
            return
        fi

        CHOICE=$( { echo "|| Back"; cat "$PIN_FILE"; } | rofi -dmenu -p "Pinned: " -theme "$ROFI_THEME" )

        if [ -z "$CHOICE" ] || [ "$CHOICE" = "|| Back" ]; then
            return
        fi

        echo -n "$CHOICE" | wl-copy
        notify-send "Clipboard" "Copied to clipboard!"
        exit 0
    done
}

unpin_menu() {
    while true; do
        if [ ! -s "$PIN_FILE" ]; then
            notify-send "Clipboard" "No pinned items to unpin!"
            return
        fi

        CHOICE=$( { echo "|| Back"; cat "$PIN_FILE"; } | rofi -dmenu -p "Unpin Item: " -theme "$ROFI_THEME" )

        if [ -z "$CHOICE" ] || [ "$CHOICE" = "||Back" ]; then
            return
        fi

        # Remove selected line cleanly
        sed -i "\|^$(echo "$CHOICE" | sed 's/[^^]/[&]/g')\$|d" "$PIN_FILE"
        notify-send "Clipboard" "Unpinned item!"
    done
}

main_menu
