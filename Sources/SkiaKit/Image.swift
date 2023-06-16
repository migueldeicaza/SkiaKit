//
//  Image.swift
//  SkiaKit
//
//  Created by Miguel de Icaza on 10/18/19.
//  Copyright © 2019 Miguel de Icaza. All rights reserved.
//

import Foundation
#if canImport(CSkiaSharp)
import CSkiaSharp
#endif

/**
 * `Image` describes a two dimensional array of pixels to draw. The pixels may be
 * decoded in a raster bitmap, encoded in a `Picture` or compressed data stream,
 * or located in GPU memory as a GPU texture.
 *
 * `Image` cannot be modified after it is created. `Image` may allocate additional
 * storage as needed; for instance, an encoded `Image` may decode when drawn.
 *
 * `Image` width and height are greater than zero. Creating an `Image` with zero width
 * or height returns `Image` equal to `nil`.
 *
 * `Image` may be created from `Bitmap`, `Pixmap`, `Surface`, `Picture`, encoded streams,
 * GPU texture, YUV_ColorSpace data, or hardware buffer. Encoded streams supported
 * include BMP, GIF, HEIF, ICO, JPEG, PNG, WBMP, WebP. Supported encoding details
 * vary with platform.
 */
public final class Image {
    var handle: OpaquePointer
    
    init (handle: OpaquePointer)
    {
        self.handle = handle
    }
    
    /**
     * Creates `Image` from bitmap, sharing or copying bitmap pixels. If the bitmap
     * is marked immutable, and its pixel memory is shareable, it may be shared
     * instead of copied.
     *
     * `Image` is returned if bitmap is valid. Valid `Bitmap` parameters include:
     * dimensions are greater than zero;
     * each dimension fits in 29 bits;
     * `ColorType` and `AlphaType` are valid, and `ColorType` is not kUnknown_`ColorType`;
     * row bytes are large enough to hold one row of pixels;
     * pixel address is not `nil`.
     * - Parameter bitmap: `ImageInfo`, row bytes, and pixels
     * - Returns: created `Image`, or `nil`
     */
    public init? (_ bitmap: Bitmap)
    {
        if let x = sk_image_new_from_bitmap(bitmap.handle) {
            handle = x
        } else {
            return nil
        }
    }
    
    /**
     * Creates `Image` from `ImageInfo`, sharing pixels.
     * `Image` is returned if `ImageInfo` is valid. Valid `ImageInfo` parameters include:
     * dimensions are greater than zero;
     * each dimension fits in 29 bits;
     * `ColorType` and `AlphaType` are valid, and `ColorType` is not kUnknown_`ColorType`;
     * rowBytes are large enough to hold one row of pixels;
     * pixels is not `nil`, and contains enough data for `Image`.
     * - Parameter info: contains width, height, `AlphaType`, `ColorType`, `ColorSpace`
     * - Parameter pixels: address or pixel storage
     * - Parameter rowBytes: size of pixel row or larger
     * - Returns: `Image` sharing pixels, or `nil`
     */
    public init? (info: ImageInfo, data: SKData, rowBytes: Int)
    {
        var cinfo = info.toNative()
        if let x = sk_image_new_raster_data(&cinfo, data.handle, rowBytes) {
            handle = x
        } else {
            return nil
        }
    }

    /**
     * Creates `Image` from pixmap, sharing `Pixmap` pixels. Pixels must remain valid and
     * unchanged until rasterReleaseProc is called. rasterReleaseProc is passed
     * releaseContext when `Image` is deleted or no longer refers to pixmap pixels.
     * Pass `nil` for rasterReleaseProc to share `Pixmap` without requiring a callback
     * when `Image` is released. Pass `nil` for releaseContext if rasterReleaseProc
     * does not require state.
     * `Image` is returned if pixmap is valid. Valid `Pixmap` parameters include:
     * dimensions are greater than zero;
     * each dimension fits in 29 bits;
     * `ColorType` and `AlphaType` are valid, and `ColorType` is not kUnknown_`ColorType`;
     * row bytes are large enough to hold one row of pixels;
     * pixel address is not `nil`.
     * - Parameter pixmap: `ImageInfo`, pixel address, and row bytes
     * - Parameter rasterReleaseProc: function called when pixels can be released; or `nil`
     * - Parameter releaseContext: state passed to rasterReleaseProc; or `nil`
     * - Returns: `Image` sharing pixmap
     */
    public init? (pixmap: Pixmap, releaseProc: sk_image_raster_release_proc? = nil, context: UnsafeMutableRawPointer? = nil )
    {
        if let x = sk_image_new_raster(pixmap.handle, releaseProc, context) {
            handle = x
        } else {
            return nil
        }
    }
    
    /**
     * Return an image backed by the encoded data, but attempt to defer decoding until the image
     * is actually used/drawn. This deferral allows the system to cache the result, either on the
     * CPU or on the GPU, depending on where the image is drawn. If memory is low, the cache may
     * be purged, causing the next draw of the image to have to re-decode.
     *
     * The subset parameter specifies a area within the decoded image to create the image from.
     * If subset is null, then the entire image is returned.
     *
     * This is similar to DecodeTo[Raster,Texture], but this method will attempt to defer the
     * actual decode, while the DecodeTo... method explicitly decode and allocate the backend
     * when the call is made.
     *
     * If the encoded format is not supported, or subset is outside of the bounds of the decoded
     * image, `nil` is returned.
     *
     * - Parameter encoded: the encoded data
     * - Parameter subset: optional, the bounds of the pixels within the decoded image to return. may be null.
     * - Returns: created `Image`, or `nil`
     */
    public init? (data: SKData)
    {
        if let x = sk_image_new_from_encoded(data.handle) {
            handle = x
        } else {
            return nil
        }
    }
    deinit {
        sk_image_unref(handle)
    }

   /**
    * Encodes `Image` pixels, returning result as `Data`. Returns existing encoded data
    * if present; otherwise, `Image` is encoded with `EncodedImageFormat`::kPNG. `ia`
    * must be built with SK_HAS_PNG_LIBRARY to encode `Image`.
    * Returns `nil` if existing encoded data is missing or invalid, and
    * encoding fails.
    * - Returns: encoded `Image`, or `nil`
    */
    public func encode () -> SKData?
    {
        if let x = sk_image_encode(handle) {
            return SKData (handle: x)
        }
        return nil
    }
    
    /**
     * Encodes `Image` pixels, returning result as `Data`.
     * Returns `nil` if encoding fails, or if encodedImageFormat is not supported.
     *
     * `Image` encoding in a format requires both building with one or more of:
     * SK_HAS_JPEG_LIBRARY, SK_HAS_PNG_LIBRARY, SK_HAS_WEBP_LIBRARY; and platform support
     * for the encoded format.
     *
     * If SK_BUILD_FOR_MAC or SK_BUILD_FOR_IOS is defined, encodedImageFormat can
     * additionally be one of: `EncodedImageFormat.ico`, `EncodedImageFormat.bmp`,
     * `EncodedImageFormat.gif``
     * quality is a platform and format specific metric trading off size and encoding
     * error. When used, quality equaling 100 encodes with the least error. quality may
     * be ignored by the encoder.
     * - Parameter encodedImageFormat: one of: `.jpeg`, `.png`, `.webp`
     * - Parameter quality: encoder specific metric with 100 equaling best
     * - Returns: encoded `Image` or `nil`
     */
    public func encode (format: EncodedImageFormat, quality: Int32) -> SKData? {
        if let x = sk_image_encode_specific(handle, format.toNative(), quality) {
            return SKData (handle: x)
        }
        return nil
    }
    
    /// Returns pixel count in each row.
    public var width: Int32 {
        get {
            sk_image_get_width(handle)
        }
    }
    
    ///  Returns pixel row count.
    public var height: Int32 {
        get {
            sk_image_get_height(handle)
        }
    }
    
    /**
     * Returns value unique to image. `Image` contents cannot change after `Image` is
     * created. Any operation to create a new `Image` will receive generate a new
     * unique number.
     */
    public var uniqueID: UInt32 {
        get {
            sk_image_get_unique_id(handle)
        }
    }
    
    /// The AlphaType  returned was a parameter to an SkImage constructor, or was parsed from encoded data.
    public var alphaType: AlphaType {
        get {
            AlphaType.fromNative (sk_image_get_alpha_type(handle))
        }
    }
    
    /// SkColorType if known; otherwise, returns `.unknown`.
    public var colorType: ColorType {
        get {
            ColorType.fromNative (sk_image_get_color_type(handle))
        }
    }
    
    /**
     * Returns `ColorSpace`, the range of colors, associated with `Image`.  The
     * reference count of `ColorSpace` is unchanged. The returned `ColorSpace` is
     * immutable.
     * `ColorSpace` returned was passed to an `Image` constructor,
     * or was parsed from encoded data. `ColorSpace` returned may be ignored when `Image`
     * is drawn, depending on the capabilities of the `Surface` receiving the drawing.
     * - Returns: `ColorSpace` in `Image`, or `nil`
     */
    public var colorSpace: ColorSpace {
        get {
            ColorSpace (handle: sk_image_get_colorspace(handle))
        }
    }
    
    /**
     * Returns true if `Image` pixels represent transparency only. If true, each pixel
     * is packed in 8 bits as defined by kAlpha_8_`ColorType`.
     * - Returns: true if pixels represent a transparency mask
     */
    public var isAlphaOnly: Bool {
        get {
            sk_image_is_alpha_only(handle)
        }
    }
    
    /**
     * Returns encoded `Image` pixels as `Data`, if `Image` was created from supported
     * encoded stream format. Platform support for formats vary and may require building
     * with one or more of: SK_HAS_JPEG_LIBRARY, SK_HAS_PNG_LIBRARY, SK_HAS_WEBP_LIBRARY.
     * Returns `nil` if `Image` contents are not encoded.
     * - Returns: encoded `Image`, or `nil`
     */
    public var encodedData : SKData {
        get {
            SKData (handle: sk_image_ref_encoded(handle))
        }
    }

    /**
     * Creates `Shader` from `Image`. `Shader` dimensions are taken from `Image`. `Shader` uses
     * transforming `Image` before `Canvas` matrix is applied.
     * - Parameter tileX: tiling in the x direction
     * - Parameter tileY: tiling in the y direction
     * - Returns: `Shader` containing `Image`
     */
    public func toShader (tileX: ShaderTileMode, tileY: ShaderTileMode) -> Shader
    {
        Shader (handle: sk_image_make_shader(handle, tileX.toNative(), tileY.toNative(), nil))
    }
    
    /**
     * Creates `Shader` from `Image`. `Shader` dimensions are taken from `Image`. `Shader` uses
     * `TileMode` rules to fill drawn area outside `Image`. localMatrix permits
     * transforming `Image` before `Canvas` matrix is applied.
     * - Parameter tileX: tiling in the x direction
     * - Parameter tileY: tiling in the y direction
     * - Parameter localMatrix: `Image` transformation, or `nil`
     * - Returns: `Shader` containing `Image`
     */
    public func toShader (tileX: ShaderTileMode, tileY: ShaderTileMode, localMatrix: Matrix) -> Shader
    {
        var lm = localMatrix.toNative()
        return Shader (handle: sk_image_make_shader(handle, tileX.toNative(), tileY.toNative(), &lm))
    }

    /**
     * Copies `Image` pixel address, row bytes, and `ImageInfo` to pixmap, if address
     * is available, and returns true. If pixel address is not available, return
     * false and leave pixmap unchanged.
     * - Parameter pixmap: storage for pixel state if pixels are readable; otherwise, ignored
     * - Returns: true if `Image` has direct access to pixels
     */
    public func peekPixels (pixmap: Pixmap) -> Bool {
        sk_image_peek_pixels(handle, pixmap.handle)
    }
    
    /**
     * Returns true the contents of `Image` was created on or uploaded to GPU memory,
     * and is available as a GPU texture.
     * - Returns: true if `Image` is a GPU texture
     */
    public var isTextureBacked: Bool {
        get {
            sk_image_is_texture_backed(handle)
        }
    }
    
    /**
     * Returns true if `Image` is backed by an image-generator or other service that creates
     * and caches its pixels or texture on-demand.
     * - Returns: true if `Image` is created as needed
     */
    public var isLazyGenerated: Bool {
        get {
            sk_image_is_lazy_generated(handle)
        }
    }
    
    ///
    /// CachingHint selects whether `ia` may internally cache `Bitmap` generated by
    /// decoding `Image`, or by copying `Image` from GPU to CPU. The default behavior
    /// allows caching `Bitmap`.
    ///
    /// Choose kDisallow_CachingHint if `Image` pixels are to be used only once, or
    /// if `Image` pixels reside in a cache outside of `ia`, or to reduce memory pressure.
    ///
    /// Choosing kAllow_CachingHint does not ensure that pixels will be cached.
    /// `Image` pixels may not be cached if memory requirements are too large or
    /// pixels are not accessible.
    ///
    public enum CachingHint : UInt32 {
        /// allows internally caching decoded and copied pixels
        case allow = 0
        /// disallows internally caching decoded and copied pixels
        case disallow

        internal func toNative () -> sk_image_caching_hint_t
        {
            return sk_image_caching_hint_t(rawValue: rawValue)
        }
        
        internal static func fromNative (_ x: sk_image_caching_hint_t) -> CachingHint
        {
            return CachingHint.init (rawValue: x.rawValue)!
        }

    }
    
    /**
     * Copies `Rect` of pixels from `Image` to dstPixels. Copy starts at offset (srcX, srcY),
     * and does not exceed `Image` (width(), height()).
     * dstInfo specifies width, height, `ColorType`, `AlphaType`, and `ColorSpace` of
     * destination. dstRowBytes specifies the gap from one destination row to the next.
     * Returns true if pixels are copied. Returns false if:
     * - dstInfo.addr() equals `nil`
     * - dstRowBytes is less than dstInfo.minRowBytes()
     * - `PixelRef` is `nil`
     * Pixels are copied only if pixel conversion is possible. If `Image` `ColorType` is
     * `.gray8`, or `.alpha8`; dstInfo.colorType() must match.
     * If `Image` `ColorType` is `.gray8`, dstInfo.colorSpace() must match.
     * If `Image` `AlphaType` is `.opaque`, dstInfo.alphaType() must
     * match. If `Image` `ColorSpace` is `nil`, `dstInfo.colorSpace` must match. Returns
     * false if pixel conversion is not possible.
     * `srcX` and `srcY` may be negative to copy only top or left of source. Returns
     * false if `width` or `height` is zero or negative.
     * Returns false if abs(srcX) >= Image width(), or if abs(srcY) >= Image height().
     * If cachingHint is `.allow`, pixels may be retained locally.
     * If cachingHint is `.disallow`, pixels are not added to the local cache.
     * - Parameter dstInfo: destination width, height, `ColorType`, `AlphaType`, `ColorSpace`
     * - Parameter dstPixels: destination pixel storage
     * - Parameter dstRowBytes: destination row length
     * - Parameter srcX: column index whose absolute value is less than `width`
     * - Parameter srcY: row index whose absolute value is less than `height`
     * - Parameter cachingHint: defaults to `.allow`
     * - Returns: true if pixels are copied to dstPixels
     */
    public func readPixels (dstInfo: ImageInfo, dstPixels: UnsafeMutableRawPointer, dstRowBytes: Int, srcX: Int32, srcY: Int32, cachingHint: CachingHint = .allow) -> Bool
    {
        var di = dstInfo.toNative()
        return sk_image_read_pixels(handle, &di, dstPixels, dstRowBytes, srcX, srcY, cachingHint.toNative())
    }
    
    /**
     * Copies a `Rect` of pixels from `Image` to dst. Copy starts at (srcX, srcY), and
     * does not exceed `Image` (width, height).
     * dst specifies width, height, `ColorType`, `AlphaType`, `ColorSpace`, pixel storage,
     * and row bytes of destination. dst.rowBytes() specifics the gap from one destination
     * row to the next. Returns true if pixels are copied. Returns false if:
     * - dst pixel storage equals `nil`
     * - dst.rowBytes is less than `ImageInfo`::minRowBytes
     * - `PixelRef` is `nil`
     * Pixels are copied only if pixel conversion is possible. If `Image` `ColorType` is
     * `.gray8`, or `.alpha8`; dstInfo.colorType() must match.
     * If `Image` `ColorType` is `.gray8`, dstInfo.colorSpace() must match.
     * If `Image` `AlphaType` is `.opaque`, dstInfo.alphaType() must
     * match. If `Image` `ColorSpace` is `nil`, `dstInfo.colorSpace` must match. Returns
     * false if pixel conversion is not possible.
     * `srcX` and `srcY` may be negative to copy only top or left of source. Returns
     * false if `width` or `height` is zero or negative.
     * Returns false if abs(srcX) >= Image width(), or if abs(srcY) >= Image height().
     * If cachingHint is `.allow`, pixels may be retained locally.
     * If cachingHint is `.disallow`, pixels are not added to the local cache.
     * - Parameter dst: destination `Pixmap`: `ImageInfo`, pixels, row bytes
     * - Parameter srcX: column index whose absolute value is less than `width`
     * - Parameter srcY: row index whose absolute value is less than `height`
     * - Parameter cachingHint: defaults to `.allow`
     * - Returns: true if pixels are copied to dst
     */
    public func readPixels (pixmap: Pixmap, srcX: Int32, srcY: Int32, cachingHint: CachingHint = .allow) -> Bool
    {
        return sk_image_read_pixels_into_pixmap(handle, pixmap.handle, srcX, srcY, cachingHint.toNative())
    }
    
    /**
     * Copies `Image` to dst, scaling pixels to fit dst.width() and dst.height(), and
     * converting pixels to match dst.colorType() and dst.alphaType(). Returns true if
     * pixels are copied. Returns false if dst.addr() is `nil`, or dst.rowBytes() is
     * less than dst `ImageInfo`::minRowBytes.
     * Pixels are copied only if pixel conversion is possible. If `Image` `ColorType` is
     * `.gray8`, or `.alpha8`; dstInfo.colorType() must match.
     * If `Image` `ColorType` is `.gray8`, dstInfo.colorSpace() must match.
     * If `Image` `AlphaType` is `.opaque`, dstInfo.alphaType() must
     * match. If `Image` `ColorSpace` is `nil`, `dstInfo.colorSpace` must match. Returns
     * false if pixel conversion is not possible.
     * Scales the image, with `quality`, to match dst.width() and dst.height().
     * filterQuality kNone_`FilterQuality` is fastest, typically implemented with
     * nearest neighbor filter. kLow_`FilterQuality` is typically implemented with
     * bilerp filter. kMedium_`FilterQuality` is typically implemented with
     * bilerp filter, and mip-map filter when size is reduced.
     * kHigh_`FilterQuality` is slowest, typically implemented with bicubic filter.
     * If cachingHint is kAllow_CachingHint, pixels may be retained locally.
     * If cachingHint is kDisallow_CachingHint, pixels are not added to the local cache.
     * - Parameter dst: destination `Pixmap`: `ImageInfo`, pixels, row bytes
     * - Parameter `quality`: the desired quality for the output
     * - Parameter cachingHint: defaults to `.allow`
     * - Returns: true if pixels are scaled to fit dst
     */
    public func scalePixels (dest: Pixmap, quality: FilterQuality, cachingHint: CachingHint = .allow) -> Bool
    {
        sk_image_scale_pixels(handle, dest.handle, quality.toNative(), cachingHint.toNative())
    }
    
    /**
     * Returns subset of `Image`. subset must be fully contained by `Image` dimensions().
     * The implementation may share pixels, or may copy them.
     * Returns `nil` if subset is empty, or subset is not contained by bounds, or
     * pixels in `Image` could not be read or copied.
     * - Parameter subset: bounds of returned `Image`
     * - Returns: partial or full `Image`, or `nil`
     */
    public func subset (_ subset: IRect) -> Image? {
        var r = subset
        if let x = sk_image_make_subset(handle, &r) {
            return Image (handle: x)
        } else {
            return nil
        }
    }
    
    /// Returns a raster-based image of the current image.
    public func toRasterImage () -> Image {
        return Image (handle: sk_image_make_non_texture_image(handle))
    }
    
//    public func applyImageFilter (_ filter: ImageFilter, subset: IRect, clipBounds: IRect) -> (Image, IRect, Point)?
//    {
//        var s = subset.toNative()
//        var c = clipBounds.toNative()
//        var outsub = sk_irect_t ()
//        var outoffset = sk_ipoint_t ()
//        
//        if let x = sk_image_make_with_filter(handle, filter.handle, &s, &c, &outsub, &outoffset) {
//            return (Image (handle: x), IRect.fromNative (outsub), IPoint.fromNative (outoffset))
//        }
//    }
    
    //sk_image_is_valid
    //sk_image_make_raster_image
    //sk_image_make_texture_image
    //sk_image_new_from_adopted_texture
    //sk_image_new_from_picture
    //sk_image_new_from_texture
    //sk_image_new_raster_copy
    //sk_image_new_raster_copy_with_pixmap
    //sk_image_ref

}
