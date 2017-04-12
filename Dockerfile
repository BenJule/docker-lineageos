# Build environment for LineageOS

FROM ubuntu:16.04
MAINTAINER Marcel O'Neil <marcel@marceloneil.com>

ENV DEBIAN_FRONTEND noninteractive

RUN sed -i 's/main$/main universe/' /etc/apt/sources.list
RUN apt-get -qq update
RUN apt-get -qqy upgrade

# Install build dependencies (source: https://wiki.cyanogenmod.org/w/Build_for_bullhead)
RUN apt-get install -y bc bison build-essential curl flex git gnupg gperf libesd0-dev liblz4-tool libncurses5-dev libsdl1.2-dev libwxgtk3.0-dev libxml2 libxml2-utils lzop maven openjdk-8-jdk pngcrush schedtool squashfs-tools xsltproc zip zlib1g-dev

# For 64-bit systems
RUN apt-get install -y g++-multilib gcc-multilib lib32ncurses5-dev lib32readline6-dev lib32z1-dev

# Install additional packages which are useful for building Android
RUN apt-get install -y ccache sudo imagemagick

# Create user build
RUN mkdir /build
RUN useradd build -d /build

# Add repo function
RUN curl http://commondatastorage.googleapis.com/git-repo-downloads/repo > /bin/repo
RUN chmod a+x /bin/repo

# Add sudo permission
RUN echo "build ALL=NOPASSWD: ALL" > /etc/sudoers.d/build

# Add startup script
ADD startup.sh /build/startup.sh
RUN chmod a+x /build/startup.sh

# Fix ownership
RUN chown -R build:build /build

VOLUME ["/build/android", "/build/zips", "/build/android-certs", "/srv/ccache"]

CMD /build/startup.sh

USER build
WORKDIR /build/android
