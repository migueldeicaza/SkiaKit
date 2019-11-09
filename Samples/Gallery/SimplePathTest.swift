//
//  SimplePathTest.swift
//  SkiaSamplesiOS
//
//  Created by Miguel de Icaza on 11/8/19.
//

import Foundation
import SkiaKit

struct sampleTest : Sample {
    static var title = "Simple Path Test"
    
    func draw (canvas: Canvas, width: Int32, height: Int32)
    {
        let paint = Paint ()
        
        paint.isAntialias = true
        paint.color = Colors.yellow
        paint.strokeCap = .round
        paint.strokeWidth = 5
        paint.isStroke = true
        
        canvas.draw (paint)

        var path = SkiaKit.Path()
        
        path.moveTo (0, 0)
        path.lineTo (Float (width), Float (height))
    
        path.close()

        paint.color = Colors.black
        canvas.drawPath (path, paint)

        path = Path()
        
        path.close()

        paint.color = Colors.white
        canvas.drawPath(path, paint)
        
        let pp = Paint ()
        pp.style = .fill
        pp.color = Colors.blue
        canvas.drawCircle(Float(width)/2, Float(height)/2, 100, pp)

        pp.style = .stroke
        pp.color = Colors.red
        pp.strokeWidth = 25
        canvas.drawCircle(Float(width)/2, Float(height)/2, 100, pp)
        
    }
}
