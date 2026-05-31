FROM alpine:3

# Add edge repositories for librespot, snapweb (testing) and mympd (community).
# Use @tag pinning so only explicitly tagged packages are pulled from edge;
# everything else resolves from the stable repos to avoid version conflicts.
RUN echo "@testing https://dl-cdn.alpinelinux.org/alpine/edge/testing/" >> /etc/apk/repositories && \
    echo "@community https://dl-cdn.alpinelinux.org/alpine/edge/community/" >> /etc/apk/repositories

RUN apk add --no-cache \
    snapcast-server \
    snapweb@testing \
    librespot@testing \
    mpd \
    mympd@community \
    supervisor \
    py3-mpd2 \
    py3-musicbrainzngs \
    py3-gobject3 \
    py3-dbus

COPY supervisord.conf /etc/supervisord.conf
COPY mpd.conf /etc/mpd.conf
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Create data directories writable by any UID (for --user support)
RUN mkdir -p /var/lib/mpd/music /var/lib/mpd/playlists /var/lib/mpd/data \
    /var/lib/librespot-cache /var/lib/snapserver \
    /var/lib/mympd /var/cache/mympd && \
    chmod 777 /var/lib/mpd /var/lib/mpd/music /var/lib/mpd/playlists /var/lib/mpd/data \
    /var/lib/librespot-cache /var/lib/snapserver \
    /var/lib/mympd /var/cache/mympd

VOLUME /var/lib/mpd
VOLUME /var/lib/snapserver
VOLUME /var/lib/librespot-cache
VOLUME /var/lib/mympd

# Snapcast stream protocol (snapclients connect here)
EXPOSE 1704
# Snapcast control protocol
EXPOSE 1705
# Snapcast HTTP JSON-RPC API / Snapweb
EXPOSE 1780
# MPD control
EXPOSE 6600
# myMPD web interface
EXPOSE 8080

ENTRYPOINT ["/entrypoint.sh"]
