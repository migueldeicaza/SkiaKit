//
//  Region.swift
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
 * `Region` describes the set of pixels used to clip `Canvas`. `Region` is compact,
 * efficiently storing a single integer rectangle, or a run length encoded array
 * of rectangles. `Region` may reduce the current `Canvas` clip, or may be drawn as
 * one or more integer rectangles. `Region` iterator returns the scan lines or
 * rectangles contained by it, optionally intersecting a bounding rectangle.
 */
public final class Region {
    var handle: OpaquePointer
    
    /**
     * Constructs an empty `Region`. `Region` is set to empty bounds
     * at (0, 0) with zero width and height.
     */
    public init ()
    {
        handle = sk_region_new()
    }

    /**
     * Constructs a copy of an existing region.
     * Copy constructor makes two regions identical by value. Internally, region and
     * the returned result share pointer values. The underlying `Rect` array is
     * copied when modified.
     * Creating a `Region` copy is very efficient and never allocates memory.
     * `Region` are always copied by value from the interface; the underlying shared
     * pointers are not exposed.
     * - Parameter region: `Region` to copy by value
     */
    public init (region: Region)
    {
        handle = sk_region_new2(region.handle)
    }
    
    public convenience init (rect: IRect)
    {
        self.init ()
        setRect (rect)
    }
    
    public convenience init (path: Path)
    {
        self.init (rect: path.bounds.ceiling)
        setPath (path)
    }
    
    /**
     * Constructs a rectangular `Region` matching the bounds of rect.
     * If rect is empty, constructs empty and returns false.
     * - Parameter rect: bounds of constructed `Region`
     * - Returns: true if rect is not empty
     */
    @discardableResult
    public func setRect (_ rect: IRect) -> Bool
    {
        var r = rect.toNative()
        return sk_region_set_rect(handle, &r)
    }
    
    /**
     * Constructs `Region` to match outline of path within clip.
     * Returns false if constructed `Region` is empty.
     * Constructed `Region` draws the same pixels as path through clip when
     * anti-aliasing is disabled.
     * - Parameter path: `Path` providing outline
     * - Parameter clip: `Region` containing path
     * - Returns: true if constructed `Region` is not empty
     */
    public func setPath (_ path: Path, clip: Region)
    {
        sk_region_set_path(handle, path.handle, clip.handle)
    }

    /**
     * Set this region to the area described by the path, clipped to the current region.
     * - Parameter path: The replacement path.
     * - Returns: true if constructed `Region` is not empty
     */
    public func setPath (_ path: Path)
    {
        let clip = Region ()
        let rect = path.bounds.ceiling
        if !rect.isEmpty {
            clip.setRect(rect)
        }
        sk_region_set_path(handle, path.handle, clip.handle)
    }
    
    /**
     * Replaces `Region` with the result of `Region` op rect.
     * Returns true if replaced `Region` is not empty.
     * - Parameter rect: `IRect` operand
     * - Parameter op: operator to apply
     * - Returns: false if result is empty
     */
    public func op (rect: IRect, op: RegionOperation) -> Bool
    {
        sk_region_op(handle, rect.left, rect.top, rect.right, rect.bottom, op.toNative ())
    }

    /**
     * Replaces `Region` with the result of `Region` op rgn.
     * Returns true if replaced `Region` is not empty.
     * - Parameter rgn: `Region` operand
     * - Parameter op: operator to apply
     * - Returns: false if result is empty
     */
    public func op (region: Region, op: RegionOperation) -> Bool
    {
        sk_region_op2(handle, region.handle, op.toNative ())
    }

    public func op (path: Path, op inop: RegionOperation) -> Bool
    {
        let p = Region (path: path)
        return op (region: p, op: inop)
    }
    
    deinit {
        sk_region_delete(handle)
    }

    /**
     * Returns minimum and maximum axes values of `IRect` array.
     * Returns (0, 0, 0, 0) if `Region` is empty.
     */
    public var bounds: IRect {
        get {
            var r = sk_irect_t()
            
            sk_region_get_bounds(handle, &r)
            return IRect.fromNative(r)
        }
    }
    
//    public func contains (region: Region) -> Bool
//    {
//        return sk_region_contains(handle, region.handle)
//    }
    
    /**
     * Returns true if `Region` intersects other.
     * Returns false if either other or `Region` is empty, or do not intersect.
     * - Parameter other: `Region` to intersect
     * - Returns: true if other and `Region` have area in common
     *
     */
    public func intersects (region: Region) -> Bool {
        sk_region_intersects(handle, region.handle)
    }

    /**
     * Returns true if `Region` intersects rect.
     * Returns false if either rect or `Region` is empty, or do not intersect.
     * - Parameter rect: `IRect` to intersect
     * - Returns: true if rect and `Region` have area in common
     */
    public func intersects (rect: IRect) -> Bool {
        var r = rect.toNative()
        return sk_region_intersects_rect(handle, &r);
    }

}
