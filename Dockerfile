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
	firefox \
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
	ca-certificates \
	qbittorrent \
	systemd \
	ufw \
	docker.io \
    && apt-get autoclean \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/*
RUN dpkg-reconfigure locales






RUN adduser ubuntu

RUN echo "ubuntu:ubuntu" | chpasswd && \
    adduser ubuntu sudo && \
    sudo usermod -a -G sudo ubuntu

#RUN wget https://download.teamviewer.com/download/linux/teamviewer_amd64.deb && apt install ./teamviewer_amd64.deb
RUN wget https://downloads.rclone.org/v1.55.0/rclone-v1.55.0-linux-amd64.deb && apt install ./rclone-v1.55.0-linux-amd64.deb

#RUN wget https://www.dropbox.com/download?dl=packages/ubuntu/dropbox_2020.03.04_amd64.deb && apt install ./dropbox_2020.03.04_amd64.deb


#RUN wget https://github.com/bnichs5/vnc/raw/master/xdman.deb && apt install ./xdman.deb

RUN sudo apt install apt-transport-https
RUN wget -O - https://repo.jellyfin.org/jellyfin_team.gpg.key | sudo apt-key add -
RUN echo "deb [arch=$( dpkg --print-architecture )] https://repo.jellyfin.org/$( awk -F'=' '/^ID=/{ print $NF }' /etc/os-release ) $( awk -F'=' '/^VERSION_CODENAME=/{ print $NF }' /etc/os-release ) main" | sudo tee /etc/apt/sources.list.d/jellyfin.list
RUN sudo apt update
RUN sudo apt install jellyfin -y
#RUN sudo systemctl start jellyfin.service
#RUN sudo systemctl start jellyfin
#RUN sudo service jellyfin enable

RUN sudo service jellyfin start

RUN sudo ufw allow 8096



#RUN curl https://downloads.plex.tv/plex-keys/PlexSign.key | sudo apt-key add -
#RUN echo deb https://downloads.plex.tv/repo/deb public main | sudo tee /etc/apt/sources.list.d/plexmediaserver.list
#RUN sudo apt install apt-transport-https
#RUN sudo apt update
#RUN sudo apt -f install plexmediaserver -y
#RUN sudo systemctl status plexmediaserver
#RUN sudo systemctl start plexmediaserver.service

#RUN sudo mkdir -p /opt/plexmedia/
#RUN sudo chown -R plex: /opt/plexmedia





#RUN wget https://downloads.plex.tv/plex-media-server-new/1.22.2.4282-a97b03fad/debian/plexmediaserver_1.22.2.4282-a97b03fad_amd64.deb && apt install ./plexmediaserver_1.22.2.4282-a97b03fad_amd64.deb -y
#RUN sudo systemctl enable plexmediaserver.service
#RUN sudo systemctl start plexmediaserver.service
#RUN sudo service plexmediaserver start











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

