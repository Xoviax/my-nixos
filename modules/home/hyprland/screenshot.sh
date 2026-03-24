#!/usr/bin/env bash

# Use absolute paths or let Nix interpolate them
GRIM="${GRIM:-grim}"
SLURP="${SLURP:-slurp}"
WL_COPY="${WL_COPY:-wl-copy}"
PKILL="${PKILL:-pkill}"
PREVIEW="${PREVIEW:-omarchy-screenshot-preview}"

# Create screenshots directory if it doesn't exist
mkdir -p "$HOME/Pictures/Screenshots"

# Select region
REGION=$($SLURP) || exit 1

FILEPATH="$HOME/Pictures/Screenshots/$(date +'%Y-%m-%d-%H%M%S_grim.png')"

# Capture screenshot
$GRIM -g "$REGION" "$FILEPATH"

if [ -f "$FILEPATH" ]; then
    # Copy to clipboard
    $WL_COPY < "$FILEPATH"

    # Kill any existing preview instance
    $PKILL -f 'omarchy-screenshot-preview' 2>/dev/null

    # Launch preview tool
    $PREVIEW "$FILEPATH" &
fi
