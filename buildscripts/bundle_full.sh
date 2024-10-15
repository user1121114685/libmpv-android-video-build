# --------------------------------------------------

if [ ! -f "deps" ]; then
  sudo rm -r deps
fi
if [ ! -f "prefix" ]; then
  sudo rm -r prefix
fi

./download.sh
./patch.sh

# --------------------------------------------------

if [ ! -f "scripts/ffmpeg" ]; then
  rm scripts/ffmpeg.sh
fi
cp flavors/full.sh scripts/ffmpeg.sh

# --------------------------------------------------

./build.sh

# --------------------------------------------------

cd deps/media-kit-android-helper

sudo chmod +x gradlew
./gradlew assembleRelease

unzip -o app/build/outputs/apk/release/app-release.apk -d app/build/outputs/apk/release

cp app/build/outputs/apk/release/lib/arm64-v8a/libmediakitandroidhelper.so      ../../prefix/arm64-v8a/usr/local/lib
cp app/build/outputs/apk/release/lib/armeabi-v7a/libmediakitandroidhelper.so    ../../prefix/armeabi-v7a/usr/local/lib
cp app/build/outputs/apk/release/lib/x86/libmediakitandroidhelper.so            ../../prefix/x86/usr/local/lib
cp app/build/outputs/apk/release/lib/x86_64/libmediakitandroidhelper.so         ../../prefix/x86_64/usr/local/lib

cd ../..

# List of architectures
architectures=("arm64-v8a" "armeabi-v7a" "x86" "x86_64")

# Create temporary directory structure for all architectures
for arch in "${architectures[@]}"; do
    mkdir -p "temp/lib/${arch}"
done

# Copy .so files for all architectures
for arch in "${architectures[@]}"; do
    cp "prefix/${arch}/usr/local/lib"/*.so "temp/lib/${arch}/"
done

# Create JAR files for each architecture
for arch in "${architectures[@]}"; do
    jar_name="default-${arch}.jar"
    (cd temp && zip -r "../${jar_name}" "lib/${arch}")
done

# Clean up temporary directory
rm -rf temp

md5sum *.jar
