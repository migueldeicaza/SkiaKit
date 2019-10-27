//
//  Mathtypes.swift
//  SkiaKit
//
//  Created by Miguel de Icaza on 10/17/19.
//  Copyright © 2019 Miguel de Icaza. All rights reserved.
//

import Foundation

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

public struct Rect : Equatable {
    public init(left: Float, top: Float, right: Float, bottom: Float) {
        self.left = left
        self.top = top
        self.right = right
        self.bottom = bottom
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
}

public struct IRect : Equatable {
    var left, top, right, bottom: Int32
    
    var midX : Int32 { left + (right - left) / 2}
    var midY : Int32 { top + (bottom - top) / 2}
    var width: Int32 { right - left }
    var height: Int32 { bottom - top }
    
    static func fromNative (_ x: sk_irect_t) -> IRect
    {
        return IRect (left: x.left, top: x.top, right: x.right, bottom: x.bottom)
    }
    
    func toNative () -> sk_irect_t
    {
        sk_irect_t(left: left, top: top, right: right, bottom: bottom)
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
