#!/bin/bash -e

## Dependency versions
# Make sure to keep v_ndk and v_ndk_n in sync, the numeric version can be found in source.properties
v_sdk=10406996_latest
v_ndk=r26c
v_ndk_n=26.2.11394342
v_sdk_platform=34
v_sdk_build_tools=33.0.2

v_libass=master
v_harfbuzz=main
v_fribidi=master
v_freetype=master
v_unibreak=master
v_mbedtls=development
v_dav1d=master
v_libxml2=master
v_ffmpeg=master
v_mpv=master

# 新增部分
v_libplacebo=master

## Dependency tree
# I would've used a dict but putting arrays in a dict is not a thing

dep_mbedtls=()
dep_dav1d=()
dep_libvorbis=(libogg)
dep_ffmpeg=(mbedtls dav1d libxml2 libplacebo)
dep_freetype2=()
dep_fribidi=()
dep_harfbuzz=()
dep_unibreak=()
dep_libass=(freetype2 fribidi harfbuzz unibreak)
dep_lua=()
#dep_shaderc=()
dep_libplacebo=()
dep_mpv=(ffmpeg libass libplacebo)
