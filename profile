#!/bin/sh

export PATH=$PATH:~/.bin:~/.cabal/bin
#export WORKON_HOME=~/.virtualenvs
#export VIRTUALENV_PYTHON="python2"

export LIBVIRT_DEFAULT_URI=qemu:///system
export PAGER="less"
export LESS="-R "
export LESSOPEN="| /usr/bin/source-highlight-esc.sh %s"
export EDITOR="vim"
export BROWSER=firefox
export SDL_VIDEO_FULLSCREEN_HEAD=0

alias e='emacs -nw'
