#!/usr/bin/env bash

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

. ~/.keys
stty -ixon
shopt -s histappend

# Path to the bash it configuration
export BASH_IT="$HOME/.bash_it"

# Lock and Load a custom theme file
# location /.bash_it/themes/
export BASH_IT_THEME='minimal'

# Don't check mail when opening terminal.
unset MAILCHECK

# Set this to the command you use for todo.txt-cli
export TODO="t"

# Fix keypad issues
#tput smkx

# Load Bash It
source $BASH_IT/bash_it.sh

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
[ -n "$NVIM_LISTEN_ADDRESS" ] && export FZF_DEFAULT_OPTS='--no-height'

if [ -f '/home/brandon/google-cloud-sdk/path.bash.inc' ]; then source '/home/brandon/google-cloud-sdk/path.bash.inc'; fi
if [ -f '/home/brandon/google-cloud-sdk/completion.bash.inc' ]; then source '/home/brandon/google-cloud-sdk/completion.bash.inc'; fi
if [ -f '/home/brandon/.kube/completion.bash.inc' ]; then source '/home/brandon/.kube/completion.bash.inc'; fi
