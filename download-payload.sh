#!/bin/bash

# Must be ran on macOS due to use of xcodebuild and lipo.

# Cleanup from last time.
rm -rf SkiaSharp.xcframework

V=2.80.3
DIR=skiasharp-$V
FILE=skiasharp-$V.zip
URL=https://www.nuget.org/api/v2/package/SkiaSharp/$V

download_nuget() {
    if test ! -e $FILE; then
        curl -L -o skiasharp-$V.zip $URL
    fi
    unzip -d skiasharp-$V $FILE
}
download_nuget

# used below in build methods
lipo_skiasharp() {
    local folder_name="$1"
    local arch="$2"
    local path=$folder_name/libSkiaSharp.framework/libSkiaSharp
    
    lipo -extract $arch $path -output $path
}

mkdir build

# iOS
build_ios() {
    mkdir build/iOS
    cp -a $DIR/build/xamarinios1.0/libSkiaSharp.framework build/iOS/libSkiaSharp.framework

    # Painfully separate all architectures.
    cp -a build/iOS build/iOS-x86_64
    cp -a build/iOS build/iOS-arm64
    rm -rf build/iOS

    # Remove other architectures.
    lipo_skiasharp build/iOS-x86_64 x86_64
    lipo_skiasharp build/iOS-arm64 arm64
}
build_ios

# tvOS
build_tvos() {
    mkdir build/tvOS
    cp -a $DIR/build/xamarintvos1.0/libSkiaSharp.framework build/tvOS/libSkiaSharp.framework

    # Painfully separate all architectures.
    cp -a build/tvOS build/tvOS-x86_64
    cp -a build/tvOS build/tvOS-arm64
    rm -rf build/tvOS

    # Remove other architectures.
    lipo_skiasharp build/tvOS-x86_64 x86_64
    lipo_skiasharp build/tvOS-arm64 arm64
}
build_tvos

# macOS
build_macos() {
    mkdir -p build/macOS-x86_64/libSkiaSharp.framework

    cp $DIR/runtimes/osx/native/libSkiaSharp.dylib .
    # https://stackoverflow.com/questions/57755276/create-ios-framework-with-dylib
    lipo libSkiaSharp.dylib -output libSkiaSharp -create 
    install_name_tool -id @rpath/libSkiaSharp.framework/libSkiaSharp libSkiaSharp

    mv libSkiaSharp build/macOS-x86_64/libSkiaSharp.framework/
    rm libSkiaSharp.dylib

    cp MacOSFramework/Info.plist build/macOS-x86_64/libSkiaSharp.framework/Info.plist
}
build_macos

create_xcframework() {
    # Create XCFramework.
    xcodebuild -create-xcframework \
            -framework build/iOS-x86_64/libSkiaSharp.framework \
            -framework build/iOS-arm64/libSkiaSharp.framework \
            -framework build/tvOS-x86_64/libSkiaSharp.framework \
            -framework build/tvOS-arm64/libSkiaSharp.framework \
            -framework build/macOS-x86_64/libSkiaSharp.framework \
            -output SkiaSharp.xcframework
}
create_xcframework
        
# Cleanup
rm -rf skiasharp-* build