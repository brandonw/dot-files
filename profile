#!/bin/sh

if which ruby >/dev/null && which gem >/dev/null; then
	PATH="$PATH:$(ruby -e 'puts Gem.user_dir')/bin"
fi
if which yarn >/dev/null; then
	PATH="$PATH:$(yarn global bin)"
fi
if which go >/dev/null; then
    export GOPATH="/home/brandon/go"
    PATH="$PATH:$GOPATH/bin"
fi
if which npm >/dev/null; then
    PATH="$PATH:./node_modules/.bin"
fi

# Make sure the global npm prefix is on the path
#[[ `which npm 2>/dev/null` ]] && pathmunge "$(npm config get prefix)/bin" "after"

PATH=~/.bin:$PATH
export PATH

function nvim_man() {
    nvim "+Man $* | only"
}
alias man=nvim_man

export LIBVIRT_DEFAULT_URI=qemu:///system
export PAGER="less"
export LESS="-R "
export LESSOPEN="| /usr/bin/source-highlight-esc.sh %s"
export EDITOR="nvim"
export BROWSER=firefox
export TERMINAL="alacritty"
export SDL_VIDEO_FULLSCREEN_HEAD=1
export IRC_CLIENT="irssi"
export FZF_DEFAULT_COMMAND='
  (git ls-files . -co --exclude-standard ||
   find . -path "*/\.*" -prune -o -type f -print -o -type l -print |
      sed s/^..//) 2> /dev/null'
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/code
export NPM_TOKEN=$(grep _authToken ~/.npmrc | sed 's@.*=@@')
export PGHOST=127.0.0.1
export PGUSER=brandon
export AWS_SDK_LOAD_CONFIG=1

source /usr/bin/virtualenvwrapper.sh
export NVM_DIR="$HOME/.nvm"
source /usr/share/nvm/init-nvm.sh
