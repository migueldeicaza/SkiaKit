# SkiaKit

SkiaKit is a 2D Graphics Library for use with Swift.   It is powered by Google's
[Skia](https://skia.org) graphics library, the same library that powers Google Chrome 
and Android graphics.

You can review the [API Documentation](https://migueldeicaza.github.io/SkiaKit/)

The Swift bindings are intended to be cross-platform, both to Apple platforms, and
new platforms where Skia and Swift run.

This work uses extensive code from Microsoft's SkiaSharp bindings authoered by 
Matthew Leibowitz and dozens of contributors.   SkiaSharp just happens to have
a very advanced set of bridge APIs to the underlying Skia engine that does not 
existin in the upstream Google Skia project.

## Getting this to work locally

First, obtain the binary dependencies, then follow the instructions for your
target platform below.

### Binary Dependencies

You can either download and install the SkiaSharp.nuget package, or
build your own local copy of Mono's Skia fork
(https://github.com/mono/skia/tree/77049b872966dc300ed233fc6e3930eb21bac5e3
from https://github.com/mono/skiasharp). Then create the following directories
in this location and then copy the following binaries:

```
native/ios:
	Copy the iOS directory libSkiaSharp.framework here
native/osx:
	Copy the file libSkiaSharp.dylib here
native/tvos:
	Copy the tvOS directory libSkiaSharp.framework here
```

### Build for Mac or Linux

1. Run `swift build`

### Build for iOS or tvOS

1. Run `make xcodeproj` to generate `SkiaKit.xcodeproj`
2. Use the generated Xcode project to build a framework for iOS or tvOS
