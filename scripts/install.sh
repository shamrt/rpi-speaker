#!/usr/bin/env bash

set -e

WYOMING_SATELLITE=$WYOMING_SATELLITE || 1
SQUEEZELITE=$SQUEEZELITE || 1
LIBRESPOT=$LIBRESPOT || 0

sudo apt install -y git pulseaudio
mkdir -p $HOME/src

# Install Wyoming satellite
if [[ $WYOMING_SATELLITE == 1 ]]; then
    git clone https://github.com/rhasspy/wyoming-satellite.git src/.
fi

# Install Squeezelite manually (Debian package is dodgy)
if [[ $SQUEEZELITE == 1 ]]; then
    mkdir -p $HOME/src/squeezelite
    cd $HOME/src/squeezelite
    wget https://sourceforge.net/projects/lmsclients/files/squeezelite/linux/squeezelite-pulse-1.9.9.1428-aarch64.tar.gz/download
    tar -xf download
    cd $HOME
fi

# librespot
if [[ $LIBRESPOT == 1 ]]; then
    sudo apt install -y build-essential cargo libpulse-dev
    cargo install librespot --locked
fi

# Install services
sudo cp $HOME/src/rpi-speaker/systemd/* /etc/systemd/user/
sudo systemctl --user daemon-reload

if [[ $WYOMING_SATELLITE == 1 ]]; then
    sudo systemctl --user enable wyoming-satellite.service
fi
if [[ $SQUEEZELITE == 1 ]]; then
    sudo systemctl --user enable squeezelite.service
fi
if [[ $LIBRESPOT == 1 ]]; then
    sudo systemctl --user enable librespot.service
fi