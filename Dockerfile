# VERSION 0.1

FROM ubuntu:14.04
ENV DEBIAN_FRONTEND noninteractive

# Activate the multiverse
RUN sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list

# Update to latest packages
# make the "de_DE.UTF-8" locale so postgres will be utf-8 enabled by default and further installations work as expected.
RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get -y install --no-install-recommends \
    unzip build-essential curl software-properties-common tar unzip wget git locales && \
    localedef -i de_DE -c -f UTF-8 -A /usr/share/locale/locale.alias de_DE.UTF-8 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

#
# Set local timezone
#
RUN echo "Europe/Berlin" > /etc/timezone
RUN dpkg-reconfigure tzdata

# Set environment variables.
# ENV LANG de_DE.utf8
# ENV LC_ALL de_DE.utf8
# ENV LANG de_DE.utf8
# ENV LANGUAGE de_DE.utf8
RUN locale-gen de_DE.utf8
RUN update-locale LANG=de_DE.utf8

ENV HOME /root
WORKDIR /

# Define default command.
CMD ["bash"]