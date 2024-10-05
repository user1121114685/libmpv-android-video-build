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


# 链接 c++shared.so
c_shere_so=$(echo "$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/"*"/sysroot/usr/lib")
ln -sf "$c_shere_so/aarch64-linux-android/libc++_shared.so" "$jniLibs_dir/arm64-v8a"
ln -sf "$c_shere_so/arm-linux-androideabi/libc++_shared.so" "$jniLibs_dir/armeabi-v7a"
ln -sf "$c_shere_so/i686-linux-android/libc++_shared.so" "$jniLibs_dir/x86"
ln -sf "$c_shere_so/x86_64-linux-android/libc++_shared.so" "$jniLibs_dir/x86_64"
tree -d ../libmpv/src/main/jniLibs
#tree -a

zip -r "default-arm64-v8a.jar"                "$jniLibs_dir/arm64-v8a"
zip -r "default-armeabi-v7a.jar"              "$jniLibs_dir/armeabi-v7a"
zip -r "default-x86.jar"                      "$jniLibs_dir/x86"
zip -r "default-x86_64.jar"                   "$jniLibs_dir/x86_64"

cd ../..

mkdir -p ../../output

cp *.jar ../../output

md5sum *.jar > ../../output/default_md5.txt

cd ..

# --------------------------------------------------

zip -r debug-symbols-default.zip prefix/*/lib
cp debug-symbols-default.zip ../output
