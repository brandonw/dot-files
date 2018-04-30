#!/bin/bash -x

SCREENCAST_NAME_PATH=~/.screencasting.file.path
OUTPUT_FILE=$(<$SCREENCAST_NAME_PATH)
if [ !$OUTPUT_FILE ]
then
	OUTPUT_FILE="$(date +'%Y-%m-%dT%I-%M%p').mov"
fi
DISPLAY=:0.0 /usr/bin/i3-nagbar -m "Recording to $OUTPUT_FILE..." -t warning &

INRES="1920x1200" # input resolution
OUTRES="1920x1200"
FPS="25" # target FPS
THREADS="2"
QUALITY="medium" #x264 preset: ultrafast,superfast,veryfast,faster,fast,medium
AUDIO_RATE="44100"

ffmpeg  -nostdin \
	-thread_queue_size 512 -f x11grab -s "$INRES" -r "$FPS" -i :0.0 \
	-thread_queue_size 512 -f alsa -i pulse -ac 2 -ar $AUDIO_RATE \
	-vcodec libx264 -preset $QUALITY -s "$OUTRES" -pix_fmt yuv420p -tune film \
	-acodec libmp3lame -ar 44100 -ab 64k -threads $THREADS -strict normal \
	-f mov file:$OUTPUT_FILE

if [ $? ]
then
	pkill i3-nagbar
	if [ "$1" == "--from-toggle" ]
	then
		rm $SCREENCAST_NAME_PATH
		DISPLAY=:0.0 /usr/bin/i3-nagbar -m "Failed to record, debug with \`screencast.sh\`" -t warning &
	fi
fi
