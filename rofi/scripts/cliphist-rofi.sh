#!/usr/bin/env bash

ROFI_THEME="$HOME/.config/rofi/clipboard.rasi"
CLEAR_OPT="󰅖 Clear Clipboard History"

# Put Clear History FIRST so it stays locked right under the search bar,
# and pass -p "Q " to avoid duplicating the placeholder text.
CHOICE=$( { echo "$CLEAR_OPT"; cliphist list | sed 's/^[0-9]*[[:space:]]*//'; } | rofi -dmenu -p "" -theme "$ROFI_THEME" )

if [ -z "$CHOICE" ]; then
    exit 0
fi

if [ "$CHOICE" = "$CLEAR_OPT" ]; then
    CONFIRM=$(printf "Yes\nNo" | rofi -dmenu -p "Clear history?" -theme "$ROFI_THEME")
    if [ "$CONFIRM" = "Yes" ]; then
        cliphist wipe
        notify-send "Clipboard" "Cleared all clipboard history!"
    fi
else
    echo "$CHOICE" | wl-copy
fi
