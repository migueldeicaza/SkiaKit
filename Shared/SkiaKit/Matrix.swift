//
//  Matrix.swift
//  SkiaKit
//
//  Created by Miguel de Icaza on 10/18/19.
//  Copyright © 2019 Miguel de Icaza. All rights reserved.
//

import Foundation
#if canImport(CSkiaSharp)
import CSkiaSharp
#endif

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
 *
 * You can either create the matrix by using one of the constuctors, or using some of the
 * convenience static methods that start with `make`
 */
public struct Matrix {
    var back: sk_matrix_t
    var mask: typeMask
    
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
    
    public init (scaleX: Float = 0, skewX: Float = 0, transX: Float = 0, scaleY: Float = 0, skewY: Float = 0, transY: Float = 0, persp0: Float = 0, persp1: Float = 0, persp2: Float = 0)
    {
        back = sk_matrix_t (scaleX: scaleX, skewX: skewX, transX: transX, skewY: skewY, scaleY: scaleY, transY: transY, persp0: persp0, persp1: persp1, persp2: persp2)
        mask = .unknown
    }
    
    init (scaleX: Float = 0, skewX: Float = 0, transX: Float = 0, scaleY: Float = 0, skewY: Float = 0, transY: Float = 0, persp0: Float = 0, persp1: Float = 0, persp2: Float = 0, mask: typeMask)
    {
        back = sk_matrix_t (scaleX: scaleX, skewX: skewX, transX: transX, skewY: skewY, scaleY: scaleY, transY: transY, persp0: persp0, persp1: persp1, persp2: persp2)
        self.mask = mask
    }
    
    func toNative () -> sk_matrix_t
    {
        back
    }
    
    /**
     * The identity matrix
     */
    public static var identity : Matrix { Matrix (scaleX: 1, skewX: 0, transX: 0, scaleY: 1, skewY: 0, transY: 0, persp0: 0, persp1: 0, persp2: 1, mask: .rectStaysRect)}
    
    /**
     * Creates a translation matrix (dx, dy).
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

    /**
     * Creates a new scale matrix.
     * - Parameter sx: The scaling in the x direction
     * - Parameter sy: The scaling in the y direction
     */
    public static func makeScale (sx: Float, sy: Float) -> Matrix
    {
        if sx == 1 && sy == 1 {
            return identity
        }
        return Matrix (scaleX: sx, scaleY: sy, persp1: 1)
    }

    public static func makeSkew (sx: Float, sy: Float) -> Matrix
    {
        return Matrix (scaleX: 1, skewX: sx, scaleY: 1, skewY: sy, persp2: 1)
    }
    
    public static func concat (target: inout Matrix, first: Matrix, second: Matrix)
    {
        var fcopy = first
        var scopy = second
        sk_matrix_concat(&target.back, &fcopy.back, &scopy.back)
    }
    
    public static func preConcat (target: inout Matrix, matrix: Matrix)
    {
        var mcopy = matrix
        sk_matrix_pre_concat(&target.back, &mcopy.back)
    }
    
    public static func postConcat (target: inout Matrix, matrix: Matrix)
    {
        var mcopy = matrix
        sk_matrix_post_concat(&target.back, &mcopy.back)
    }

    
    static func fromNative (m: sk_matrix_t) -> Matrix
    {
        return Matrix(scaleX: m.scaleX, skewX: m.skewX, transX: m.transX, scaleY: m.scaleY, skewY: m.skewY, transY: m.transY, persp0: m.persp0, persp1: m.persp1, persp2: m.persp2)
    }
    
    //sk_3dview_apply_to_canvas
    //sk_3dview_destroy
    //sk_3dview_dot_with_normal
    //sk_3dview_get_matrix
    //sk_3dview_new
    //sk_3dview_restore
    //sk_3dview_rotate_x_degrees
    //sk_3dview_rotate_x_radians
    //sk_3dview_rotate_y_degrees
    //sk_3dview_rotate_y_radians
    //sk_3dview_rotate_z_degrees
    //sk_3dview_rotate_z_radians
    //sk_3dview_save
    //sk_3dview_translate
    //sk_matrix44_as_col_major
    //sk_matrix44_as_row_major
    //sk_matrix44_destroy
    //sk_matrix44_determinant
    //sk_matrix44_equals
    //sk_matrix44_get
    //sk_matrix44_get_type
    //sk_matrix44_invert
    //sk_matrix44_map2
    //sk_matrix44_map_scalars
    //sk_matrix44_new
    //sk_matrix44_new_concat
    //sk_matrix44_new_copy
    //sk_matrix44_new_identity
    //sk_matrix44_new_matrix
    //sk_matrix44_post_concat
    //sk_matrix44_post_scale
    //sk_matrix44_post_translate
    //sk_matrix44_pre_concat
    //sk_matrix44_pre_scale
    //sk_matrix44_pre_translate
    //sk_matrix44_preserves_2d_axis_alignment
    //sk_matrix44_set
    //sk_matrix44_set_3x3_row_major
    //sk_matrix44_set_col_major
    //sk_matrix44_set_concat
    //sk_matrix44_set_identity
    //sk_matrix44_set_rotate_about_degrees
    //sk_matrix44_set_rotate_about_radians
    //sk_matrix44_set_rotate_about_radians_unit
    //sk_matrix44_set_row_major
    //sk_matrix44_set_scale
    //sk_matrix44_set_translate
    //sk_matrix44_to_matrix
    //sk_matrix44_transpose
    //sk_matrix_DEFINED
    //sk_matrix_map_points
    //sk_matrix_map_radius
    //sk_matrix_map_rect
    //sk_matrix_map_vector
    //sk_matrix_map_vectors
    //sk_matrix_map_xy
    //sk_matrix_try_invert

}
