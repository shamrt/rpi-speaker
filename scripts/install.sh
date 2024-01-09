#!/usr/bin/env bash

set -e
set -x

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." >/dev/null 2>&1 && pwd)"

if [ "$EUID" -eq 0 ]; then
    echo "Please run as current user"
    exit
fi

WYOMING_SATELLITE=${WYOMING_SATELLITE:-1}
SQUEEZELITE=${SQUEEZELITE:-1}
LIBRESPOT=${LIBRESPOT:-0}

sudo apt install -y pulseaudio
mkdir -p $HOME/src

# Check if $HOME/src/wyoming-satellite directory doesn't exist
# Install Wyoming satellite
if [[ $WYOMING_SATELLITE == 1 ]]; then
    if [ ! -d "$HOME/src/wyoming-satellite" ]; then
        git clone https://github.com/rhasspy/wyoming-satellite.git $HOME/src/wyoming-satellite
        cp $PROJECT_DIR/wyoming-satellite/sounds/* $HOME/src/wyoming-satellite/sounds/
    fi
    cd $HOME/src/wyoming-satellite/
    sudo apt-get install python3-venv alsa-utils
    ./script/setup
    ./.venv/bin/pip3 install 'pysilero-vad==1.0.0'
    ./.venv/bin/pip3 install 'webrtc-noise-gain==1.2.3'
fi

# Install Squeezelite manually (Debian package is dodgy)
if [[ $SQUEEZELITE == 1 ]]; then
    if [ ! -f "$HOME/src/squeezelite/squeezelite" ]; then
        mkdir -p $HOME/src/squeezelite
        cd $HOME/src/squeezelite
        wget https://sourceforge.net/projects/lmsclients/files/squeezelite/linux/squeezelite-pulse-1.9.9.1428-aarch64.tar.gz/download
        tar -xf download
        cd $HOME
    fi
fi

# librespot
if [[ $LIBRESPOT == 1 ]]; then
    if [ ! -f "$HOME/.cargo/bin/librespot" ]; then
        sudo apt install -y build-essential cargo libpulse-dev
        cargo install librespot --locked
    fi
fi

# Install services
sudo cp $PROJECT_DIR/systemd/* /etc/systemd/user/
systemctl --user daemon-reload

if [[ $WYOMING_SATELLITE == 1 ]]; then
    systemctl --user enable wyoming-satellite.service
    systemctl --user start wyoming-satellite.service
fi
if [[ $SQUEEZELITE == 1 ]]; then
    systemctl --user enable squeezelite.service
    systemctl --user start squeezelite.service
fi
if [[ $LIBRESPOT == 1 ]]; then
    systemctl --user enable librespot.service
    systemctl --user start librespot.service
fi
