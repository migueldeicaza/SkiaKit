//
//  Paint.swift
//  SkiaKit
//
//  Created by Miguel de Icaza on 10/16/19.
//  Copyright © 2019 Miguel de Icaza. All rights reserved.
//

import Foundation

public final class Paint {
    var handle : OpaquePointer
       
    init (handle: OpaquePointer)
    {
        self.handle = handle
    }
    
    public init ()
    {
       handle = sk_paint_new()
    }

    deinit {
       sk_paint_delete(handle)
    }
    
    public func reset ()
    {
        sk_paint_reset(handle)
    }
    
    public var isAntialias : Bool {
        get {
            sk_paint_is_antialias(handle)
        }
        set {
            sk_paint_set_antialias(handle, newValue)
        }
    }
    
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
    
    public var hintingLevel : PaintHinting {
        get {
            PaintHinting.fromNative (sk_paint_get_hinting(handle))
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
    
    public var style : PaintStyle {
        get {
            PaintStyle.fromNative (sk_paint_get_style(handle))
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
