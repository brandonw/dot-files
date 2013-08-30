#!/bin/sh

PID=`pgrep offlineimap`

[[ -n "$PID" ]] && kill "$PID"

offlineimap -o -1 -u quiet &>/dev/null &

exit
