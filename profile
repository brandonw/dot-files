#!/bin/sh

export PATH=$PATH:~/.bin:~/.cabal/bin:~/.local/bin:./node_modules/.bin
if which ruby >/dev/null && which gem >/dev/null; then
	PATH="$(ruby -e 'puts Gem.user_dir')/bin:$PATH"
fi

export LIBVIRT_DEFAULT_URI=qemu:///system
export PAGER="less"
export LESS="-R "
export LESSOPEN="| /usr/bin/source-highlight-esc.sh %s"
export EDITOR="nvim"
export BROWSER=firefox
export TERM="xterm-256color"
export SDL_VIDEO_FULLSCREEN_HEAD=1
export IRC_CLIENT="irssi"
export PYTHONDONTWRITEBYTECODE=1
export NOSE_NOCAPTURE=1
export FZF_DEFAULT_COMMAND='
  (git ls-files . -co --exclude-standard ||
   find . -path "*/\.*" -prune -o -type f -print -o -type l -print |
      sed s/^..//) 2> /dev/null'
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/code
source /usr/bin/virtualenvwrapper.sh
