#!/bin/sh
V=2.80.0-preview.3
DIR=skiasharp-$V
FILE=skiasharp-$V.zip
URL=https://www.nuget.org/api/v2/package/SkiaSharp/$V
if test ! -e $FILE; then
    curl -L -o skiasharp-$V.zip https://www.nuget.org/api/v2/package/SkiaSharp/$V
fi
unzip -d skiasharp-$V $FILE

# iOS
monodis --output=dummy $DIR/lib/xamarinios1.0/SkiaSharp.dll
unzip -d SkiaKit/iOS/libSkiaSharp.framework libSkiaSharp.framework
rm libSkiaSharp.framework

# tvOS
monodis --output=dummy $DIR/lib/xamarintvos1.0/SkiaSharp.dll
unzip -d SkiaKit/tvOS/libSkiaSharp.framework libSkiaSharp.framework
rm libSkiaSharp.framework

# macOS
cp $DIR/runtimes/osx/native/libSkiaSharp.dylib SkiaKit/macOS



