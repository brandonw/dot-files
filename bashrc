#!/bin/bash

if [ "$HOSTNAME" == "waskiewicz-server" ]
then
	# undef rtorrent related keybindings if on the server
	stty stop undef
	stty start undef
fi
if [ "$HOSTNAME" == "brandon-pc" ]
then
	# use rxvt instead of rxvt-unicode as TERM
	export TERM="rxvt"
	export WINEDEBUG=-all
	alias pacman='pacman-color'
	alias sudo='sudo '

	. ~/.keys

	streaming() {
		INRES="1680x1050" # input resolution
		OUTRES="672x420"
		FPS="20" # target FPS
		QUAL="superfast" #x264 preset
		STREAM_KEY="$1"

		ffmpeg -f x11grab -s "$INRES" -r "$FPS" -i :0.0 \
			-f alsa -ac 2 -i pulse -ar 22050 -vcodec libx264 -preset $QUAL -s "$OUTRES" \
			-acodec libmp3lame -ab 128k -threads 0  \
			-f flv "rtmp://live.justin.tv/app/$JTV_STREAM_KEY flashver=FMLE/3.0\20(compatible;\20FMSc/1.0)"  
	}
fi

if [ -f /etc/bash_completion ]; then
	. /etc/bash_completion
fi

alias ls='ls --color=auto'

# set pubkey in keychain
eval `keychain --eval --agents ssh id_rsa`

# use vim as man pager
export PAGER="/bin/sh -c \"unset PAGER;col -b -x | \
	vim -R -c 'set ft=man nomod nolist' -c 'map q :q<CR>' \
        -c 'map <SPACE> <C-D>' -c 'map b <C-U>' \
	-c 'nmap K :Man <C-R>=expand(\\\"<cword>\\\")<CR><CR>' -\""

# use vim as editor
export EDITOR="vim"
