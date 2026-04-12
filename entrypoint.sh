#!/bin/sh
set -e

# Create the FIFO pipe for MPD -> snapserver
if [ ! -p /tmp/snapfifo-mpd ]; then
    mkfifo /tmp/snapfifo-mpd
fi

exec supervisord -c /etc/supervisord.conf
