//
//  SurfaceProps.swift
//  SkiaKit
//
//  Created by Miguel de Icaza on 11/2/19.
//

import Foundation

/**
 * Describes properties and constraints of a given `Surface`. The rendering engine can parse these
 * during drawing, and can sometimes optimize its performance (e.g. disabling an expensive
 * feature).
 */
public class SurfaceProperties {
    var handle: OpaquePointer
    
    init (handle: OpaquePointer)
    {
        self.handle = handle
    }
    
    
    public init (_ pixelGeometry: PixelGeometry)
    {
        handle = sk_surfaceprops_new(0, pixelGeometry.toNative())
    }
    
    deinit {
        sk_surfaceprops_delete(handle)
    }
    
    /// The pixel geometry for the surface
    public var pixelGeometry: PixelGeometry { PixelGeometry.fromNative (sk_surfaceprops_get_pixel_geometry(handle)) }
}
