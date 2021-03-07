//
//  Definitions.swift
//  SkiaKit
//
//  Created by Miguel de Icaza on 10/16/19.
//  Copyright © 2019 Miguel de Icaza. All rights reserved.
//

import Foundation
#if canImport(CSkiaSharp)
import CSkiaSharp
#endif

public typealias FontEdging = sk_font_edging_t
public typealias FontHinting = sk_font_hinting_t

/// 
/// Describes how pixel bits encode color. A pixel may be an alpha mask, a grayscale, Red Green and Blue (RGB), or
/// Alpha, Red, Green and Blue (ARGB)
/// 
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

/// Describes how to interpret the alpha component of a pixel. A pixel may
/// be opaque, or alpha, describing multiple levels of transparency.
/// In simple blending, alpha weights the draw color and the destination
/// color to create a new color. If alpha describes a weight from zero to one:
/// new color = draw color * alpha + destination color * (1 - alpha)
/// In practice alpha is encoded in two or more bits, where 1.0 equals all bits set.
/// RGB may have alpha included in each component value; the stored
/// value is the original RGB multiplied by alpha. Premultiplied color
/// components improve performance.
///
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


/// Blending modes for compositing digital images.   These are an implementation of the Porter Duff blending modes
public enum BlendMode : UInt32 {
    /// Replaces destination with Alpha and Color components set to zero; a fully transparent pixel (operation: [0, 0])
    case clear = 0
    /// Replaces destination with source. Destination alpha and color component values are ignored.
    case src
    /// Preserves destination, ignoring source. Drawing with Paint set to kDst has no effect.
    case dst
    /// Replaces destination with source blended with destination. If source is opaque, replaces destination with source. Used as the default Blend_Mode for SkPaint.
    case srcOver
    /// Replaces destination with destination blended with source. If destination is opaque, has no effect.
    case dstOver
    /// Replaces destination with source using destination opacity.
    case srcIn
    /// Scales destination opacity by source opacity.
    case dstIn
    /// Replaces destination with source using the inverse of destination opacity, drawing source fully where destination opacity is zero.
    case srcOut
    /// Replaces destination opacity with inverse of source opacity. If source is transparent, has no effect.
    case dstOut
    /// Blends destination with source using read destination opacity.
    case srcATop
    /// Blends destination with source using source opacity.
    case dstATop
    /// Blends destination by exchanging transparency of the source and destination.
    case xor
    /// Replaces destination with source and destination added together.
    case plus
    /// Replaces destination with source and destination multiplied together.
    case modulate
    /// Replaces destination with inverted source and destination multiplied together.
    case screen
    /// Replaces destination with multiply or screen, depending on destination.
    case overlay
    /// Replaces destination with darker of source and destination.
    case darken
    /// Replaces destination with lighter of source and destination.
    case lighten
    /// Makes destination brighter to reflect source.
    case colorDodge
    /// Makes destination darker to reflect source.
    case colorBurn
    /// Makes destination lighter or darker, depending on source.
    case hardLight
    /// Makes destination lighter or darker, depending on source.
    case softLight
    /// Subtracts darker from lighter with higher contrast.
    case difference
    /// Subtracts darker from lighter with lower contrast.
    case exclusion
    /// Multiplies source with destination, darkening image.
    case multiply
    /// Replaces hue of destination with hue of source, leaving saturation and luminosity unchanged.
    case hue
    /// Replaces saturation of destination saturation hue of source, leaving hue and luminosity unchanged.
    case saturation
    /// Replaces hue and saturation of destination with hue and saturation of source, leaving luminosity unchanged.
    case color
    /// Replaces luminosity of destination with luminosity of source, leaving hue and saturation unchanged.
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

/// Controls how much filtering to be done when scaling/transforming complex colors
public enum FilterQuality : UInt32
{
    /// fastest but lowest quality, typically nearest-neighbor
    case none = 0
    /// typically bilerp
    case low
    /// typically bilerp + mipmaps for down-scaling
    case medium
    /// slowest but highest quality, typically bicubic or better
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

///
/// TextAlign adjusts the text relative to the text position.
/// TextAlign affects glyphs drawn with: `Canvas.drawText`, `Canvas.drawPosText`,
/// `Canvas.drawPosTextH`, `Canvas.drawTextOnPath`,
/// `Canvas.drawTextOnPathHV`, `Canvas.rawTextRSXform`, `Canvas.drawTextBlob`,
/// and `Canvas.drawString`;
/// as well as calls that place text glyphs like `getTextWidths()` and `getTextPath()`.
///
/// The text position is set by the font for both horizontal and vertical text.
/// Typically, for horizontal text, the position is to the left side of the glyph on the
/// base line; and for vertical text, the position is the horizontal center of the glyph
/// at the caps height.
///
/// Align adjusts the glyph position to center it or move it to abut the position
/// using the metrics returned by the font.
///
/// Align defaults to `.left`.
///
public enum TextAlign : UInt32 {
    /// Leaves the glyph at the position computed by the font offset by the text position.
    case left = 0
    /// Moves the glyph half its width if flags has `.verticalText` clear, and half its height if flags has `.verticalText` set.
    case center
    /// Moves the glyph by its width if flags has `verticalText` clear, and by its height if flags has `verticalText` set.
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

///
/// TextEncoding determines whether text specifies character codes and their encoded
/// size, or glyph indices. Characters are encoded as specified by the Unicode standard.
///
/// Character codes encoded size are specified by UTF-8, UTF-16, or UTF-32.
/// All character code formats are able to represent all of Unicode, differing only
/// in the total storage required.
///
/// UTF-8 (RFC 3629) encodes each character as one or more 8-bit bytes.
///
/// UTF-16 (RFC 2781) encodes each character as one or two 16-bit words.
///
/// UTF-32 encodes each character as one 32-bit word.
///
/// font manager uses font data to convert character code points into glyph indices.
/// A glyph index is a 16-bit word.
///
/// TextEncoding is set to `.utf8` by default.
///
public enum TextEncoding : UInt32 {
    /// Uses bytes to represent UTF-8 or ASCII.
    case utf8  = 0
    /// Uses two byte words to represent most of Unicode.
    case utf16
    /// Uses four byte words to represent all of Unicode.
    case utf32
    /// Uses two byte words to represent glyph indices.
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

/// Selects if an array of points are drawn as discrete points, as lines, or as an open polygon.
public enum PointMode : UInt32 {
    /// Draw each point separately.
    case points = 0
    /// Draw each pair of points as a line segment.
    case lines = 1
    /// Draw the array of points as a open polygon.
    case polygon = 2
    
    internal func toNative () -> sk_point_mode_t
    {
        return sk_point_mode_t.init(rawValue)
    }
    
    internal static func fromNative (_ x: sk_point_mode_t) -> PointMode
    {
        return PointMode.init(rawValue: x.rawValue)!
    }
}

/// Enum describing format of encoded data.
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

///  Refers to the density of a typeface, in terms of the lightness or heaviness of the strokes.
///
///  A font weight describes the relative weight of a font, in terms of the lightness or heaviness of the strokes.
///  Weight differences are generally differentiated by an increased stroke or thickness that is associated with a
///  given character in a font, as compared to a "normal" character from that same font.
///
///  The FontWeights values correspond to the `usWeightClass` definition in the OpenType specification.
///  The `usWeightClass` represents an integer value between 1 and 999.
///  Lower values indicate lighter weights; higher values indicate heavier weights.
///
/// The numerical value of the enumeration is the `usWeightClass`
///
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

/// Indications on how the shader should handle drawing outside the original bounds.
public enum ShaderTileMode : UInt32 {
    /// Replicate the edge color if the shader draws outside of its original bounds.
    case clamp = 0
    /// Repeat the shader's image horizontally and vertically.
    case repeats
    /// Repeat the shader's image horizontally and vertically, alternating mirror images so that adjacent images always seam.
    case mirror
    /// Only draw within the original domain, return transparent-black everywhere else.
    case decal
    
    internal func toNative () -> sk_shader_tilemode_t
    {
        return sk_shader_tilemode_t(rawValue: rawValue)
    }
    
    internal static func fromNative (_ x: sk_shader_tilemode_t) -> ShaderTileMode
    {
        return ShaderTileMode.init (rawValue: x.rawValue)!
    }
}

public enum SKSurfacePropsFlags : UInt32 {
    case none = 0
    case useDeviceIndependentFonts = 1
}

///
/// Description of how the LCD strips are arranged for each pixel. If this is unknown, or the
/// pixels are meant to be "portable" and/or transformed before showing (e.g. rotated, scaled)
/// then use `.unknown`
///
public enum PixelGeometry : UInt32 {
    case unknown = 0
    case rgbHorizontal
    case bgrHorizontal
    case rgbVertical
    case bgrVertical
    
    internal func toNative () -> sk_pixelgeometry_t
    {
        return sk_pixelgeometry_t(rawValue: rawValue)
    }
    
    internal static func fromNative (_ x: sk_pixelgeometry_t) -> PixelGeometry
    {
        return PixelGeometry.init (rawValue: x.rawValue)!
    }
}

/// The logical operations that can be performed when combining two regions.
public enum RegionOperation: UInt32 {
    /// subtract the op region from the first region
    case difference = 0
    /// intersect the two regions
    case intersect
    /// union (inclusive-or) the two regions
    case union
    /// exclusive-or the two regions
    case xor
    /// subtract the first region from the op region
    case reverseDifference
    /// replace the dst region with the op region
    case replace
    
    internal func toNative () -> sk_region_op_t
    {
        return sk_region_op_t(rawValue: rawValue)
    }
    
    internal static func fromNative (_ x: sk_region_op_t) -> RegionOperation
    {
        return RegionOperation.init (rawValue: x.rawValue)!
    }

}
