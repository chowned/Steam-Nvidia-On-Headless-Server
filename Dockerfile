FROM debian:bullseye-slim
LABEL maintainer="Josh.5 <jsunnex@gmail.com>"

# Update package repos
ARG DEBIAN_FRONTEND=noninteractive
RUN \
    echo "**** Update apt database ****" \
        && sed -i '/^.*main/ s/$/ contrib non-free/' /etc/apt/sources.list \
    && \
    echo
    
RUN apt update && apt upgrade -y
RUN echo 'en_US.UTF-8 UTF-8' > /etc/locale.gen 
RUN locale-gen
RUN apt-get clean autoclean -y && apt-get autoremove
RUN rm -rf /var/lib/apt/lists/* /var/tmp/* /tmp/*

ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8
    
RUN apt-get install -y --reinstall ca-certificates

RUN apt-get install -y --no-install-recommends curl \
            git \
            mlocate \
            nano \
            net-tools \
            patch \
            pciutils \
            pkg-config \
            procps \
            rsync \
            screen \
            sudo \
            unzip \
            wget \
            xz-utils
            
RUN apt-get install -y --no-install-recommends \
            python3 \
            python3-numpy \
            python3-pip \
            python3-setuptools
            
RUN  rm -rf \
            /var/lib/apt/lists/* \
            /var/tmp/* \
            /tmp/*
            
RUN apt-get install -y supervisor
RUN dpkg --add-architecture i386
RUN apt-get install -y --no-install-recommends \
            libgl1-mesa-dri \
            libgl1-mesa-glx \
            libgles2-mesa \
            libglu1-mesa \
            mesa-utils \
            mesa-utils-extra
           
RUN apt-get install -y --no-install-recommends \
            libvulkan1 \
            libvulkan1:i386 \
            mesa-vulkan-drivers \
            mesa-vulkan-drivers:i386 \
            vulkan-tools
            
RUN apt-get install -y --no-install-recommends \
            libdbus-1-3 \
            libegl1 \
            libgtk-3-0 \
            libgtk2.0-0 \
            libsdl2-2.0-0
            
RUN apt-get install -y --no-install-recommends \
            avahi-utils \
            dbus-x11 \
            libxcomposite-dev \
            libxcursor1 \
            x11-xfs-utils \
            x11vnc \
            xauth \
            xfonts-base \
            xorg \
            xserver-xorg-core \
            xserver-xorg-input-evdev \
            xserver-xorg-input-libinput \
            xserver-xorg-legacy \
            xserver-xorg-video-all \
            xserver-xorg-video-dummy \
            xvfb
            
RUN apt-get install -y --no-install-recommends \
            pulseaudio \
            alsa-utils \
            libasound2 \
            libasound2-plugins 
            
RUN apt-get install -y openssh-server 
RUN echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config

# Install Neko server
COPY --from=m1k1o/neko:base /usr/bin/neko /usr/bin/neko
COPY --from=m1k1o/neko:base /var/www /var/www

ARG NOVNC_VERSION=1.2.0
RUN  cd /tmp \
        && wget -O /tmp/novnc.tar.gz https://github.com/novnc/noVNC/archive/v${NOVNC_VERSION}.tar.gz \
        && cd /tmp \
        && tar -xvf /tmp/novnc.tar.gz \
        && cd /tmp/noVNC-${NOVNC_VERSION} \
        && sed -i 's/credentials: { password: password } });/credentials: { password: password },\n                           wsProtocols: ["'"binary"'"] });/g' app/ui.js \
        && mkdir -p /opt \
        && rm -rf /opt/noVNC \
        && cd /opt \
        && mv -f /tmp/noVNC-${NOVNC_VERSION} /opt/noVNC \
        && cd /opt/noVNC \
        && ln -s vnc.html index.html \
        && chmod -R 755 /opt/noVNC \
        && sed -i '/    document.title =/c\    document.title = "Steam Headless - noVNC";' \
            /opt/noVNC/app/ui.js \
        && apt-get update \
        && apt-get install -y \
            nginx \
        && apt-get clean autoclean -y \
        && apt-get autoremove -y \
        && rm -rf \
            /var/lib/apt/lists/* \
            /tmp/noVNC* \
            /tmp/novnc.tar.gz
