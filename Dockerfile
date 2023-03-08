FROM docker.io/jellyfin/jellyfin:10.8.9

RUN apt update && \
    apt install --no-install-recommends --no-install-suggests -y openssh-client

COPY --from=ghcr.io/aleksasiriski/rffmpeg-go:v0.0.4 /app/rffmpeg-go/rffmpeg-go /usr/local/bin/rffmpeg

RUN chmod +x /usr/local/bin/rffmpeg && \
    ln -s /usr/local/bin/rffmpeg /usr/local/bin/ffmpeg && \
    ln -s /usr/local/bin/rffmpeg /usr/local/bin/ffprobe

COPY rffmpeg.yml /etc/rffmpeg/rffmpeg.yml

RUN mkdir -p /config/rffmpeg/.ssh && \
    chmod 700 /config/rffmpeg/.ssh && \
    ssh-keygen -t ed25519 -f /config/rffmpeg/.ssh/id_ed25519 -q -N ""

RUN apt purge wget -y && \
    rm -rf /var/lib/apt/lists/* && \
    apt autoremove --purge -y && \
    apt clean

VOLUME /config

ENTRYPOINT ["./jellyfin/jellyfin", \
    "--datadir", "/config", \
    "--cachedir", "/config/cache", \
    "--ffmpeg", "/usr/local/bin/ffmpeg"]