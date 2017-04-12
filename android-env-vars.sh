export PATH=/build/bin:$PATH
if [ $ccache ]; then
    export USE_CCACHE=1
    export CCACHE_DIR=/srv/ccache
fi
export ANDROID_JACK_VM_ARGS="-Dfile.encoding=UTF-8 -XX:+TieredCompilation -Xmx4G"
