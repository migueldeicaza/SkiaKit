//
//  2DPathSample.swift
//  SkiaSamplesiOS
//
//  Created by Miguel de Icaza on 11/8/19.
//

import Foundation
import SkiaKit

struct TwoDPathSample: Sample {
    static var title = "2D Path Effect"
    
    public func draw(canvas: Canvas, width: Int32, height: Int32) {
        //let fwidth = Float(width)
        //let fheight = Float (height)
        
        canvas.clear(color: Colors.white)

        let blockSize : Float = 30

        // create the path
        let path = SkiaKit.Path()
        // the rect must be offset as the path uses the center
        let rect = Rect(x: blockSize / -2, y: blockSize / -2, width: blockSize, height: blockSize);
        path.addRect(rect)

        // move the path around: across 1 block
        var offsetMatrix = Matrix.makeScale(sx: 2 * blockSize, sy: blockSize);
        // each row, move across a bit / offset
        let skew = Matrix.makeSkew (sx: 0.5, sy: 0)
        Matrix.preConcat(target: &offsetMatrix, matrix: skew)

        // create the paint
        let paint = Paint ()
    
        paint.pathEffect = PathEffect.make2DPath(matrix: &offsetMatrix, path: path)
        paint.color = Colors.lightGray

        // draw a rectangle
        //canvas.drawRect(Rect(width: fwidth + blockSize, height: fheight + blockSize), paint)
        canvas.drawRect(Rect (left: 100, top: 100, right: 200, bottom: 200), paint)
        
        let paint2 = Paint ()
        paint2.color = Colors.blue
        canvas.drawRect(Rect (left: 400, top: 400, right: 200, bottom: 200), paint2)
    }
}
