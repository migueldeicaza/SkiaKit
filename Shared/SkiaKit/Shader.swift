//
//  Shader.swift
//  SkiaKit
//
//  Created by Miguel de Icaza on 10/17/19.
//  Copyright © 2019 Miguel de Icaza. All rights reserved.
//

import Foundation

/**
 * Shaders specify the source color(s) for what is being drawn. If a paint
 * has no shader, then the paint's color is used. If the paint has a
 * shader, then the shader's color(s) are use instead, but they are
 * modulated by the paint's alpha. This makes it easy to create a shader
 * once (e.g. bitmap tiling or gradient) and then change its transparency
 * w/o having to modify the original shader... only the paint's alpha needs
 * to be modified.
 */
public final class Shader {
    var handle : OpaquePointer
    init (handle: OpaquePointer)
    {
        self.handle = handle
    }
    
    public func makeEmpty () -> Shader
    {
        return Shader (handle: sk_shader_new_empty())
    }
    
    public static func makeColor (color: Color) -> Shader
    {
        return Shader (handle: sk_shader_new_color (color.color))
    }

    /**
     * Creates a new shader that will draw with the specified bitmap.
     *
     * If the bitmap cannot be used (has no pixels, or its dimensions exceed implementation limits) then
     * an empty shader may be returned. If the source bitmap's color type is Alpha8 then that
     * mask will be colorized using the color on the paint.
     *
     * - Parameter source: The bitmap to use inside the shader.
     * - Parameter tileModeX: The tiling mode to use when sampling the bitmap in the x-direction.
     * - Parameter tileModeYThe tiling mode to use when sampling the bitmap in the y-direction.:
     * - Returns: Returns a new SKShader, or an empty shader on error.
     */
    public static func makeBitmap (source: Bitmap, tileModeX: ShaderTileMode, tileModeY: ShaderTileMode) -> Shader
    {
        return Shader (handle: sk_shader_new_bitmap(source.handle, tileModeX.toNative(), tileModeY.toNative(), nil))
    }

    /**
     * Creates a new shader that will draw with the specified bitmap.
     *
     * If the bitmap cannot be used (has no pixels, or its dimensions exceed implementation limits) then
     * an empty shader may be returned. If the source bitmap's color type is Alpha8 then that
     * mask will be colorized using the color on the paint.
     *
     * - Parameter source: The bitmap to use inside the shader.
     * - Parameter tileModeX: The tiling mode to use when sampling the bitmap in the x-direction.
     * - Parameter tileModeYThe tiling mode to use when sampling the bitmap in the y-direction.:
     * - Parameter localMatrix: The matrix to apply before applying the shader.
     * - Returns: Returns a new SKShader, or an nil shader on error.
     */
    public static func makeBitmap (source: Bitmap, tileModeX: ShaderTileMode, tileModeY: ShaderTileMode, localMatrix: Matrix)  -> Shader?
    {
        var l = localMatrix.toNative()
        if let x = sk_shader_new_bitmap(source.handle, tileModeX.toNative(), tileModeY.toNative(), &l) {
            return Shader (handle: x)
        }
        return nil
    }

    /**
     * Creates a new shader that produces the same colors as invoking this shader and then applying the color filter.
     * - Parameter shader: The shader to apply
     * - Parameter tileModeX: the color filter to apply
     * - Returns: Returns a new SKShader, or an empty shader on error.
     */
    public static func makeColorFilter (shader: Shader, colorFilter: ColorFilter) -> Shader
    {
        return Shader (handle: sk_shader_new_color_filter(shader.handle, colorFilter.handle))
    }

    /**
     * Creates a shader that first applies the specified matrix and then applies the shader.
     * - Parameter shader: The shader to apply
     * - Parameter localMatrix: The matrix to apply before applying the shader.
     * - Returns: Returns a new SKShader, or nil on error (the matrix can not be inverted)
     */
    public static func makeLocalMatrix (shader: Shader, localMatrix: Matrix) -> Shader?
    {
        var l = localMatrix.toNative()
        
        if let x = sk_shader_new_local_matrix(shader.handle, &l) {
            return Shader (handle: x)
        }
        return nil
    }

    /**
     * Creates a shader that generates a linear gradient between the two specified points.
     * - Parameter start: The start point for the gradient.
     * - Parameter end: The end point for the gradient.
     * - Parameter colors: The array colors to be distributed between the two points.
     * - Parameter colorPos: The positions (in the range of 0..1) of each corresponding color, or null to evenly distribute the colors.
     * - Parameter mode: The tiling mode.
     * - Returns: Returns a new SKShader, or an empty shader on error.
     */
    public static func makeLinearGradient (start: Point, end: Point, colors: [Color], colorPos: [Float]?, mode: ShaderTileMode) -> Shader
    {
        var pt : [sk_point_t] = [start.toNative(), end.toNative()]
        var ncolors : [sk_color_t] = []
        for x in colors {
            ncolors.append(x.color)
        }
        if var cp = colorPos {
            return Shader (handle: sk_shader_new_linear_gradient(&pt, &ncolors, &cp, Int32 (colors.count), mode.toNative(), nil))
        } else {
            return Shader (handle: sk_shader_new_linear_gradient(&pt, &ncolors, nil, Int32 (colors.count), mode.toNative(), nil))
        }
    }

    /**
     * Creates a shader that generates a linear gradient between the two specified points.
     * - Parameter start: The start point for the gradient.
     * - Parameter end: The end point for the gradient.
     * - Parameter colors: The array colors to be distributed between the two points.
     * - Parameter colorPos: The positions (in the range of 0..1) of each corresponding color, or null to evenly distribute the colors.
     * - Parameter mode: The tiling mode.
     * - Returns: Returns a new SKShader, or nil on error
     */
    public static func makeLinearGradient (start: Point, end: Point, colors: [Color], colorPos: [Float]?, mode: ShaderTileMode, localMatrix: Matrix) -> Shader?
    {
        var l = localMatrix.toNative()
        

        var pt : [sk_point_t] = [start.toNative(), end.toNative()]
        var ncolors : [sk_color_t] = []
        for x in colors {
            ncolors.append(x.color)
        }
        var x: OpaquePointer
        if var cp = colorPos {
            x = sk_shader_new_linear_gradient(&pt, &ncolors, &cp, Int32 (colors.count), mode.toNative(), &l)
        } else {
            x = sk_shader_new_linear_gradient(&pt, &ncolors, nil, Int32 (colors.count), mode.toNative(), &l)
        }
        if x != nil {
            return Shader (handle: x)
        } else {
            return nil
        }
    }

    deinit
    {
        sk_shader_unref(handle)
    }
    
}
