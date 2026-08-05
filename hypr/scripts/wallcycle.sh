#!/usr/bin/env bash

# Folder where your wallpapers are kept
WALL_DIR="$HOME/Downloads/walls"

# List of images to cycle through
WALLS=(
    "$WALL_DIR/wp1.png"
    "$WALL_DIR/wp6.png"
)

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
