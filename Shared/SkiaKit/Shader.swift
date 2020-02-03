//
//  Shader.swift
//  SkiaKit
//
//  Created by Miguel de Icaza on 10/17/19.
//  Copyright © 2019 Miguel de Icaza. All rights reserved.
//

import Foundation
import CSkiaSharp

/**
 * Shaders specify the source color(s) for what is being drawn. If a paint
 * has no shader, then the paint's color is used. If the paint has a
 * shader, then the shader's color(s) are use instead, but they are
 * modulated by the paint's alpha. This makes it easy to create a shader
 * once (e.g. bitmap tiling or gradient) and then change its transparency
 * w/o having to modify the original shader... only the paint's alpha needs
 * to be modified.
 *
 * Use any of the various static `make` methods to create the shader
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

    static func toNative (_ colors: [Color]) -> [sk_color_t]
    {
        var ncolors : [sk_color_t] = []
        for x in colors {
            ncolors.append(x.color)
        }
        return ncolors
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
        var ncolors = toNative (colors)
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
    public static func makeLinearGradient (start: Point, end: Point, colors: [Color], colorPos: [Float]?, mode: ShaderTileMode, localMatrix: Matrix? = nil) -> Shader?
    {
        var ptr : UnsafePointer<sk_matrix_t>? = nil
        var native : sk_matrix_t
        if let l = localMatrix {
            native = l.toNative()
            ptr = UnsafePointer<sk_matrix_t> (&native)
        }
        
        var pt : [sk_point_t] = [start.toNative(), end.toNative()]
        var ncolors = toNative (colors)
        var x: OpaquePointer!
        if var cp = colorPos {
            x = sk_shader_new_linear_gradient(&pt, &ncolors, &cp, Int32 (colors.count), mode.toNative(), ptr)
        } else {
            x = sk_shader_new_linear_gradient(&pt, &ncolors, nil, Int32 (colors.count), mode.toNative(), ptr)
        }
        if x != nil {
            return Shader (handle: x)
        } else {
            return nil
        }
    }
    
    /// Creates a shader that generates a radial gradient given the center and radius.
    /// - Parameter center: The center of the circle for this gradient.
    /// - Parameter radius: The positive radius of the circle for this gradient.
    /// - Parameter colors: The array colors to be distributed between the center and edge of the circle.
    /// - Parameter colorPos: The positions (in the range of 0..1) of each corresponding color, or null to evenly distribute the colors.
    /// - Parameter mode: The tiling mode.
    /// - Parameter localMatrix: optional, the matrix to apply before applying the shader.
    /// - Returns: a new shader 
    public static func makeRadialGradient (center: Point, radius: Float, colors: [Color], colorPos: [Float]?, mode: ShaderTileMode, localMatrix: Matrix? = nil) -> Shader?
    {
        var ptr : UnsafePointer<sk_matrix_t>? = nil
        var native : sk_matrix_t
        if let l = localMatrix {
            native = l.toNative()
            ptr = UnsafePointer<sk_matrix_t> (&native)
        }
        
        let ncolors = toNative (colors)
        var cpt = center.toNative()
        var x: OpaquePointer!
        if var cp = colorPos {
            x = sk_shader_new_radial_gradient(&cpt, radius, ncolors, &cp, Int32 (colors.count), mode.toNative(), ptr)
        } else {
            x = sk_shader_new_radial_gradient(&cpt, radius, ncolors, nil, Int32 (colors.count), mode.toNative(), ptr)
        }
        if x != nil {
            return Shader (handle: x)
        } else {
            return nil
        }
    }
    
    /// Creates a shader that generates a sweep gradient given a center.
    /// - Parameter center:The coordinates of the center of the sweep.
    /// - Parameter colors: The array colors to be distributed between the center and edge of the circle.
    /// - Parameter colorPos: The positions (in the range of 0..1) of each corresponding color, or null to evenly distribute the colors.
    /// - Parameter mode: The tiling mode.
    /// - Parameter startAngle: The start of the angular range.
    /// - Parameter endAngle: The end of the angular range.
    /// - Parameter localMatrix: optional, the matrix to apply before applying the shader.
    /// - Returns: a new shader
    public static func makeSweepGradient (center: Point, colors: [Color], colorPos: [Float]?, mode: ShaderTileMode = .clamp, startAngle: Float = 0, endAngle: Float = 360, localMatrix: Matrix? = nil) -> Shader?
    {
        var ptr : UnsafePointer<sk_matrix_t>? = nil
        var native : sk_matrix_t
        if let l = localMatrix {
            native = l.toNative()
            ptr = UnsafePointer<sk_matrix_t> (&native)
        }

        let ncolors = toNative (colors)
        var cpt = center.toNative()
        var x: OpaquePointer!
        if var cp = colorPos {
            x = sk_shader_new_sweep_gradient(&cpt, ncolors, &cp, Int32(colors.count), mode.toNative(), startAngle, endAngle, ptr)
        } else {
            x = sk_shader_new_sweep_gradient(&cpt, ncolors, nil, Int32(colors.count), mode.toNative(), startAngle, endAngle, ptr)
        }
        if x != nil {
            return Shader (handle: x)
        } else {
            return nil
        }
    }
    
    /// Creates a shader that generates a conical gradient given two circles.
    /// - Parameter start: The coordinates for the starting point.
    /// - Parameter startRadius: The radius at the starting point.
    /// - Parameter end: The coordinates for the end point.
    /// - Parameter endRadius: The radius at the end point.
    /// - Parameter colors: The array colors to be distributed between the center and edge of the circle.
    /// - Parameter colorPos: The positions (in the range of 0..1) of each corresponding color, or null to evenly distribute the colors.
    /// - Parameter mode: The radius at the end point.
    /// - Parameter localMatrix: optional, the matrix to apply before applying the shader.
    /// - Returns: a new shader
    public static func makeTwoPointConicalGradient (start: Point, startRadius: Float, end: Point, endRadius: Float, colors: [Color], colorPos: [Float]?, mode: ShaderTileMode = .clamp, localMatrix: Matrix? = nil) -> Shader?
    {
        var ptr : UnsafePointer<sk_matrix_t>? = nil
        var native : sk_matrix_t
        if let l = localMatrix {
            native = l.toNative()
            ptr = UnsafePointer<sk_matrix_t> (&native)
        }

        let ncolors = toNative (colors)
        var startpt = start.toNative()
        var endpt = end.toNative()
        var x: OpaquePointer!
        if var cp = colorPos {
            x = sk_shader_new_two_point_conical_gradient(&startpt, startRadius, &endpt, endRadius, ncolors, &cp, Int32(colors.count), mode.toNative(), ptr)
        } else {
            x = sk_shader_new_two_point_conical_gradient(&startpt, startRadius, &endpt, endRadius, ncolors, nil, Int32(colors.count), mode.toNative(), ptr)
        }
        if x != nil {
            return Shader (handle: x)
        } else {
            return nil
        }
    }
    
    /// Creates a new shader that draws Perlin fractal noise.
    /// - Parameter baseFrequencyX: The frequency in the x-direction in the range of 0..1.
    /// - Parameter baseFrequencyY: The frequency in the y-direction in the range of 0..1.
    /// - Parameter numOctaves: he number of octaves, usually fairly small.
    /// - Parameter seed: The randomization seed.
    /// - Parameter tileSize: The tile size used to modify the frequencies so that the noise will be tileable for the given size.
    /// - Returns: a new shader
    public static func makePerlinNoiseFractalNoise (baseFrequencyX: Float, baseFrequencyY: Float, numOctaves: Int32, seed: Float, tileSize: ISize? = nil) -> Shader
    {
        var ptr : UnsafePointer<sk_isize_t>? = nil
        var n: sk_isize_t
        if let t = tileSize {
            n = t.toNative()
            ptr = UnsafePointer<sk_isize_t>(&n)
        }
        return Shader (handle: sk_shader_new_perlin_noise_fractal_noise(baseFrequencyX, baseFrequencyY, numOctaves, seed, ptr))
    }

    /// Creates a new shader that draws Perlin turbulence noise.
    /// - Parameter baseFrequencyX: The frequency in the x-direction in the range of 0..1.
    /// - Parameter baseFrequencyY: The frequency in the y-direction in the range of 0..1.
    /// - Parameter numOctaves: he number of octaves, usually fairly small.
    /// - Parameter seed: The randomization seed.
    /// - Parameter tileSize: The tile size used to modify the frequencies so that the noise will be tileable for the given size.
    /// - Returns: a new shader
    public static func makePerlinNoiseTurbulence (baseFrequencyX: Float, baseFrequencyY: Float, numOctaves: Int32, seed: Float, tileSize: ISize? = nil) -> Shader
    {
        var ptr : UnsafePointer<sk_isize_t>? = nil
        var n: sk_isize_t
        if let t = tileSize {
            n = t.toNative()
            ptr = UnsafePointer<sk_isize_t>(&n)
        }
        return Shader (handle: sk_shader_new_perlin_noise_turbulence(baseFrequencyX, baseFrequencyY, numOctaves, seed, ptr))
    }
    
    /// Create a new compose shader, which combines two shaders optionally, with a blend mode.
    /// The colors from this shader are seen as the destination by the blend mode.
    ///
    /// - Parameter with: The colors from this shader are seen as the source by the blend mode.
    /// - Parameter blend: The blend mode that combines the two shaders.
    /// - Returns: a new shader that composes the current shader with the provided one
    public func compose (with: Shader, blend: BlendMode? = nil) -> Shader
    {
        if let b = blend {
            return Shader (handle: sk_shader_new_compose_with_mode (handle, with.handle, b.toNative()))
        } else {
            return Shader (handle: sk_shader_new_compose(handle, with.handle))
        }
    }
    deinit
    {
        sk_shader_unref(handle)
    }
    
}
