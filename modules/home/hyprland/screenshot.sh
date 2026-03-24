#!/usr/bin/env bash

# Create screenshots directory if it doesn't exist
mkdir -p "$HOME/Pictures/Screenshots"

FILEPATH="$HOME/Pictures/Screenshots/$(date +'%Y-%m-%d-%H%M%S_grim.png')"

# Capture screenshot with grim and slurp
grim -g "$(slurp)" "$FILEPATH"

if [ -f "$FILEPATH" ]; then
    # Copy to clipboard
    wl-copy < "$FILEPATH"

    # Kill any existing preview instance
    pkill -f 'omarchy-screenshot-preview' 2>/dev/null

    # Launch preview tool
    omarchy-screenshot-preview "$FILEPATH" &
fi
