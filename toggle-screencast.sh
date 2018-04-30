#!/bin/bash

SCREENCAST_NAME_PATH=~/.screencasting.file.path
if [ -f $SCREENCAST_NAME_PATH ]
then
	# It is currently running
	OUTPUT_FILE=$(<$SCREENCAST_NAME_PATH)
	pkill i3-nagbar
	pkill ffmpeg
	rm $SCREENCAST_NAME_PATH
else
	# It has not been started yet
	OUTPUT_FILE="$HOME/$(date +'%Y-%m-%dT%I.%M%p')"
	echo $OUTPUT_FILE > $SCREENCAST_NAME_PATH
	screencast.sh --from-toggle $@ &
fi
