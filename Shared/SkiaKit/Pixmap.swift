//
//  Pixmap.swift
//  SkiaKit
//
//  Created by Miguel de Icaza on 10/28/19.
//

import Foundation

public class Pixmap {
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
    
    public init ()
    {
        handle = sk_pixmap_new()
        owns = true
    }
    
    public init (info: ImageInfo, addr: UnsafeMutableRawPointer)
    {
        var cinfo = info.toNative()
        handle = sk_pixmap_new_with_params(&cinfo, addr, info.rowBytes)
        owns = true
    }
    
    public init (info: ImageInfo, addr: UnsafeMutableRawPointer, rowBytes: Int)
    {
        var cinfo = info.toNative()
        handle = sk_pixmap_new_with_params(&cinfo, addr, rowBytes)
        owns = true
    }
    
    public func reset ()
    {
        sk_pixmap_reset(handle)
    }
    
    public func reset (info: ImageInfo, addr: UnsafeMutableRawPointer, rowBytes: Int)
    {
        var cinfo = info.toNative()
        sk_pixmap_reset_with_params (handle, &cinfo, addr, rowBytes);
    }
    
    public var info: ImageInfo {
        get {
            var info: sk_imageinfo_t = sk_imageinfo_t()
            
            sk_pixmap_get_info(handle, &info)
            return ImageInfo.fromNative (info)
        }
    }
    
    public var rect: IRect {
        get {
            let i = info
            return IRect (left: 0, top: 0, right: i.width, bottom: i.height)
        }
    }
    
    public var rowBytes : Int {
        get {
            sk_pixmap_get_row_bytes(handle)
        }
    }
    
    public var pixels : UnsafeRawPointer {
        get {
            sk_pixmap_get_pixels(handle)
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
    
    public func readPixels (dstInfo: ImageInfo, dstPixels: UnsafeMutableRawPointer, dstRowBytes: Int, srcX: Int32 = 0, srcY: Int32 = 0, behavior: TransferFunctionBehavior = .respect) -> Bool
    {
        var cinfo = dstInfo.toNative()
        return sk_pixmap_read_pixels(handle, &cinfo, dstPixels, dstRowBytes, srcX, srcY, behavior.toNative ())
    }
    
    public func readPixels (into: Pixmap, srcX: Int32 = 0, srcY: Int32 = 0) -> Bool
    {
        readPixels(dstInfo: into.info, dstPixels: UnsafeMutableRawPointer (mutating: into.pixels), dstRowBytes: into.rowBytes, srcX: srcX, srcY: srcY, behavior: .respect)
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
    public func encode (encoder: EncodedImageFormat, quality: Int32) -> Data?
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
        var ir = subset.toNative()
        return sk_pixmap_extract_subset(handle, into.handle, &ir)
    }

    public func erase (_ color: Color)
    {
        erase (color, rect)
    }
    
    public func erase (_ color: Color, _ rect: IRect)
    {
        var r = rect.toNative()
        sk_pixmap_erase_color(handle, color.color, &r)
    }
}
