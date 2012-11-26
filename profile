#!/bin/sh

export PATH=$PATH:~/.bin:~/.cabal/bin

# use vim as man pager
export PAGER="/bin/sh -c \"unset PAGER;col -b -x | \
	vim -R -c 'set ft=man nomod nolist' -c 'map q :q<CR>' \
        -c 'map <SPACE> <C-D>' -c 'map b <C-U>' \
	-c 'nmap K :Man <C-R>=expand(\\\"<cword>\\\")<CR><CR>' -\""

# use vim as editor
export EDITOR="vim"
export PATH=$PATH:~/.bin
export TERM="rxvt"
export BROWSER=chromium
export WORKON_HOME=~/.virtualenvs
export VIRTUALENV_PYTHON="python2"

source .keys
