#!/bin/sh
V=1.68.1.1
DIR=skiasharp-$V
FILE=skiasharp-$V.zip
URL=https://www.nuget.org/api/v2/package/SkiaSharp/$V
if test ! -e $FILE; then
    curl -L -o skiasharp-1.68.1.1.zip https://www.nuget.org/api/v2/package/SkiaSharp/1.68.1.1
fi
unzip -d skiasharp-$V $FILE

# iOS
monodis --output=dummy $DIR/lib/Xamarin.iOS/SkiaSharp.dll
unzip -d SkiaKit/iOS/libSkiaSharp.framework libSkiaSharp.framework
rm libSkiaSharp.framework

# tvOS
monodis --output=dummy $DIR/lib/Xamarin.tvOS/SkiaSharp.dll
unzip -d SkiaKit/tvOS/libSkiaSharp.framework libSkiaSharp.framework
rm libSkiaSharp.framework

# macOS
cp $DIR/runtimes/osx/native/libSkiaSharp.dylib SkiaKit/macOS



