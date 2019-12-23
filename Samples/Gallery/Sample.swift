//
//  Sample.swift
//  SkiaSamplesiOS
//
//  Created by Miguel de Icaza on 10/27/19.
//

import Foundation
import SkiaKit

protocol Sample {
    init ()
    
    static var title: String { get }
    //var category: String { get } =
    func draw (canvas: Canvas, width: Int32, height: Int32)
}

#if canImport(SwiftUI) && canImport(UIKit)

import SwiftUI

struct SampleRender : UIViewRepresentable {
    var sample: Sample
    init (_ sample: Sample)
    {
        self.sample = sample
    }
    
    func updateUIView(_ uiView: SkiaView, context: UIViewRepresentableContext<SampleRender>) {
        uiView.setNeedsDisplay ()
    }
    
    func makeUIView (context: Context) -> SkiaView
    {
        let sv = SkiaView ()
        sv.drawingCallback = draw

        return sv
    }
    
    func draw (surface: Surface, info: ImageInfo)
    {
        sample.draw (canvas: surface.canvas, width: info.width, height: info.height)
    }
}

struct sampleDraw : Sample {
    static var title = "Green text on aqua background"
    
    func draw (canvas: Canvas, width: Int32, height: Int32)
    {
        canvas.clear (color: Colors.aqua)
        let paint = Paint()
        paint.textSize = 64
        canvas.drawText (text: "text", x: 150, y: 175, paint: paint)
        paint.strokeWidth = 10
        paint.color = Colors.green
        paint.style = .stroke
        canvas.drawRect(Rect(left: 0, top: 0, right: Float(width), bottom: Float(height)), paint)
    }
}

#endif // canImport(SwiftUI) && canImport(UIKit)
