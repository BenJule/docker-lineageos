#!/bin/bash

echo $PATH
source /etc/bash.bashrc
echo $PATH

# Initialize ccache if needed
if [ ! -f /srv/ccache/ccache.conf ] && [ $ccache ]; then
	echo "Initializing ccache in /srv/ccache..."
	CCACHE_DIR=/srv/ccache ccache -M $ccache
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
