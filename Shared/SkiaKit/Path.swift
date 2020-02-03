//
//  Path.swift
//  SkiaKit
//
//  Created by Miguel de Icaza on 10/17/19.
//  Copyright © 2019 Miguel de Icaza. All rights reserved.
//

import Foundation
import CSkiaSharp

/**
 * `Path` contain geometry. `Path` may be empty, or contain one or more verbs that
 * outline a figure. `Path` always starts with a move verb to a Cartesian coordinate,
 * and may be followed by additional verbs that add lines or curves.
 * Adding a close verb makes the geometry into a continuous loop, a closed contour.
 * `Path` may contain any number of contours, each beginning with a move verb.
 *
 * `Path` contours may contain only a move verb, or may also contain lines,
 * quadratic beziers, conics, and cubic beziers. `Path` contours may be open or
 * closed.
 *
 * When used to draw a filled area, `Path` describes whether the fill is inside or
 * outside the geometry. `Path` also describes the winding rule used to fill
 * overlapping contours.
 *
 * The various commands that add to the path provide a fluid interface, meaning that
 * calling the methods return the instance on which it was invoked, easily allowing
 * the drawing operations to be concatenated.
 */
public final class Path {
    var handle : OpaquePointer
    init (handle: OpaquePointer)
    {
        self.handle = handle
    }
    
    /**
     * Constructs an empty `Path`. By default, `Path` has no verbs, no points, and no weights.
     * the `fillType` is set to `.winding`
     */
    public init ()
    {
        handle = sk_path_new()
    }
    
    /**
     * Returns FillType, the rule used to fill Path. FillType of a new Path is .winding
     */
    public var fillType : FillType {
        get {
            return FillType.fromNative (sk_path_get_filltype(handle))
        }
        set {
            sk_path_set_filltype(handle, newValue.toNative())
        }
    }
    
    public var convexity: Convexity {
        get {
            return Convexity.fromNative(sk_path_get_convexity(handle))
        }
        set {
            sk_path_set_convexity(handle, newValue.toNative ())
        }
    }
    
    /// Returns the number of elements on the verb array containing the draw operations
    public var verbCount: Int32 { sk_path_count_verbs(handle) }
    
    public var isConvex:  Bool { convexity == .convex }
    public var isConcave: Bool { convexity == .concave }
    
    /**
     * Returns if `Path` is empty.
     * Empty `Path` may have FillType but has no `Point`, `Path.verb`, or conic weight.
     * `Path`() constructs empty `Path`; reset() and rewind() make `Path` empty.
     */
    public var isEmpty: Bool { verbCount == 0 }
    public var isOval: Bool { sk_path_is_oval(handle, nil) }
    public var isRoundedRect: Bool { sk_path_is_rrect(handle, nil) }
    public var isLine: Bool { sk_path_is_line(handle, nil) }
    public var isRect: Bool { sk_path_is_rect(handle, nil, nil, nil) }

    /**
     * Returns the number of points in SkPath.
     * the count is initially zero.
     */
    public var pointCount: Int32 { sk_path_count_points(handle) }
    
    /**
     * Returns a mask, where each set bit corresponds to a SegmentMask constant
     * if `Path` contains one or more verbs of that type.
     * Returns zero if `Path` contains no lines, or curves: quads, conics, or cubics.
     * `egmentMasks` returns a cached result; it is very fast.
     */
    public var segmentMasks: SegmentMask { SegmentMask.init (rawValue: sk_path_get_segment_masks(handle))! }
    
    /**
     * Returns `Point` at index in `Point` array. Valid range for index is
     * 0 to countPoints() - 1.
     * Returns (0, 0) if index is out of range.
     * - Parameter index: `Point` array element selector
     * - Returns: `Point` array value or (0, 0)
     */
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
    
    /**
     * Returns minimum and maximum axes values of `Point` array.
     * Returns (0, 0, 0, 0) if `Path` contains no points. Returned bounds width and height may
     * be larger or smaller than area affected when `Path` is drawn.
     * `Rect` returned includes all `Point` added to `Path`, including `Point` associated with
     * `.move` that define empty contours.
     * - Returns: bounds of all `Point` in `Point` array
     */
    public var bounds: Rect {
        get {
            var rect: sk_rect_t = sk_rect_t()
            
            sk_path_get_bounds(handle, &rect)
            return Rect.fromNative(rect)
        }
    }
    
    /**
     * Returns minimum and maximum axes values of the lines and curves in `Path`.
     * Returns (0, 0, 0, 0) if `Path` contains no points.
     * Returned bounds width and height may be larger or smaller than area affected
     * when `Path` is drawn.
     * Includes `Point` associated with `.move` that define empty
     * contours.
     * Behaves identically to `bounds` when `Path` contains
     * only lines. If `Path` contains curves, computed bounds includes
     * the maximum extent of the quad, conic, or cubic; is slower than `bounds`
     * and unlike `bounds`, does not cache the result.
     *
     * - Returns: tight bounds of curves in `Path`
     */
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
    
    public func getRect () -> (rect: Rect, isClosed: Bool, direction: Direction)
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
    
    /**
     * Returns true if the point (x, y) is contained by `Path`, taking into
     * account FillType.
     * - Parameter x: x-axis value of containment test
     * - Parameter y: y-axis value of containment test
     * - Returns: true if `Point` is in `Path`
     */
    public func contains (x: Float, y: Float) -> Bool
    {
        sk_path_contains(handle, x, y)
    }
    
    /**
     * Returns true if the point (x, y) is contained by `Path`, taking into
     * account FillType.
     * - Parameter point: point of containment test
     * - Returns: true if `Point` is in `Path`
     */
    public func contains (point: Point) -> Bool
    {
        sk_path_contains(handle, point.x, point.y)
    }
    
    public func offset (_ pt: Point)
    {
        transform (matrix: Matrix.makeTranslation(sx: pt.x, sy: pt.y))   
    }

    public func offset (x: Float, y: Float)
    {
        transform (matrix: Matrix.makeTranslation(sx: x, sy: y))
    }

    @discardableResult
    public func move (to: Point) -> Path
    {
        sk_path_move_to(handle, to.x, to.y)
        return self
    }

    @discardableResult
    public func moveTo (_ x: Float, _ y: Float) -> Path
    {
        sk_path_move_to(handle, x, y)
        return self
    }

    @discardableResult
    public func rmove (to: Point) -> Path
    {
        sk_path_rmove_to(handle, to.x, to.y)
        return self
    }

    @discardableResult
    public func rmoveTo (_ x: Float, _ y: Float) -> Path
    {
        sk_path_rmove_to(handle, x, y)
        return self
    }

    @discardableResult
    public func line (to: Point) -> Path
    {
        sk_path_line_to(handle, to.x, to.y)
        return self
    }
    
    @discardableResult
    public func lineTo (_ x: Float, _ y: Float) -> Path
    {
        sk_path_line_to(handle, x, y)
        return self
    }
    
    @discardableResult
    public func rline (to: Point) -> Path
    {
        sk_path_rline_to(handle, to.x, to.y)
        return self
    }

    @discardableResult
    public func rlineTo (_ x: Float, _ y: Float) -> Path
    {
        sk_path_rline_to(handle, x, y)
        return self
    }

    /**
     * Adds quad from last point towards `p1`, to `p2`
     * If `Path` is empty, or last `Path.verb` is `.close`, last point is set to (0, 0)
     * before adding quad.
     * Appends `.move` verb to verb array and (0, 0) to `Point` array, if needed;
     * then appends `.quad` to verb array; and `Point` p1, p2
     * to `Point` array.
     * - Parameter p1: control `Point` of added quad
     * - Parameter p2: end `Point` of added quad
     * - Returns: the path
     */
    @discardableResult
    public func quadCurve (to: Point, controlPoint: Point) -> Path
    {
        sk_path_quad_to(handle, to.x, to.y, controlPoint.x, controlPoint.y)
        return self
    }
    
    @discardableResult
    public func rcurve (to: Point, controlPoint: Point) -> Path
    {
        sk_path_rquad_to(handle, to.x, to.y, controlPoint.x, controlPoint.y)
        return self
    }
    
    @discardableResult
    public func conic (to: Point, and: Point, weightedBy: Float) -> Path
    {
        sk_path_conic_to(handle, to.x, to.y, and.x, and.y, weightedBy)
        return self
    }
    
    @discardableResult
    public func rconic (to: Point, and: Point, weightedBy: Float) -> Path
    {
        sk_path_rconic_to(handle, to.x, to.y, and.x, and.y, weightedBy)
        return self
    }
    
    @discardableResult
    public func cubic (to: Point, controlPoint1: Point, controlPoint2: Point)  -> Path
    {
        sk_path_cubic_to(handle, to.x, to.y, controlPoint1.x, controlPoint1.y, controlPoint2.x, controlPoint2.y)
        return self
    }

    @discardableResult
    public func cubicTo (_ x0: Float, _ y0: Float, _ x1: Float, _ y1: Float, _ x2: Float, _ y2: Float) -> Path
    {
        sk_path_cubic_to(handle, x0, y0, x1, y1, x2, y2)
        return self
    }

    @discardableResult
    public func rcubic (to: Point, controlPoint1: Point, controlPoint2: Point)  -> Path
    {
        sk_path_rcubic_to(handle, to.x, to.y, controlPoint1.x, controlPoint1.y, controlPoint2.x, controlPoint2.y)
        return self
    }

    @discardableResult
    public func rcubicTo (_ x0: Float, _ y0: Float, _ x1: Float, _ y1: Float, _ x2: Float, _ y2: Float) -> Path
    {
        sk_path_rcubic_to(handle, x0, y0, x1, y1, x2, y2)
        return self
    }

    /**
     * Appends arc to `Path`. Arc is implemented by one or more conics weighted to
     * describe part of oval with radii (rx, ry) rotated by xAxisRotate degrees. Arc
     * curves from last `Path` `Point` to (x, y), choosing one of four possible routes:
     * clockwise or counterclockwise, and smaller or larger.
     * Arc sweep is always less than 360 degrees. arcTo() appends line to (x, y) if
     * either radii are zero, or if last `Path` `Point` equals (x, y). arcTo() scales radii
     * (rx, ry) to fit last `Path` `Point` and (x, y) if both are greater than zero but
     * too small.
     * arcTo() appends up to four conic curves.
     * arcTo() implements the functionality of SVG arc, although SVG sweep-flag value
     * is opposite the integer value of sweep; SVG sweep-flag uses 1 for clockwise,
     * while kCW_Direction cast to int is zero.
     * - Parameter radius: radius on x-axis and y-aix before x-axis, y-axis rotation
     * - Parameter xAxisRotate: x-axis rotation in degrees; positive values are clockwise
     * - Parameter largeArc: chooses smaller or larger arc
     * - Parameter sweep: chooses clockwise or counterclockwise arc
     * - Parameter end: end of arc
     */
    @discardableResult
    public func arcTo (radius: Point, xAxisRotate: Float, largeArc: Size, sweep: Direction, end: Point) -> Path
    {
        sk_path_arc_to(handle, radius.x, radius.y, xAxisRotate, largeArc.toNative(), sweep.toNative(), end.x, end.y)
        return self
    }
    
    /**
     * Appends arc to `Path`, relative to last `Path` `Point`. Arc is implemented by one or
     * more conic, weighted to describe part of oval with radii (rx, ry) rotated by
     * xAxisRotate degrees. Arc curves from last `Path` `Point` to relative end `Point`:
     * (dx, dy), choosing one of four possible routes: clockwise or
     * counterclockwise, and smaller or larger. If `Path` is empty, the start arc `Point`
     * is (0, 0).
     * Arc sweep is always less than 360 degrees. arcTo() appends line to end `Point`
     * if either radii are zero, or if last `Path` `Point` equals end `Point`.
     * arcTo() scales radii (rx, ry) to fit last `Path` `Point` and end `Point` if both are
     * greater than zero but too small to describe an arc.
     * arcTo() appends up to four conic curves.
     * arcTo() implements the functionality of svg arc, although SVG "sweep-flag" value is
     * opposite the integer value of sweep; SVG "sweep-flag" uses 1 for clockwise, while
     * `.direction` cast to int is zero.
     * - Parameter radius: radius before the rotation
     * - Parameter xAxisRotate: x-axis rotation in degrees; positive values are clockwise
     * - Parameter largeArc: chooses smaller or larger arc
     * - Parameter sweep: chooses clockwise or counterclockwise arc
     * - Parameter offset:  offset end of arc from last `Path` `Point`
     */
    @discardableResult
    public func rarcTo (radius: Point, xAxisRotate: Float, largeArc: Size, sweep: Direction, offset: Point) -> Path
    {
        sk_path_rarc_to(handle, radius.x, radius.y, xAxisRotate, largeArc.toNative(), sweep.toNative(), offset.x, offset.y)
        return self
    }
    
    /**
     * Appends arc to `Path`. Arc added is part of ellipse
     * bounded by oval, from startAngle through sweepAngle. Both startAngle and
     * sweepAngle are measured in degrees, where zero degrees is aligned with the
     * positive x-axis, and positive sweeps extends arc clockwise.
     * arcTo() adds line connecting `Path` last `Point` to initial arc `Point` if forceMoveTo
     * is false and `Path` is not empty. Otherwise, added contour begins with first point
     * of arc. Angles greater than -360 and less than 360 are treated modulo 360.
     * - Parameter oval: bounds of ellipse containing arc
     * - Parameter startAngle: starting angle of arc in degrees
     * - Parameter sweepAngle: sweep, in degrees. Positive is clockwise; treated modulo 360
     * - Parameter forceMoveTo: true to start a new contour with arc
     */
    @discardableResult
    public func arcTo (oval: Rect, startAngle: Float, sweepAngle: Float, forceMoveTo: Bool) -> Path
    {
        var o = oval.toNative()
        sk_path_arc_to_with_oval(handle, &o, startAngle, sweepAngle, forceMoveTo)
        return self
    }
    
    /**
     * Appends arc to `Path`, after appending line if needed. Arc is implemented by conic
     * weighted to describe part of circle. Arc is contained by tangent from
     * last `Path` point to (x1, y1), and tangent from (x1, y1) to (x2, y2). Arc
     * is part of circle sized to radius, positioned so it touches both tangent lines.
     * If last Path Point does not start Arc, arcTo appends connecting Line to Path.
     * The length of Vector from (x1, y1) to (x2, y2) does not affect Arc.
     * Arc sweep is always less than 180 degrees. If radius is zero, or if
     * tangents are nearly parallel, arcTo appends Line from last Path Point to (x1, y1).
     * arcTo appends at most one Line and one conic.
     * arcTo implements the functionality of PostScript arct and HTML Canvas arcTo.
     * - Parameter x1: x-axis value common to pair of tangents
     * - Parameter y1: y-axis value common to pair of tangents
     * - Parameter x2: x-axis value end of second tangent
     * - Parameter y2: y-axis value end of second tangent
     * - Parameter radius: distance from arc to circle center
     */
    @discardableResult
    public func arcTo (x1: Float, y1: Float, x2: Float, y2: Float, radius: Float) -> Path
    {
        sk_path_arc_to_with_points(handle, x1, y1, x2, y2, radius)
        return self
    }

    /**
     * Appends `.close` to `Path`. A closed contour connects the first and last `Point`
     * with line, forming a continuous loop. Open and closed contour draw the same
     * with `Paint.Fill`. With `Paint.Stroke`, open contour draws
     * `Paint.Cap` at contour start and end; closed contour draws
     * `Paint.Join`::Join at contour start and end.
     * close() has no effect if `Path` is empty or last `Path` `.close`
     */
    public func close ()
    {
        sk_path_close(handle)
    }
    
    /**
     * Sets `Path` to its initial state, preserving internal storage.
     * Removes verb array, `Point` array, and weights, and sets FillType to kWinding_FillType.
     * Internal storage associated with `Path` is retained.
     * Use rewind() instead of reset() if `Path` storage will be reused and performance
     * is critical.
     */
    public func rewind ()
    {
        sk_path_rewind(handle)
    }
    
    /**
     * Sets `Path` to its initial state.
     * Removes verb array, `Point` array, and weights, and sets FillType to kWinding_FillType.
     * Internal storage associated with `Path` is released.
     *
     */
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
    @discardableResult
    public func addRect (_ rect: Rect, direction: Direction = .clockwise) -> Path
    {
        var r = rect.toNative()
        sk_path_add_rect(handle, &r, direction.toNative())
        return self
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
    @discardableResult
    public func addRect (_ rect: Rect, direction: Direction = .clockwise, start: UInt32) -> Path
    {
        var r = rect.toNative()
        sk_path_add_rect_start(handle, &r, direction.toNative(), start)
        return self
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
    @discardableResult
    public func addRoundedRect (_ roundedRect: RoundRect, direction: Direction = .clockwise) -> Path
    {
        sk_path_add_rrect(handle, roundedRect.handle, direction.toNative())
        return self
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
    @discardableResult
    public func addRoundedRect (_ roundedRect: RoundRect, direction: Direction = .clockwise, start: UInt32) -> Path
    {
        sk_path_add_rrect_start(handle, roundedRect.handle, direction.toNative(), start)
        return self
    }
    
    /**
     * Adds oval to path, appending kMove_Verb, four kConic_Verb, and kClose_Verb.
     * Oval is upright ellipse bounded by `Rect` oval with radii equal to half oval width
     * and half oval height. Oval begins at (oval.fRight, oval.centerY()) and continues
     * clockwise if dir is kCW_Direction, counterclockwise if dir is kCCW_Direction.
     * - Parameter rect: bounds of ellipse added
     * - Parameter direction: `Path`::Direction to wind ellipse
     */
    @discardableResult
    public func addOval (_ rect: Rect, direction: Direction = .clockwise) -> Path
    {
        var m = rect.toNative()
        sk_path_add_oval(handle, &m, direction.toNative())
        return self
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
    @discardableResult
    public func addArc (_ rect: Rect, startAngle: Float, sweepAngle: Float) -> Path
    {
        var m = rect.toNative()
        sk_path_add_arc(handle, &m, startAngle, sweepAngle)
        return self
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
    
    @discardableResult
    public func addPath (_ other: Path, dx: Float, dy: Float, mode: PathAddMode = .append) -> Path
    {
        sk_path_add_path_offset(handle, other.handle, dx, dy, sk_path_add_mode_t (mode == .append ? 0 : 1))
        return self
    }
    
    @discardableResult
    public func addPath (_ other: Path, mode: PathAddMode = .append) -> Path
    {
        sk_path_add_path(handle, other.handle, sk_path_add_mode_t (mode == .append ? 0 : 1))
        return self
    }

    @discardableResult
    public func addPath (_ other: Path, matrix: Matrix, mode: PathAddMode = .append) -> Path
    {
        var m = matrix.toNative()
        sk_path_add_path_matrix(handle, other.handle, &m, sk_path_add_mode_t (mode == .append ? 0 : 1))
        return self
    }

    @discardableResult
    public func addPathReverse (_ other: Path) -> Path
    {
        sk_path_add_path_reverse(handle, other.handle)
        return self
    }
    
    @discardableResult
    public func addCircle (x: Float, y: Float, radius: Float, direction: Direction = .clockwise) -> Path
    {
        sk_path_add_circle(handle, x, y, radius, direction.toNative())
        return self
    }
    
    @discardableResult
    public func addPoly (points: [Point], close: Bool = true) -> Path
    {
        var p : [sk_point_t] = []
        for x in points {
            p.append(x.toNative())
        }
        sk_path_add_poly(handle, &p, Int32 (p.count), close)
        return self
    }
    
    public func op (other: Path, op: Op, result: Path) -> Bool
    {
        sk_pathop_op(handle, other.handle, op.toNative(), result.handle)
    }
    
    public func op (other: Path, op localop: Op) -> Path?
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
    
    /// Four oval parts with radii (rx, ry) start at last SkPath SkPoint and ends at (x, y).
    /// Size and Direction select one of the four oval parts.
    public enum Size : UInt32 {
        // smaller of arc pair
        case small = 0
        // larger of arc pair
        case large
        
        internal func toNative () -> sk_path_arc_size_t
        {
            return sk_path_arc_size_t.init(rawValue)
        }
        
        internal static func fromNative (_ x : sk_path_arc_size_t) -> Size
        {
            return Size.init(rawValue: x.rawValue)!
        }
    }
    

    ///
    /// FillType selects the rule used to fill `Path`. `Path` set to `.winding`
    /// fills if the sum of contour edges is not zero, where clockwise edges add one, and
    /// counterclockwise edges subtract one. `Path` set to `.evenOdd` fills if the
    /// number of contour edges is odd. Each FillType has an inverse variant that
    /// reverses the rule:
    /// `.inverseWinding` fills where the sum of contour edges is zero;
    /// `.inverseEvenOdd` fills where the number of contour edges is even.
    ///
    ///
    public enum FillType : UInt32
    {
        /// Specifies fill as area is enclosed by a non-zero sum of contour directions
        case winding = 0
        /// Specifies fill as area enclosed by an odd number of contours.
        case evenOdd = 1
        /// Specifies fill as area is enclosed by a zero sum of contour directions.
        case inverseWinding = 2
        /// Specifies fill as area enclosed by an even number of contours.
        case inverseEvenOdd = 3
        
        internal func toNative () -> sk_path_filltype_t
        {
           return sk_path_filltype_t.init(rawValue)
        }

        internal static func fromNative (_ x: sk_path_filltype_t) -> FillType
        {
           return FillType.init(rawValue: x.rawValue)!
        }
    }

    ///
    /// `Path` is convex if it contains one contour and contour loops no more than
    /// 360 degrees, and contour angles all have same Direction. Convex `Path`
    /// may have better performance and require fewer resources on GPU surface.
    ///
    /// `Path` is concave when either at least one Direction change is clockwise and
    /// another is counterclockwise, or the sum of the changes in Direction is not 360
    /// degrees.
    ///
    /// Initially `Path` Convexity is kUnknown_Convexity. `Path` Convexity is computed
    /// f needed by destination `Surface`.
    ///
    ///
    public enum Convexity : UInt32 {
        /// Indicates Convexity has not been determined.
        case unknown = 0
        /// Path has one contour made of a simple geometry without indentations.
        case convex = 1
        /// Path has more than one contour, or a geometry with indentations.
        case concave = 2
        
        internal func toNative () -> sk_path_convexity_t
        {
           return sk_path_convexity_t.init(rawValue)
        }

        internal static func fromNative (_ x: sk_path_convexity_t) -> Convexity
        {
           return Convexity.init(rawValue: x.rawValue)!
        }
    }

    /// SegmentMask constants correspond to each drawing Verb type in Path; for
    /// instance, if Path only contains lines, only the `.line` bit is set.
    public enum SegmentMask : UInt32 {
        ///  Set if verb array contains a `.line` verb
        case line = 1
        /// Set if verb array contains `.quad`. Note that `conicTo()` may add a quad.
        case quad = 2
        ///  Set if verb array contains a `.conic` verb
        case conic = 4
        /// Set if verb array contains `.cubic` verb
        case cubic = 8
    }

    ///
    /// `PathDirection` describes whether contour is clockwise or counterclockwise.
    /// When `Path` contains multiple overlapping contours, `PathDirection` together with
    /// `FillType` determines whether overlaps are filled or form holes.
    ///
    /// `PathDirection` also determines how contour is measured. For instance, dashing
    /// measures along `Path` to determine where to start and stop stroke; `PathDirection`
    /// will change dashed results as it steps clockwise or counterclockwise.
    ///
    /// Closed contours like `Rect`, `RRect`, circle, and oval added with
    /// `.clockwise` travel clockwise; the same added with `.counterclockwise`
    /// travel counterclockwise.
    ///
    public enum Direction : UInt32 {
        case clockwise = 0
        case counterClockwise = 1
        
        internal func toNative () -> sk_path_direction_t
        {
            return sk_path_direction_t (rawValue)
        }
        
        internal static func fromNative (_ x: sk_path_direction_t) -> Direction
        {
            return x.rawValue == 0 ? .clockwise : .counterClockwise
        }
    }

    /// The logical operations that can be performed when combining two paths
    public enum Op : UInt32 {
        /// subtract the op path from the first path
        case difference = 0
        /// intersect the two paths
        case intersect = 1
        /// union (inclusive-or) the two paths
        case union = 2
        /// exclusive-or the two paths
        case xor = 3
        /// subtract the first path from the op path
        case reverseDifference = 4
        
        internal func toNative () -> sk_pathop_t
        {
            return sk_pathop_t (rawValue)
        }
        
        internal static func fromNative (_ x: sk_pathop_t) -> Op
        {
            return Op.init(rawValue: x.rawValue)!
        }
    }

}
