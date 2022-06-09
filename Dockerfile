FROM python:3.9-slim

WORKDIR /

RUN if [ "$(uname -m)" = "aarch64" ] ; then \
        export HOST_CPU_ARCH=arm64; \
    elif [ "$(uname -m)" = "x86_64" ]; then \
        export HOST_CPU_ARCH=amd64; \
        apt-get -y update && apt-get -y upgrade && \
        apt-get install -y software-properties-common && \
        add-apt-repository -y ppa:qbittorrent-team/qbittorrent-stable && \
        apt-get install -y python3 python3-pip python3-lxml aria2 \
        qbittorrent-nox tzdata p7zip-full p7zip-rar xz-utils wget libmagic-dev libffi-dev curl pv jq \
        locales unzip neofetch mediainfo git make g++ gcc automake \
        autoconf libtool libcurl4-openssl-dev qt5-default \
        libsodium-dev libssl-dev libcrypto++-dev libc-ares-dev \
        libsqlite3-dev libfreeimage-dev swig libboost-all-dev \
        libpthread-stubs0-dev zlib1g-dev && \
        wget -q https://github.com/yzop/gg/raw/main/ffmpeg-git-${HOST_CPU_ARCH}-static.tar.xz && \
        tar -xf ff*.tar.xz && rm -rf *.tar.xz && \
        mv ff*/ff* /usr/local/bin/ && rm -rf ff* && \
        wget -q https://github.com/viswanathbalusu/megasdkrest/releases/latest/download/megasdkrest-${HOST_CPU_ARCH} -O /usr/local/bin/megasdkrest && \
        chmod a+x /usr/local/bin/megasdkrest && mkdir /app/ && chmod 777 /app/ && \
        apt-get -y autoremove && rm -rf /var/lib/apt/lists/* && apt-get clean && \
        pip3 install --no-cache-dir MirrorX && \
        apt-get purge -yqq gcc && apt-get -y autoremove && rm -rf /var/lib/apt/lists/* && apt-get clean
        
# Requirements Mirror Bot
COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt

RUN apt-get -y update && apt-get -y upgrade && apt-get -y autoremove && apt-get -y autoclean

WORKDIR /app
RUN chmod 777 /app

COPY . .

CMD ["bash", "start.sh"]
