#!/usr/bin/env bash
SPEAKER_NAME="$1"

cd $HOME/src/wyoming-satellite 
script/run \
    --name $SPEAKER_NAME \
    --uri 'tcp://0.0.0.0:10700' \
    --mic-command 'arecord -r 16000 -c 1 -f S16_LE -t raw' \
    --snd-command 'aplay -r 22050 -c 1 -f S16_LE -t raw' \
    --vad \
    --awake-wav sounds/OOT_MiniMap_On.wav \
    --done-wav sounds/OOT_MiniMap_Off.wav \
    --mic-auto-gain 5 \
    --mic-noise-suppression 2