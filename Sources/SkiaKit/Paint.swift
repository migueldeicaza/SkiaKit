//
//  Paint.swift
//  SkiaKit
//
//  Created by Miguel de Icaza on 10/16/19.
//  Copyright © 2019 Miguel de Icaza. All rights reserved.
//

import Foundation
import SkiaSharp

/**
 * `Paint` controls options applied when drawing. `Paint` collects all
 * options outside of the `Canvas` clip and `Canvas` matrix.
 * Various options apply to strokes and fills, and images.
 * `Paint` collects effects and filters that describe single-pass and multiple-pass
 * algorithms that alter the drawing geometry, color, and transparency. For instance,
 * `Paint` does not directly implement dashing or blur, but contains the objects that do so.
 */
public final class Paint {
    ///
    /// Set Style to fill, stroke, or both fill and stroke geometry.
    ///
    /// The stroke and fill share all paint attributes; for instance, they are drawn with the same color.
    /// Use `.strokeAndFill` to avoid hitting the same pixels twice with a stroke draw and
    /// a fill draw.
    ///
    public enum Style : UInt32 {
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
       
        internal static func fromNative (_ x : sk_paint_style_t) -> Style
        {
            return Style.init(rawValue: x.rawValue)!
        }
    }
    
    ///
    /// Join specifies how corners are drawn when a shape is stroked. Join
    /// affects the four corners of a stroked rectangle, and the connected segments in a
    /// stroked path.
    ///
    /// Choose miter join to draw sharp corners. Choose round join to draw a circle with a
    /// radius equal to the stroke width on top of the corner. Choose bevel join to minimally
    /// connect the thick strokes.
    ///
    /// The fill path constructed to describe the stroked path respects the join setting but may
    /// not contain the actual join. For instance, a fill path constructed with round joins does
    /// not necessarily include circles at each connected segment.
    ///
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

    ///
    /// Hinting adjusts the glyph outlines so that the shape provides a uniform
    /// look at a given point size on font engines that support it. Hinting may have a
    /// muted effect or no effect at all depending on the platform.
    ///
    /// The four levels roughly control corresponding features on platforms that use FreeType
    /// as the font engine.
    ///
    ///
    public enum Hinting : UInt32 {
        /// Leaves glyph outlines unchanged from their native representation.
        /// With FreeType, this is equivalent to the FT_LOAD_NO_HINTING
        /// bit-field constant supplied to FT_Load_Glyph, which indicates that the vector
        /// outline being loaded should not be fitted to the pixel grid but simply scaled
        /// to 26.6 fractional pixels.
        case noHinting = 0
        /// Modifies glyph outlines minimally to improve constrast.
        /// With FreeType, this is equivalent in spirit to the
        /// FT_LOAD_TARGET_LIGHT value supplied to FT_Load_Glyph. It chooses a
        /// lighter hinting algorithm for non-monochrome modes.
        /// Generated glyphs may be fuzzy but better resemble their original shape.
        case slight = 1
        /// Modifies glyph outlines to improve constrast. This is the default.
        /// With FreeType, this supplies FT_LOAD_TARGET_NORMAL to FT_Load_Glyph,
        /// choosing the default hinting algorithm, which is optimized for standard
        /// gray-level rendering.
        case normal = 2
        /// Modifies glyph outlines for maxiumum constrast. With FreeType, this selects
        /// FT_LOAD_TARGET_LCD or FT_LOAD_TARGET_LCD_V if kLCDRenderText_Flag is set.
        /// FT_LOAD_TARGET_LCD is a variant of FT_LOAD_TARGET_NORMAL optimized for
        /// horizontally decimated LCD displays; FT_LOAD_TARGET_LCD_V is a
        /// variant of FT_LOAD_TARGET_NORMAL optimized for vertically decimated LCD displays.
        case full = 3
        
        internal func toNative () -> sk_paint_hinting_t
        {
            return sk_paint_hinting_t.init(rawValue)
        }
        
        internal static func fromNative (_ x : sk_paint_hinting_t) -> Hinting
        {
            return Hinting.init(rawValue: x.rawValue)!
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

    var handle : OpaquePointer
       
    init (handle: OpaquePointer)
    {
        self.handle = handle
    }
    
    /// Constructs SkPaint with default values.
    public init ()
    {
       handle = sk_paint_new()
    }

    deinit {
       sk_paint_delete(handle)
    }
    
    /**
     * Sets all `Paint` contents to their initial values. This is equivalent to replacing
     * `Paint` with the result of `Paint`
     */
    public func reset ()
    {
        sk_paint_reset(handle)
    }
    
    /// Returns true if pixels on the active edges of SkPath may be drawn with partial transparency.
    /// When setting, requests, but does not require, that edge pixels draw opaque or with
    /// partial transparency.
    public var isAntialias : Bool {
        get {
            sk_paint_is_antialias(handle)
        }
        set {
            sk_paint_set_antialias(handle, newValue)
        }
    }
    
    /// Returns true if color error may be distributed to smooth color transition.
    /// When setting, requests, but does not require, to distribute color error.
    public var isDither : Bool {
        get {
            sk_paint_is_dither(handle)
        }
        set {
            sk_paint_set_dither(handle, newValue)
        }
    }
    
    public var isVerticalText : Bool {
        get {
            sk_paint_is_verticaltext(handle)
        }
        set {
            sk_paint_set_verticaltext(handle, newValue)
        }
    }
    
    public var isLinearText : Bool {
        get {
            sk_paint_is_linear_text(handle)
        }
        set {
            sk_paint_set_linear_text(handle, newValue)
        }
    }

    public var subpixelText : Bool {
        get {
            sk_paint_is_subpixel_text(handle)
        }
        set {
            sk_paint_set_subpixel_text(handle, newValue)
        }
    }

    public var lcdRenderedText : Bool {
        get {
            sk_paint_is_lcd_render_text(handle)
        }
        set {
            sk_paint_set_lcd_render_text(handle, newValue)
        }
    }

    public var isEmbeddedBitmapText  : Bool {
        get {
            sk_paint_is_embedded_bitmap_text(handle)
        }
        set {
            sk_paint_set_embedded_bitmap_text(handle, newValue)
        }
    }
    
    public var isAutohinted : Bool {
        get {
            sk_paint_is_autohinted(handle)
        }
        set {
            sk_paint_set_autohinted (handle, newValue)
        }
    }
    
    public var fakeBoldText : Bool {
        get {
            sk_paint_is_fake_bold_text(handle)
        }
        set {
            sk_paint_set_fake_bold_text (handle, newValue)
        }
    }
    
    public var hintingLevel : Hinting {
        get {
            Hinting.fromNative (sk_paint_get_hinting(handle))
        }
        set {
            sk_paint_set_hinting(handle, newValue.toNative())
        }
    }
    
    public var deviceKerningEnabled : Bool {
        get {
            sk_paint_is_dev_kern_text(handle)
        }
        set {
            sk_paint_set_dev_kern_text(handle, newValue)
        }
    }
    
    public var isStroke : Bool {
        get {
            style != .fill
        }
        set {
            style = newValue ? .stroke : .fill
        }
    }
    
    public var style : Style {
        get {
            Style.fromNative (sk_paint_get_style(handle))
        }
        set {
            sk_paint_set_style(handle, newValue.toNative())
        }
    }

    public var color : Color {
        get {
            Color (sk_paint_get_color (handle))
        }
        set {
            sk_paint_set_color(handle, sk_color_t (newValue.color))
        }
    }
    
    public var strokeWidth : Float {
        get {
            sk_paint_get_stroke_width(handle)
        }
        set {
            sk_paint_set_stroke_width(handle, newValue)
        }
    }
    
    public var strokeMiter : Float {
        get {
            sk_paint_get_stroke_miter(handle)
        }
        set {
            sk_paint_set_stroke_miter(handle, newValue)
        }
    }
    
    public var strokeCap : StrokeCap {
        get {
            StrokeCap.fromNative (sk_paint_get_stroke_cap(handle))
        }
        set {
            sk_paint_set_stroke_cap(handle, newValue.toNative ())
        }
    }
    
    public var strokeJoin : StrokeJoin {
        get {
            StrokeJoin.fromNative (sk_paint_get_stroke_join(handle))
        }
        set {
            sk_paint_set_stroke_join (handle, newValue.toNative ())
        }
    }
    
    public var shader : Shader {
        get {
            Shader (handle: sk_paint_get_shader(handle))
        }
        set {
            sk_paint_set_shader(handle, newValue.handle)
        }
    }
    
    public var maskFilter : MaskFilter {
        get {
            MaskFilter (handle: sk_paint_get_maskfilter(handle))
        }
        set {
            sk_paint_set_maskfilter(handle, newValue.handle)
        }
    }
    
    public var colorFilter : ColorFilter {
        get {
            ColorFilter (handle: sk_paint_get_colorfilter(handle))
        }
        set {
            sk_paint_set_colorfilter(handle, newValue.handle)
        }
    }
    
    public var imageFilter : ImageFilter {
        get {
            ImageFilter (handle: sk_paint_get_imagefilter(handle))
        }
        set {
            sk_paint_set_imagefilter(handle, newValue.handle)
        }
    }
    public var blendMode : BlendMode {
        get {
            BlendMode.fromNative (sk_paint_get_blendmode(handle))
        }
        set {
            sk_paint_set_blendmode(handle, newValue.toNative ())
        }
    }
    public var filterQuality : FilterQuality {
        get {
            FilterQuality.fromNative (sk_paint_get_filter_quality(handle))
        }
        set {
            sk_paint_set_filter_quality(handle, newValue.toNative ())
        }
    }
    
    public var typeface : Typeface {
        get {
            Typeface (handle: sk_paint_get_typeface(handle), owns: true)
        }
        set {
            sk_paint_set_typeface(handle, newValue.handle)
        }
    }
    
    public var textSize : Float {
        get {
            sk_paint_get_textsize(handle)
        }
        set {
            sk_paint_set_textsize(handle, newValue)
        }
    }
    
    public var textAlign : TextAlign {
        get {
            TextAlign.fromNative (sk_paint_get_text_align(handle))
        }
        set {
            sk_paint_set_text_align(handle, newValue.toNative())
        }
    }
    
    public var textEncoding : TextEncoding {
        get {
            TextEncoding.fromNative (sk_paint_get_text_encoding(handle))
        }
        set {
            sk_paint_set_text_encoding(handle, newValue.toNative())
        }
    }
    
    public var textScaleX : Float {
        get {
            sk_paint_get_text_scale_x(handle)
        }
        set {
            sk_paint_set_text_scale_x(handle, newValue)
        }
    }
    
    public var textSkewX : Float {
        get {
            sk_paint_get_text_skew_x(handle)
        }
        set {
            sk_paint_set_text_skew_x(handle, newValue)
        }
    }
    
    public var pathEffect : PathEffect {
        get {
            PathEffect (handle: sk_paint_get_path_effect(handle))
        }
        set {
            sk_paint_set_path_effect(handle, newValue.handle)
        }
    }
    
    public var fontSpacing : Float {
        get {
            sk_paint_get_fontmetrics(handle, nil, 0)
        }
    }
    
    public var fontMetrics : sk_fontmetrics_t {
        get {
            let ptr = UnsafeMutablePointer<sk_fontmetrics_t>.allocate(capacity: 1)
            sk_paint_get_fontmetrics(handle, ptr, 0)
            
            return ptr.pointee
        }
    }
    
    public func getFontMetrics (metrics : inout sk_fontmetrics_t, scale: Float = 0) -> Float
    {
        let ptr = UnsafeMutablePointer<sk_fontmetrics_t>.allocate(capacity: 1)
        let res = sk_paint_get_fontmetrics(handle, ptr, 0)
        
        metrics = ptr.pointee
        return res
    }
    
    public func clone () -> Paint
    {
        Paint (handle: sk_paint_clone (handle))
    }
    
    // MeasureText

    public func measureText (text: String) -> Float
    {
        return sk_paint_measure_text(handle, text, text.utf8.count, nil)
    }

    public func measureText (text: String, bounds: inout Rect) -> Float
    {
        let ret = UnsafeMutablePointer<sk_rect_t>.allocate(capacity: 1)
        let r = sk_paint_measure_text(handle, text, text.utf8.count, ret)
        bounds = Rect.fromNative (ret.pointee)
        return r
    }
    
    // TODO: BreakText
    // TODO: GetTextPath
    // TODO: GetFillPath
    // TODO: CountGlyphs
    // TODO: GetGlyphs
    // TODO: ContainsGlyphs
    // TODO: GetGlyphWidhts
    // TODO: GetTextIntercepts
    // TODO: GetPositionedTextIntercepts
    // TODO: GetHorizontalTextIntercepts
    
}
