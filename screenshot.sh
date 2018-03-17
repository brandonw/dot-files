#!/bin/bash

DRIVE_DIR="/home/brandon/drive/"
DRIVE_PUB_DIR="Public/"
DATETIME_FORMAT="+%F_%R.%S"
IMAGE_FMT=".jpg"

SCREENSHOT_FILENAME=$(date $DATETIME_FORMAT)$IMAGE_FMT
SCREENSHOT_RELATIVE_PATH=$DRIVE_PUB_DIR$SCREENSHOT_FILENAME
cd $DRIVE_DIR
import $SCREENSHOT_RELATIVE_PATH -compress None
# drive push -no-prompt $SCREENSHOT_RELATIVE_PATH
# drive pub $SCREENSHOT_RELATIVE_PATH 2>/dev/null | sed -ne 's/.*\(http[^"]*\).*/\1/p' | xclip -in -rmlastnl -selection clipboard
