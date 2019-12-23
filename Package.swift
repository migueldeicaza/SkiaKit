// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import Foundation
import PackageDescription

// This file's directory
let dir = URL(fileURLWithPath: #file).deletingLastPathComponent().path

// Using unsafe flags to link libSkiaSharp by conventional path
//  FIXME: Use binary artifacts if/when they are supported:
//    https://github.com/apple/swift-evolution/blob/master/proposals/0272-swiftpm-binary-dependencies.md
// Also see Package.xcconfig for another hack, since Xcode doesn't respect the platform conditions...
let linkFlags: [LinkerSetting] = [
	.unsafeFlags(["-L" + dir + "/native/osx"], .when(platforms:[.macOS])),
	.unsafeFlags(["-F" + dir + "/native/ios"], .when(platforms:[.iOS])),
	.unsafeFlags(["-F" + dir + "/native/tvos"], .when(platforms:[.tvOS])),
]

let package = Package(
	name: "SkiaKit",
	platforms: [
		.macOS(.v10_15),
		.iOS(.v13),
		.tvOS(.v13),
	],
	products: [
		// Products define the executables and libraries produced by a package, and make them visible to other packages.
		.library(
			name: "SkiaKit",
			type: .dynamic,
			targets: ["SkiaKit"]),
	],
	dependencies: [
		// Dependencies declare other packages that this package depends on.
		// .package(url: /* package url */, from: "1.0.0"),
	],
	targets: [
		// Targets are the basic building blocks of a package. A target can define a module or a test suite.
		// Targets can depend on other targets in this package, and on products in packages which this package depends on.
		.target(
			name: "SkiaKit",
			dependencies: ["SkiaSharp"],
			linkerSettings: linkFlags),

		.target(
			name: "Gallery",
			dependencies: ["SkiaKit"],
			path: "Samples/Gallery",
			linkerSettings: linkFlags),

		.systemLibrary(name: "SkiaSharp"),

		.testTarget(
			name: "SkiaKitTests",
			dependencies: ["SkiaKit"],
			linkerSettings: linkFlags),
	]
)
