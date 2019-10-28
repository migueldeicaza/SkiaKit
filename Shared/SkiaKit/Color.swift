//
//  Color.swift
//  SkiaKit
//
//  Created by Miguel de Icaza on 10/17/19.
//  Copyright © 2019 Miguel de Icaza. All rights reserved.
//

import Foundation

public struct Color : Equatable {
    var color : UInt32
    
    public init (_ value: UInt32)
    {
        color = value
    }
    
    public init (r: UInt8, g: UInt8, b: UInt8, a: UInt8 = 0xff)
    {
        color = ((UInt32(a) << 24) | (UInt32(r) << 16) | (UInt32(g) << 8) | UInt32 (b))
    }
    
    public init (hue: Float, saturation: Float, lightness: Float, alpha: UInt8 = 0xff)
    {
        // convert from percentages
        let h = hue / 360.0
        let s = saturation / 100.0
        let l = lightness / 100.0

        // RGB results from 0 to 255
        var r = l * 255.0
        var g = l * 255.0
        var b = l * 255.0

        // HSL from 0 to 1
        if (fabsf (s) > 0.001) {
            var v2 : Float
            if l < 0.5 {
                v2 = l * (1.0 + s);
            } else {
                v2 = (l + s) - (s * l)
            }
            let v1 = 2.0 * l - v2

            r = 255 * Color.hueToRgb (v1, v2, h + (1.0 / 3.0))
            g = 255 * Color.hueToRgb (v1, v2, h)
            b = 255 * Color.hueToRgb (v1, v2, h - (1.0 / 3.0))
        }

        color = (UInt32)((alpha << 24) | (UInt8 (r) << 16) | (UInt8(g) << 8) | UInt8(b))
    }
    
    static func hueToRgb (_ v1: Float, _ v2: Float, _ vh: Float) -> Float
    {
        var vH = vh
        if vH < 0 {
            vH = vH + 1
        }
        if vH > 1 {
            vH = vH - 1
        }
            
        if (6 * vH) < 1 {
            return v1 + (v2 - v1) * 6 * vH
        }
        if (2 * vH) < 1 {
            return v2
        }
        if (3 * vH) < 2 {
            return v1 + (v2 - v1) * ((2.0 / 3.0) - vH) * 6
        }
        return v1
    }
    
    public var alpha : UInt8 {
        get {
            (UInt8)((color >> 24) & 0xff)
        }
    }
    
    public var red : UInt8 {
        get {
            (UInt8)((color >> 16) & 0xff)
        }
    }
    
    public var green : UInt8 {
        get {
            (UInt8)((color >> 8) & 0xff)
        }
    }
    
    public var blue : UInt8 {
        get {
            (UInt8)(color  & 0xff)
        }
    }
}
