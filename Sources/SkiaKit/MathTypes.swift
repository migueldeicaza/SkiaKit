//
//  Mathtypes.swift
//  SkiaKit
//
//  Created by Miguel de Icaza on 10/17/19.
//  Copyright © 2019 Miguel de Icaza. All rights reserved.
//

import Foundation
#if canImport(CSkiaSharp)
import CSkiaSharp
#endif

public typealias Point = sk_point_t
public extension Point {
    var length : Float { sqrtf(x*x+y*y)}
    
    mutating func offset (dx: Float, dy: Float)
    {
        x = x + dx
        y = y + dy
    }
    
    mutating func offset (point: Point)
    {
        x = x + point.x
        y = y + point.y
    }
    
    func normalize (_ point: Point) -> Point
    {
        let ls = point.x * point.x + point.y * point.y
        let invNorm =  1.0 / sqrtf(ls)
        return Point (x: point.x * invNorm, y: point.y * invNorm)
    }
    
    func distance (_ first: Point, _ second: Point) -> Float
    {
        let dx = first.x - second.x
        let dy = first.y - second.y
        return sqrtf (dx*dx + dy*dy)
    }
    
    static func + (ls: Point, rs: Point) -> Point
    {
        Point (x: ls.x + rs.x, y: ls.y + rs.y)
    }

    static func - (ls: Point, rs: Point) -> Point
    {
        Point (x: ls.x - rs.x, y: ls.y - rs.y)
    }
    
    static prefix func - (pt: Point) -> Point
    {
        Point (x: -pt.x, y: -pt.y)
    }
}

public typealias IPoint = sk_ipoint_t
public extension IPoint {
    var length : Float { sqrtf(Float (x*x+y*y)) }
    
    mutating func offset (dx: Int32, dy: Int32)
    {
        x = x + dx
        y = y + dy
    }
    
    mutating func offset (point: IPoint)
    {
        x = x + point.x
        y = y + point.y
    }
        
    static func + (ls: IPoint, rs: IPoint) -> IPoint
    {
        IPoint (x: ls.x + rs.x, y: ls.y + rs.y)
    }

    static func - (ls: IPoint, rs: IPoint) -> IPoint
    {
        IPoint (x: ls.x - rs.x, y: ls.y - rs.y)
    }
    
    static prefix func - (pt: IPoint) -> IPoint
    {
        IPoint (x: -pt.x, y: -pt.y)
    }
    
//    func toNative () -> sk_ipoint_t
//    {
//        sk_ipoint_t(x: x, y: y)
//    }
//
//    static func fromNative (v: sk_ipoint_t) -> IPoint
//    {
//        return IPoint (x: v.x, y: v.y)
//    }

}

public typealias Rect = sk_rect_t
public extension Rect {
    init (x: Float, y: Float, width: Float, height: Float)
    {
        self.init(left: x, top: y, right: x+width, bottom: y+height)
    }
    
    init (width: Float, height: Float)
    {
        self.init(left: 0, top: 0, right: width, bottom: height)
    }
    
    var midX : Float { left + (right - left) / 2.0}
    var midY : Float { top + (bottom - top) / 2.0}
    var width: Float { right - left }
    var height: Float { bottom - top }
    
    static var empty: Rect { Rect(left: 0, top: 0, right: 0, bottom: 0)}
    
    var ceiling: IRect {
        get {
            IRect.ceiling (value: self, outwards: false)
        }
    }
    
}

public typealias IRect = sk_irect_t
public extension IRect {
    init (x: Int32, y: Int32, width: Int32, height: Int32)
    {
        self.init(left: x, top: y, right: x+width, bottom: y+height)
    }
    
    init (width: Int32, height: Int32)
    {
        self.init(left: 0, top: 0, right: width, bottom: height)
    }
    
    var midX : Int32 { left + (right - left) / 2}
    var midY : Int32 { top + (bottom - top) / 2}
    var width: Int32 { right - left }
    var height: Int32 { bottom - top }
    
    static func ceiling (value: Rect, outwards: Bool) -> IRect {
        var x, y, r, b : Int32

        x = Int32 ((outwards && value.width > 0) ? floor (Float (value.left)) : ceil (Float (value.left)));
        y = Int32 ((outwards && value.height > 0) ? floor (Float (value.top)) : ceil (Float (value.top)));
        r = Int32 ((outwards && value.width < 0) ? floor (Float (value.right)) : ceil (Float (value.right)));
        b = Int32 ((outwards && value.height < 0) ? floor (Float (value.bottom)) : ceil (Float (value.bottom)));
        
        return IRect (left: x, top: y, right: r, bottom: b)
    }
    
    var isEmpty: Bool {
        get {
            return left == 0 && top == 0 && right == 0 && bottom == 0
        }
    }
}

public typealias Size = sk_size_t
public extension Size {
    var width: Float { return self.w }
    var height: Float { return self.h }
    var isEmpty : Bool {
        get { width == 0 && height == 0 }
    }
    
    func toPoint () -> Point
    {
        return Point (x: Float (width), y: Float (height))
    }

    func toIPoint () -> IPoint
    {
        return IPoint (x: Int32(width), y: Int32(height))
    }
}

public typealias ISize = sk_isize_t
public extension ISize{
    var width:  Int32 { return self.w }
    var height: Int32 { return self.h }
    var isEmpty : Bool {
        get { width == 0 && height == 0 }
    }
    
    func toPoint () -> Point
    {
        return Point (x: Float (width), y: Float (height))
    }

    func toIPoint () -> IPoint
    {
        return IPoint (x: width, y: height)
    }
}
