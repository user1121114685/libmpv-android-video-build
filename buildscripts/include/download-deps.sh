#!/bin/bash -e

. ./include/depinfo.sh

[ -z "$WGET" ] && WGET=wget

mkdir -p deps && cd deps

# mbedtls
[ ! -d mbedtls ] && git clone --depth 1 --branch $v_mbedtls --recursive https://github.com/Mbed-TLS/mbedtls.git mbedtls

# dav1d
[ ! -d dav1d ] && git clone --depth 1 --branch $v_dav1d https://code.videolan.org/videolan/dav1d.git dav1d

# libiconv
[ ! -d libiconv ] && git clone --depth 1 --branch $v_libiconv https://git.savannah.gnu.org/git/libiconv.git libiconv

# libxml2
[ ! -d libxml2 ] && git clone --depth 1 --branch $v_libxml2 --recursive https://gitlab.gnome.org/GNOME/libxml2.git libxml2

# ffmpeg
[ ! -d ffmpeg ] && git clone --depth 1 --branch $v_ffmpeg https://github.com/FFmpeg/FFmpeg.git ffmpeg

# freetype2
[ ! -d freetype2 ] && git clone --recurse-submodules --depth 1 --branch $v_freetype https://github.com/freetype/freetype.git freetype2

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
[ ! -d mpv ] && git clone --depth 1 --branch $v_mpv https://github.com/mpv-player/mpv.git mpv



# media-kit-android-helper
[ ! -d media-kit-android-helper ] && git clone --depth 1 --branch main https://github.com/media-kit/media-kit-android-helper.git


cd ..
