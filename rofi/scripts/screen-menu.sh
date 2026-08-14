#!/usr/bin/env bash

# Capture menu options matching your theme style
options="✘ Screenshot (Region)\n✘ Screenshot (Fullscreen)\n✘ Record Region (Start/Stop)\n✘ Record Screen (Start/Stop)"

chosen=$(echo -e "$options" | rofi -dmenu -i -p "┇┇ Capture Menu " \
    -theme ~/.config/rofi/clipboard.rasi \
    -theme-str 'entry { enabled: false; }' \
    -theme-str 'prompt { enabled: true; }')

case "$chosen" in
    "✘ Screenshot (Region)")
        mkdir -p ~/Pictures
        file=~/Pictures/Screenshot_$(date +'%Y-%m-%d_%H-%M-%S').png
        grim -g "$(slurp)" - | wl-copy && grim -g "$(slurp)" "$file"
        ;;
    "✘ Screenshot (Fullscreen)")
        mkdir -p ~/Pictures
        file=~/Pictures/Screenshot_$(date +'%Y-%m-%d_%H-%M-%S').png
        grim - | wl-copy && grim "$file"
        ;;
    "✘ Record Region (Start/Stop)")
        if pgrep -x "wf-recorder" > /dev/null; then
            pkill -INT wf-recorder
            notify-send "Screen Recording" "Stopped and saved to ~/Videos"
        else
            mkdir -p ~/Videos
            file=~/Videos/Recording_$(date +'%Y-%m-%d_%H-%M-%S').mp4
            notify-send "Screen Recording" "Select region..."
            wf-recorder -g "$(slurp)" -f "$file" &
        fi
        ;;
    "✘ Record Screen (Start/Stop)")
        if pgrep -x "wf-recorder" > /dev/null; then
            pkill -INT wf-recorder
            notify-send "Screen Recording" "Stopped and saved to ~/Videos"
        else
            mkdir -p ~/Videos
            file=~/Videos/Recording_$(date +'%Y-%m-%d_%H-%M-%S').mp4
            notify-send "Screen Recording" "Started recording screen"
            wf-recorder -f "$file" &
        fi
        ;;
esac
