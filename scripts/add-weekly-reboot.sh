#!/usr/bin/env bash

set -e

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

if crontab -l | grep -q 'shutdown -r now'; then
    echo "Crontab already has a weekly reboot"
    exit
fi

# Restart the unit weekly to prevent lock-ups
(crontab -l || true; echo "@weekly /sbin/shutdown -r now") | crontab -