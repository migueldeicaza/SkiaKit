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
}
