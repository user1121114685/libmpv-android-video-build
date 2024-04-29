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
# https://mesonbuild.com/Builtin-options.html
# 如果使用 cpp_args 只能编译 c++的跨平台 所以这里改成 c_args  因为 libmpv 是c 项目
# ndk\25.2.9519653\toolchains\llvm\prebuilt\windows-x86_64\bin\llvm-readelf.exe -d I:\libmpv.so 查看 依赖情况
# media-kit 依赖情况如下  没有  [libc++_shared.so]
#  0x0000000000000001 (NEEDED)       Shared library: [libm.so]
#  0x0000000000000001 (NEEDED)       Shared library: [libandroid.so]
#  0x0000000000000001 (NEEDED)       Shared library: [libOpenSLES.so]
#  0x0000000000000001 (NEEDED)       Shared library: [libEGL.so]
#  0x0000000000000001 (NEEDED)       Shared library: [libdl.so]
#  0x0000000000000001 (NEEDED)       Shared library: [libc.so]

meson setup $build --cross-file "$prefix_dir"/crossfile.txt \
	--default-library shared \
	-Diconv=disabled -Dlua=disabled \
	-Dlibmpv=true -Dcplayer=false \
	-Dmanpage-build=disabled

ninja -C $build -j$cores
DESTDIR="$prefix_dir" ninja -C $build install

echo "当前 native_dir 目录路径是 $native_dir"
ln -sf "$prefix_dir"/lib/libmpv.so "$native_dir"
