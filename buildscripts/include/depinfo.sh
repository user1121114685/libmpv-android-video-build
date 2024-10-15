#!/bin/bash -e

## Dependency versions

v_sdk=11076708_latest
v_ndk=27.1.12297006
v_sdk_build_tools=35.0.0

v_libass=0.17.3
v_harfbuzz=10.0.1
v_fribidi=1.0.16
v_freetype=2-13-3
v_mbedtls=3.6.1
v_libplacebo=7.349.0
v_dav1d=1.4.3
v_libxml2=2.10.3
v_ffmpeg=master
v_mpv=master
v_libogg=1.3.5
v_libvorbis=1.3.7
v_libvpx=1.13


## Dependency tree
# I would've used a dict but putting arrays in a dict is not a thing

dep_mbedtls=()
dep_dav1d=()
dep_libvorbis=(libogg)
if [ -n "$ENCODERS_GPL" ]; then
	dep_ffmpeg=(mbedtls dav1d libxml2 libvorbis libvpx libx264)
else
	dep_ffmpeg=(mbedtls dav1d libxml2)
fi
dep_freetype2=()
dep_fribidi=()
dep_harfbuzz=()
dep_libass=(freetype fribidi harfbuzz)
dep_lua=()
dep_shaderc=()
dep_libplacebo=()
if [ -n "$ENCODERS_GPL" ]; then
	dep_mpv=(ffmpeg libass libplacebo fftools_ffi)
else
	dep_mpv=(ffmpeg libass libplacebo)
fi
