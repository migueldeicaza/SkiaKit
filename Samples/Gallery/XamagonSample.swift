//
//  XamagonSample.swift
//  SkiaSamplesiOS
//
//  Created by Miguel de Icaza on 10/27/19.
//

import Foundation
import SkiaKit

struct sampleXamagon : Sample {
    static var title = "Xamagon"
    
    func draw (canvas: Canvas, width: Int32, height: Int32)
    {
        // Width 41.6587026 => 144.34135
        // Height 56 => 147

        let paddingFactor : Float = 0.6
        let imageLeft : Float = 41.6587026
        let imageRight : Float = 144.34135
        let imageTop : Float = 56
        let imageBottom : Float = 147

        let imageWidth = imageRight - imageLeft

        let scale = (Float ((height > width ? width : height)) / imageWidth) * paddingFactor

        var translateX = ((imageLeft + imageRight) / -2.0)
        translateX = translateX + (Float (width) / (scale * 0.5))
        var translateY = ((imageBottom + imageTop) / -2.0)
        translateY = translateY + (Float (height) / (scale * 0.5))

        canvas.scale (scale)
        canvas.translate (dx: translateX, dy: translateY)

        let paint = Paint ()
        
        paint.isAntialias = true
        paint.color = Colors.white
        paint.strokeCap = .round

        canvas.draw (paint)

        var path = SkiaKit.Path()
        
        path.moveTo (71.4311121, 56)
        path.cubicTo(68.6763107, 56.0058575, 65.9796704, 57.5737917, 64.5928855, 59.965729)
        path.lineTo(43.0238921, 97.5342563)
        path.cubicTo(41.6587026, 99.9325978, 41.6587026, 103.067402, 43.0238921, 105.465744)
        path.lineTo(64.5928855, 143.034271)
        path.cubicTo(65.9798162, 145.426228, 68.6763107, 146.994582, 71.4311121, 147)
        path.lineTo(114.568946, 147)
        path.cubicTo(117.323748, 146.994143, 120.020241, 145.426228, 121.407172, 143.034271)
        path.lineTo(142.976161, 105.465744)
        path.cubicTo(144.34135, 103.067402, 144.341209, 99.9325978, 142.976161, 97.5342563)
        path.lineTo(121.407172, 59.965729)
        path.cubicTo(120.020241, 57.5737917, 117.323748, 56.0054182, 114.568946, 56)
        path.lineTo(71.4311121, 56)
        path.close()

        paint.color = Colors.darkBlue
        canvas.drawPath (path, paint)

        path = Path()
        path.moveTo (71.8225901, 77.9780432)
        path.cubicTo(71.8818491, 77.9721857, 71.9440029, 77.9721857, 72.0034464, 77.9780432)
        path.lineTo(79.444074, 77.9780432)
        path.cubicTo(79.773437, 77.9848769, 80.0929203, 78.1757336, 80.2573978, 78.4623994)
        path.lineTo(92.8795281, 101.015639)
        path.cubicTo(92.9430615, 101.127146, 92.9839987, 101.251384, 92.9995323, 101.378901)
        path.cubicTo(93.0150756, 101.251354, 93.055974, 101.127107, 93.1195365, 101.015639)
        path.lineTo(105.711456, 78.4623994)
        path.cubicTo(105.881153, 78.167045, 106.215602, 77.975134, 106.554853, 77.9780432)
        path.lineTo(113.995483, 77.9780432)
        path.cubicTo(114.654359, 77.9839007, 115.147775, 78.8160066, 114.839019, 79.4008677)
        path.lineTo(102.518299, 101.500005)
        path.lineTo(114.839019, 123.568869)
        path.cubicTo(115.176999, 124.157088, 114.671442, 125.027775, 113.995483, 125.021957)
        path.lineTo(106.554853, 125.021957)
        path.cubicTo(106.209673, 125.019028, 105.873247, 124.81384, 105.711456, 124.507327)
        path.lineTo(93.1195365, 101.954088)
        path.cubicTo(93.0560031, 101.84258, 93.0150659, 101.718333, 92.9995323, 101.590825)
        path.cubicTo(92.983989, 101.718363, 92.9430906, 101.842629, 92.8795281, 101.954088)
        path.lineTo(80.2573978, 124.507327)
        path.cubicTo(80.1004103, 124.805171, 79.7792269, 125.008397, 79.444074, 125.021957)
        path.lineTo(72.0034464, 125.021957)
        path.cubicTo(71.3274867, 125.027814, 70.8220664, 124.157088, 71.1600463, 123.568869)
        path.lineTo(83.4807624, 101.500005)
        path.lineTo(71.1600463, 79.400867)
        path.cubicTo(70.8647037, 78.86725, 71.2250368, 78.0919422, 71.8225901, 77.9780432)
        path.lineTo(71.8225901, 77.9780432)
        path.close()

        paint.color = Colors.white
        canvas.drawPath(path, paint)
    }
}
