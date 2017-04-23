FROM ubuntu:16.04
MAINTAINER Marcel O'Neil <marcel@marceloneil.com>

ARG DEBIAN_FRONTEND="noninteractive"
ENV TZ="Etc/UTC" \
    USER="build" \
    JACK_RAM="4G" \
    USE_CCACHE=1 \
    CCACHE_SIZE="75G" \
    TAG="14.1" \
    TYPE="NIGHTLY" \
    SIGN_BUILDS=0 \
    PATH=/build/bin:$PATH 

# Add files
ADD . /build

RUN sed -i 's/main$/main universe/' /etc/apt/sources.list && \
    apt-get -qq update && \
    apt-get -qqy upgrade && \

# Install build dependencies
    apt-get install -y \
    bc \
    bison \
    build-essential \
    ccache \
    curl \
    flex \
    git \
    gnupg \
    gperf \
    imagemagick \
    libesd0-dev \
    liblz4-tool \
    libncurses5-dev \
    libsdl1.2-dev \
    libwxgtk3.0-dev \
    libxml2 \
    libxml2-utils \
    lzop maven \
    openjdk-8-jdk \
    pngcrush \
    schedtool \
    squashfs-tools \
    sudo \
    tzdata \
    xsltproc \
    zip \
    zlib1g-dev && \

# For 64-bit systems
    apt-get install -y \
    g++-multilib \
    gcc-multilib \
    lib32ncurses5-dev \
    lib32readline6-dev \
    lib32z1-dev && \

# Fix timezone
    ln -fs /usr/share/zoneinfo/$TZ /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata && \

# Create user build
    useradd build -d /build && \

# Add sudo permission
    echo "build ALL=NOPASSWD: ALL" > /etc/sudoers.d/build && \

# Add repo command
    curl http://commondatastorage.googleapis.com/git-repo-downloads/repo > /build/bin/repo && \
    chmod a+x /build/bin/repo && \

# Fix script permissions
    chmod a+x /build/bin/build && \
    chmod a+x /build/bin/migration && \

# Fix ownership
    chown -R build:build /build

VOLUME ["/build/android", "/build/zips", "/build/android-certs", "/srv/ccache"]

CMD build
USER build
WORKDIR /build/android
