FROM centos:7

RUN yum install -y curl wget gnupg \
    && wget -O - https://rpm.nodesource.com/setup_14.x | bash \
    && yum -y install nodejs \
    && yum groupinstall -y 'Development Tools' \
    && yum install -y epel-release \
    && yum install -y git gcc make gcc-c++.x86_64 boost-dev boost-system-dev boost-date-time-dev sodium-dev \
    && git clone https://github.com/MoneroOcean/xmr-node-proxy /xmr-node-proxy \
    && cd /xmr-node-proxy \
    && npm install \
    && cp -n config_example.json config.json \
    && openssl req -subj "/C=IT/ST=Pool/L=Daemon/O=Mining Pool/CN=mining.proxy" -newkey rsa:2048 -nodes -keyout cert.key -x509 -out cert.pem -days 36500 \
    && cd / && rm -rf /xmr-node-proxy 

EXPOSE 8080 8443 3333

WORKDIR /xmr-node-proxy
CMD node proxy.js
