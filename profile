#!/bin/sh

. /opt/homebrew/opt/asdf/libexec/asdf.sh

[ -d $HOME/.bin ] && export PATH="$HOME/.bin:$PATH"

export PAGER="less"
export LESS="-R "
export LESSOPEN="| source-highlight-esc.sh %s"
export EDITOR="nvim"
export BROWSER=firefox
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

export PGDATABASE=pushbot_development
export JUMPHOST_PROFILE=brandon
