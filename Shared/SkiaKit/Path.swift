//
//  Path.swift
//  SkiaKit
//
//  Created by Miguel de Icaza on 10/17/19.
//  Copyright © 2019 Miguel de Icaza. All rights reserved.
//

import Foundation

public class Path {
    var handle : OpaquePointer
    init (handle: OpaquePointer)
    {
        self.handle = handle
    }
    
    public init ()
    {
        handle = sk_path_new()
    }
    
    /**
     * Returns FillType, the rule used to fill Path. FillType of a new Path is .winding
     */
    public var fillType : PathFillType {
        get {
            return PathFillType.fromNative (sk_path_get_filltype(handle))
        }
        set {
            sk_path_set_filltype(handle, newValue.toNative())
        }
    }
    
    public var convexity: PathConvexity {
        get {
            return PathConvexity.fromNative(sk_path_get_convexity(handle))
        }
        set {
            sk_path_set_convexity(handle, newValue.toNative ())
        }
    }
    
    public var verbCount: Int32 { sk_path_count_verbs(handle) }
    public var isConvex:  Bool { convexity == .convex }
    public var isConcave: Bool { convexity == .concave }
    public var isEmpty: Bool { verbCount == 0 }
    public var isOval: Bool { sk_path_is_oval(handle, nil) }
    public var isRoundedRect: Bool { sk_path_is_rrect(handle, nil) }
    public var isLine: Bool { sk_path_is_line(handle, nil) }
    public var isRect: Bool { sk_path_is_rect(handle, nil, nil, nil) }
    public var pointCount: Int32 { sk_path_count_points(handle) }
    public var segmentMasks: PathSegmentMask { PathSegmentMask.init (rawValue: sk_path_get_segment_masks(handle))! }
    public subscript (index: Int32) -> Point {
        get {
            getPoint (index: index)
        }
    }
    public var lastPoint: Point {
        get {
            var pp = sk_point_t()
            
            sk_path_get_last_point(handle, &pp)
            return Point(x: pp.x, y: pp.y)
        }
    }
    
    public var bounds: Rect {
        get {
            var rect: sk_rect_t = sk_rect_t()
            
            sk_path_get_bounds(handle, &rect)
            return Rect.fromNative(rect)
        }
    }
    
    public var tightBounds: Rect {
        get {
            if let r = getTightBounds() {
                return r
            }
            return Rect.empty
        }
    }
    
    public func getTightBounds () -> Rect?
    {
        var ret = sk_rect_t ()
        if sk_pathop_tight_bounds(handle, &ret) {
            return Rect.fromNative(ret)
        }
        return nil
    }
    
    public func getOvalBounds () -> Rect?
    {
        var ret = sk_rect_t ()
        if sk_path_is_oval(handle, &ret) {
            return Rect.fromNative(ret)
        }
        return nil
    }
    
    public func getRoundRect () -> RoundRect?
    {
        let rrect = RoundRect()
        if sk_path_is_rrect(handle, rrect.handle) {
            return rrect
        }
        return nil
    }
    
    public func getLine () -> [Point]?
    {
        var tmp = [sk_point_t(), sk_point_t ()]
        if sk_path_is_line(handle, &tmp) {
            return [Point(x: tmp[0].x, y: tmp[0].y), Point(x: tmp[1].x, y: tmp[1].y)]
        }
        return nil
    }
    
    public func getRect () -> (rect: Rect, isClosed: Bool, direction: PathDirection)
    {
        var rect = sk_rect_t ()
        var isClosed = false
        var dir = sk_path_direction_t(rawValue: 0)
        
        sk_path_is_rect(handle, &rect, &isClosed, &dir)
        
        return (Rect.fromNative(rect), isClosed, dir.rawValue == 0 ? .clockwise : .counterClockwise)
    }
    
    /**
     * Returns the point stored at the specified index, if this is out of bounds, it returns a point(0,0)
     */
    public func getPoint (index: Int32) -> Point  {
        var pt = sk_point_t()
        
        sk_path_get_point(handle, index, &pt)
        return Point(x: pt.x, y: pt.y)
    }
    
    public func getPoints (maxPoints: Int32 = -1) -> [Point]
    {
        var n = 0
        if maxPoints < 1 {
            n = Int (pointCount)
        }
        let ptr = UnsafeMutablePointer<sk_point_t>.allocate(capacity: n)
        sk_path_get_points(handle, ptr, Int32 (n))
        var ret: [Point] = []
        ptr.withMemoryRebound(to: Point.self, capacity: n) { val in
            
            for idx in 0..<n {
                ret.append((val + idx).pointee)
            }
        }
        return ret
    }
    
    public func contains (x: Float, y: Float) -> Bool
    {
        sk_path_contains(handle, x, y)
    }
    
    public func contains (point: Point) -> Bool
    {
        sk_path_contains(handle, point.x, point.y)
    }
    
    // TODO: offset
    
    public func move (to: Point)
    {
        sk_path_move_to(handle, to.x, to.y)
    }
    
    public func rmove (to: Point)
    {
        sk_path_rmove_to(handle, to.x, to.y)
    }
    
    public func line (to: Point)
    {
        sk_path_line_to(handle, to.x, to.y)
    }
    
    public func rline (to: Point)
    {
        sk_path_rline_to(handle, to.x, to.y)
    }
    
    public func addQuadCurve (to: Point, controlPoint: Point)
    {
        sk_path_quad_to(handle, to.x, to.y, controlPoint.x, controlPoint.y)
    }
    
    public func addRCurve (to: Point, controlPoint: Point)
    {
        sk_path_rquad_to(handle, to.x, to.y, controlPoint.x, controlPoint.y)
    }
    
    public func conic (to: Point, and: Point, weightedBy: Float)
    {
        sk_path_conic_to(handle, to.x, to.y, and.x, and.y, weightedBy)
    }
    
    public func rconic (to: Point, and: Point, weightedBy: Float)
    {
        sk_path_rconic_to(handle, to.x, to.y, and.x, and.y, weightedBy)
    }
    
    public func cubic (to: Point, controlPoint1: Point, controlPoint2: Point)
    {
        sk_path_cubic_to(handle, to.x, to.y, controlPoint1.x, controlPoint1.y, controlPoint2.x, controlPoint2.y)
    }
    
    public func rcubic (to: Point, controlPoint1: Point, controlPoint2: Point)
    {
        sk_path_rcubic_to(handle, to.x, to.y, controlPoint1.x, controlPoint1.y, controlPoint2.x, controlPoint2.y)
    }
    
    // TODO: ArcTo
    // TODO: RArcTo
    
    public func close ()
    {
        sk_path_close(handle)
    }
    
    public func rewind ()
    {
        sk_path_rewind(handle)
    }
    
    public func reset ()
    {
        sk_path_reset(handle)
    }
    
    /**
     * Add Rect to the path, appending kMove_Verb, three kLine_Verb, and kClose_Verb,
     * starting with top-left corner of Rect; followed by top-right, bottom-right,
     * and bottom-left if dir is .clockwise direction; or followed by bottom-left,
     * bottom-right, and top-right if dir is .counterClockwise direction
     *
     * - Parameter rect: Rect to add as a closed contour
     * - Parameter dir: Direction to wind added contour
     */
    public func addRect (_ rect: Rect, direction: PathDirection = .clockwise)
    {
        var r = rect.toNative()
        sk_path_add_rect(handle, &r, direction.toNative())
    }
    
    /**
     * Add Rect to the path, appending kMove_Verb, three kLine_Verb, and kClose_Verb,
     * starting with top-left corner of Rect; followed by top-right, bottom-right,
     * and bottom-left if dir is .clockwise direction; or followed by bottom-left,
     * bottom-right, and top-right if dir is .counterClockwise direction
     *
     * - Parameter rect: Rect to add as a closed contour
     * - Parameter dir: Direction to wind added contour
     * - Parameter start: index of initial point of Rect
     */
    public func addRect (_ rect: Rect, direction: PathDirection = .clockwise, start: UInt32)
    {
        var r = rect.toNative()
        sk_path_add_rect_start(handle, &r, direction.toNative(), start)
    }
    
    /**
     * Append RoundedRect to the path, creating a new closed contour. RRect has bounds
     * equal to rect; each corner is 90 degrees of an ellipse with radii (rx, ry). If
     * dir is .clockwise, RRect starts at top-left of the lower-left corner and
     * winds clockwise. If dir is .counterClockwise, RRect starts at the bottom-left
     * of the upper-left corner and winds counterclockwise.
     *
     * If either rx or ry is too large, rx and ry are scaled uniformly until the
     * corners fit. If rx or ry is less than or equal to zero, the method appends
     * the Rect rect to the path.
     * After appending, Path may be empty, or may contain: Rect, Oval, or RoundRect.
     * - Parameter roundedRect: bounds of the rectangle
     * - Parameter Directon to wind the the rectangle
     */
    public func addRoundedRect (_ roundedRect: RoundRect, direction: PathDirection = .clockwise)
    {
        sk_path_add_rrect(handle, roundedRect.handle, direction.toNative())
    }
    
    /**
     * Append RoundedRect to the path, creating a new closed contour. RRect has bounds
     * equal to rect; each corner is 90 degrees of an ellipse with radii (rx, ry). If
     * dir is .clockwise, RRect starts at top-left of the lower-left corner and
     * winds clockwise. If dir is .counterClockwise, RRect starts at the bottom-left
     * of the upper-left corner and winds counterclockwise.
     *
     * If either rx or ry is too large, rx and ry are scaled uniformly until the
     * corners fit. If rx or ry is less than or equal to zero, the method appends
     * the Rect rect to the path.
     * After appending, Path may be empty, or may contain: Rect, Oval, or RoundRect.
     * - Parameter roundedRect: bounds of the rectangle
     * - Parameter Directon to wind the rectangle
     * - Parameter start: index of initial point of RRect
     */
    public func addRoundedRect (_ roundedRect: RoundRect, direction: PathDirection = .clockwise, start: UInt32)
    {
        sk_path_add_rrect_start(handle, roundedRect.handle, direction.toNative(), start)
    }
    
    public func addOval (_ rect: Rect, direction: PathDirection = .clockwise)
    {
        var m = rect.toNative()
        sk_path_add_oval(handle, &m, direction.toNative())
    }
    
    /**
     * Append arc to the path, as the start of new contour. Arc added is part of ellipse
     * bounded by oval, from startAngle through sweepAngle. Both startAngle and
     * sweepAngle are measured in degrees, where zero degrees is aligned with the
     * positive x-axis, and positive sweeps extends arc clockwise.
     *
     * If sweepAngle is less than -360, or sweepAngle is larger than 360; and startAngle modulo 90 is nearly
     * zero, append oval instead of arc. Otherwise, sweepAngle values are treated
     * modulo 360, and arc may or may not draw depending on numeric rounding.
     * - Parameter oval:        bounds of ellipse containing arc
     * - Parameter startAngle:  starting angle of arc in degrees
     * - Parameter sweepAngle  sweep, in degrees. Positive is clockwise; treated modulo 360
     */
    public func addArc (_ rect: Rect, startAngle: Float, sweepAngle: Float)
    {
        var m = rect.toNative()
        sk_path_add_arc(handle, &m, startAngle, sweepAngle)
    }
    
    /**
     * Transform verb array, Point array, and weight by matrix.
     * transform may change verbs and increase their number.
     * Path is replaced by transformed data.
     */
    public func transform (matrix: Matrix)
    {
        var mat = matrix.toNative();
        
        sk_path_transform(handle, &mat)
    }
    
    public enum PathAddMode {
        case append
        case extend
    }
    
    public func addPath (_ other: Path, dx: Float, dy: Float, mode: PathAddMode = .append)
    {
        sk_path_add_path_offset(handle, other.handle, dx, dy, sk_path_add_mode_t (mode == .append ? 0 : 1))
    }
    
    public func addPath (_ other: Path, mode: PathAddMode = .append)
    {
        sk_path_add_path(handle, other.handle, sk_path_add_mode_t (mode == .append ? 0 : 1))
    }

    public func addPath (_ other: Path, matrix: Matrix, mode: PathAddMode = .append)
    {
        var m = matrix.toNative()
        sk_path_add_path_matrix(handle, other.handle, &m, sk_path_add_mode_t (mode == .append ? 0 : 1))
    }

    public func addPathReverse (_ other: Path)
    {
        sk_path_add_path_reverse(handle, other.handle)
    }
    
    public func addCircle (x: Float, y: Float, radius: Float, direction: PathDirection = .clockwise)
    {
        sk_path_add_circle(handle, x, y, radius, direction.toNative())
    }
    
    public func addPoly (points: [Point], close: Bool = true)
    {
        var p : [sk_point_t] = []
        for x in points {
            p.append(x.toNative())
        }
        sk_path_add_poly(handle, &p, Int32 (p.count), close)
    }
    
    public func op (other: Path, op: PathOp, result: Path) -> Bool
    {
        sk_pathop_op(handle, other.handle, op.toNative(), result.handle)
    }
    
    public func op (other: Path, op localop: PathOp) -> Path?
    {
        let res = Path()
        if op (other: other, op: localop, result: res) {
            return res
        }
        return nil
    }
    
    public func simplify (result: Path)
    {
        sk_pathop_simplify(handle, result.handle)
    }
    
    public func simplify () -> Path
    {
        let result = Path ()
        simplify (result: result)
        return result
    }
    
    public func toSvgPathData () -> String
    {
        let res = SKString ()
        sk_path_to_svg_string(handle, res.handle)
        return res.getStr()
    }
    
    public static func parseSvgPathData (svgPath: String) -> Path?
    {
        let path = Path ()
        let success = sk_path_parse_svg_string(path.handle, svgPath)
        if success {
            return path
        }
        return nil
    }
    
    // TODO: ConvertConicToQuads
    // TODO: Iterators
    // TODO: OpBuilder
    deinit
    {
        sk_path_delete(handle)
    }
}
