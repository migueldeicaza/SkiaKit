//
//  Surface.swift
//  SkiaKit
//
//  Created by Miguel de Icaza on 10/26/19.
//

import Foundation

/**
 * `Surface` is responsible for managing the pixels that a canvas draws into. The pixels can be
 * allocated either in CPU memory (a raster surface) or on the GPU (a GrRenderTarget surface).
 *
 * `Surface` takes care of allocating a `Canvas` that will draw into the surface. Call
 * surface->getCanvas() to use that canvas (but don't delete it, it is owned by the surface).
 *
 * `Surface` always has non-zero dimensions. If there is a request for a new surface, and either
 * of the requested dimensions are zero, then `nil` will be returned.
 *
 * Use one of the static `make` methods to create instances of `Surface`
 */
public final class Surface {
    var handle: OpaquePointer
    
    init (handle: OpaquePointer)
    {
        self.handle = handle
    }
    
    /**
     * Allocates raster `Surface`. `Canvas` returned by `Surface` draws directly into pixels.
     * `Surface` is returned if all parameters are valid.
     * Valid parameters include:
     * info dimensions are greater than zero;
     * info contains `ColorType` and `AlphaType` supported by raster surface;
     * pixels is not `nil`;
     * rowBytes is large enough to contain info width pixels of `ColorType`.
     * Pixel buffer size should be info height times computed rowBytes.
     * Pixels are not initialized.
     * To access pixels after drawing, call flush() or peekPixels().
     * - Parameter imageInfo: width, height, `ColorType`, `AlphaType`, `ColorSpace`,
     * of raster surface; width and height must be greater than zero
     * - Parameter pixels: pointer to destination pixels buffer
     * - Parameter rowBytes: interval from one `Surface` row to the next
     * - Parameter surfaceProps: LCD striping orientation and setting for device independent fonts;
     * may be `nil`
     * - Returns: `Surface` if all parameters are valid; otherwise, `nil`
     */
    public static func make (info: ImageInfo, pixels: UnsafeMutableRawPointer, rowBytes: Int, surfaceProps: SurfaceProperties? = nil) -> Surface
    {
        var ninfo = info.toNative()
        
        return Surface (handle: sk_surface_new_raster_direct(&ninfo, pixels, rowBytes, nil, nil, surfaceProps == nil ? nil : surfaceProps!.handle))
    }
    
    public var canvas: Canvas { Canvas (handle: sk_surface_get_canvas(handle), owns: false)}
}
