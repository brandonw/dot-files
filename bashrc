#!/usr/bin/env bash

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

. ~/.profile
. ~/.keys
stty -ixon
shopt -s histappend

streaming() {
	INRES="1920x1080" # input resolution
	OUTRES="1920x1080"
	FPS="25" # target FPS
	GOP="50" # i-frame interval, should be double FPS
	GOPMIN="25" # min i-frame interval, should be equal to FPS
	THREADS="2"
	CBR="750k"
	QUALITY="fast" #x264 preset: ultrafast,superfast,veryfast,faster,fast,medium
	AUDIO_RATE="44100"
	SERVER="live-jfk"

	ffmpeg  -thread_queue_size 512 -f x11grab -s "$INRES" -r "$FPS" -i :1.0 \
		-thread_queue_size 512 -f alsa -i pulse -ac 2 -ar $AUDIO_RATE \
		-vcodec libx264 -g $GOP -keyint_min $GOPMIN -b:v $CBR -minrate $CBR -maxrate $CBR -bufsize $CBR \
			-preset $QUALITY -s "$OUTRES" -pix_fmt yuv420p -tune film \
		-acodec libmp3lame -ar 44100 -ab 64k -threads $THREADS -strict normal \
		-f flv "rtmp://$SERVER.twitch.tv/app/$TWITCH_STREAM_KEY"
}

screencast() {
	INRES="1920x1200" # input resolution
	OUTRES="1920x1200"
	FPS="25" # target FPS
	THREADS="2"
	QUALITY="medium" #x264 preset: ultrafast,superfast,veryfast,faster,fast,medium
	AUDIO_RATE="44100"

	ffmpeg  -thread_queue_size 512 -f x11grab -s "$INRES" -r "$FPS" -i :0.0 \
		-thread_queue_size 512 -f alsa -i pulse -ac 2 -ar $AUDIO_RATE \
		-vcodec libx264 -preset $QUALITY -s "$OUTRES" -pix_fmt yuv420p -tune film \
		-acodec libmp3lame -ar 44100 -ab 64k -threads $THREADS -strict normal \
		-f mov file:$(date -Iseconds).mov
}

# Path to the bash it configuration
export BASH_IT="$HOME/.bash_it"

# Lock and Load a custom theme file
# location /.bash_it/themes/
export BASH_IT_THEME='minimal'

# Don't check mail when opening terminal.
unset MAILCHECK

# Set this to the command you use for todo.txt-cli
export TODO="t"

# Load Bash It
source $BASH_IT/bash_it.sh

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
[ -n "$NVIM_LISTEN_ADDRESS" ] && export FZF_DEFAULT_OPTS='--no-height'

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/brandon/google-cloud-sdk/path.bash.inc' ]; then source '/home/brandon/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/brandon/google-cloud-sdk/completion.bash.inc' ]; then source '/home/brandon/google-cloud-sdk/completion.bash.inc'; fi
