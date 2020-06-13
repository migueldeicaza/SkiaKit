//
//  TextSample.swift
//  SkiaSamplesiOS
//
//  Created by Miguel de Icaza on 10/27/19.
//

import Foundation
import SkiaKit

struct sampleText : Sample {
    static var title = "Text"
    
    func draw (canvas: Canvas, width: Int32, height: Int32)
    {
        canvas.drawColor(Colors.white)
        
        var font = Font()
        font.size = 64
        var paint = Paint()
        paint.isAntialias = true
        paint.color = Color (0xff4281a4)
        paint.isStroke = false
        
        canvas.draw (text: "SkiaKit", x: Float (width/2), y: 64, font: font, paint: paint)
        
        paint = Paint()
        paint.isAntialias = true
        paint.color = Color (0xff9cafb7)
        paint.isStroke = true
        paint.strokeWidth = 3
        //paint.textAlign = .center
        
        canvas.draw (text: "SkiaKit", x: Float (width/2), y: 144, font: font, paint: paint)

        paint = Paint()
        
        paint.isAntialias = true
        paint.color = Color (0xffe6b89c)
        font.scaleX = 1.5
        //paint.textAlign = .right
        
        canvas.draw (text: "SkiaKit", x: Float (width/2), y: 224, font: font, paint: paint)

    }
}
