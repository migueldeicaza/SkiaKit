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

/**
 * Describes how to interpret the alpha component of a pixel. A pixel may
 * be opaque, or alpha, describing multiple levels of transparency.
 * In simple blending, alpha weights the draw color and the destination
 * color to create a new color. If alpha describes a weight from zero to one:
 * new color = draw color * alpha + destination color * (1 - alpha)
 * In practice alpha is encoded in two or more bits, where 1.0 equals all bits set.
 * RGB may have alpha included in each component value; the stored
 * value is the original RGB multiplied by alpha. Premultiplied color
 * components improve performance.
 */
public enum AlphaType : UInt32 {
    /// Uninitialized
    case unknown = 0
    /// pixel is opaque
    case opaque
    /// pixel components are premultiplied by alpha
    case premul
    /// pixel components are independent of alpha
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

/**
 * Set Style to fill, stroke, or both fill and stroke geometry.
 *
 * The stroke and fill share all paint attributes; for instance, they are drawn with the same color.
 * Use `.strokeAndFill` to avoid hitting the same pixels twice with a stroke draw and
 * a fill draw.
 */
public enum PaintStyle : UInt32 {
    /// set to fill geometry
    case fill = 0
    /// set to stroke geometry
    case stroke = 1
    /// sets to stroke and fill geometry
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

/// Cap draws at the beginning and end of an open path contour.
public enum StrokeCap : UInt32 {
    /// no stroke extension - the default stroke value
    case butt = 0
    /// adds circle
    case round = 1
    /// adds square
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

/**
 * Join specifies how corners are drawn when a shape is stroked. Join
 * affects the four corners of a stroked rectangle, and the connected segments in a
 * stroked path.
 *
 * Choose miter join to draw sharp corners. Choose round join to draw a circle with a
 * radius equal to the stroke width on top of the corner. Choose bevel join to minimally
 * connect the thick strokes.
 *
 * The fill path constructed to describe the stroked path respects the join setting but may
 * not contain the actual join. For instance, a fill path constructed with round joins does
 * not necessarily include circles at each connected segment.
 */
public enum StrokeJoin : UInt32 {
    /// extends to miter limit
    case miter = 0
    /// adds circle
    case round = 1
    /// connects outside edges
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

/**
 * Refers to the density of a typeface, in terms of the lightness or heaviness of the strokes.
 *
 * A font weight describes the relative weight of a font, in terms of the lightness or heaviness of the strokes.
 * Weight differences are generally differentiated by an increased stroke or thickness that is associated with a
 * given character in a font, as compared to a "normal" character from that same font.
 *
 * The FontWeights values correspond to the `usWeightClass` definition in the OpenType specification.
 * The `usWeightClass` represents an integer value between 1 and 999.
 * Lower values indicate lighter weights; higher values indicate heavier weights.
 *
 *The numerical value of the enumeration is the `usWeightClass`
 */
public enum FontStyleWeight : Int32 {
    /// Invisible weight
    case invisible   =   0
    /// Specifies a "Thin" font weight.
    case thin        = 100
    /// Specifies a "Extra Light" font weight.
    case extraLight  = 200
    /// Specifies a "Light" font weight.
    case light       = 300
    /// Specifies a "Normal" font weight.
    case normal      = 400
    /// Specifies a "Medirum" font weight.
    case medium      = 500
    /// Specifies a "Semi bold" font weight.
    case semiBold    = 600
    /// Specifies a "Bold" font weight.
    case bold        = 700
    /// Specifies a "Extra Bold" font weight.
    case extraBold   = 800
    /// Specifies a "Black" font weight.
    case black       = 900
    /// Specifies a "Extra Black" font weight.
    case extraBlack  = 1000
}


/// Predefined font widths for use with Typeface, these values match the `usWidthClass` from the OpenType specification.   These are numbers from 1 to 9, lower numbers represent narrower widths, higher numbers indicate wider widths.
public enum FontStyleWidth : Int32 {
    /// 50% width of normal, `usWidthClass` = 1
    case ultraCondensed   = 1
    /// 62.5% width of normal, `usWidthClass` = 2
    case extraCondensed   = 2
    /// 75% width of normal, `usWidthClass` = 3
    case condensed        = 3
    /// 87.5% width of normal, `usWidthClass` = 4
    case semiCondensed    = 4
    /// 100% width of normal, `usWidthClass` = 5
    case normal           = 5
    /// 112.5% width of normal, `usWidthClass` = 6
    case semiExpanded     = 6
    /// 125% width of normal, `usWidthClass` = 7
    case expanded         = 7
    /// 150% width of normal, `usWidthClass` = 8
    case extraExpanded    = 8
    /// 200% width of normal, `usWidthClass` = 9
    case ultraExpanded    = 9
}

/// Font slants for use with Typeface.
public enum FontStyleSlant : UInt32 {
    /// The upright/normal font slant.
    case upright = 0
    /// The italic font slant, in which the slanted characters appear as they were designed.
    case italic  = 1
    /// The characters in an oblique font are artificially slanted. The slant is achieved by performing a shear transformation on the characters from a normal font. When a true italic font is not available on a computer or printer, an oblique style can generated from the normal font and used to simulate an italic font.
    case oblique = 2
    
    internal func toNative () -> sk_font_style_slant_t
    {
        return sk_font_style_slant_t(rawValue: rawValue)
    }
    
    internal static func fromNative (_ x: sk_font_style_slant_t) -> FontStyleSlant
    {
        return FontStyleSlant.init (rawValue: x.rawValue)!
    }
}
