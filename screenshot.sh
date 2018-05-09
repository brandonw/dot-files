#!/bin/bash

DRIVE_DIR="/home/brandon/drive/"
DRIVE_PUB_DIR="Public/"
DATETIME_FORMAT="+%F_%R.%S"
IMAGE_FMT=".jpg"

SCREENSHOT_FILENAME=$(date $DATETIME_FORMAT)$IMAGE_FMT
SCREENSHOT_RELATIVE_PATH=$DRIVE_PUB_DIR$SCREENSHOT_FILENAME
SCREENSHOT_FULL_PATH=$DRIVE_DIR$SCREENSHOT_RELATIVE_PATH
cd $DRIVE_DIR

if [[ "$@" =~ "--full" ]]
then
	EXTRA=" -window root"
fi

import$EXTRA -compress None $SCREENSHOT_RELATIVE_PATH
echo $SCREENSHOT_FULL_PATH | xclip -in -rmlastnl
# drive push -no-prompt $SCREENSHOT_RELATIVE_PATH
# drive pub $SCREENSHOT_RELATIVE_PATH 2>/dev/null | sed -ne 's/.*\(http[^"]*\).*/\1/p' | xclip -in -rmlastnl -selection clipboard
