// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.
import Foundation
import PackageDescription

let dir = URL(fileURLWithPath: #file).deletingLastPathComponent().path
var target: [Target] = []

#if os(Linux)
target = [
	.target (
		name: "CSkiaSharp",
		dependencies: ["CSkiaSharpBinary"],
		cSettings: [
		.headerSearchPath("include"),
		],
		linkerSettings: [
		.unsafeFlags(["-L" + dir])
		]
	)
]
#else
target = [
	.target (
		name: "CSkiaSharp",
		dependencies: ["CSkiaSharpBinary"],
		cSettings: [
		.headerSearchPath("include")
		]
	),
	.binaryTarget (
		name: "CSkiaSharpBinary",
		path: "SkiaSharp.xcframework"
	)
]
#endif

let package = Package(
    name: "SkiaKit",
    platforms: [
	.macOS(.v10_15),
	.iOS(.v13),
	.tvOS(.v13),
    ],    
    products: [
        .library(name: "SkiaKit", targets: ["SkiaKit"])
    ],
    targets: [
	.testTarget (
		name: "SkiaKitTests",
		dependencies: ["SkiaKit"]
	),
    .target (
		name: "SkiaKit", 
		dependencies: ["CSkiaSharp"],
		cSettings: [
		.headerSearchPath("include")
		]
	)
    ] + target
)

