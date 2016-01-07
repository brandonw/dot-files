#!/bin/sh

export PATH=$PATH:~/.bin:~/.cabal/bin:~/.local/bin
if which ruby >/dev/null && which gem >/dev/null; then
	PATH="$(ruby -rubygems -e 'puts Gem.user_dir')/bin:$PATH"
fi
export WORKON_HOME=~/.virtualenvs
export VIRTUALENV_PYTHON="python2"

export LIBVIRT_DEFAULT_URI=qemu:///system
export PAGER="less"
export LESS="-R "
export LESSOPEN="| /usr/bin/source-highlight-esc.sh %s"
export EDITOR="vim"
export BROWSER=firefox
export LEDGER_PAGER=less
export SDL_VIDEO_FULLSCREEN_HEAD=1
export IRC_CLIENT="irssi"

alias e='emacs -nw'
