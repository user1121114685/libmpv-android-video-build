# --------------------------------------------------

if [ ! -f "deps" ]; then
  sudo rm -r deps
fi
if [ ! -f "prefix" ]; then
  sudo rm -r prefix
fi
tree -d $ANDROID_NDK_HOME
./download.sh
./patch.sh

# --------------------------------------------------

if [ ! -f "scripts/ffmpeg" ]; then
  rm scripts/ffmpeg.sh
fi
cp flavors/default.sh scripts/ffmpeg.sh

# --------------------------------------------------

./build.sh

# --------------------------------------------------

cd deps/media-kit-android-helper

sudo chmod +x gradlew
./gradlew assembleRelease

unzip -q -o app/build/outputs/apk/release/app-release.apk -d app/build/outputs/apk/release

# 设置jniLibs目录的路径
jniLibs_dir="../../../libmpv/src/main/jniLibs"

# 创建符号链接
for arch in arm64-v8a armeabi-v7a x86 x86_64; do
  ln -sf "$(pwd)/app/build/outputs/apk/release/lib/$arch/libmediakitandroidhelper.so" "$jniLibs_dir/$arch"
done

# 链接ffmpeg的相关库
for lib in libswscale libswresample libpostproc libavutil libavformat libavfilter libavdevice libavcodec; do
  for arch in arm64-v8a armeabi-v7a x86 x86_64; do
    ln -sf prefix"/$arch/lib/$lib.so" "$jniLibs_dir/$arch"
  done
done

cd ../..

# --------------------------------------------------

cd deps/media_kit/media_kit_native_event_loop

flutter create --org com.alexmercerind --template plugin_ffi --platforms=android .

if ! grep -q android "pubspec.yaml"; then
  printf "      android:\n        ffiPlugin: true\n" >> pubspec.yaml
fi

flutter pub get

cp -a ../../mpv/libmpv/. src/include/

cd example

flutter clean
flutter build apk --release

unzip -q -o build/app/outputs/apk/release/app-release.apk -d build/app/outputs/apk/release

cd build/app/outputs/apk/release/

# --------------------------------------------------

rm -r lib/*/libapp.so
rm -r lib/*/libflutter.so

# 链接 c++shared.so
c_shere_so=$(echo "$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/"*"/sysroot/usr/lib")
ln -sf "$c_shere_so/aarch64-linux-android/libc++_shared.so" "./lib/arm64-v8a"
ln -sf "$c_shere_so/arm-linux-androideabi/libc++_shared.so" "./lib/armeabi-v7a"
ln -sf "$c_shere_so/i686-linux-android/libc++_shared.so" "./lib/x86"
ln -sf "$c_shere_so/x86_64-linux-android/libc++_shared.so" "./lib/x86_64"
tree -d $c_shere_so
tree -a

zip -r "default-arm64-v8a.jar"                lib/arm64-v8a
zip -r "default-armeabi-v7a.jar"              lib/armeabi-v7a
zip -r "default-x86.jar"                      lib/x86
zip -r "default-x86_64.jar"                   lib/x86_64

mkdir -p ../../../../../../../../../../output

cp *.jar ../../../../../../../../../../output

md5sum *.jar > ../../../../../../../../../../output/default_md5.txt

cd ../../../../../../../../..

# --------------------------------------------------

zip -r debug-symbols-default.zip prefix/*/lib
cp debug-symbols-default.zip ../output
