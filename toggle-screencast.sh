#!/bin/bash -x
set -x

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
	OUTPUT_FILE="$HOME/$(date +'%Y-%m-%dT%I.%M%p').mov"
	echo $OUTPUT_FILE > $SCREENCAST_NAME_PATH
	DISPLAY=:0.0 /usr/bin/i3-nagbar -m "Recording to $OUTPUT_FILE..." -t warning &
	screencast.sh &
fi
