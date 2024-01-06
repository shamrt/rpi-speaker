#!/bin/env bash
SQUEEZELITE="$HOME/src/squeezelite/squeezelite"

OUTPUT_DEVICE="$($SQUEEZELITE -l | grep Anker | awk '{$1=$1};1' | cut -d " " -f 1)"
PLAYER_NAME=$1

$SQUEEZELITE -o $OUTPUT_DEVICE -n $PLAYER_NAME