#!/bin/bash

V=2.80.3-preview.40
DIR=skiasharp-$V
FILE=skiasharp-$V.zip
URL=https://www.nuget.org/api/v2/package/SkiaSharp.NativeAssets.Linux/$V

download_nuget() {
    if test ! -e $FILE; then
        curl -L -o skiasharp-$V.zip $URL
    fi
    unzip -d skiasharp-$V $FILE
}
download_nuget

mv $DIR/runtimes/linux-x64/native/libSkiaSharp.so .
rm -rf skiasharp-*
