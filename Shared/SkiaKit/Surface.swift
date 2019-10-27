//
//  Surface.swift
//  SkiaKit
//
//  Created by Miguel de Icaza on 10/26/19.
//

import Foundation

public class Surface {
    var handle: OpaquePointer
    
    init (handle: OpaquePointer)
    {
        self.handle = handle
    }
    
    public static func make (info: ImageInfo, pixels: UnsafeMutableRawPointer, rowBytes: Int) -> Surface
    {
        var ninfo = info.toNative()
        
        return Surface (handle: sk_surface_new_raster_direct(&ninfo, pixels, rowBytes, nil, nil, nil))
    }
    
    public var canvas: Canvas { Canvas (handle: sk_surface_get_canvas(handle), owns: false)}
}
