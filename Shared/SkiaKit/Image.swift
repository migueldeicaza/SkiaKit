//
//  Image.swift
//  SkiaKit
//
//  Created by Miguel de Icaza on 10/18/19.
//  Copyright © 2019 Miguel de Icaza. All rights reserved.
//

import Foundation

public final class Image {
    var handle: OpaquePointer
    
    init (handle: OpaquePointer)
    {
        self.handle = handle
    }
    
    public init (_ bitmap: Bitmap)
    {
        handle = sk_image_new_from_bitmap(bitmap.handle)
    }
    
    
    deinit {
        sk_image_unref(handle)
    }
    
    public func encode () -> SKData
    {
        SKData (handle: sk_image_encode(handle))
    }
}
