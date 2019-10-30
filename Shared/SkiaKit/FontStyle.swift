//
//  FontStyle.swift
//  SkiaKit iOS
//
//  Created by Miguel de Icaza on 10/29/19.
//

import Foundation

/// Represents a particular style (bold, italic, condensed) of a typeface.
public final class FontStyle {
    var handle: OpaquePointer
    var owns: Bool
    
    init (handle: OpaquePointer, owns: Bool)
    {
        self.handle = handle
        self.owns = owns
    }
    
    /// Creates a new SKFontStyle with the specified weight, width and slant.
    public init (weight: Int32, width: Int32, slant: FontStyleSlant)
    {
        handle = sk_fontstyle_new(weight, width, slant.toNative())
        owns = true
    }
    
    /// Creates a new SKFontStyle with the specified weight, width and slant.
    public init (weight: FontStyleWeight, width: FontStyleWidth, slant: FontStyleSlant)
    {
        handle = sk_fontstyle_new(weight.rawValue, width.rawValue, slant.toNative())
        owns = true
    }
    
    deinit {
        if owns {
            sk_fontstyle_delete(handle)
        }
    }
    
    /// Gets the weight of this style.
    public var weight: Int32 { sk_fontstyle_get_weight(handle) }
    /// Gets the width of this style.
    public var width: Int32 { sk_fontstyle_get_width(handle) }
    /// Gets the slant of this style.
    public var slant: FontStyleSlant { FontStyleSlant.fromNative (sk_fontstyle_get_slant(handle)) }
    
    /// Gets a new normal (upright and not bold) font style.
    public var normal: FontStyle = FontStyle(weight: .normal, width: .normal, slant: .upright)
    /// Gets a new upright font style that is bold.
    public var bold: FontStyle = FontStyle(weight: .bold, width: .normal, slant: .upright)
    /// Gets a new italic font style.
    public var italic: FontStyle = FontStyle(weight: .normal, width: .normal, slant: .italic)
    /// Gets a new italic font style that is bold.
    public var boldItalic: FontStyle = FontStyle(weight: .bold, width: .normal, slant: .italic)
}
