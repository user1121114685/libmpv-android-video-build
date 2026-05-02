#!/bin/bash -e

## Dependency versions

v_sdk=9123335_latest
v_ndk=27.2.12479018
v_sdk_build_tools=34.0.0

v_libass=0.17.4
v_harfbuzz=14.2.0
v_fribidi=1.0.16
v_freetype=2-14-3
v_mbedtls=4.1.0
v_dav1d=1.5.3
v_libxml2=2.15.3
v_ffmpeg=8.1
v_mpv=5e847889b34b736760a1702b82191693d89d46d9
v_libplacebo=27aa71a97f4daed84916936572fa6a2e1c3eedb7
v_lcms2=lcms2.19
v_libogg=1.3.6
v_libvorbis=1.3.7
v_libvpx=1.15.2
v_libx264=0480cb05fa188d37ae87e8f4fd8f1aea3711f7ee
v_fftools_ffi=9b0d4da026d9c830702ec043c1f1f98d407025af
v_media_kit_android_helper=b768ce102cfa9b5ddec618bb939d689d1b0899fa
v_gas_preprocessor=ac1836309c2e77023c228b7184485597286289d3

## Pinned commit SHAs for tag-based clones
sha_mbedtls=0fe989b6b514192783c469039edd325fd0989806
sha_dav1d=b546257f770768b2c88258c533da38b91a06f737
sha_libxml2=c94eb0210183b9d7cb43f8e7fddc6be55843ef49
sha_libvpx=d168454ecd099805c675d4a98c66f4891373302a
sha_ffmpeg=9047fa1b084f76b1b4d065af2d743df1b40dfb56
sha_freetype=0a0221a1347e2f1e07c395263540026e9a0aa7c7
sha_fribidi=68162babff4f39c4e2dc164a5e825af93bda9983
sha_harfbuzz=b0ffab42d473eb380ad0fcf42730e0f1868cbc97
sha_libass=bbb3c7f1570a4a021e52683f3fbdf74fe492ae84
sha_lcms2=b76633e60c8387a77268fb3359277ca25b5fd75c


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
dep_libplacebo=(shaderc lcms2)
if [ -n "$ENCODERS_GPL" ]; then
	dep_mpv=(ffmpeg libass libplacebo fftools_ffi)
else
	dep_mpv=(ffmpeg libass libplacebo)
fi
