//
//  Typeface.swift
//  SkiaKit
//
//  Created by Miguel de Icaza on 10/17/19.
//  Copyright © 2019 Miguel de Icaza. All rights reserved.
//

import Foundation

/**
 * The `Typeface` class specifies the typeface and intrinsic style of a font.
 * This is used in the paint, along with optionally algorithmic settings like
 * textSize, textskewX, textScaleX, FakeBoldText_Mask, to specify
 * how text appears when drawn (and measured).
 *
 * Typeface objects are immutable, and so they can be shared between threads.
 */
public final class Typeface {
    var handle : OpaquePointer
    var owns: Bool
    
    /// The default normal typeface
    static var defaultTypeface = Typeface (handle: sk_typeface_ref_default(), owns: false)
    
    init (handle: OpaquePointer, owns: Bool)
    {
        self.handle = handle
        self.owns = owns
    }
    
    /// Returns a new typeface configured with the defaults
    public static func createDefault () -> Typeface
    {
        return Typeface(handle: sk_typeface_create_default(), owns: true)
    }
    
    //public init (familyName: String, weight: Int, width: Int, slant: FontStyleSlant)
    
//    public init? (familyName: String, style: FontStyle?)
//    {
//
//    }
    deinit
    {
        if owns {
            sk_typeface_unref(handle)
        }
    }
}
