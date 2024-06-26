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

unset CC CXX # meson wants these unset

meson setup $build --cross-file "$prefix_dir"/crossfile.txt \
  --buildtype=release \
  --default-library=static \
  -Dfontconfig=disabled \
  -Ddirectwrite=disabled \
  -Dasm=disabled \
  -Dlibunibreak=enabled \
  -Drequire-system-font-provider=false

ninja -C $build -j$cores
DESTDIR="$prefix_dir" ninja -C $build install
