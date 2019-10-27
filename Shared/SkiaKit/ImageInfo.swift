//
//  SKImageInfo.swift
//  SkiaKit
//
//  Created by Miguel de Icaza on 10/16/19.
//  Copyright © 2019 Miguel de Icaza. All rights reserved.
//

import Foundation

public struct ImageInfo {
    public var width : Int32
    public var height: Int32
    public var colorType : ColorType
    public var alphaType : AlphaType
    public var colorSpace : ColorSpace?
    
    public init (width: Int32, height: Int32, colorType: ColorType, alphaType: AlphaType)
    {
        self.width = width
        self.height = height
        self.colorType = colorType
        self.alphaType = alphaType
    }
    
    public init (_ width: Int32, _ height: Int32)
    {
        self.width = width
        self.height = height
        self.colorType = ImageInfo.platformColorType ()
        self.alphaType = .premul
    }
    
    static func platformColorType () -> ColorType
    {
        ColorType.fromNative (sk_colortype_get_default_8888())
    }
    
    func toNative () -> sk_imageinfo_t
    {
        let cs = colorSpace != nil ? colorSpace!.handle : OpaquePointer(bitPattern: 0)
        return sk_imageinfo_t (
               colorspace: cs ,
                    width: width,
                   height: height,
                colorType: colorType.toNative(),
                alphaType: alphaType.toNative())
    }
    
    public var bytesPerPixel : Int32 {
        get {
            switch colorType {
            case .unknown:
                return 0
            case .alpha8, .gray8:
                return 1
            case .rgb565, .argb4444:
                return 2
            case .bgra8888, .rgb101010x, .rgba1010102, .rgb888x, .rgba8888:
                return 4
            case .rgbaF16:
                return 8
            }
        }
    }
    
    public var bitsPerPixel : Int32 {
        get {
            bytesPerPixel * 8
        }
    }
    
    public var bytesSize: Int {
        get {
            Int(width) * Int(height) * Int(bytesPerPixel)
        }
    }
    
    public var rowBytes: Int {
        get {
            Int(width) * Int(bytesPerPixel)
        }
    }
    
    public var isEmpty: Bool {
        get {
            width <= 0 || height <= 0
        }
    }
    
    public var isOpaque: Bool {
        get {
            alphaType == .opaque
        }
    }
    
    
}
