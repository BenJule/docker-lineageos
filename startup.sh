#!/bin/bash

# Allocate 4 gigs to jack
export ANDROID_JACK_VM_ARGS="-Dfile.encoding=UTF-8 -XX:+TieredCompilation -Xmx4G"

# Initialize ccache if needed
if [ $CCACHE ]; then
    echo "Enabling ccache..."
    export USE_CCACHE=1
    export CCACHE_DIR=/srv/ccache
    if [ ! -f /srv/ccache/ccache.conf ]; then
            echo "Initializing ccache in /srv/ccache..."
            export CCACHE_DIR=/srv/ccache ccache -M $CCACHE
    fi
fi

# Initialize repository if needed
if [ ! "$(ls -A)" ]; then
	repo init -u https://github.com/LineageOS/android.git -b cm-$TAG
fi

# The following code is in part from julianxhokaxhiu/docker-lineage-cicd
IFS=','
for codename in $DEVICE_LIST; do
	if [ ! -z "$codename" ]; then
		repo sync
		source build/envsetup.sh
		breakfast $codename
		mka target-files-package dist
                echo "Target files generated???"
		croot
		./build/tools/releasetools/sign_target_files_apks -o \
			-d /build/android-certs \
			out/dist/*-target_files-*.zip \
			out/dist/signed-target_files.zip
		./build/tools/releasetools/ota_from_target_files \
			-k /build/android-certs/releasekey \
			--block --backup=true \
			out/dist/signed-target_files.zip \
			/build/zips/lineage-$TAG-`date +%Y%m%d`-$TYPE-$codename.zip
		make clean
	fi
done
