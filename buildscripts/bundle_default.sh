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
cp flavors/default.sh scripts/ffmpeg.sh

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

# Function to create JAR with desired structure
create_jar() {
    arch=$1
    src_dir="prefix/$arch/usr/local/lib"
    jar_name="default-$arch.jar"
    
    # Create a temporary directory
    temp_dir=$(mktemp -d)
    
    # Copy .so files to the temporary directory with desired structure
    mkdir -p "$temp_dir/lib/$arch"
    cp "$src_dir"/*.so "$temp_dir/lib/$arch/"
    
    # Create the JAR file
    (cd "$temp_dir" && zip -r "../../$jar_name" lib)
    
    # Clean up
    rm -rf "$temp_dir"
}

# Create JARs for each architecture
create_jar "arm64-v8a"
create_jar "armeabi-v7a"
create_jar "x86"
create_jar "x86_64"

md5sum *.jar
