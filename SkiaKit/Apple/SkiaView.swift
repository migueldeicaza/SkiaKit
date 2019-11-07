//
//  SkiaView.swift
//  SkiaKit
//
//  Created by Miguel de Icaza on 10/26/19.
//

import Foundation
import UIKit

/**
 * `SkiaView` is a UIView that you can add to your programs that can render some Skia content for you.
 * To do this, create an instance of this class, and then set the `drawingCallback` property to point
 * to a function that takes a `Surface` and an `ImageInfo` as parameter, and this will be called when
 * the view needs to render itself.
 *
 * You can set the `ignorePixelScaling` to ignore the built-in scaling that uses the `UIView`'s
 * `contentScaleFactor`
 */
public class SkiaView: UIView {
    /// This property when set points to the method to invoke when drawing.   The  method
    /// receives a surface and the ImageInfo where it should draw its contents.
    public var drawingCallback: (_ surface: Surface, _ imageInfo: ImageInfo) -> () = emptyCallback(surface:imageInfo:)
    
    static func emptyCallback (surface: Surface, imageInfo: ImageInfo)
    {
        // Does nothing
    }

    /// If true, this will ignore the pixel scaling of the device, otherwise some virtual pixels might use the number of physical pixels specified in the system
    public var ignorePixelScaling: Bool = false {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
    }
    
    required init? (coder: NSCoder)
    {
        super.init (coder: coder)
    }
    
    override public func draw(_ rect: CGRect) {
        super.draw (rect)
        
        // Create the Skia Context
        let scale = ignorePixelScaling ? 1 : contentScaleFactor
        let info = ImageInfo(width: Int32 (bounds.width * scale), height: Int32 (bounds.height * scale), colorType: .bgra8888, alphaType: .premul)
        if info.width == 0 || info.height == 0 {
            return
        }

        if let bitmapData = malloc(info.bytesSize) {
            guard let surface = Surface.make (info, bitmapData, info.rowBytes) else {
                free (bitmapData)
                return
            }
            drawingCallback (surface, info)
            surface.canvas.flush ()
            
            guard let dataProvider = CGDataProvider(dataInfo: nil, data: bitmapData, size: info.bytesSize, releaseData: {ctx, ptr, size in }) else {

                free(bitmapData)
                return
            }
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue).union(.byteOrder32Little)
            if let image = CGImage(width: Int(info.width), height: Int(info.height), bitsPerComponent: 8, bitsPerPixel: Int(info.bytesPerPixel*8), bytesPerRow: info.rowBytes, space: colorSpace, bitmapInfo: bitmapInfo, provider: dataProvider, decode: nil, shouldInterpolate: false, intent: .defaultIntent) {
                if let ctx = UIGraphicsGetCurrentContext() {
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
            free (bitmapData)
        }
    }
}
