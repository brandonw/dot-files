#!/bin/bash

if [ "$HOSTNAME" == "waskiewicz-server" ]
then
	# undef rtorrent related keybindings if on the server
	stty stop undef
	stty start undef
fi

# use vim as man pager
export PAGER="/bin/sh -c \"unset PAGER;col -b -x | \
	vim -R -c 'set ft=man nomod nolist' -c 'map q :q<CR>' \
        -c 'map <SPACE> <C-D>' -c 'map b <C-U>' \
	-c 'nmap K :Man <C-R>=expand(\\\"<cword>\\\")<CR><CR>' -\""

# use vim as editor
export EDITOR="vim"
