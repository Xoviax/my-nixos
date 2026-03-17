#!/usr/bin/env bash

# Get battery stats for BAT0 and BAT1
BAT0_CAP=$(cat /sys/class/power_supply/BAT0/capacity 2>/dev/null || echo 0)
BAT1_CAP=$(cat /sys/class/power_supply/BAT1/capacity 2>/dev/null || echo 0)

# Total average (basic approximation, usually they are balanced)
TOTAL_CAP=$(( (BAT0_CAP + BAT1_CAP) / 2 ))

# Get status
STATUS0=$(cat /sys/class/power_supply/BAT0/status 2>/dev/null || echo "Unknown")
STATUS1=$(cat /sys/class/power_supply/BAT1/status 2>/dev/null || echo "Unknown")

ICON="󰁹"
if [[ "$STATUS0" == "Charging" || "$STATUS1" == "Charging" ]]; then
    ICON="󰂄"
fi

# Output JSON for Waybar
echo "{\"text\": \"$ICON $TOTAL_CAP%\", \"tooltip\": \"Main: $BAT0_CAP%\nExternal: $BAT1_CAP%\", \"class\": \"battery\", \"percentage\": $TOTAL_CAP}"
