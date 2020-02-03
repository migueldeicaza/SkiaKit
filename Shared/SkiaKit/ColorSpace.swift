//
//  ColorSpace.swift
//  SkiaKit
//
//  Created by Miguel de Icaza on 10/16/19.
//  Copyright © 2019 Miguel de Icaza. All rights reserved.
//

import Foundation
import CSkiaSharp

public final class ColorSpace {
    var handle: OpaquePointer
    
    public init ()
    {
        handle = OpaquePointer(bitPattern: 0)!
    }
    
    init (handle: OpaquePointer)
    {
        self.handle = handle
    }
    
    deinit {
        sk_colorspace_unref(handle)
    }
}
