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

public struct Point : Equatable {
    public init(x: Float, y: Float) {
        self.x = x
        self.y = y
    }
    
    public var x, y: Float
    public var length : Float { sqrtf(x*x+y*y)}
    
    public mutating func offset (dx: Float, dy: Float)
    {
        x = x + dx
        y = y + dy
    }
    
    public mutating func offset (point: Point)
    {
        x = x + point.x
        y = y + point.y
    }
    
    public func normalize (_ point: Point) -> Point
    {
        let ls = point.x * point.x + point.y * point.y
        let invNorm =  1.0 / sqrtf(ls)
        return Point (x: point.x * invNorm, y: point.y * invNorm)
    }
    
    public func distance (_ first: Point, _ second: Point) -> Float
    {
        let dx = first.x - second.x
        let dy = first.y - second.y
        return sqrtf (dx*dx + dy*dy)
    }
    
    public static func + (ls: Point, rs: Point) -> Point
    {
        Point (x: ls.x + rs.x, y: ls.y + rs.y)
    }

    public static func - (ls: Point, rs: Point) -> Point
    {
        Point (x: ls.x - rs.x, y: ls.y - rs.y)
    }
    
    public static prefix func - (pt: Point) -> Point
    {
        Point (x: -pt.x, y: -pt.y)
    }
    
    func toNative () -> sk_point_t
    {
        sk_point_t(x: x, y: y)
    }
}

public struct IPoint : Equatable {
    public init(x: Int32, y: Int32) {
        self.x = x
        self.y = y
    }
    
    public var x, y: Int32
    public var length : Float { sqrtf(Float (x*x+y*y)) }
    
    public mutating func offset (dx: Int32, dy: Int32)
    {
        x = x + dx
        y = y + dy
    }
    
    public mutating func offset (point: IPoint)
    {
        x = x + point.x
        y = y + point.y
    }
        
    public static func + (ls: IPoint, rs: IPoint) -> IPoint
    {
        IPoint (x: ls.x + rs.x, y: ls.y + rs.y)
    }

    public static func - (ls: IPoint, rs: IPoint) -> IPoint
    {
        IPoint (x: ls.x - rs.x, y: ls.y - rs.y)
    }
    
    public static prefix func - (pt: IPoint) -> IPoint
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

public struct Rect : Equatable {
    public init(left: Float, top: Float, right: Float, bottom: Float) {
        self.left = left
        self.top = top
        self.right = right
        self.bottom = bottom
    }
    
    public init (x: Float, y: Float, width: Float, height: Float)
    {
        self.left = x
        self.top = y
        self.right = x + width
        self.bottom = y + height
    }
    
    public init (width: Float, height: Float)
    {
        self.left = 0
        self.top = 0
        self.right = width
        self.bottom = height
    }
    
    public var left, top, right, bottom: Float
    
    public var midX : Float { left + (right - left) / 2.0}
    public var midY : Float { top + (bottom - top) / 2.0}
    public var width: Float { right - left }
    public var height: Float { bottom - top }
    
    static var empty: Rect { Rect(left: 0, top: 0, right: 0, bottom: 0)}
    
    static func fromNative (_ x: sk_rect_t) -> Rect
    {
        return Rect (left: x.left, top: x.top, right: x.right, bottom: x.bottom)
    }
    
    func toNative () -> sk_rect_t
    {
        sk_rect_t(left: left, top: top, right: right, bottom: bottom)
    }
    
    public var ceiling: IRect {
        get {
            IRect.ceiling (value: self, outwards: false)
        }
    }
    
}

public struct IRect : Equatable {
    var left, top, right, bottom: Int32
    
    public init(left: Int32, top: Int32, right: Int32, bottom: Int32) {
        self.left = left
        self.top = top
        self.right = right
        self.bottom = bottom
    }
    
    public init (x: Int32, y: Int32, width: Int32, height: Int32)
    {
        self.left = x
        self.top = y
        self.right = x + width
        self.bottom = y + height
    }
    
    public init (width: Int32, height: Int32)
    {
        self.left = 0
        self.top = 0
        self.right = width
        self.bottom = height
    }
    
    var midX : Int32 { left + (right - left) / 2}
    var midY : Int32 { top + (bottom - top) / 2}
    var width: Int32 { right - left }
    var height: Int32 { bottom - top }
    
    public static func ceiling (value: Rect, outwards: Bool) -> IRect {
        var x, y, r, b : Int32

        x = Int32 ((outwards && value.width > 0) ? floor (Float (value.left)) : ceil (Float (value.left)));
        y = Int32 ((outwards && value.height > 0) ? floor (Float (value.top)) : ceil (Float (value.top)));
        r = Int32 ((outwards && value.width < 0) ? floor (Float (value.right)) : ceil (Float (value.right)));
        b = Int32 ((outwards && value.height < 0) ? floor (Float (value.bottom)) : ceil (Float (value.bottom)));
        
        return IRect (left: x, top: y, right: r, bottom: b)
    }
    
    static func fromNative (_ x: sk_irect_t) -> IRect
    {
        return IRect (left: x.left, top: x.top, right: x.right, bottom: x.bottom)
    }
    
    func toNative () -> sk_irect_t
    {
        sk_irect_t(left: left, top: top, right: right, bottom: bottom)
    }
    
    public var isEmpty: Bool {
        get {
            return left == 0 && top == 0 && right == 0 && bottom == 0
        }
    }
}

public struct Size : Equatable {
    public var width, height: Float
    
    public var isEmpty : Bool {
        get { width == 0 && height == 0 }
    }
    
    public func toPoint () -> Point
    {
        return Point (x: width, y: height)
    }
    
    static func fromNative (_ x: sk_size_t) -> Size
    {
        return Size (width: x.w, height: x.h)
    }
    
    func toNative () -> sk_size_t
    {
        sk_size_t(w: width, h: height)
    }
}

public struct ISize : Equatable {
    public var width, height: Int32
    
    public var isEmpty : Bool {
        get { width == 0 && height == 0 }
    }
    
    public func toPoint () -> Point
    {
        return Point (x: Float (width), y: Float (height))
    }

    public func toIPoint () -> IPoint
    {
        return IPoint (x: width, y: height)
    }

    static func fromNative (_ x: sk_isize_t) -> ISize
    {
        return ISize (width: x.w, height: x.h)
    }
    
    func toNative () -> sk_isize_t
    {
        sk_isize_t(w: width, h: height)
    }
}
