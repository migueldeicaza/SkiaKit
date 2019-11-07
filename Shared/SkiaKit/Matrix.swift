//
//  Matrix.swift
//  SkiaKit
//
//  Created by Miguel de Icaza on 10/18/19.
//  Copyright © 2019 Miguel de Icaza. All rights reserved.
//

import Foundation

/**
 * `Matrix` holds a 3x3 matrix for transforming coordinates. This allows mapping
 * `Point` and vectors with translation, scaling, skewing, rotation, and
 * perspective.
 * `Matrix` elements are in row major order. `Matrix` does not have a constructor,
 * so it must be explicitly initialized. setIdentity() initializes `Matrix`
 * so it has no effect. setTranslate(), setScale(), set`ew`(), setRotate(), set9 and setAll()
 * initializes all `Matrix` elements with the corresponding mapping.
 * `Matrix` includes a hidden variable that classifies the type of matrix to
 * improve performance. `Matrix` is not thread safe unless getType() is called first.
 */
public final class Matrix {
    public var scaleX, skewX, transX : Float
    public var scaleY, skewY, transY : Float
    public var persp0, persp1, persp2: Float
    var mask : typeMask
    
    enum typeMask : UInt32 {
        case identity = 0
        case translate = 1
        case scale = 2
        case affine = 4
        case perspective = 8
        case rectStaysRect = 0x10
        case onlyPerspectiveValid = 0x40
        case unknown = 0x80
    }
    
    public init (scaleX: Float, skewX: Float, transX: Float, scaleY: Float, skewY: Float, transY: Float, persp0: Float, persp1: Float, persp2: Float)
    {
        self.scaleX = scaleX
        self.skewX = skewX
        self.transX = transX
        self.scaleY = scaleY
        self.skewY = skewY
        self.transY = transY
        self.persp0 = persp0
        self.persp1 = persp1
        self.persp2 = persp2
        mask = .unknown
    }
    
    init (scaleX: Float, skewX: Float, transX: Float, scaleY: Float, skewY: Float, transY: Float, persp0: Float, persp1: Float, persp2: Float, mask: typeMask)
    {
        self.scaleX = scaleX
        self.skewX = skewX
        self.transX = transX
        self.scaleY = scaleY
        self.skewY = skewY
        self.transY = transY
        self.persp0 = persp0
        self.persp1 = persp1
        self.persp2 = persp2
        self.mask = mask
    }
    
    func toNative () -> sk_matrix_t
    {
        sk_matrix_t(mat: (scaleX, skewX, transX, scaleY, skewY, transY, persp0, persp1, persp2))
    }
    
    /**
     * The identity matrix
     */
    public static var identity : Matrix { Matrix (scaleX: 1, skewX: 0, transX: 0, scaleY: 1, skewY: 0, transY: 0, persp0: 0, persp1: 0, persp2: 1, mask: .rectStaysRect)}
    
    public var values : [Float] {
        get {
            return [scaleX, skewX, transX, scaleY, skewY, transY, persp0, persp1, persp2]
        }
    }
    
    /**
     * Sets SkMatrix to translate by (dx, dy).
     * - Parameter dx: horizontal translation
     * - Parameter dy: vertical translation
     * - Returns: `Matrix` with translation
     */
    public static func makeTranslation (sx: Float, sy: Float) -> Matrix
    {
        if sx == 1 && sy == 1 {
            return identity
        }
        return Matrix (scaleX: sx, skewX: 0, transX: 0, scaleY: sy, skewY: 0, transY: 0, persp0: 0, persp1: 0, persp2: 1)
    }
    
    static func fromNative (m: sk_matrix_t) -> Matrix
    {
        let (a,b,c,d,e,f,g,h,i) = m.mat
        
        return Matrix(scaleX: a, skewX: b, transX: c, scaleY: d, skewY: e, transY: f, persp0: g, persp1: h, persp2: i)
    }
}
