//
//  ImageFilter.swift
//  SkiaKit
//
//  Created by Miguel de Icaza on 10/17/19.
//  Copyright © 2019 Miguel de Icaza. All rights reserved.
//

import Foundation
import CSkiaSharp

public final class ImageFilter {
    var handle : OpaquePointer
    init (handle: OpaquePointer)
    {
        self.handle = handle
    }
    
    deinit
    {
        sk_imagefilter_unref(handle)
    }
}
