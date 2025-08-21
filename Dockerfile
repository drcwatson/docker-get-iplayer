# Forked from https://github.com/JamesBarwell/docker-get-iplayer
ARG ALPINE_VERSION=latest
FROM alpine:${ALPINE_VERSION}
LABEL maintainer="barwell, cwatson"

RUN apk --update add \
    ffmpeg \
    openssl \
    perl-mojolicious \
    perl-lwp-protocol-https \
    perl-xml-simple \
    perl-xml-libxml \
    perl-cgi

RUN apk add atomicparsley --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ --allow-untrusted && ln -s `which atomicparsley` /usr/local/bin/AtomicParsley

RUN mkdir -p /data

WORKDIR /app

# Create a new group and user inside the container
# GID and UID are to match settings in the NFS host
ENV UID=1000
ENV GID=1000
RUN addgroup -g ${GID} -S iplayer && adduser -S iplayer -G iplayer -u ${UID}

RUN wget -q https://raw.githubusercontent.com/get-iplayer/get_iplayer/master/get_iplayer && \
    wget -q https://raw.githubusercontent.com/get-iplayer/get_iplayer/master/get_iplayer.cgi && \
    chmod 0755 ./get_iplayer ./get_iplayer.cgi

    # Create a local script with the right arguments
RUN echo "/app/get_iplayer --ffmpeg /usr/bin/ffmpeg --profile-dir /data/iplayer/.get_iplayer --output /data/iplayer $*" > /app/get_iplayer.sh && \
    chmod +x /app/get_iplayer.sh

# Set the created user as the default user
USER iplayer

ENTRYPOINT ["/app/get_iplayer", "--ffmpeg", "/usr/bin/ffmpeg", "--profile-dir", "/data/iplayer/.get_iplayer", "--output", "/data/iplayer"]

CMD ["-h"]

# Expose port for webserver
EXPOSE 1935
