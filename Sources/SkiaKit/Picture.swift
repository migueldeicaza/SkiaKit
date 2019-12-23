//
//  Picture.swift
//  SkiaKit
//
//  Created by Miguel de Icaza on 11/6/19.
//

import Foundation
import SkiaSharp

public final class Picture {
    var handle: OpaquePointer
    
    init (handle: OpaquePointer)
    {
        self.handle = handle
    }
    
    /// Gets the non-zero value unique among all pictures.
    public var uniqueId: UInt32 {
        get {
            sk_picture_get_unique_id(handle)
        }
    }

    /// Gets the culling rectangle for this picture.
    public var cullRect: Rect {
        get {
            var r = sk_rect_t ()
            sk_picture_get_cull_rect(handle, &r)
            return Rect.fromNative(r)
        }
    }
    
    deinit {
        sk_picture_unref(handle)
    }
}
