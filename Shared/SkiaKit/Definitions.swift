//
//  Definitions.swift
//  SkiaKit
//
//  Created by Miguel de Icaza on 10/16/19.
//  Copyright © 2019 Miguel de Icaza. All rights reserved.
//

import Foundation

/**
 * Describes how pixel bits encode color. A pixel may be an alpha mask, a grayscale, Red Green and Blue (RGB), or
 * Alpha, Red, Green and Blue (ARGB)
 */
public enum ColorType : UInt32 {
    /// If set, encoding format and size is unknown.
    case unknown = 0
    /// Stores 8-bit byte pixel encoding that represents transparency. Value of zero is completely transparent; a value of 255 is completely opaque.
    case alpha8
    /// Stores 16-bit word pixel encoding that contains five bits of blue, six bits of green, and five bits of red.
    case rgb565
    /// Stores 16-bit word pixel encoding that contains four bits of alpha, four bits of blue, four bits of green, and four bits of red.
    case argb4444
    /// Stores 32-bit word pixel encoding that contains eight bits of red, eight bits of green, eight bits of blue, and eight bits of alpha.
    case rgba8888
    /// Stores 32-bit word pixel encoding that contains eight bits of red, eight bits of green, eight bits of blue, and eight unused bits.
    case rgb888x
    /// Stores 32-bit word pixel encoding that contains eight bits of blue, eight bits of green, eight bits of red, and eight bits of alpha.
    case bgra8888
    /// Stores 32-bit word pixel encoding that contains ten bits of red, ten bits of green, ten bits of blue, and two bits of alpha.
    case rgba1010102
    ///     Stores 32-bit word pixel encoding that contains ten bits of red, ten bits of green, ten bits of blue, and two unused bits.
    case rgb101010x
    /// Stores 8-bit byte pixel encoding that equivalent to equal values for red, blue, and green, representing colors from black to white.
    case gray8
    /// Stores 64-bit word pixel encoding that contains 16 bits of blue, 16 bits of green, 16 bits of red, and 16 bits of alpha. Each component is encoded as a half float.
    case rgbaF16
    
    internal func toNative () -> sk_colortype_t
    {
        return sk_colortype_t.init(rawValue)
    }
    
    internal static func fromNative (_ x: sk_colortype_t) -> ColorType
    {
        return ColorType.init(rawValue: x.rawValue)!
    }
}

public enum AlphaType : UInt32 {
    case unknown = 0
    case opaque
    case premul
    case unpremul
    
    internal func toNative () -> sk_alphatype_t
    {
        return sk_alphatype_t.init(rawValue)
    }
    
    internal static func fromNative (_ x: sk_alphatype_t) -> AlphaType
    {
        return AlphaType.init(rawValue: x.rawValue)!
    }
}

public enum PaintHinting : UInt32 {
    case noHinting = 0
    case slight = 1
    case normal = 2
    case full = 3
    
    internal func toNative () -> sk_paint_hinting_t
    {
        return sk_paint_hinting_t.init(rawValue)
    }
    
    internal static func fromNative (_ x : sk_paint_hinting_t) -> PaintHinting
    {
        return PaintHinting.init(rawValue: x.rawValue)!
    }
}

public enum PaintStyle : UInt32 {
    case fill = 0
    case stroke = 1
    case strokeAndFill
    
    internal func toNative () -> sk_paint_style_t
    {
        return sk_paint_style_t.init(rawValue)
    }
   
    internal static func fromNative (_ x : sk_paint_style_t) -> PaintStyle
    {
        return PaintStyle.init(rawValue: x.rawValue)!
    }
}

public enum StrokeCap : UInt32 {
    case butt = 0
    case round = 1
    case square = 2
    
    internal func toNative () -> sk_stroke_cap_t
    {
        return sk_stroke_cap_t.init(rawValue)
    }
    
    internal static func fromNative (_ x: sk_stroke_cap_t) -> StrokeCap
    {
        return StrokeCap.init(rawValue: x.rawValue)!
    }
}

public enum StrokeJoin : UInt32 {
    case miter = 0
    case round = 1
    case bevel = 2
    
    internal func toNative () -> sk_stroke_join_t
    {
        return sk_stroke_join_t.init(rawValue)
    }
    
    internal static func fromNative (_ x: sk_stroke_join_t) -> StrokeJoin
    {
        return StrokeJoin.init(rawValue: x.rawValue)!
    }
}

public enum BlendMode : UInt32 {
    case clear = 0
    case src
    case dst
    case srcOver
    case dstOver
    case srcIn
    case dstIn
    case srcOut
    case dstOut
    case srcATop
    case dstATop
    case xor
    case plus
    case modulate
    case screen
    case overlay
    case darken
    case lighten
    case colorDodge
    case colorBurn
    case hardLight
    case softLight
    case difference
    case exclusion
    case multiply
    case hue
    case saturation
    case color
    case luminosity
    
    internal func toNative () -> sk_blendmode_t
    {
        return sk_blendmode_t.init(rawValue)
    }
    
    internal static func fromNative (_ x: sk_blendmode_t) -> BlendMode
    {
        return BlendMode.init(rawValue: x.rawValue)!
    }
}

public enum FilterQuality : UInt32
{
    case none = 0
    case low
    case medium
    case high

    internal func toNative () -> sk_filter_quality_t
    {
        return sk_filter_quality_t.init(rawValue)
    }
    
    internal static func fromNative (_ x: sk_filter_quality_t) -> FilterQuality
    {
        return FilterQuality.init(rawValue: x.rawValue)!
    }
}

public enum TextAlign : UInt32 {
    case left = 0
    case center
    case right
    
    internal func toNative () -> sk_text_align_t
    {
        return sk_text_align_t.init(rawValue)
    }
    
    internal static func fromNative (_ x: sk_text_align_t) -> TextAlign
    {
        return TextAlign.init(rawValue: x.rawValue)!
    }
}

public enum TextEncoding : UInt32 {
    case utf8  = 0
    case utf16
    case utf32
    case glyphId

    internal func toNative () -> sk_text_encoding_t
    {
        return sk_text_encoding_t.init(rawValue)
    }
    
    internal static func fromNative (_ x: sk_text_encoding_t) -> TextEncoding
    {
        return TextEncoding.init(rawValue: x.rawValue)!
    }
}

public enum ClipOperation : UInt32 {
    case difference = 0
    case intersect = 1
    
    internal func toNative () -> sk_clipop_t
    {
        return sk_clipop_t.init(rawValue)
    }
    
    internal static func fromNative (_ x: sk_clipop_t) -> ClipOperation
    {
        return x.rawValue == 0 ? .difference : .intersect
    }
}

public enum PointMode : UInt32 {
    case Points = 0
    case Lines = 1
    case Polygon = 2
    
    internal func toNative () -> sk_point_mode_t
    {
        return sk_point_mode_t.init(rawValue)
    }
    
    internal static func fromNative (_ x: sk_point_mode_t) -> PointMode
    {
        return PointMode.init(rawValue: x.rawValue)!
    }
}

public enum PathFillType : UInt32
{
    case winding = 0
    case evenOdd = 1
    case inverseWinding = 2
    case inverseEvenOdd = 3
    
    internal func toNative () -> sk_path_filltype_t
    {
       return sk_path_filltype_t.init(rawValue)
    }

    internal static func fromNative (_ x: sk_path_filltype_t) -> PathFillType
    {
       return PathFillType.init(rawValue: x.rawValue)!
    }
}

public enum PathConvexity : UInt32 {
    case unknown = 0
    case convex = 1
    case concave = 2
    
    internal func toNative () -> sk_path_convexity_t
    {
       return sk_path_convexity_t.init(rawValue)
    }

    internal static func fromNative (_ x: sk_path_convexity_t) -> PathConvexity
    {
       return PathConvexity.init(rawValue: x.rawValue)!
    }
}

public enum PathSegmentMask : UInt32 {
    case line = 1
    case quad = 2
    case conic = 4
    case cubic = 8
}

/**
 * `PathDirection` describes whether contour is clockwise or counterclockwise.
 * When `Path` contains multiple overlapping contours, `PathDirection` together with
 * `FillType` determines whether overlaps are filled or form holes.
 *
 * `PathDirection` also determines how contour is measured. For instance, dashing
 * measures along `Path` to determine where to start and stop stroke; `PathDirection`
 * will change dashed results as it steps clockwise or counterclockwise.
 *
 * Closed contours like `Rect`, `RRect`, circle, and oval added with
 * `.clockwise` travel clockwise; the same added with `.counterclockwise`
 * travel counterclockwise.
 */
public enum PathDirection : UInt32 {
    case clockwise = 0
    case counterClockwise = 1
    
    internal func toNative () -> sk_path_direction_t
    {
        return sk_path_direction_t (rawValue)
    }
    
    internal static func fromNative (_ x: sk_path_direction_t) -> PathDirection
    {
        return x.rawValue == 0 ? .clockwise : .counterClockwise
    }
}

public enum PathOp : UInt32 {
    case difference = 0
    case intersect = 1
    case union = 2
    case xor = 3
    case reverseDifference = 4
    
    internal func toNative () -> sk_pathop_t
    {
        return sk_pathop_t (rawValue)
    }
    
    internal static func fromNative (_ x: sk_pathop_t) -> PathOp
    {
        return PathOp.init(rawValue: x.rawValue)!
    }
}

public enum TransferFunctionBehavior : UInt32 {
    case respect = 0
    case ignore
    
    internal func toNative () -> sk_transfer_function_behavior_t
    {
        return sk_transfer_function_behavior_t(rawValue: rawValue)
    }
    
    internal static func fromNative (_ x: sk_transfer_function_behavior_t) -> TransferFunctionBehavior
    {
        return TransferFunctionBehavior.init (rawValue: x.rawValue)!
    }
}

/**
 * Enum describing format of encoded data.
 */
public enum EncodedImageFormat : UInt32 {
    case bmp = 0
    case gif
    case ico
    case jpeg
    case png
    case wbmp
    case webp
    case pkm
    case ktx
    case astc
    case dng
    case heif

    internal func toNative () -> sk_encoded_image_format_t
    {
        return sk_encoded_image_format_t(rawValue: rawValue)
    }
    
    internal static func fromNative (_ x: sk_encoded_image_format_t) -> EncodedImageFormat
    {
        return EncodedImageFormat.init (rawValue: x.rawValue)!
    }

}

