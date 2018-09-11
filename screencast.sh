#!/bin/bash

SCREENCAST_NAME_PATH=~/.screencasting.file.path
OUTPUT_FILE=$(<$SCREENCAST_NAME_PATH)

if [ ! "$OUTPUT_FILE" ]
then
	OUTPUT_FILE="$(date +'%Y-%m-%dT%I-%M%p')"
fi
MOV_FILE=$OUTPUT_FILE.mov
GIF_FILE=$OUTPUT_FILE.gif
FINAL_OUTPUT=$MOV_FILE

if [[ "$*" =~ "--to-gif" ]]
then
	FINAL_OUTPUT=$GIF_FILE
fi
DISPLAY=:0.0 /usr/bin/i3-nagbar -m "Recording to $FINAL_OUTPUT..." -t warning &

INRES="1920x1200" # input resolution
OUTRES="1920x1200"
FPS="15" # target FPS
THREADS="2"
QUALITY="medium" #x264 preset: ultrafast,superfast,veryfast,faster,fast,medium
AUDIO_RATE="44100"

AUDIO_PARAMS1="-thread_queue_size 4096 -f alsa -i pulse -ac 2 -ar $AUDIO_RATE"
AUDIO_PARAMS2="-acodec libmp3lame -ar 44100 -ab 64k -threads $THREADS -strict normal"
if [[ "$*" =~ "--no-audio" ]] || [[ "$*" =~ "--to-gif" ]]
then
	AUDIO_PARAMS1=""
	AUDIO_PARAMS2=""
fi

ffmpeg  -nostdin \
	-thread_queue_size 512 -f x11grab -s "$INRES" -r "$FPS" -i :0.0 \
	$AUDIO_PARAMS1 \
	-vcodec libx264 -preset $QUALITY -s "$OUTRES" -pix_fmt yuv420p -tune film \
	$AUDIO_PARAMS2 \
	-f mov file:"$MOV_FILE"

FFMPEG_STATUS_CODE=$?
pkill i3-nagbar
# 255 is used when ffmpeg is signalled via SIGTERM and then exits normally
if [ $FFMPEG_STATUS_CODE ] && [ $FFMPEG_STATUS_CODE != '255' ]
then
	if [[ "$*" =~ "--from-toggle" ]]
	then
		rm $SCREENCAST_NAME_PATH
		DISPLAY=:0.0 /usr/bin/i3-nagbar -m "Failed to record, debug with \`screencast.sh\`" -t warning &
		exit 1
	fi
fi

if [[ "$*" =~ "--to-gif" ]]
then
	ffmpeg -i "$MOV_FILE" "$OUTPUT_FILE.tmp.gif"
	rm "$MOV_FILE"
	gifsicle -O2 "$OUTPUT_FILE.tmp.gif" -o "$GIF_FILE"
	rm "$OUTPUT_FILE.tmp.gif"
fi
