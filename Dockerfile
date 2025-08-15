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
    perl-xml-libxml

RUN apk add atomicparsley --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ --allow-untrusted && ln -s `which atomicparsley` /usr/local/bin/AtomicParsley

RUN mkdir -p /data

WORKDIR /app

# Create a new group and user inside the container
RUN addgroup -S iplayer && adduser -S iplayer -G iplayer

RUN wget -q https://raw.githubusercontent.com/get-iplayer/get_iplayer/master/get_iplayer && \
   chmod 0755 ./get_iplayer

# Set the created user as the default user
USER iplayer

ENTRYPOINT ["./get_iplayer", "--ffmpeg", "/usr/bin/ffmpeg", "--profile-dir", "/data/iplayer/.get_iplayer", "--output", "/data/iplayer"]

CMD ["-h"]
