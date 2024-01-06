# rpi-speaker

Small set of scripts to set up a vanilla Raspberry Pi OS lite as a Home Assistant speaker.

Services installed:

- [wyoming-satellite](https://github.com/rhasspy/wyoming-satellite#event-commands) (default)
- [squeezelite](https://github.com/ralph-irving/squeezelite) (default)
- [librespot](https://github.com/librespot-org/librespot) (optional)

## Installation

Install Raspberry Pi OS lite on your ARM-powered device (tested on a Raspberry Pi 4B and Zero 2 W).

Set up SSH access, your  and your audio output device (e.g. a USB conference speaker) in `raspi-config`, if not already done.

```bash
sudo raspi-config
```

Clone this repository and run the install script:

```bash
./scripts/install.sh
```

