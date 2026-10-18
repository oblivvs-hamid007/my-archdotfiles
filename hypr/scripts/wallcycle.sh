#!/usr/bin/env bash

# Folder where your wallpapers are kept
WALL_DIR="$HOME/Downloads/walls"

# Enable nullglob so empty matches don't return raw glob strings
shopt -s nullglob

# Dynamically grab all files starting with "wp" in WALL_DIR
WALLS=( "$WALL_DIR"/wp* )

# Check if any wallpaper starting with 'wp' was found
if [ ${#WALLS[@]} -eq 0 ]; then
    notify-send "Wallpaper Error" "No files starting with 'wp' found in $WALL_DIR"
    exit 1
fi

# File to keep track of current index
INDEX_FILE="/tmp/current_wall_index"

# Read current index or set to 0
if [ -f "$INDEX_FILE" ]; then
    INDEX=$(cat "$INDEX_FILE")
else
    INDEX=0
fi

# Calculate next index
NEXT_INDEX=$(( (INDEX + 1) % ${#WALLS[@]} ))

# Save new index
echo "$NEXT_INDEX" > "$INDEX_FILE"

# Apply wallpaper with awww transition
awww img "${WALLS[$NEXT_INDEX]}" --transition-type fade --transition-duration 2 --transition-fps 144
