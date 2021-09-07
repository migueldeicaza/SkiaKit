# SkiaKit

> [Go to macOS / iOS / tvOS](#apple) | [Go to Linux](#linux)

SkiaKit is a 2D Graphics Library for use with Swift. It is powered by Google's
[Skia](https://skia.org) graphics library, the same library that powers Google Chrome and Android graphics.

You can review the [API Documentation](https://migueldeicaza.github.io/SkiaKit/)

The Swift bindings are intended to be cross-platform, both to Apple platforms, Linux, and new platforms where Skia and Swift run.

This work uses extensive code from Microsoft's SkiaSharp bindings authored by
Matthew Leibowitz and dozens of contributors. SkiaSharp just happens to have
a very advanced set of bridge APIs to the underlying Skia engine that does not
existing in the upstream Google Skia project.

## Getting this to work

### Apple

Supports:

- `x86_64` Mac: anything from 2008 MacBook to M1 (using x86 emulation)
- `arm64` iPhone: anything past iPhone 5S
- `arm64` iPad: anything past iPad Air / iPad mini 2 (post-2013)
- iPhone Simulator
- iPad Simulator
- tvOS

Not currently supported:

- Mac Catalyst

#### Recommended usage

You can add SkiaKit to your project by putting this dependency in your `Package.swift`:

```swift
.package(url: "https://github.com/bloomos/SkiaKit.git", .branch("generated"))
```

#### Using manually

If using manually, you'll need to download and assemble the `SkiaSharp.xcframework` required.

This must be ran on macOS with the [Command Line Tools for XCode](https://developer.apple.com/downloads/) installed.

```sh
git clone https://github.com/bloomos/SkiaKit.git
cd SkiaKit
make download-payload
```

### Linux

SkiaKit is platform agnostic and makes a best-effort support for Linux. An `.so` for the SkiaSharp library is included and supports [the following Linux distributions](https://github.com/mono/SkiaSharp/issues/453).

The `libSkiaSharp.so` file will need to be distributed alongside your project.

If the following

#### Recommended usage

You can add SkiaKit to your project by putting this dependency in your `Package.swift`:

```swift
.package(url: "https://github.com/bloomos/SkiaKit.git", .branch("generated"))
```

#### Using manually

If using manually, you'll need to provide `libSkiaSharp.so` in the root of the `SkiaKit` folder. For [certain Linux distros](https://github.com/mono/SkiaSharp/issues/453), a convenience script is provided.

This script requires `curl` and `unzip`.

```sh
git clone https://github.com/bloomos/SkiaKit.git
cd SkiaKit
make download-payload-linux
```
