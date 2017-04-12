#!/bin/bash

# Initialize ccache if needed
if [ ! -f /srv/ccache/ccache.conf ]; then
	echo "Initializing ccache in /srv/ccache..."
	CCACHE_DIR=/srv/ccache ccache -M 75G
fi

if ! [ `ls -A` ]; then
	repo init -u https://github.com/LineageOS/android.git -b cm-14.1
fi

# Taken in part from julianxhokaxhiu/docker-lineage-cicd
IFS=','
for codename in $DEVICE_LIST; do
	if ! [ -z "$codename" ]; then
		repo sync
		source build/envsetup.sh
		breakfast $codename
		mka target-files-package dist
		croot
		./build/tools/releasetools/sign_target_files_apks -o \
			-d ~/.android-certs \
			out/dist/*-target_files-*.zip \
			out/dist/signed-target_files.zip
		./build/tools/releasetools/ota_from_target_files \
			-k ~/.android-certs/releasekey \
			--block --backup=true \
			out/dist/signed-target_files.zip \
			/home/build/zips/lineage-14.1-`date +%Y%m%d`-$codename.zip
		make clean
	fi
done
