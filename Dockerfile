# 16.04 LTS
FROM ubuntu:xenial

RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get -y install --no-install-recommends sudo curl git ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN useradd --home-dir /home/ci --create-home --shell /bin/bash --user-group ci --groups sudo
RUN echo 'ci ALL=NOPASSWD: ALL' >> /etc/sudoers

USER ci
