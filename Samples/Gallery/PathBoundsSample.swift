//
//  PathBoundsSample.swift
//  SkiaSamplesiOS
//
//  Created by Miguel de Icaza on 10/27/19.
//

import Foundation
import SkiaKit

struct samplePathBounds : Sample {
    static var title: String = "Path bounds"
    
    func draw (canvas: Canvas, width: Int32, height: Int32)
    {
        canvas.clear (color: Colors.white)
        canvas.scale(2)
        
        let paint = Paint ()
        paint.style = .stroke
        paint.strokeWidth = 1
        paint.isAntialias = true
        paint.strokeCap = .round
        
        let textPaint = Paint ()
        textPaint.isAntialias = true
        
        let path = Path ()
        path.move(to: Point(x: -6.2157825e-7, y: -25.814698))
        path.rcubic(to: Point(x: -34.64102137842175, y: 19.9999998), controlPoint1: Point(x:0, y: 40), controlPoint2: Point(x: 0, y: 40))
        path.offset (Point (x: 50, y: 35))
        
        // draw using getbounds
        paint.color = Colors.lightBlue
        canvas.drawPath (path, paint)
        let rect = path.bounds
        
        paint.color = Colors.darkBlue
        canvas.drawRect(rect, paint)
        
        canvas.drawText(text: "Bounds", x: rect.left, y: rect.bottom + paint.textSize + 10, paint: textPaint)
        
        // move for next curve
        path.offset (Point (x: 100, y: 0))
        
        // draw using getTightBounds
        paint.color = Colors.lightBlue
        canvas.drawPath(path, paint)
        
        if let rect = path.getTightBounds() {
            paint.color = Colors.darkBlue
            canvas.drawRect(rect, paint)
            canvas.drawText("TightBounds", rect.left, rect.bottom + paint.textSize, paint: textPaint)
        }
    }
}
