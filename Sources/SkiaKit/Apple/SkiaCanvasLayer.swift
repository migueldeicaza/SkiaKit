//
//  SkiaCanvasLayer.swift
//  SkiaKit
//
//  Created by Miguel de Icaza on 10/26/19.
//

#if canImport(QuartzCore)

import Foundation
import CoreGraphics
import QuartzCore

public class SkiaLayer : CALayer {
    public var drawingCallback: (_ surface: Surface, _ imageInfo: ImageInfo) -> ()
    
    /// Cache bitmap data until next render or deinit.
    private var oldBitmapData: UnsafeMutableRawPointer? = nil

    static func emptyCallback (surface: Surface, imageInfo: ImageInfo)
    {
        // Does nothing
    }
    
    public override init ()
    {
        ignorePixelScaling = false
        drawingCallback = SkiaLayer.emptyCallback
        super.init ()
        setNeedsDisplay()
        needsDisplayOnBoundsChange = true
    }
    
    public required init? (coder: NSCoder)
    {
        ignorePixelScaling = false
        drawingCallback = SkiaLayer.emptyCallback
        super.init (coder: coder)
    }
    
    deinit {
        if oldBitmapData != nil {
            free (oldBitmapData)
        }
    }
    
    /// If true, this will ignore the pixel scaling of the device, otherwise some virtual pixels might use the number of physical pixels specified in the system
    public var ignorePixelScaling: Bool {
        didSet {
            setNeedsDisplay()
        }
    }
    
    public override func draw(in ctx: CGContext) {
        super.draw(in: ctx)
        
        // Create the Skia Context
        let scale = ignorePixelScaling ? 1 : contentsScale
        let info = ImageInfo(width: Int32 (bounds.width * scale), height: Int32 (bounds.height * scale), colorType: .bgra8888, alphaType: .premul)
        if info.width == 0 || info.height == 0 {
            return
        }
        
        if oldBitmapData != nil {
            free (oldBitmapData)
        }
        guard let bitmapData = malloc(info.bytesSize) else {
            return
        }
        // Store so we don't free early.
        oldBitmapData = bitmapData

        guard let surface = Surface.make (info, bitmapData, info.rowBytes)  else {
            return
        }
        drawingCallback (surface, info)
        surface.canvas.flush ()
        
        guard let dataProvider = CGDataProvider(dataInfo: nil, data: bitmapData, size: info.bytesSize, releaseData: {ctx, ptr, size in }) else {
            return
        }
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue).union(.byteOrder32Little)
        if let image = CGImage(width: Int(info.width), height: Int(info.height), bitsPerComponent: 8, bitsPerPixel: Int(info.bytesPerPixel*8), bytesPerRow: info.rowBytes, space: colorSpace, bitmapInfo: bitmapInfo, provider: dataProvider, decode: nil, shouldInterpolate: false, intent: .defaultIntent) {
#if os(OSX)
            ctx.draw(image, in: bounds)
#else
            // in iOS, WatchOS and tvOS we need to flip the image on
            // https://developer.apple.com/library/ios/documentation/2DDrawing/Conceptual/DrawingPrintingiOS/GraphicsDrawingOverview/GraphicsDrawingOverview.html#//apple_ref/doc/uid/TP40010156-CH14-SW26
            ctx.saveGState()
            ctx.translateBy(x: 0, y: bounds.height)
            ctx.scaleBy(x: 1, y: -1)
            ctx.draw(image, in: bounds)
            ctx.restoreGState()
#endif
        }
    }
}

#endif