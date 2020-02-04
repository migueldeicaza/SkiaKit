//
//  SKImageInfo.swift
//  SkiaKit
//
//  Created by Miguel de Icaza on 10/16/19.
//  Copyright © 2019 Miguel de Icaza. All rights reserved.
//

import Foundation
import CSkiaSharp

/**
 * Describes pixel dimensions and encoding. `Bitmap`, `Image`, `Pixmap`, and `Surface`
 * can be created from `ImageInfo`. `ImageInfo` can be retrieved from `Bitmap` and
 * `Pixmap`, but not from `Image` and `Surface`. For example, `Image` and `Surface`
 * implementations may defer pixel depth, so may not completely specify `ImageInfo`.
 *
 * `ImageInfo` contains dimensions, the pixel integral width and height. It encodes
 * how pixel bits describe alpha, transparency; color components red, blue,
 * and green; and `ColorSpace`, the range and linearity of colors.
 */
public struct ImageInfo {
    /// Returns pixel count in each row.
    public var width : Int32
    /// Returns pixel row count (height)
    public var height: Int32
    /// Returns the colortype for this ImageInfo
    public var colorType : ColorType
    /// Returns the alpha type
    public var alphaType : AlphaType
    /// Returns SkColorSpace, the range of colors - the returned value is immutable
    public var colorSpace : ColorSpace?
    
    /**
     * Creates `ImageInfo` from integral dimensions width and height, `ColorType`,
     * `AlphaType`, and optionally `ColorSpace.
     *
     * If `ColorSpace` cs is `nil` and `ImageInfo` is part of drawing source: `ColorSpace`
     * defaults to sRGB, mapping into `Surface` `ColorSpace`.
     *
     * Parameters are not validated to see if their values are legal, or that the
     * combination is supported.
     * - Parameter width: pixel column count; must be zero or greater
     * - Parameter height: pixel row count; must be zero or greater
     * - Parameter colorType: the colortype
     * - Parameter alphaType: the alpha type
     * - Parameter colorSpace: range of colors; may be `nil`
     * - Returns: created `ImageInfo`
     */
    public init (width: Int32, height: Int32, colorType: ColorType, alphaType: AlphaType, colorSpace: ColorSpace? = nil)
    {
        self.width = width
        self.height = height
        self.colorType = colorType
        self.alphaType = alphaType
        self.colorSpace = colorSpace
    }
    
    /**
    * Creates `ImageInfo` from integral dimensions width and height
    * The returned imageInfo sets the colorType to the default platform color type (rgb8888)
    * and the `alphaType` is set to `.premul` and the colorspace is set to `nil`
    *
    * Parameters are not validated to see if their values are legal, or that the
    * combination is supported.
    * - Parameter width: pixel column count; must be zero or greater
    * - Parameter height: pixel row count; must be zero or greater
    * - Returns: created `ImageInfo`
    */
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
    
    static func fromNative (_ x: sk_imageinfo_t) -> ImageInfo
    {
        ImageInfo(width: x.width, height: x.height, colorType: ColorType.fromNative (x.colorType), alphaType: AlphaType.fromNative(x.alphaType), colorSpace: x.colorspace == nil ? nil : ColorSpace (handle: x.colorspace))
    }
    
    /// Returns number of bytes per pixel required by the `colorType` (1, 2, 4 or 8 bytes) or zero if the `colorType` is set to `.unknown`
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
    
    /// Number of bits used by the colorType (this is bytesPerPixel multiplied by 8)
    public var bitsPerPixel : Int32 {
        get {
            bytesPerPixel * 8
        }
    }
    
    /// Returns the number of bytes necesary to allocate the image of the `width`x`height` that uses `bytesPerPixel` to store the data.
    public var bytesSize: Int {
        get {
            Int(width) * Int(height) * Int(bytesPerPixel)
        }
    }
    
    /// Returns the number of bytes necessary to store one row of pixels
    public var rowBytes: Int {
        get {
            Int(width) * Int(bytesPerPixel)
        }
    }
    
    /// Returns if ImageInfo describes an empty area of pixels by checking if either `width` or `height` is zero or smaller.
    public var isEmpty: Bool {
        get {
            width <= 0 || height <= 0
        }
    }
    
    /**
     * Returns true if `alphaType` is set to hint that all pixels are opaque; their
     * alpha value is implicitly or explicitly 1.0. If true, and all pixels are
     * not opaque, Skia may draw incorrectly.
     *
     * Does not check if `colorType` allows alpha, or if any pixel value has
     * transparency.
     */
    public var isOpaque: Bool {
        get {
            alphaType == .opaque
        }
    }
    
    /// Returns a new ImageInfo instance that has the width and height changed per the specified parameters
    public func withDimensions (width: Int32, height: Int32) -> ImageInfo
    {
            var copy = self
            copy.width = width
            copy.height = height
            return copy
    }

    /// Returns a new ImageInfo instance that has the colorType changed with the specified parameter
    public func withColorType (_ colorType: ColorType) -> ImageInfo
    {
            var copy = self
            copy.colorType = colorType
            return copy
    }

    /// Returns a new ImageInfo instance that has the colorSpace changed with the specified parameter
    public func withColorSpace (_ colorSpace: ColorSpace? ) -> ImageInfo
    {
            var copy = self
            copy.colorSpace = colorSpace
            return copy
    }

    /// Returns a new ImageInfo instance that has the colorSpace changed with the specified parameter
    public func withAlphaType (_ alphaType: AlphaType) -> ImageInfo
    {
            var copy = self
            copy.alphaType = alphaType
            return copy
    }
}
