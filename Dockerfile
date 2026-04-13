FROM alpine:3

# Add testing repository for librespot and snapweb
RUN echo "https://dl-cdn.alpinelinux.org/alpine/edge/testing/" >> /etc/apk/repositories

RUN apk add --no-cache \
    snapcast-server \
    snapweb \
    librespot \
    mpd \
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
    /var/lib/librespot-cache /var/lib/snapserver && \
    chmod 777 /var/lib/mpd /var/lib/mpd/music /var/lib/mpd/playlists /var/lib/mpd/data \
    /var/lib/librespot-cache /var/lib/snapserver

VOLUME /var/lib/mpd
VOLUME /var/lib/snapserver
VOLUME /var/lib/librespot-cache

# Snapcast stream protocol (snapclients connect here)
EXPOSE 1704
# Snapcast control protocol
EXPOSE 1705
# Snapcast HTTP JSON-RPC API / Snapweb
EXPOSE 1780
# MPD control
EXPOSE 6600

ENTRYPOINT ["/entrypoint.sh"]
