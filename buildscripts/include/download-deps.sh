#!/bin/bash -e

. ./include/depinfo.sh

[ -z "$WGET" ] && WGET=wget

mkdir -p deps && cd deps

# mbedtls
[ ! -d mbedtls ] && git clone --depth 1 --branch $v_mbedtls --recursive https://github.com/Mbed-TLS/mbedtls.git mbedtls

# dav1d
[ ! -d dav1d ] && git clone --depth 1 --branch $v_dav1d https://code.videolan.org/videolan/dav1d.git dav1d

# libxml2
[ ! -d libxml2 ] && git clone --depth 1 --branch $v_libxml2 --recursive https://gitlab.gnome.org/GNOME/libxml2.git libxml2

# ffmpeg
[ ! -d ffmpeg ] && git clone --depth 1 --branch $v_ffmpeg https://github.com/FFmpeg/FFmpeg.git ffmpeg

# freetype2
[ ! -d freetype2 ] && git clone --recurse-submodules --depth 1 --branch $v_freetype https://gitlab.freedesktop.org/freetype/freetype.git freetype2

# fribidi
[ ! -d fribidi ] && git clone --depth 1 --branch $v_fribidi https://github.com/fribidi/fribidi.git fribidi

# harfbuzz
[ ! -d harfbuzz ] && git clone --depth 1 --branch $v_harfbuzz https://github.com/harfbuzz/harfbuzz.git harfbuzz

# unibreak
[ ! -d unibreak ] && git clone --depth 1 --branch $v_unibreak https://github.com/adah1972/libunibreak.git unibreak

# libass
[ ! -d libass ] && git clone --depth 1 --branch $v_libass https://github.com/libass/libass.git libass
# 新增部分
# libplacebo
[ ! -d libplacebo ] && git clone --depth 1 --branch $v_libplacebo --recursive https://code.videolan.org/videolan/libplacebo.git libplacebo

# mpv
[ ! -d mpv ] && git clone --branch $v_mpv https://github.com/mpv-player/mpv.git mpv

cd mpv
git config --global user.email "admin@shaoxia.xyz"
git config --global user.name "联盟少侠"
 # 添加 PR 提交者的仓库作为新的远程仓库
git remote add pr-remote https://github.com/Dudemanguy/mpv.git

 # 获取 PR 提交者的仓库更新
git fetch pr-remote

 # 直接合并 PR 分支到您当前的分支
git merge pr-remote/queue-seek-stop-play

cd ..

# media-kit-android-helper
[ ! -d media-kit-android-helper ] && git clone --depth 1 --branch main https://github.com/media-kit/media-kit-android-helper.git

# media_kit
[ ! -d media_kit ] && git clone --depth 1 --single-branch --branch main https://github.com/media-kit/media-kit.git media_kit

cd ..
