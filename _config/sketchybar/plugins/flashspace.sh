#!/usr/bin/env sh

# make sure it's executable with:
# chmod +x ~/.config/sketchybar/plugins/flashspace.sh
if [ "$1" = "$WORKSPACE" ]; then
    sketchybar --set $NAME background.drawing=on
else
    sketchybar --set $NAME background.drawing=off
fi
