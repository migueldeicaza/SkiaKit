# SkiaKit

SkiaKit is a 2D Graphics Library for use with Swift. It is powered by Google's
[Skia](https://skia.org) graphics library, the same library that powers Google Chrome and Android graphics.

You can review the [API Documentation](https://migueldeicaza.github.io/SkiaKit/)

The Swift bindings are intended to be cross-platform, both to Apple platforms, Linux, and new platforms where Skia and Swift run.

This work uses extensive code from Microsoft's SkiaSharp bindings authored by
Matthew Leibowitz and dozens of contributors. SkiaSharp just happens to have
a very advanced set of bridge APIs to the underlying Skia engine that does not
existing in the upstream Google Skia project.

## Getting this to work

### macOS / iOS / tvOS

Supports:

- `x86_64` Mac: anything from 2008 MacBook to M1 (using x86 emulation)
- `arm64` iPhone: anything past iPhone 5S
- `arm64` iPad: anything past iPad Air / iPad mini 2 (post-2013)
- iPhone Simulator
- iPad Simulator
- tvOS

You can add SkiaKit to your project by putting this dependency in your `Package.swift`:

```swift
.package(url: "https://github.com/bloomos/SkiaKit.git", .branch("generated"))
```

The `generated` branch includes the `XCFramework` needed for SkiaSharp's Skia bindings.

### Linux

Linux support is being worked on (TODO).
