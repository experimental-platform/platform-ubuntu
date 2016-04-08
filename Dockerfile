FROM ubuntu:xenial
# Activate the multiverse
# RUN sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.lists
ENV DEBIAN_FRONTEND noninteractive
ENV container docker
RUN mkdir -p  /etc/apt/sources.d/
RUN echo "deb mirror://mirrors.ubuntu.com/mirrors.txt xenial main restricted universe multiverse \n\
deb mirror://mirrors.ubuntu.com/mirrors.txt xenial-updates main restricted universe multiverse \n\
deb mirror://mirrors.ubuntu.com/mirrors.txt xenial-backports main restricted universe multiverse \n\
deb mirror://mirrors.ubuntu.com/mirrors.txt xenial-security main restricted universe multiverse" > /etc/apt/sources.d/ubuntu-mirrors.list


# Update to latest packages
# make the "de_DE.UTF-8" locale so postgres will be utf-8 enabled by default and further installations work as expected.
RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get -y install --no-install-recommends \
    sudo netcat unzip curl software-properties-common tar unzip wget git locales && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN wget -O /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.0.0/dumb-init_1.0.0_amd64 && \
    chmod +x /usr/local/bin/dumb-init

# TODO: Re-enable once Ubuntu gets its shit together
# See: https://bugs.launchpad.net/ubuntu/+source/apparmor/+bug/969299
RUN localedef -i de_DE -c -f UTF-8 -A /usr/share/locale/locale.alias de_DE.UTF-8
RUN update-locale LANG=de_DE.utf8
RUN locale-gen de_DE.utf8

#
# Set local timezone
#
RUN rm /etc/localtime; ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime
RUN dpkg-reconfigure tzdata

# Set environment variables.
# ENV LANG de_DE.utf8
# ENV LC_ALL de_DE.utf8
# ENV LANG de_DE.utf8
# ENV LANGUAGE de_DE.utf8

ENV HOME /root
WORKDIR /

# Define default command.
CMD ["bash"]
