//
//  File.swift
//  SkiaSamplesiOS
//
//  Created by Miguel de Icaza on 11/8/19.
//

import Foundation
import SkiaKit

struct fractalPerlinNoiseShaderSample : Sample {
    static var title = "Fractal Perlin Noise Shader"
    
    public func draw(canvas: Canvas, width: Int32, height: Int32) {
        canvas.clear(color: Colors.white)

        let paint = Paint()
        paint.shader = Shader.makePerlinNoiseFractalNoise(baseFrequencyX: 0.05, baseFrequencyY: 0.05, numOctaves: 4, seed: 0)
        canvas.draw(paint)
    }
}


