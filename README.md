docker-lineageos [![Build Status](https://travis-ci.org/marceloneil/docker-lineageos.svg?branch=master)](https://travis-ci.org/marceloneil/docker-lineageos)
==================

Create a [Docker] based environment to build [LineageOS].

This Dockerfile will create a docker container which is based on Ubuntu 16.04.
It will install the "repo" utility and any other build dependencies which are required to compile LineageOS (formerly known as CyanogenMod).

The main working directory is a shared folder on the host system, so the Docker container can be removed at any time.

**NOTE:** Remember that LineageOS is a huge project. It will consume a large amount of disk space (~80 GB) and it can easily take hours to build.

### How to pull

**NOTES:**
* You will need to [install Docker][Docker_Installation] to proceed!
* If an image does not exist, ```docker build``` is executed first

```
docker pull marceloneil/docker-lineageos
```

### Create migration zips

```
docker run \
    --rm \
    -v </path/to/ccache>:/srv/ccache \
    -v </path/to/android>:/build/android \
    -v </path/to/zips>:/build/zips \
    -v </path/to/android-certs>:/build/android-certs \
    marceloneil/docker-lineageos \
    migration
```

### Build android

#### Default build
```
docker run -d \
    --name lineageos-build \
    -e DEVICE_LIST="<device1,device2>" \
    -e NAME="<git name>" \
    -e EMAIL="<git email"> \
    -v </path/to/ccache>:/srv/ccache \
    -v </path/to/android>:/build/android \
    -v </path/to/zips>:/build/zips \
    -v </path/to/android-certs>:/build/android-certs \
    marceloneil/docker-lineageos 
```

#### Signed build
```
docker run -d \
    --name lineageos-build \
    -e DEVICE_LIST="<device1,device2>" \
    -e SIGN_BUILD=1 \
    -e NAME="<git name>" \
    -e EMAIL="<git email"> \
    -v </path/to/ccache>:/srv/ccache \
    -v </path/to/android>:/build/android \
    -v </path/to/zips>:/build/zips \
    -v </path/to/android-certs>:/build/android-certs \
    marceloneil/docker-lineageos 
```

#### All options
```
docker run -d \
    --name lineageos-build \
    -e DEVICE_LIST="<device1,device2>" \
    -e TZ="<timezone>" \ # Default is Etc/UTC
    -e JACK_RAM="<ram to allocate>" \ # Default is 4G
    -e USE_CCACHE=<0/1> \ # Default is 1
    -e CCACHE_SIZE="<size to allocate>" \ # Default is 75G
    -e TAG="<lineageos version>" \ # Default is 14.1
    -e TYPE="<build label>" \ # Default is NIGHTLY
    -e SIGN_BUILDS=<0/1> \ # Default is 0
    -e NAME="<git name>" \
    -e EMAIL="<git email"> \
    -v </path/to/ccache>:/srv/ccache \
    -v </path/to/android>:/build/android \
    -v </path/to/zips>:/build/zips \
    -v </path/to/android-certs>:/build/android-certs \
    marceloneil/docker-lineageos 
```

Then simply run `docker start lineageos-build` to rebuild
    
==================

[Docker]:                      https://www.docker.com/
[LineageOS]:                   https://www.lineageos.org/
[Docker_Installation]:         https://www.docker.com/get-docker
