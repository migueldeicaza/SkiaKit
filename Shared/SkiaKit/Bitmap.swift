//
//  SKBitmap.swift
//  SkiaKit
//
//  Created by Miguel de Icaza on 10/15/19.
//  Copyright © 2019 Miguel de Icaza. All rights reserved.
//

import Foundation
#if canImport(CSkiaSharp)
import CSkiaSharp
#endif

public enum BitmapError : Error {
    case outOfMemory
}

/**
 * Bitmap describes a two-dimensional raster pixel array. Bitmap is built on
 * ImageInfo, containing integer width and height, ColorType and AlphaType
 * describing the pixel format, and ColorSpace describing the range of colors.
 * Bitmap points to PixelRef, which describes the physical array of pixels.
 * ImageInfo bounds may be located anywhere fully inside PixelRef bounds.
 *
 * Bitmap can be drawn using Canvas. Bitmap can be a drawing destination for Canvas
 * draw member functions. Bitmap flexibility as a pixel container limits some
 * optimizations available to the target platform.
 *
 * If pixel array is primarily read-only, use Image for better performance.
 * If pixel array is primarily written to, use Surface for better performance.
 *
 * Bitmap is not thread safe. Each thread must have its own copy of Bitmap fields,
 * although threads may share the underlying pixel array.
 */
public final class Bitmap {
    var handle : OpaquePointer
  
    /**
     * Creates an empty Bitmap without pixels, with `colorType` set to `.unkonwn`
     * `alphaType` set to `.unknown`, and with a width and height of zero. PixelRef origin is
     * set to (0, 0). Bitmap is not volatile.
     *
     * - Returns:  empty Bitmap
     * example: https://fiddle.skia.org/c/@Bitmap_empty_constructor
     */
    public init ()
    {
        handle = sk_bitmap_new()
    }
 
    public convenience init (_ width: Int32, _ height: Int32, isOpaque: Bool = false) throws
    {
        try self.init (ImageInfo (width: width, height: height, colorType: ImageInfo.platformColorType(), alphaType: isOpaque ? .opaque : .premul))
    }
    
    public init (_ imageInfo: ImageInfo, rowBytes: Int? = nil) throws
    {
        handle = sk_bitmap_new()
        if !tryAllocPixels(info: imageInfo.toNative(), rowBytes: rowBytes) {
            throw BitmapError.outOfMemory
        }
    }

    // TODO: constructor that takes alloc flags, to clear the buffer
    
    deinit {
        sk_bitmap_destructor(handle)
    }
    
    /**
     * Returns row bytes, the interval from one pixel row to the next. Row bytes
     * is at least as large as: `width`* `imageInfo.bytesPerPixel`.
     * Returns zero if colorType is `.unknown`, or if row bytes supplied to
     * setInfo() is not large enough to hold a row of pixels.
     *
     * - Returns:  byte length of pixel row
     */
    public var rowBytes : Int {
        get {
            return Int (sk_bitmap_get_row_bytes(handle))
        }
    }
    
    /**
     * Sets `ImageInfo` to info following and allocates pixel
     * memory.  `rowBytes` must equal or exceed `info.width` times `info.bytesPerPixel`,
     * or equal zero. Pass in zero for `rowBytes` to compute the minimum valid value.
     * Returns `false` and calls `reset()` if `ImageInfo` could not be set, or memory could
     * not be allocated.
     *
     * On most platforms, allocating pixel memory may succeed even though there is
     * not sufficient memory to hold pixels; allocation does not take place
     * until the pixels are written to. The actual behavior depends on the platform
     * implementation of malloc().
     * - Parameter info: contains width, height, `AlphaType`, `ColorType`, `ColorSpace`
     * - Parameter rowBytes: size of pixel row or larger; may be zero
     * - Returns: true if pixel storage is allocated
     */
    public func tryAllocPixels (info: sk_imageinfo_t, rowBytes: Int? = nil) -> Bool
    {
        withUnsafePointer(to: info) { ptr in
            sk_bitmap_try_alloc_pixels(handle, ptr, rowBytes == nil ? self.rowBytes : rowBytes!)
        }
    }
    
    /**
     * Resets to its initial state; all fields are set to zero, as if `Bitmap` had
     * been initialized by `Bitmap`().
     *
     * Sets `width`, `height`, `row bytes` to zero; pixel address to `nil`; `ColorType` to
     * `.unknown`; and `AlphaType` to `.unknown`.
     *
     * If `PixelRef` is allocated, its reference count is decreased by one, releasing
     * its memory if `Bitmap` is the sole owner.
     */
    public func reset ()
    {
        sk_bitmap_reset(handle)
    }
    
    /**
     * Sets internal flag to mark `Bitmap` as immutable. Once set, pixels can not change.
     * Any other bitmap sharing the same `PixelRef` are also marked as immutable.
     * Once `PixelRef` is marked immutable, the setting cannot be cleared.
     * Writing to immutable `Bitmap` pixels triggers an assert on debug builds.
     * example: https://fiddle.skia.org/c/@Bitmap_setImmutable
     */
    public func setImmutable ()
    {
        sk_bitmap_set_immutable(handle)
    }
    
    /**
     * Replaces pixel values with c. All pixels contained by the bounds are affected.
     * If the `colorType` is `.gray9` or `.krgb565`, then alpha
     * is ignored;  RGB is treated as opaque.  If colorType is `.alpha8`
     * then RGB is ignored.
     *
     * - Parameter c: unpremultiplied color
     * example: https://fiddle.skia.org/c/@Bitmap_eraseColor
     */
    public func erase (_ color: Color)
    {
        sk_bitmap_erase(handle, color.color)
    }
    
    public func erase (_ color: Color, rect: IRect)
    {
        var r = rect.toNative()
        
        sk_bitmap_erase_rect (handle, color.color, &r)
    }
    
    public func getAddr8 (x: Int32, y: Int32) -> UInt8
    {
        sk_bitmap_get_addr_8(handle, x, y)
    }
    
    public func getAddr16 (x: Int32, y: Int32) -> UInt16
    {
        sk_bitmap_get_addr_16(handle, x, y)
    }
    
    public func getAddr32 (x: Int32, y: Int32) -> UInt32
    {
        sk_bitmap_get_addr_32(handle, x, y)
    }
    
    public func getAddr64 (x: Int32, y: Int32) -> UnsafeMutableRawPointer?
    {
        sk_bitmap_get_addr (handle, x, y)
    }
    
    public func getPixel (x: Int32, y: Int32) -> Color
    {
        Color (sk_bitmap_get_pixel_color(handle, x, y))
    }
    
    public func setPixel (x: Int32, y: Int32, value: Color)
    {
        sk_bitmap_set_pixel_color(handle, x, y, value.color)
    }
    
    public func canCopy (to colorType: ColorType) -> Bool
    {
        let srcCT = self.colorType
        if srcCT == .unknown {
            return false
        }
        
        if srcCT == .alpha8 || colorType != .alpha8{
            return false // can't convert from alpha to non-alpha
        }
        let sameConfigs = srcCT == colorType
        switch colorType {
        case .alpha8,
             .rgb565,
             .rgba8888,
             .bgra8888,
             .rgb888x,
             .rgba1010102,
             .rgb101010x,
             .rgbaF16:
            break
        case .gray8:
            if !sameConfigs {
                return false
            }
            break
        case .argb4444:
            return sameConfigs || srcCT == ImageInfo.platformColorType()
        default:
            return false
        }
        return true
    }
    
//    public func copy (to: Bitmap, colorType: ColorType) -> Bool
//    {
//        if !canCopy(to: colorType) {
//            return false
//        }
//        guard var srcPM = peekPixels() else {
//            return false
//        }
//        let dstInfo = srcPM.info.makeWith(colorType: colorType)
//        var srcInfo = srcPM.info
//        switch (colorType){
//        case .rgb565:
//            // copyTo() is not strict on alpha type. Here we set the src to opaque to allow
//            // the call to ReadPixels() to succeed and preserve this lenient behavior.
//            
//            if srcInfo.alphaType != .opaque {
//                srcPM = srcPM.makeWith (alphaType: .opaque)
//            }
//            dstInfo.alphaType = .opaque
//        case .unknown:
//            <#code#>
//        case .alpha8:
//            <#code#>
//        case .argb4444:
//            <#code#>
//        case .rgba8888:
//            <#code#>
//        case .rgb888x:
//            <#code#>
//        case .bgra8888:
//            <#code#>
//        case .rgba1010102:
//            <#code#>
//        case .rgb101010x:
//            <#code#>
//        case .gray8:
//            <#code#>
//        case .rgbaF16:
//            <#code#>
//        }
//        return true
//    }
    
//    public func extractSubset (to destination: Bitmap, subset: IRect) -> Bool
//    {
//        sk_bitmap_extract_subset(handle, destination.handle, subset)
//    }
    
    public var imageInfo: ImageInfo {
        get {
            let out = UnsafeMutablePointer<sk_imageinfo_t>.allocate(capacity: 1)
            sk_bitmap_get_info(handle, out);
            let r = out.pointee
            return ImageInfo (width: r.width, height: r.height, colorType: ColorType.fromNative (r.colorType), alphaType: AlphaType.fromNative (r.alphaType))
        }
    }
    
    var _imageInfo: sk_imageinfo_t {
        get {
            let out = UnsafeMutablePointer<sk_imageinfo_t>.allocate(capacity: 1)
            sk_bitmap_get_info(handle, out);
            return out.pointee
        }
    }
    
    public var width : Int32 {
        get {
            return _imageInfo.width
        }
    }
    
    public var height: Int32 {
        get {
            return _imageInfo.height
        }
    }
    
    public var alphaType: AlphaType {
        get {
            return AlphaType.fromNative (_imageInfo.alphaType)
        }
    }
    
    public var bytesPerPixel: Int32 {
        get {
            return imageInfo.bytesPerPixel
        }
    }
    
    public var colorType: ColorType {
        get {
            ColorType.fromNative (_imageInfo.colorType)
        }
    }
    
    public var byteCount: Int {
        get {
            sk_bitmap_get_byte_count(handle)
        }
    }
    
    public func getPixels () -> (buffer: UnsafeMutableRawPointer?, len: Int)
    {
        var len: Int = 0
        let ret = sk_bitmap_get_pixels(handle, &len)
        return (ret, len)
    }
    
    public func setPixels (buffer: UnsafeMutableRawPointer)
    {
        sk_bitmap_set_pixels(handle, buffer)
    }

    /**
     * Returns the pixels if they are available without having to lock the bitmap.
     * - Returns: Returns the pixels if they are available, otherwise null.
     */
    public func peekPixels () -> Pixmap?
    {
        let pixmap = Pixmap ()
        if peekPixels(pixmap) {
            return pixmap
        }
        return nil
    }
    
    /**
     * Returns the pixmap of the bitmap
     * - Returns: true on success, false on failure
     */
    public func peekPixels (_ pixmap: Pixmap) -> Bool
    {
        sk_bitmap_peek_pixels(handle, pixmap.handle)
        
    }
    //public func getPixels () -> [Color]
    //{
    //    var ret = Array<color>.init(unsafeUninitializedCapacity: Int(width) * Int(height)) { ptr,arg  in }
    //    sk_bitmap_get_pixel_colors(handle, ret)
    //    return ret
    //}
}
