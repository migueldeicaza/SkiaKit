//
//  RoundRect.swift
//  SkiaKit
//
//  Created by Miguel de Icaza on 10/18/19.
//  Copyright © 2019 Miguel de Icaza. All rights reserved.
//

import Foundation
#if canImport(CSkiaSharp)
import CSkiaSharp
#endif

public final class RoundRect {
    var handle: OpaquePointer
    
    init (handle: OpaquePointer)
    {
        self.handle = handle
    }
    
    public init ()
    {
        handle = sk_rrect_new()
        sk_rrect_set_empty(handle)
    }
    
    public init (rect: Rect)
    {
        handle = sk_rrect_new()
        set (rect: rect)
    }
    
    public init (rect: Rect, xradius: Float, yradius: Float)
    {
        handle = sk_rrect_new()
        set (rect: rect, xradius: xradius, yradius: yradius)
    }
    
    public init (rr: RoundRect)
    {
        handle = sk_rrect_new_copy(rr.handle)
    }
    
    public var rect : Rect {
        get {
            let ptr = UnsafeMutablePointer<sk_rect_t>.allocate(capacity: 1)
            
            sk_rrect_get_rect(handle, ptr);
            return ptr.pointee
        }
    }
    public func setEmpty ()
    {
        sk_rrect_set_empty(handle)
    }
    
    public func set (rect: Rect)
    {
        withUnsafePointer(to: rect) {
            sk_rrect_set_rect(handle, $0)
        }
    }
    
    public func set (rect: Rect, xradius: Float, yradius: Float)
    {
        withUnsafePointer(to: rect) {
            sk_rrect_set_rect_xy(handle, $0, xradius, yradius)
        }
    }
    
    deinit {
        sk_rrect_delete(handle)
    }
    //sk_rrect_contains
    //sk_rrect_delete
    //sk_rrect_get_height
    //sk_rrect_get_radii
    //sk_rrect_get_rect
    //sk_rrect_get_type
    //sk_rrect_get_width
    //sk_rrect_inset
    //sk_rrect_is_valid
    //sk_rrect_new
    //sk_rrect_new_copy
    //sk_rrect_offset
    //sk_rrect_outset
    //sk_rrect_set_empty
    //sk_rrect_set_nine_patch
    //sk_rrect_set_oval
    //sk_rrect_set_rect
    //sk_rrect_set_rect_radii
    //sk_rrect_set_rect_xy
    //sk_rrect_transform

}
