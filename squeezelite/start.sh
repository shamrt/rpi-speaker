#!/bin/env bash
OUTPUT_DEVICE="$($HOME/src/squeezelite/squeezelite -l | grep Anker | awk '{$1=$1};1' | cut -d " " -f 1)"
PLAYER_NAME=$1

$HOME/src/squeezelite/squeezelite -o $OUTPUT_DEVICE -n $PLAYER_NAME