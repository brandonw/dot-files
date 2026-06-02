#!/usr/bin/env sh

# Highlights this item if it represents the active rift workspace.
# $1 is this item's 0-based workspace index (the item is named rift.$1).
# Reads live state from rift, so it's correct on the initial `sketchybar
# --update` as well as on every `rift_workspace_change` event.
#
# make sure it's executable with:
# chmod +x ~/.config/sketchybar/plugins/rift.sh

ACTIVE=$(rift-cli query workspaces 2>/dev/null | jq -r '.[] | select(.is_active) | .index')

if [ "$1" = "$ACTIVE" ]; then
    sketchybar --set "$NAME" background.drawing=on
else
    sketchybar --set "$NAME" background.drawing=off
fi
