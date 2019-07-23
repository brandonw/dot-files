#!/bin/sh

if which ruby >/dev/null && which gem >/dev/null; then
	PATH="$PATH:$(ruby -e 'puts Gem.user_dir')/bin"
fi
if which yarn >/dev/null; then
	PATH="$PATH:$(yarn global bin)"
fi
PATH=~/.bin:$PATH
export PATH

export LIBVIRT_DEFAULT_URI=qemu:///system
export PAGER="less"
export LESS="-R "
export LESSOPEN="| /usr/bin/source-highlight-esc.sh %s"
export EDITOR="nvim"
export BROWSER=firefox
export TERM="st-256color"
export TERMINAL="xst"
export SDL_VIDEO_FULLSCREEN_HEAD=1
export IRC_CLIENT="irssi"
export FZF_DEFAULT_COMMAND='
  (git ls-files . -co --exclude-standard ||
   find . -path "*/\.*" -prune -o -type f -print -o -type l -print |
      sed s/^..//) 2> /dev/null'
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/code
export NPM_TOKEN=$(grep _authToken ~/.npmrc | sed 's@.*=@@')
source /usr/bin/virtualenvwrapper.sh
