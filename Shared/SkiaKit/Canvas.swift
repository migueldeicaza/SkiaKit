//
//  SKCanvas.swift
//  SkiaKit
//
//  Created by Miguel de Icaza on 10/15/19.
//  Copyright © 2019 Miguel de Icaza. All rights reserved.
//

import Foundation

public class Canvas {
    var handle: OpaquePointer
    var owns: Bool
    
    public init (_ bitmap : Bitmap)
    {
        handle = sk_canvas_new_from_bitmap(bitmap.handle)
        owns = true
    }
    
    init (handle: OpaquePointer, owns: Bool)
    {
        self.handle = handle
        self.owns = owns
    }
    
    deinit {
        if owns {
            sk_canvas_destroy(handle)
        }
    }
    
    public func drawText (text: String, x: Float, y: Float, paint: Paint)
    {
        let utf8 = text.utf8CString
        
        sk_canvas_draw_text(handle, text, utf8.count, x, y, paint.handle)
    }
    
    public func quickReject (rect: Rect) -> Bool
    {
        withUnsafePointer(to: rect.toNative()) {
            sk_canvas_quick_reject(handle, $0)
        }
    }
    
//    public func quickReject (path: Path) -> Bool
//    {
//
//    }
    
    // TODO: saveLayer
    
    public func save () -> Int32
    {
        sk_canvas_save(handle)
    }
    
    public func drawColor (_ color: Color, blendMode: BlendMode = .src)
    {
        sk_canvas_draw_color(handle, color.color, blendMode.toNative())
    }
    
    public func drawLine (_ p0: Point, _ p1: Point, paint: Paint)
    {
        sk_canvas_draw_line(handle, p0.x, p0.y, p1.x, p1.y, paint.handle)
    }

    public func drawLine (x0: Float, y0: Float, x1: Float, y1: Float, paint: Paint)
    {
        sk_canvas_draw_line(handle, x0, y0, x1, y1, paint.handle)
    }

    public func clear ()
    {
        drawColor(Colors.empty(), blendMode: .src)
    }
    public func clear (color: Color)
    {
        drawColor(color, blendMode: .src)
    }
    
    public func restore ()
    {
        sk_canvas_restore(handle)
    }
    
    public func restoreToCount (count: Int32)
    {
        sk_canvas_restore_to_count(handle, count)
    }
    
    public func translate (dx: Float, dy: Float)
    {
        sk_canvas_translate(handle, dx, dy)
    }

    public func translate (pt: Point)
    {
        sk_canvas_translate(handle, pt.x, pt.y)
    }
    
    public func scale (_ scale: Float)
    {
        sk_canvas_scale (handle, scale, scale)
    }
    
    public func scale (sx: Float, sy: Float)
    {
        sk_canvas_scale (handle, sx, sy)
    }
    
    public func scale (size: Point)
    {
        sk_canvas_scale(handle, size.x, size.y)
    }
    
    /**
     *
     * - Parameter pivot: the pivot point for the scale to take place
     */
    public func scale (sx: Float, sy: Float, pivot: Point)
    {
        translate(pt: pivot)
        scale (sx: sx, sy: sy)
        translate (pt: -pivot)
    }
    
    public func rotate (degrees: Float)
    {
        sk_canvas_rotate_degrees(handle, degrees)
    }
    
    public func rotate (radians: Float)
    {
        sk_canvas_rotate_radians(handle, radians)
    }
    
    public func rotate (degrees: Float, pivot: Point)
    {
        translate(pt: pivot)
        sk_canvas_rotate_degrees(handle, degrees)
        translate(pt: -pivot)
    }
    
    public func rotate (radians: Float, pivot: Point)
    {
        translate(pt: pivot)
        sk_canvas_rotate_radians(handle, radians)
        translate(pt: -pivot)
    }
    
    public func skew (sx: Float, sy: Float)
    {
        sk_canvas_skew(handle,sx, sy)
    }
    
//    public func concat (matrix: inout Matrix)
//    {
//
//    }
    
    public func clip (rect: Rect, operation: ClipOperation = .intersect, antialias: Bool = false)
    {
        withUnsafePointer(to: rect.toNative()) {
            sk_canvas_clip_rect_with_operation(handle, $0, operation.toNative (), antialias)
        }
    }
    
    public func clip (roundedRect: RoundRect, operation: ClipOperation = .intersect, antialias: Bool = false)
    {
        sk_canvas_clip_rrect_with_operation(handle, roundedRect.handle, operation.toNative(), antialias)
    }
    
    public func clip (path: Path, operation: ClipOperation = .intersect, antialias: Bool = false)
    {
        sk_canvas_clip_path_with_operation(handle, path.handle, operation.toNative(), antialias)
    }
    
    public func clip (region: Region, operation: ClipOperation = .intersect)
    {
        sk_canvas_clip_region(handle, region.handle, operation.toNative())
    }
    
    public var localClipBounds : Rect {
        get {
            let (b, _) = getLocalClipBounds()
            return b
        }
    }
    
    public var deviceClipounds: IRect {
        get {
            let (b, _) = getDeviceClipBounds()
            return b
        }
    }
    public func getLocalClipBounds () -> (bounds: Rect, empty: Bool)
    {
        let bounds = UnsafeMutablePointer<sk_rect_t>.allocate(capacity: 1);
        
        let notEmpty = sk_canvas_get_local_clip_bounds(handle, bounds)
        return (Rect.fromNative (bounds.pointee), !notEmpty)
    }
    
    public func getDeviceClipBounds () -> (bounds: IRect, empty: Bool)
    {
        let bounds = UnsafeMutablePointer<sk_irect_t>.allocate(capacity: 1);
        
        let notEmpty = sk_canvas_get_device_clip_bounds(handle, bounds)
        return (IRect.fromNative (bounds.pointee), !notEmpty)
    }
    
    public func draw (_ paint: Paint)
    {
        sk_canvas_draw_paint (handle, paint.handle)
    }
    
    public func drawRegion (_ region: Region, _ paint: Paint)
    {
        sk_canvas_draw_region(handle, region.handle, paint.handle)
    }
    
    public func drawRect (_ rect: Rect, _ paint: Paint)
    {
        withUnsafePointer(to: rect.toNative()) { ptr in
            sk_canvas_draw_rect(handle, ptr, paint.handle)
        }
    }
    
    public func drawRoundRect (_ roundedRect: RoundRect, _ paint: Paint)
    {
        sk_canvas_draw_rrect(handle, roundedRect.handle, paint.handle)
    }
    
    public func drawRoundRect (_ rect: Rect, rx: Float, ry: Float, _ paint: Paint)
    {
        withUnsafePointer(to: rect.toNative()) { ptr in
            sk_canvas_draw_round_rect(handle, ptr, rx, ry, paint.handle)
        }
    }
        
    public func drawOval (_ rect: Rect, paint: Paint)
    {
        withUnsafePointer(to: rect.toNative()) { ptr in
            sk_canvas_draw_oval(handle, ptr, paint.handle)
        }
    }
    
    public func drawCircle (_ cx: Float, _ cy: Float, _ radius: Float, _ paint: Paint)
    {
        sk_canvas_draw_circle(handle, cx, cy, radius, paint.handle)
    }
    
    public func drawCircle (_ point: Point, _ radius: Float, _ paint: Paint)
    {
        sk_canvas_draw_circle(handle, point.x, point.y, radius, paint.handle)
    }
    
    public func drawPath (_ path: Path, _ paint: Paint)
    {
        sk_canvas_draw_path(handle, path.handle, paint.handle)
    }
    
    public func drawPoints (_ pointMode: PointMode, _ points: [Point], _ paint: Paint)
    {
        var nativePoints: [sk_point_t] = []
        for x in points {
            nativePoints.append(x.toNative ())
        }
        
        sk_canvas_draw_points(handle, pointMode.toNative(), points.count, nativePoints, paint.handle)
    }
    
    public func drawPoint (_ x: Float, _ y: Float, _ paint: Paint)
    {
        sk_canvas_draw_point(handle, x, y, paint.handle)
    }
    
    public func drawPoint (_ x: Float, _ y: Float, _ color: Color)
    {
        let paint = Paint()
        paint.color = color
        drawPoint (x, y, paint)
    }
    
    public func drawImage (_ image: Image, _ x: Float, _ y: Float, _ paint: Paint? = nil)
    {
        sk_canvas_draw_image(handle, image.handle, x, y, paint == nil ? nil : paint!.handle)
    }
    
    public func drawImage (_ image: Image, _ dest: Rect, _ paint: Paint? = nil)
    {
        withUnsafePointer(to: dest.toNative()) { ptr in
            sk_canvas_draw_image_rect(handle, image.handle, nil, ptr, paint == nil ? nil : paint!.handle)
        }
    }
    
    public func drawImage (_ image: Image, source: Rect, dest: Rect, _ paint: Paint? = nil)
    {
        withUnsafePointer(to: dest.toNative()) { destPtr in
            withUnsafePointer(to: source.toNative()) { srcPtr in
                sk_canvas_draw_image_rect(handle, image.handle, srcPtr, destPtr, paint == nil ? nil : paint!.handle)
            }
        }
    }
    
    // TODO drawPicture
    // TODO drawDrawable
    
    public func drawBitmap (_ bitmap: Bitmap, _ point: Point, _ paint: Paint? = nil)
    {
        drawBitmap(bitmap, point.x, point.y, paint)
    }
    
    public func drawBitmap (_ bitmap: Bitmap, _ left: Float, _ top: Float, _ paint: Paint? = nil )
    {
        sk_canvas_draw_bitmap(handle, bitmap.handle, left, top, paint == nil ? nil : paint!.handle)
    }

    public func drawBitmap (_ bitmap: Bitmap, _ dest: Rect, _ paint: Paint? = nil )
    {
        withUnsafePointer(to: dest.toNative()) { rectPtr in
            sk_canvas_draw_bitmap_rect(handle, bitmap.handle, nil, rectPtr, paint == nil ? nil : paint!.handle)
        }
    }

    public func drawBitmap (_ bitmap: Bitmap, source: Rect, dest: Rect, _ paint: Paint? = nil )
    {
        withUnsafePointer(to: dest.toNative()) { destPtr in
            withUnsafePointer(to: source.toNative()) { srcPtr in
                sk_canvas_draw_bitmap_rect(handle, bitmap.handle, srcPtr, destPtr, paint == nil ? nil : paint!.handle)
            }
        }
    }

    // TODO: drawSurface
    
    public func drawText (_ text: String, _ x: Float, _ y: Float, paint: Paint)
    {
        sk_canvas_draw_text(handle, text, text.utf8CString.count, x, y, paint.handle)
    }

    public func drawTextBlob (_ textBlob: TextBlob, _ x: Float, _ y: Float, paint: Paint)
    {
        sk_canvas_draw_text_blob(handle, textBlob.handle, x, y, paint.handle)
    }
    
    public func drawPositionedText (_ text: String, _ points: [Point], _ paint: Paint)
    {
        var nativePoints: [sk_point_t] = []
        for x in points {
            nativePoints.append(x.toNative ())
        }
        
        sk_canvas_draw_pos_text(handle, text, text.utf8CString.count, nativePoints, paint.handle)
    }
    
    public func drawTextOnPath (_ text: String, _ path: Path, _ hOffset: Float, _ vOffset: Float, _ paint: Paint)
    {
        sk_canvas_draw_text_on_path(handle, text, text.utf8CString.count, path.handle, hOffset, vOffset, paint.handle)
    }
    
    public func flush ()
    {
        sk_canvas_flush(handle)
    }
    
    public func drawBitmapNinePatch (_ bitmap: Bitmap, _ center: IRect, _ dest: Rect, _ paint: Paint? = nil)
    {
        withUnsafePointer(to: dest.toNative()) { destPtr in
            withUnsafePointer(to: center.toNative()) { centerPtr in
                sk_canvas_draw_bitmap_nine(handle, bitmap.handle, centerPtr, destPtr, paint == nil ? nil : paint!.handle)
            }
        }
    }
    
    public func drawImageNinePatch (_ image: Image, _ center: IRect, _ dest: Rect, _ paint: Paint? = nil)
    {
        withUnsafePointer(to: dest.toNative()) { destPtr in
            withUnsafePointer(to: center.toNative()) { centerPtr in
                sk_canvas_draw_image_nine(handle, image.handle, centerPtr, destPtr, paint == nil ? nil : paint!.handle)
            }
        }
    }
    
    // TODO: drawAnnotation
    // TODO: drawUrlAnnotation
    // TODO: drawNamedDestinationAnnotation
    // TODO: drawLinkDestinationAnnotation
    // TODO: DrawBitmapLattice
    // TODO: DrawImageLattice
    // TODO: drawVertices
    
    public func resetMatrix ()
    {
        sk_canvas_reset_matrix(handle)
    }
    
    public func setMatrix (_ matrix: Matrix)
    {
        withUnsafePointer (to: matrix.toNative()) { matrixPtr in
            sk_canvas_set_matrix(handle, matrixPtr)
        }
    }
    
    public var totalMatrix: Matrix {
        get {
            let matrix = UnsafeMutablePointer<sk_matrix_t>.allocate(capacity: 1);
            sk_canvas_get_total_matrix(handle, matrix)
            return Matrix.fromNative (m: matrix.pointee)
        }
    }
    
    public var saveCount: Int32 {
        get {
            sk_canvas_get_save_count(handle)
        }
    }
}
