#!/bin/bash -e

. ../../include/depinfo.sh
. ../../include/path.sh

build=_build$ndk_suffix

if [ "$1" == "build" ]; then
	true
elif [ "$1" == "clean" ]; then
	rm -rf $build
	exit 0
else
	exit 255
fi

unset CC CXX
meson setup $build --wipe --cross-file "$prefix_dir"/crossfile.txt \
	-Dvulkan=disabled -Ddemos=false -Ddefault_library=static

ninja -C $build -j$cores
DESTDIR="$prefix_dir" ninja -C $build install
#${SED:-sed} '/^Libs:/ s|-lc++|-static-libc++|' "$prefix_dir/lib/pkgconfig/libplacebo.pc" -i
