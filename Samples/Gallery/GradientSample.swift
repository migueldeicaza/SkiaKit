//
//  File.swift
//  SkiaSamplesiOS
//
//  Created by Miguel de Icaza on 11/8/19.
//

import Foundation
import SkiaKit

struct gradientSample: Sample {
    static var title = "Gradient"
    
    public func draw(canvas: Canvas, width: Int32, height: Int32) {
        let ltColor = Colors.white
        let dkColor = Colors.black

        var paint = Paint()
        paint.isAntialias = true
        let shader = Shader.makeLinearGradient(start: Point(x: 0, y: 0), end: Point(x:0, y: Float (height)), colors: [ltColor, dkColor], colorPos: nil, mode: .clamp)
        paint.shader = shader
        canvas.draw(paint)
        
        // Center and Scale the Surface
        let scale = (width < height ? width : height) / (240);
        canvas.translate(dx: Float (width) / 2, dy: Float (height) / 2);
        canvas.scale(Float (scale))
        canvas.translate(dx: -128, dy: -128);

        paint = Paint()
        paint.isAntialias = true
        if let shader = Shader.makeTwoPointConicalGradient(start: Point(x: 115.2, y:102.4), startRadius: 25.6, end: Point(x:102.4, y: 102.4), endRadius: 128, colors: [ltColor, dkColor], colorPos: nil, mode: .clamp) {
            paint.shader = shader
        
            canvas.drawOval(Rect(left: 51.2, top: 51.2, right: 204.8, bottom: 204.8), paint: paint)
        }
    }
}
