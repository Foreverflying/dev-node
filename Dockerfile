ARG NODE_VERSION="latest"

FROM node:${NODE_VERSION}

LABEL maintainer="Andy Deng <andy.z.deng@gmail.com>"

RUN apt-get update && \
    apt-get -y upgrade && \
    ACCEPT_EULA=Y DEBIAN_FRONTEND=noninteractive apt-get install -y \
        lsof \
        netcat \
        net-tools \
        telnet \
        vim \
        psmisc \
        sudo \
        unzip \
        tzdata \
        && \
    apt-get autoclean && \
    usermod node -s /bin/bash && \
    mkdir -p /opt/workspace && \
    chown node:node /opt/workspace && \
    chmod u+w /etc/sudoers && \
    echo 'node    ALL=(ALL)    NOPASSWD:ALL' > /etc/sudoers && \
    chmod u-w /etc/sudoers

USER node

VOLUME [ "/home/node" ]

WORKDIR /opt/workspace

CMD tail -f
