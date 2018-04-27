#!/bin/bash -x

SCREENCAST_NAME_PATH=~/.screencasting.file.path
OUTPUT_FILE=$(<$SCREENCAST_NAME_PATH)
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
