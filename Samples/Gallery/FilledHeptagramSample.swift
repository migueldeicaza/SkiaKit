//
//  FilledHeptagramSample.swift
//  SkiaSamplesiOS
//
//  Created by Miguel de Icaza on 11/8/19.
//

import Foundation
import SkiaKit

struct filledHeptagramSample : Sample {
    static var title = "Filled Heptagram"
    
    func draw(canvas: Canvas, width: Int32, height: Int32) {
        let size = Float (height > width ? width : height) * 0.75
        let R = 0.45 * size
        let TAU = Float (6.2831853)

        let path = SkiaKit.Path()
        path.moveTo(R, 0)
        
        for i in 1..<7 {
            let theta = 3.0 * Float (i) * TAU / 7
            path.lineTo(R * cos(theta), R * sin(theta))
        }
        path.close ()

        let paint = Paint ()
        paint.isAntialias = true
        
    
        canvas.clear(color: Colors.white)
        canvas.translate(dx: Float (width / 2), dy: Float (height / 2))
        canvas.drawPath(path, paint)
    }
}
