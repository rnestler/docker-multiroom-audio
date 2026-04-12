FROM alpine:3

# Add testing repository for librespot
RUN echo "https://dl-cdn.alpinelinux.org/alpine/edge/testing/" >> /etc/apk/repositories

RUN apk add --no-cache \
    snapcast-server \
    librespot \
    mpd \
    supervisor

COPY supervisord.conf /etc/supervisord.conf
COPY snapserver.conf /etc/snapserver.conf
COPY mpd.conf /etc/mpd.conf
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Create MPD directories
RUN mkdir -p /var/lib/mpd/music /var/lib/mpd/playlists /var/lib/mpd/data

# Snapcast stream protocol (snapclients connect here)
EXPOSE 1704
# Snapcast control protocol
EXPOSE 1705
# Snapcast HTTP JSON-RPC API
EXPOSE 1780
# MPD control
EXPOSE 6600

ENTRYPOINT ["/entrypoint.sh"]
