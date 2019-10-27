//
//  SKBitmap.swift
//  SkiaKit
//
//  Created by Miguel de Icaza on 10/15/19.
//  Copyright © 2019 Miguel de Icaza. All rights reserved.
//

import Foundation

public enum BitmapError : Error {
    case outOfMemory
}
public class Bitmap {
    var handle : OpaquePointer
    
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
    
    public var rowBytes : Int {
        get {
            return Int (sk_bitmap_get_row_bytes(handle))
        }
    }
    
    public func tryAllocPixels (info: sk_imageinfo_t, rowBytes: Int? = nil) -> Bool
    {
        withUnsafePointer(to: info) { ptr in
            sk_bitmap_try_alloc_pixels(handle, ptr, rowBytes == nil ? self.rowBytes : rowBytes!)
        }
    }
    
    public func reset ()
    {
        sk_bitmap_reset(handle)
    }
    
    public func setImmutable ()
    {
        sk_bitmap_set_immutable(handle)
    }
    
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
    
    // TODO: CopyTo
    
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

    //public func getPixels () -> [Color]
    //{
    //    var ret = Array<color>.init(unsafeUninitializedCapacity: Int(width) * Int(height)) { ptr,arg  in }
    //    sk_bitmap_get_pixel_colors(handle, ret)
    //    return ret
    //}
}
