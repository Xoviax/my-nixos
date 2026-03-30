#!/usr/bin/env bash

# Use absolute paths or let Nix interpolate them
GRIM="${GRIM:-grim}"
SLURP="${SLURP:-slurp}"
WL_COPY="${WL_COPY:-wl-copy}"
PKILL="${PKILL:-pkill}"
PREVIEW="${PREVIEW:-omarchy-screenshot-preview}"
HYPRCTL="${HYPRCTL:-hyprctl}"
JQ="${JQ:-jq}"
MAGICK="${MAGICK:-magick}"

# Create screenshots directory if it doesn't exist
mkdir -p "$HOME/Pictures/Screenshots"

# Capture a fullscreen frame first so hover-only UI states are preserved.
TMP_SHOT="$(mktemp --suffix=.png)"
trap 'rm -f "$TMP_SHOT"' EXIT
$GRIM "$TMP_SHOT" || exit 1

MODE="${1:-fullscreen}"
FILEPATH="$HOME/Pictures/Screenshots/$(date +'%Y-%m-%d-%H%M%S_grim.png')"

if [ "$MODE" = "region" ]; then
    # Select region
    # Get active workspaces across all monitors
    ACTIVE_WS=$($HYPRCTL monitors -j | $JQ -c '[.[].activeWorkspace.id]')
    # Pass all existing window geometries on active workspaces into slurp so it highlights them on hover.
    REGION=$($HYPRCTL clients -j | $JQ -r --argjson ws "$ACTIVE_WS" '.[] | select((.hidden == false) and (.workspace.id | IN($ws[]))) | "\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"' | $SLURP)

    if [ -z "$REGION" ]; then
        exit 1
    fi

    # Crop from frozen screenshot instead of capturing live screen.
    X="${REGION%%,*}"
    REST="${REGION#*,}"
    Y="${REST%% *}"
    SIZE="${REST#* }"

    $MAGICK "$TMP_SHOT" -crop "${SIZE}+${X}+${Y}" +repage "$FILEPATH"
else
    # Fullscreen mode
    cp "$TMP_SHOT" "$FILEPATH"
fi

if [ -f "$FILEPATH" ]; then
    # Copy to clipboard
    $WL_COPY < "$FILEPATH"

    # Kill any existing preview instance
    $PKILL -f 'omarchy-screenshot-preview' 2>/dev/null

    # Launch preview tool
    $PREVIEW "$FILEPATH" &
fi
