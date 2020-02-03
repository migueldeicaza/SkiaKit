// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.
import Foundation
import PackageDescription

let sharedSources = [
	"./Shared/SkiaKit/PictureRecorder.swift",
	"./Shared/SkiaKit/SKString.swift",
	"./Shared/SkiaKit/Picture.swift",
	"./Shared/SkiaKit/FontManager.swift",
	"./Shared/SkiaKit/MathTypes.swift",
	"./Shared/SkiaKit/Surface.swift",
	"./Shared/SkiaKit/FontStyle.swift",
	"./Shared/SkiaKit/SurfaceProperties.swift",
	"./Shared/SkiaKit/Pixmap.swift",
	"./Shared/SkiaKit/Data.swift",
	"./Shared/SkiaKit/PathEffect.swift",
	"./Shared/SkiaKit/Definitions.swift",
	"./Shared/SkiaKit/ColorFilter.swift",
	"./Shared/SkiaKit/Paint.swift",
	"./Shared/SkiaKit/ColorSpace.swift",
	"./Shared/SkiaKit/Typeface.swift",
	"./Shared/SkiaKit/MaskFilter.swift",
	"./Shared/SkiaKit/FontStyleSet.swift",
	"./Shared/SkiaKit/SKObject.swift",
	"./Shared/SkiaKit/Image.swift",
	"./Shared/SkiaKit/RoundRect.swift",
	"./Shared/SkiaKit/ImageInfo.swift",
	"./Shared/SkiaKit/Path.swift",
	"./Shared/SkiaKit/SKStream.swift",
	"./Shared/SkiaKit/Canvas.swift",
	"./Shared/SkiaKit/Region.swift",
	"./Shared/SkiaKit/Matrix.swift",
	"./Shared/SkiaKit/Shader.swift",
	"./Shared/SkiaKit/TextBlob.swift",
	"./Shared/SkiaKit/Colors.swift",
	"./Shared/SkiaKit/ImageFilter.swift",
	"./Shared/SkiaKit/Bitmap.swift",
	"./Shared/SkiaKit/Color.swift"
]

let dir = URL(fileURLWithPath: #file).deletingLastPathComponent().path

let linkFlags: [LinkerSetting] = [
	.unsafeFlags(["-L" + dir + "/native/osx"], .when(platforms:[.macOS])),
	.unsafeFlags(["-F" + dir + "/native/ios"], .when(platforms:[.iOS])),
	.unsafeFlags(["-F" + dir + "/native/tvos"], .when(platforms:[.tvOS])),
]

let package = Package(
    name: "SkiaKit",
    products: [
        .library(name: "SkiaKit", targets: ["SkiaKit"])
    ],
    targets: [
        .target (
		name: "SkiaKit", 
		dependencies: ["CSkiaSharp"],
		path: ".",
		sources: ["Shared/SkiaKit/MathTypes.swift", "Shared/SkiaKit/SKString.swift"],
		cSettings: [
	    	    .headerSearchPath("Shared/Headers"),
	    	    .headerSearchPath("SkiaKit/macOS"),
		    .headerSearchPath("include")],
		linkerSettings: linkFlags
		    
		),
	.target (
		name: "CSkiaSharp",
		path: "skiasharp",
		sources: ["dummy.m"],
		cSettings: [
	    	    .headerSearchPath("../Shared/Headers"),
	    	    .headerSearchPath("../SkiaKit/macOS"),
		    .headerSearchPath("include")]
		)
    ]
)

//let sharedHeaders = [
//	"./Shared/Headers/sk_xml.h",
//	"./Shared/Headers/sk_stream.h",
//	"./Shared/Headers/sk_textblob.h",
//	"./Shared/Headers/sk_matrix.h",
//	"./Shared/Headers/sk_codec.h",
//	"./Shared/Headers/sk_typeface.h",
//	"./Shared/Headers/sk_path.h",
//	"./Shared/Headers/sk_mask.h",
//	"./Shared/Headers/sk_imagefilter.h",
//	"./Shared/Headers/sk_colorspace.h",
//	"./Shared/Headers/sk_maskfilter.h",
//	"./Shared/Headers/sk_shader.h",
//	"./Shared/Headers/sk_vertices.h",
//	"./Shared/Headers/sk_data.h",
//	"./Shared/Headers/sk_rrect.h",
//	"./Shared/Headers/sk_image.h",
//	"./Shared/Headers/sk_document.h",
//	"./Shared/Headers/sk_paint.h",
//	"./Shared/Headers/sk_surface.h",
//	"./Shared/Headers/sk_string.h",
//	"./Shared/Headers/sk_picture.h",
//	"./Shared/Headers/sk_region.h",
//	"./Shared/Headers/sk_bitmap.h",
//	"./Shared/Headers/sk_types.h",
//	"./Shared/Headers/sk_colortable.h",
//	"./Shared/Headers/sk_canvas.h",
//	"./Shared/Headers/sk_patheffect.h",
//	"./Shared/Headers/gr_context.h",
//	"./Shared/Headers/sk_colorfilter.h",
//	"./Shared/Headers/sk_general.h",
//	"./Shared/Headers/sk_drawable.h",
//	"./Shared/Headers/sk_svg.h",
//	"./Shared/Headers/sk_pixmap.h",
//	"./Shared/Headers/SkiaKit.h",
//];
//
//let package = Package(
//    name: "SkiaKit",
//    
//    products: [
//        // Products define the executables and libraries produced by a package, and make them visible to other packages.
//        .library(
//            name: "SkiaKit",
//            targets: ["SkiaSharp", "SkiaKit"]),
//    ],
//    dependencies: [
//        // Dependencies declare other packages that this package depends on.
//        // .package(url: /* package url */, from: "1.0.0"),
//	
//    ],
//    targets: [
//        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
//        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
//	.target(
//	    name: "SkiaSharp",
//	    path: "stub/macOS",
//	    publicHeadersPath: "Shared/Headers",
//	    cSettings: [
//	    	    .headerSearchPath("../../SkiaKit/macOS"),
//	    	    .headerSearchPath("../../Shared/Headers"),
//		    .headerSearchPath("include")
//	    ]),
//        .target(
//            name: "SkiaKit",
//	    dependencies: ["SkiaSharp"],
//	    path: ".",
//	    sources: sharedSources + sharedHeaders)
//        //.testTarget(
//        //    name: "SkiaKitTests",
//        //    dependencies: ["SkiaKit"]),
//    ]
//)
