//
//  Surface.swift
//  SkiaKit
//
//  Created by Miguel de Icaza on 10/26/19.
//

import Foundation
#if canImport(CSkiaSharp)
import CSkiaSharp
#endif

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
    public static func make (_ info: ImageInfo, _ pixels: UnsafeMutableRawPointer, _ rowBytes: Int, _ surfaceProps: SurfaceProperties? = nil) -> Surface?
    {
        var ninfo = info.toNative()
    
        if let h = sk_surface_new_raster_direct(&ninfo, pixels, rowBytes, nil, nil, surfaceProps == nil ? nil : surfaceProps!.handle) {
            return Surface (handle: h)
        }
        return nil
    }
    
    /**
    * Allocates raster `Surface`. `Canvas` returned by `Surface` draws directly into pixels.
    * `Surface` is returned if all parameters are valid.
    * Valid parameters include:
    * info dimensions are greater than zero;
    * info contains `ColorType` and `AlphaType` supported by raster surface;
    * pixels is not `nil`;
    * rowBytes is large enough to contain info width pixels of `ColorType`.
    * To access pixels after drawing, call flush() or peekPixels().
    * - Parameter imageInfo: width, height, `ColorType`, `AlphaType`, `ColorSpace`,
    * of raster surface; width and height must be greater than zero
    * - Parameter rowBytes: optional, interval from one `Surface` row to the next
    * - Parameter surfaceProps: LCD striping orientation and setting for device independent fonts;
    * may be `nil`
    * - Returns: `Surface` if all parameters are valid; otherwise, `nil`
    */
    public static func make (_ info: ImageInfo, _ rowBytes: Int? = nil, _ surfaceProps: SurfaceProperties? = nil) -> Surface?
    {
        var _info = info.toNative()
        if let h = sk_surface_new_raster(&_info, rowBytes == nil ? 0 : rowBytes!, surfaceProps == nil ? nil : surfaceProps!.handle) {
            return Surface (handle: h)
        }
        return nil
    }
    
    /**
     * Allocates raster `Surface`. `Canvas` returned by `Surface` draws directly into the pixmap's pixels.
     * `Surface` is returned if all parameters are valid.
     * Valid parameters include:
     * info dimensions are greater than zero;
     * info contains `ColorType` and `AlphaType` supported by raster surface;
     * pixels is not `nil`;
    
     * - Parameter pixmap: The pixmap to use as the backing store for this surface
     * - Parameter surfaceProps: LCD striping orientation and setting for device independent fonts;
     * may be `nil`
     * - Returns: `Surface` if all parameters are valid; otherwise, `nil`
     */
    public static func make (pixmap: Pixmap, surfaceProps: SurfaceProperties? = nil) -> Surface?
    {
        return make (pixmap.info, pixmap.pixels, pixmap.rowBytes, surfaceProps)
    }
    
    /// Returns `Surface` without backing pixels. Drawing to the `Canvas` returned from this  surface
    /// has no effect. Calling `makeImageSnapshot' on returned SkSurface returns `nil`.
    /// - Parameter width: one or greater
    /// - Parameter height: one or greater
    /// - Returns: Surface if width and height are positive; otherwise, `nil`
    public static func makeNull (width: Int32, height: Int32) -> Surface?
    {
        if let h = sk_surface_new_null(width, height) {
            return Surface (handle: h)
        }
        return nil
    }
    
    /**
     * Returns `Canvas` that draws into `Surface`. Subsequent calls return the same `Canvas`.
     * `Canvas` returned is managed and owned by `Surface`, and is deleted when `Surface`
     * is deleted.
     * - Returns: drawing `Canvas` for `Surface`
     */
    public var canvas: Canvas { Canvas (handle: sk_surface_get_canvas(handle), owns: .doesNotOwn)}
    
    /// Returns SurfaceProps for the surface which contains the LCD striping orientation and setting for device independent fonts
    public var surfaceProperties: SurfaceProperties {
        get {
            return SurfaceProperties(handle: sk_surface_get_props(handle), owns: false)
        }
    }
    
    /**
     * Returns `Image` capturing `Surface` contents. Subsequent drawing to `Surface` contents
     * are not captured. `Image` allocation is accounted for if `Surface` was created with
     * Budgeted = `.yes`
     * - Returns: `Image` initialized with `Surface` contents
     */
    public func snapshot () -> Image?
    {
        if let h = sk_surface_new_image_snapshot(handle) {
            return Image (handle: h)
        }
        return nil
    }
    
    /**
     * Draws `Surface` contents to canvas, with its top-left corner at (x, y).
     * If `Paint` paint is not `nil`, apply `ColorFilter`, alpha, `ImageFilter`,
     * `BlendMode`, and `DrawLooper`.
     * - Parameter canvas: `Canvas` drawn into
     * - Parameter x: horizontal offset in `Canvas`
     * - Parameter y: vertical offset in `Canvas`
     * - Parameter paint: `Paint` containing `BlendMode`, `ColorFilter`, `ImageFilter`,
     * and so on; or `nil`
     */
    public func draw (canvas: Canvas, x: Float, y: Float, paint: Paint? = nil)
    {
        sk_surface_draw(handle, canvas.handle, x, y, paint == nil ? nil : paint!.handle)
    }
    
    /**
     * Copies `Surface` pixel address, row bytes, and `ImageInfo` to a pixmap and returns it, if address
     * is available, and returns true. If pixel address is not available, returns
     * nil.
     *
     * pixmap contents become invalid on any future change to `Surface`.
     * - Returns: The pixmap with the contents, or nil.
     */
    public func peekPixels () -> Pixmap?
    {
        let pixmap = Pixmap ()
        if sk_surface_peek_pixels(handle, pixmap.handle) {
            return pixmap
        }
        return nil
    }
    
    /**
     * Copies `Rect` of pixels from `Canvas` into dstPixels.
     * Source `Rect` corners are (srcX, srcY) and `Surface` (width, height).
     * Destination `Rect` corners are (0, 0) and (dstInfo.width, dstInfo.height).
     * Copies each readable pixel intersecting both rectangles, without scaling,
     * converting to dstInfo.colorType() and dstInfo.alphaType() if required.
     *
     * Pixels are readable when `Surface` is raster, or backed by a GPU.
     *
     * The destination pixel storage must be allocated by the caller.
     *
     * Pixel values are converted only if `ColorType` and `AlphaType`
     * do not match. Only pixels within both source and destination rectangles
     * are copied. dstPixels contents outside `Rect` intersection are unchanged.
     *
     * Pass negative values for srcX or srcY to offset pixels across or down destination.
     *
     * Does not copy, and returns nil if:
     * - Source and destination rectangles do not intersect.
     * - `Surface` pixels could not be converted to dstInfo.colorType() or dstInfo.alphaType().
     * - dstRowBytes is too small to contain one row of pixels.
     * - Parameter dstInfo: width, height, `ColorType`, and `AlphaType` of dstPixels
     * - Parameter dstPixels: storage for pixels; dstInfo.height() times dstRowBytes, or larger
     * - Parameter dstRowBytes: size of one destination row; dstInfo.width() times pixel size, or larger
     * - Parameter srcX: offset into readable pixels on x-axis; may be negative
     * - Parameter srcY: offset into readable pixels on y-axis; may be negative
     * - Returns: the updated ImageInfo, or nil on error

     */
    public func readPixels (info: ImageInfo, dstPixels: UnsafeMutableRawPointer!, dstRowBytes: Int, srcX: Int32, srcY: Int32) -> ImageInfo?
    {
        var l = info.toNative()
        if sk_surface_read_pixels(handle, &l, dstPixels, dstRowBytes, srcX, srcY) {
            return ImageInfo.fromNative(l)
        }
        return nil
    }
}
