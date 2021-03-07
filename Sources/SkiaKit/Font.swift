//
//  SKFont.swift
//  SkiaKit
//
//  Created by Miguel de Icaza on 6/12/20.
//

import Foundation
#if canImport(CSkiaSharp)
import CSkiaSharp
#endif

public final class Font {
    var handle : OpaquePointer
    var owns: Bool

    init (handle: OpaquePointer, owns: Bool)
    {
        self.handle = handle
        self.owns = owns
    }

    public init ()
    {
        handle = sk_font_new()
        owns = true
    }
    
    public init (typeface: Typeface, size: Float, scaleX: Float, skewX: Float){
        handle = sk_font_new_with_values(typeface.handle, size, scaleX, skewX)
        owns = true
    }
    
    deinit {
        sk_font_delete(handle)
    }
    
    public var subpixelText : Bool {
        get {
            sk_font_is_subpixel(handle)
        }
        set {
            sk_font_set_subpixel(handle, newValue)
        }
    }


    public var isForceAutoHinting: Bool {
        get {
            sk_font_is_force_auto_hinting(handle)
        }
        set {
            sk_font_set_force_auto_hinting(handle, newValue)
        }
    }
    public var isEmbeddedBitmaps: Bool {
        get {
            sk_font_is_embedded_bitmaps(handle)
        }
        set {
            sk_font_set_embedded_bitmaps(handle, newValue)
        }
    }
    public var isLinearMetrics: Bool {
        get {
            sk_font_is_linear_metrics(handle)
        }
        set {
            sk_font_set_linear_metrics(handle, newValue)
        }
    }
    public var isEmbolden: Bool {
        get {
            sk_font_is_embolden(handle)
        }
        set {
            sk_font_set_embolden(handle, newValue)
        }
    }
    public var isBaselineSnap: Bool {
        get {
            sk_font_is_baseline_snap(handle)
        }
        set {
            sk_font_set_baseline_snap(handle, newValue)
        }
    }
    
    public var edging: FontEdging {
        get { sk_font_get_edging(handle)
        }
        set {
            sk_font_set_edging(handle, newValue)
        }
    }
    
    public var fontHinting: FontHinting {
        get {
            sk_font_get_hinting(handle)
        }
        set {
            sk_font_set_hinting(handle, newValue)
        }
    }
    public var typeface: Typeface {
        get {
            Typeface (handle: sk_font_get_typeface(handle), owns: true)
        }
        
        set {
            sk_font_set_typeface(handle, newValue.handle)
        }
    }
    public var size: Float {
        get {
            sk_font_get_size(handle)
        }
        set {
            sk_font_set_size(handle, newValue)
        }
    }
    public var scaleX: Float {
        get {
            sk_font_get_scale_x(handle)
        }
        set {
            sk_font_set_scale_x(handle, newValue)
        }
    }
    public var skewX: Float {
        get {
            sk_font_get_skew_x(handle)
        }
        set {
            sk_font_set_skew_x(handle, newValue)
        }
    }
    
    /// Retrieve the corresponding glyph IDs of a string of characters.
    /// - Returns: the array of glyphs, or nil if there is an error
    public func getGlyphs (str: String) -> [UInt16]?
    {
        let utflen = str.utf8.count
        let nglyphs = sk_font_text_to_glyphs(handle, str, utflen, UTF8_SK_TEXT_ENCODING, nil, Int32 (utflen))
        if nglyphs <= 0 {
            return nil
        }
        var glyphs = Array<UInt16>.init (repeating: 0, count: Int(nglyphs))
        sk_font_text_to_glyphs(handle, str, utflen, UTF8_SK_TEXT_ENCODING, &glyphs, nglyphs)
        return glyphs
    }

    /// The number of glyphs necessary to render this string with this font
    public func countGlyphs (str: String) -> Int32
    {
        let utflen = str.utf8.count
        return sk_font_text_to_glyphs(handle, str, utflen, UTF8_SK_TEXT_ENCODING, nil, Int32 (utflen))
    }
    
    public func getGlyphPositions (glyphs: inout [UInt16], origin: Point = Point(x: 0, y: 0)) -> [Point] {
        var positions: [Point] = Array.init (repeating: Point(x:0, y:0), count: glyphs.count)
        var o = origin
        sk_font_get_pos(handle, &glyphs, Int32 (glyphs.count), &positions, &o)
        return positions
    }
    
 
    //sk_font_break_text
    //sk_font_get_metrics
    //sk_font_get_path
    //sk_font_get_paths
    //sk_font_get_widths_bounds
    //sk_font_get_xpos
    //sk_font_measure_text
    //sk_font_unichar_to_glyph
    //sk_font_unichars_to_glyphs
    //SK_C_API void sk_text_utils_get_path(const void* text, size_t length, sk_text_encoding_t //encoding, float x, float y, const sk_font_t* font, sk_path_t* path);
    //SK_C_API void sk_text_utils_get_pos_path(const void* text, size_t length, sk_text_encoding_t //encoding, const sk_point_t pos[], const sk_font_t* font, sk_path_t* path);


}
