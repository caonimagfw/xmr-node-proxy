FROM alpine:latest
ENV ALPINE_MIRROR "http://dl-cdn.alpinelinux.org/alpine"
RUN echo "${ALPINE_MIRROR}/edge/main" >> /etc/apk/repositories
RUN apk add --no-cache nodejs-current  --repository="http://dl-cdn.alpinelinux.org/alpine/edge/community"
RUN apk add --no-cache --virtual .gyp python git make cmake libstdc++ gcc g++ automake libtool autoconf linux-headers bash openssl-dev
RUN apk add --no-cache boost boost-dev boost-system boost-date_time libsodium npm
RUN git clone https://github.com/MoneroOcean/xmr-node-proxy /xmr-node-proxy \
    && cd /xmr-node-proxy \
    && npm install \
    && cp -n config_example.json config.json \
    && openssl req -subj "/C=IT/ST=Pool/L=Daemon/O=Mining Pool/CN=mining.proxy" -newkey rsa:2048 -nodes -keyout cert.key -x509 -out cert.pem -days 36500 \
    && cd / && rm -rf /xmr-node-proxy 

EXPOSE 8080 8443 3333

WORKDIR /xmr-node-proxy
CMD node proxy.js

