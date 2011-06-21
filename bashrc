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
	alias pacman='pacman-color'
	alias sudo='sudo '
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
