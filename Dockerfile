FROM docker.io/jellyfin/jellyfin:10.8.8

RUN apt update && \
    apt install --no-install-recommends --no-install-suggests -y openssh-client python3-click python3-yaml python3-psycopg2

COPY rffmpeg /usr/local/bin/rffmpeg

RUN chmod +x /usr/local/bin/rffmpeg && \
    ln -s /usr/local/bin/rffmpeg /usr/local/bin/ffmpeg && \
    ln -s /usr/local/bin/rffmpeg /usr/local/bin/ffprobe

COPY rffmpeg.yml /etc/rffmpeg/rffmpeg.yml

RUN mkdir -p /config/rffmpeg/.ssh && \
    chmod 700 /config/rffmpeg/.ssh && \
    ssh-keygen -t rsa -f /config/rffmpeg/.ssh/id_rsa -q -N ""

RUN /usr/local/bin/rffmpeg init -y

RUN apt purge wget -y && \
    rm -rf /var/lib/apt/lists/* && \
    apt autoremove --purge -y && \
    apt clean

VOLUME /config

ENTRYPOINT ["./jellyfin/jellyfin", \
    "--datadir", "/config", \
    "--cachedir", "/config/cache", \
    "--ffmpeg", "/usr/local/bin/ffmpeg"]