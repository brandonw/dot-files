if [ "$HOSTNAME" == "waskiewicz-server" ]
then
	# undef rtorrent related keybindings if on the server
	stty stop undef
	stty start undef
fi
if [ "$HOSTNAME" == "waskiewicz-pc" ]
then
	# use rxvt instead of rxvt-unicode as TERM
	export TERM="rxvt"

	# exports STREAM_KEY
	. .stream_key

	streaming() {
		INRES="640x480"
		OUTRES="640x480"
		SCREEN_OFF=":0.0+1,19"
		AUDIO_IN="pulse"
		FPS="20"
		PIX_FMT="yuv420p"
		QUAL="faster"

		# -f flv "rtmp://live.justin.tv/app/$STREAM_KEY flashver=FMLE/3.0\20(compatible;\20FMSc/1.0)"

		ffmpeg \
			-f x11grab -s "$INRES" -r "$FPS" -i "$SCREEN_OFF" \
			-f alsa -ac 2 -i "$AUDIO_IN" \
			-vcodec libx264 -vpre "$QUAL" -s "$OUTRES" -pix_fmt $PIX_FMT \
			-acodec libmp3lame -ab 128k -threads 0  \
			-f flv "test.flv"
	}
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
