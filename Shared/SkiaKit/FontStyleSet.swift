//
//  FontStyleSet.swift
//  SkiaKit
//
//  Created by Miguel de Icaza on 11/4/19.
//

import Foundation
#if canImport(CSkiaSharp)
import CSkiaSharp
#endif

/// Represets the set of styles for a particular font family.
public final class FontStyleSet {
    var handle: OpaquePointer
    
    init (handle: OpaquePointer) {
        self.handle = handle
    }
    
    deinit {
        sk_fontstyleset_unref(handle)
    }
    /// Creates an empty font style set
    public init ()
    {
        handle = sk_fontstyleset_create_empty()
    }
    
    /// Returns the number of font stypes in this set.
    public var count: Int32 {
        get {
            sk_fontstyleset_get_count(handle)
        }
    }
    
    func getStyle (index: Int32) -> FontStyle {
        let x = FontStyle ()
        sk_fontstyleset_get_style(handle, index, x.handle, nil)
        return x
    }
    
    /// Returns an array of FontStyles in this set
    public var styles: [FontStyle] {
        get {
            var ret : [FontStyle] = []
            for x in 0..<count {
                ret.append(getStyle (index: x))
            }
            return ret
        }
    }
    
    /// Creates a new SKTypeface with a style that is the closest match to the specified font style.
    /// - Returns: the typeface if found, or `nil` if nothing matches
    public func createTypeface (style: FontStyle) -> Typeface? {
        let x = sk_fontstyleset_match_style(handle, style.handle)
        if x == nil {
            return nil
        }
        return Typeface(handle: x!, owns: true)
    }
    
    /// Creates a new SKTypeface with a style that is the closest match to the specified font style.
    /// - Returns: the typeface if available, nil if the index is invalid
    public func createTypeface (index: Int32) -> Typeface? {
        let x = sk_fontstyleset_create_typeface(handle, index)
        if x == nil {
            return nil
        }
        return Typeface(handle: x!, owns: true)
    }

    /// Returns the name of the font style.
    public func getStyleName (index: Int32) -> String
    {
        let str = SKString ()
        sk_fontstyleset_get_style(handle, index, nil, str.handle)
        return str.getStr()
    }
    //sk_fontstyleset_create_empty

}
