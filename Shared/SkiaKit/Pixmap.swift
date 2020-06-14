//
//  Pixmap.swift
//  SkiaKit
//
//  Created by Miguel de Icaza on 10/28/19.
//

import Foundation
#if canImport(CSkiaSharp)
import CSkiaSharp
#endif

/**
 * `Pixmap` provides a utility to pair `ImageInfo` with pixels and row bytes.
 * `Pixmap` is a low level class which provides convenience functions to access
 * raster destinations. `Canvas` can not draw `Pixmap`, nor does `Pixmap` provide
 * a direct drawing destination.
 *
 * Use `Bitmap` to draw pixels referenced by `Pixmap`; use `Surface` to draw into
 * pixels referenced by `Pixmap`.
 *
 */
// `Pixmap` does not try to manage the lifetime of the pixel memory. Use `PixelRef`
// to manage pixel memory; `PixelRef` is safe across threads.
public final class Pixmap {
    var handle: OpaquePointer
    var owns: Bool
    
    init (handle: OpaquePointer, owns: Bool)
    {
        self.handle = handle
        self.owns = owns
    }
    
    deinit {
        if owns {
            sk_pixmap_destructor(handle)
        }
    }
    
    /**
     *  Creates an empty `Pixmap` without pixels, with `.unknown` `ColorType`, with
     * `.unknown` `AlphaType`, and with a width and height of zero. Use
     * `reset()` to associate pixels, `ColorType`, `AlphaType`, width, and height
     * after `Pixmap` has been created.
     */
    public init ()
    {
        handle = sk_pixmap_new()
        owns = true
    }
    
    /**
     * Creates `Pixmap` from info width, height, `AlphaType`, and `ColorType`.
     * addr points to pixels, or `nil`.  This computes the bytes per row from the
     * `info` parameter.
     *
     * No parameter checking is performed; it is up to the caller to ensure that
     * `addr` and `rowBytes` agree with `info`.
     *
     * The memory lifetime of pixels is managed by the caller. When `Pixmap` goes
     * out of scope, `addr` is unaffected.
     * `Pixmap` may be later modified by `reset()` to change its size, pixel type, or
     * storage.
     * - Parameter info: width, height, `AlphaType`, `ColorType` of `ImageInfo`
     * - Parameter addr: pointer to pixels allocated by caller; may be `nil`
     * - Returns: initialized `Pixmap`
     */
    public init (info: ImageInfo, addr: UnsafeMutableRawPointer)
    {
        var cinfo = info.toNative()
        handle = sk_pixmap_new_with_params(&cinfo, addr, info.rowBytes)
        owns = true
    }
    
    /**
     * Creates `Pixmap` from info width, height, `AlphaType`, and `ColorType`.
     * `addr` points to pixels, or `nil`. `rowBytes` should be `info.width` times
     * `info.bytesPerPixel`, or larger.
     * No parameter checking is performed; it is up to the caller to ensure that
     * `addr` and `rowBytes` agree with `info`.
     * The memory lifetime of pixels is managed by the caller. When `Pixmap` goes
     * out of scope, addr is unaffected.
     * `Pixmap` may be later modified by `reset()` to change its size, pixel type, or
     * storage.
     * - Parameter info: width, height, `AlphaType`, `ColorType` of `ImageInfo`
     * - Parameter addr: pointer to pixels allocated by caller; may be `nil`
     * - Parameter rowBytes: size of one row of addr; width times pixel size, or larger
     * - Returns: initialized `Pixmap`
     */
    public init (info: ImageInfo, addr: UnsafeMutableRawPointer, rowBytes: Int)
    {
        var cinfo = info.toNative()
        handle = sk_pixmap_new_with_params(&cinfo, addr, rowBytes)
        owns = true
    }
    
    /**
     * Sets width, height, row bytes to zero; pixel address to `nil`; `ColorType` to
     * `.unknown`; and `AlphaType` to `.unknown`
     * The prior pixels are unaffected; it is up to the caller to release pixels
     * memory if desired.
     */
    public func reset ()
    {
        sk_pixmap_reset(handle)
    }
    
    /**
     * Sets width, height, `AlphaType`, and `ColorType` from `info`.
     * Sets pixel address from `addr`, which may be `nil`.
     * Sets row bytes from `rowBytes`, which should be `info.width` times
     * `info.bytesPerPixel`, or larger.
     * Does not check `addr`. Asserts if built with SK_DEBUG defined and if `rowBytes` is
     * too small to hold one row of pixels.
     * The memory lifetime pixels are managed by the caller. When `Pixmap` goes
     * out of scope, `addr` is unaffected.
     * - Parameter info: width, height, `AlphaType`, `ColorType` of `ImageInfo`
     * - Parameter addr: pointer to pixels allocated by caller; may be `nil`
     * - Parameter rowBytes: size of one row of `addr`; width times pixel size, or larger

     */
    public func reset (info: ImageInfo, addr: UnsafeMutableRawPointer, rowBytes: Int)
    {
        var cinfo = info.toNative()
        sk_pixmap_reset_with_params (handle, &cinfo, addr, rowBytes);
    }
    
    /// Returns width, height, `AlphaType`, `ColorType`, and `ColorSpace`.
    public var info: ImageInfo {
        get {
            var info: sk_imageinfo_t = sk_imageinfo_t()
            
            sk_pixmap_get_info(handle, &info)
            return ImageInfo.fromNative (info)
        }
    }
    
    /// Returns pixel count in each pixel row. Should be equal or less than: `rowBytes` / `info.bytesPerPixel`
    public var width : Int32 { info.width }
    
    /// Returns pixel row count.
    public var height : Int32 { info.height }
    
    /// Return the dimensions of the pixmap (from its ImageInfo)
    public var rect: IRect {
        get {
            let i = info
            return IRect (left: 0, top: 0, right: i.width, bottom: i.height)
        }
    }
    
    /// Returns the ColorType for this pixmap
    public var colorType: ColorType { info.colorType }
    
    /// Returns the AlphaType for this pixmap
    public var alphaType: AlphaType { info.alphaType }
    
    /// Returns SkColorSpace, the range of colors, associated with ImageInfo. The
    /// reference count of SkColorSpace is unchanged. The returned SkColorSpace is
    /// immutable.
    public var colorSpace: ColorSpace? { info.colorSpace }
    /**
     * Returns row bytes, the interval from one pixel row to the next. Row bytes
     * is at least as large as: `width` * `info.bytesPerPixel`.
     * Returns zero if `colorType` `.unknown`
     * It is up to the `Bitmap` creator to ensure that row bytes is a useful value.
     */
    public var rowBytes : Int {
        get {
            sk_pixmap_get_row_bytes(handle)
        }
    }
    
    /**
     * Returns true if SkAlphaType is kOpaque_SkAlphaType.
     * Does not check if SkColorType allows alpha, or if any pixel value has
     * transparency.
     */
    public var isOpaque: Bool { info.isOpaque }
    
    /// Returns pixel address, the base address corresponding to the pixel origin.
    public var pixels : UnsafeMutableRawPointer {
        get {
            UnsafeMutableRawPointer (mutating: sk_pixmap_get_pixels(handle))
        }
    }
    
    public func getPixels (x: Int32, y: Int32) -> UnsafeRawPointer
    {
        return sk_pixmap_get_pixels_with_xy(handle, x, y)
    }
    
    public func getPixel (x: Int32, y: Int32) -> Color
    {
        return Color (sk_pixmap_get_pixel_color(handle, x, y))
    }
    
    public func scalePixels (destination: Pixmap, quality: FilterQuality)
    {
        sk_pixmap_scale_pixels(handle, destination.handle, quality.toNative())
    }
    
    /**
     * Copies a rectangle of pixels to `dstPixels`. Copy starts at (`srcX`, `srcY`), and does not
     * exceed `Pixmap` `(width, height)`.
     * `dstInfo` specifies width, height, `ColorType`, `AlphaType`, and
     * `ColorSpace` of destination. dstRowBytes specifics the gap from one destination
     * row to the next. Returns `true` if pixels are copied. Returns `false` if
     * `dstInfo` address equals `nil`, or `dstRowBytes` is less than `dstInfo.minRowBytes(`
     *
     * Pixels are copied only if pixel conversion is possible. If `Pixmap` `colorType` is
     * `.gray8`, or `.alpha8`; `dstInfo.colorType` must match.
     * If `Pixmap` `colorType` is `.gray8`, `dstInfo.colorSpace` must match.
     * If `Pixmap`` alphaType` is `.opaque`, `dstInfo.alphaType` must
     * match. If `Pixmap` `colorSpace` is `nil`, `dstInfo.colorSpace` must match.
     * `srcX` and `srcY` may be negative to copy only top or left of source. Returns
     * false if `Pixmap` `width` or `height` is zero or negative.
     *
     * - Parameter dstInfo: destination width, height, `ColorType`, `AlphaType`, `ColorSpace`
     * - Parameter dstPixels: destination pixel storage
     * - Parameter dstRowBytes: destination row length
     * - Parameter srcX: column index whose absolute value is less than width()
     * - Parameter srcY: row index whose absolute value is less than height()
     * - Returns: true if pixels are copied to dstPixels, or `false` if the pixel convesion is not possible, or if width/height is zero or negative, or abs(srcX) >= Pixmap width(), or if abs(srcY) >= Pixmap height().
     */
    public func readPixels (dstInfo: ImageInfo, dstPixels: UnsafeMutableRawPointer, dstRowBytes: Int, srcX: Int32 = 0, srcY: Int32 = 0) -> Bool
    {
        var cinfo = dstInfo.toNative()
        return sk_pixmap_read_pixels(handle, &cinfo, dstPixels, dstRowBytes, srcX, srcY)
    }
    
    /**
     * Copies a rectangle of pixels to dst. Copy starts at `(srcX, srcY)`, and does not
     * exceed `Pixmap` `(width, height)`. `dst` specifies width, height, `ColorType`,
     * `AlphaType`, and `ColorSpace` of destination.  Returns true if pixels are copied.
     * Returns false if dst address equals `nil`, or `dst.rowBytes` is less than
     * dst `ImageInfo.minRowBytes`.
     * Pixels are copied only if pixel conversion is possible. If `Pixmap` `colorType` is
     * `.gray8`, or `.alpha8`; `dstInfo.colorType` must match.
     * If `Pixmap` `colorType` is `.gray8`, `dstInfo.colorSpace` must match.
     * If `Pixmap`` alphaType` is `.opaque`, `dstInfo.alphaType` must
     * match. If `Pixmap` `colorSpace` is `nil`, `dstInfo.colorSpace` must match.
     * `srcX` and `srcY` may be negative to copy only top or left of source. Returns
     * false if `Pixmap` `width` or `height` is zero or negative.
     * - Parameter dst: `ImageInfo` and pixel address to write to
     * - Parameter srcX: column index whose absolute value is less than width()
     * - Parameter srcY: row index whose absolute value is less than height()
     * - Returns: true if pixels are copied to dst, or `false` if the pixel convesion is not possible, or if width/height is zero or negative, or abs(srcX) >= Pixmap width(), or if abs(srcY) >= Pixmap height().
     */
    public func readPixels (into: Pixmap, srcX: Int32 = 0, srcY: Int32 = 0) -> Bool
    {
        readPixels(dstInfo: into.info, dstPixels: UnsafeMutableRawPointer (mutating: into.pixels), dstRowBytes: into.rowBytes, srcX: srcX, srcY: srcY)
    }
    
    /**
     * Encodes the bitmap using the specified format.
     * - Parameter dest: the stream to write the encoded bitmap into
     * - Parameter src: the source bitmap to encode
     * - Parameter encoder: the format to use to encode the bitmap
     * - Parameter quality; the encoder-specific quality level
     * - Returns: true on success, false on failure
     */
    public static func encode (dest: SKWStream, src: Bitmap, encoder: EncodedImageFormat, quality: Int32) -> Bool
    {
        let pixmap = Pixmap ()
        return src.peekPixels (pixmap) && encode (dest: dest, src: pixmap, encoder: encoder, quality: quality)
    }
    
    /**
     * Encodes the pixmap using the specified format.
     * - Parameter dest: the stream to write the encoded pixmap into
     * - Parameter src: the source pixmap to encode
     * - Parameter encoder: the format to use to encode the pixmap
     * - Parameter quality; the encoder-specific quality level
     * - Returns: true on success, false on failure
     */
    public static func encode (dest: SKWStream, src: Pixmap, encoder: EncodedImageFormat, quality: Int32) -> Bool
    {
        sk_pixmap_encode_image(dest.handle, src.handle, encoder.toNative(), quality)
    }
    
    /**
     * Encodes the pixmap using the specified format.
     * - Parameter encoder: the format to use to encode the pixmap
     * - Parameter quality; the encoder-specific quality level
     * - Returns: nil on error, or Data containing the image in the specified format with the specified quality on success
     */
    public func encode (encoder: EncodedImageFormat, quality: Int32) -> SKData?
    {
        let stream = SKDynamicMemoryWStream ()
        let result = Pixmap.encode (dest: stream, src: self, encoder: encoder, quality: quality)
        if result {
            return stream.getData()
        }
        return nil
    }
    
    public func extract (subset: IRect) -> Pixmap?
    {
        let res = Pixmap()
        if extract (into: res, subset: subset) {
            return res
        }
        return nil
    }

    public func extract (into: Pixmap, subset: IRect) -> Bool
    {
        var ir = subset
        return sk_pixmap_extract_subset(handle, into.handle, &ir)
    }

    public func erase (_ color: Color)
    {
        erase (color, rect)
    }
    
    public func erase (_ color: Color, _ rect: IRect)
    {
        var r = rect
        sk_pixmap_erase_color(handle, color.color, &r)
    }
    
    
    public func withColorType (_ colorType: ColorType) -> Pixmap
    {
        return Pixmap (info: info.withColorType(colorType), addr: pixels, rowBytes: rowBytes)
    }

    public func withColorSpace (_ colorSpace: ColorSpace ) -> Pixmap
    {
        return Pixmap (info: info.withColorSpace(colorSpace), addr: pixels, rowBytes: rowBytes)
    }

    public func withAlphaType (_ alphaType: AlphaType) -> Pixmap
    {
        return Pixmap (info: info.withAlphaType(alphaType), addr: pixels, rowBytes: rowBytes)
    }
    
    //sk_pixmap_erase_color4f
    //sk_pixmap_get_writable_addr

}
