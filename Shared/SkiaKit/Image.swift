//
//  Image.swift
//  SkiaKit
//
//  Created by Miguel de Icaza on 10/18/19.
//  Copyright © 2019 Miguel de Icaza. All rights reserved.
//

import Foundation

/**
 * `Image` describes a two dimensional array of pixels to draw. The pixels may be
 * decoded in a raster bitmap, encoded in a `Picture` or compressed data stream,
 * or located in GPU memory as a GPU texture.
 * `Image` cannot be modified after it is created. `Image` may allocate additional
 * storage as needed; for instance, an encoded `Image` may decode when drawn.
 * `Image` width and height are greater than zero. Creating an `Image` with zero width
 * or height returns `Image` equal to `nil`.
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
    
    public init (_ bitmap: Bitmap)
    {
        handle = sk_image_new_from_bitmap(bitmap.handle)
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
}
