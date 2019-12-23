//
//  TextBlob.swift
//  SkiaKit
//
//  Created by Miguel de Icaza on 10/18/19.
//  Copyright © 2019 Miguel de Icaza. All rights reserved.
//

import Foundation
import SkiaSharp

/**
 * `TextBlob` combines multiple text runs into an immutable container. Each text
 * run consists of glyphs, `Paint`, and position. Only parts of `Paint` related to
 * fonts and text rendering are used by run.
 */
public final class TextBlob {
    var handle: OpaquePointer
    
    init (handle: OpaquePointer)
    {
        self.handle = handle
    }
    
    /// Gets the unique, non-zero value representing the text blob.
    public func getUniqueId () -> UInt32
    {
        sk_textblob_get_unique_id(handle)
    }
    
    /// Gets the conservative blob bounding box.
    public var bounds: Rect {
        get {
            var r = sk_rect_t()
            sk_textblob_get_bounds(handle, &r)
            return Rect.fromNative(r)
        }
    }
    
    deinit {
        sk_textblob_unref(handle)
    }
}

/// A builder object that is used to create a `TextBlob`.
public final class TextBlobBuilder {
    var handle: OpaquePointer
    var owns: Bool
    
    init (handle: OpaquePointer, owns: Bool)
    {
        self.handle = handle
        self.owns = owns
    }

    /// Creates a new instance of the TextBlobBuilder
    public init ()
    {
        handle = sk_textblob_builder_new()
        owns = true
    }
    
    deinit {
        if owns {
            sk_textblob_builder_delete(handle)
        }
    }
    
    /**
     * Create the SKTextBlob from all the added runs.
     * - Returns: the new SKTextBlob if there were runs, otherwise null.
     */
    public func build () -> TextBlob
    {
        TextBlob (handle: sk_textblob_builder_make(handle))
    }
    
    /// Adds a new default-positioned run to the builder.
    /// - Parameter font: The font to use for this run
    /// - Parameter x: The x position for this run
    /// - Parameter y: The y position for this run
    /// - Parameter glyphs: The glyphs to use for this run
    public func addRun (font: Paint, x: Float, y: Float, glyphs: [ushort])
    {
        let run = allocateRun(font: font, count: Int32 (glyphs.count), x: x, y: y)
        run.clusters.copyMemory(from: glyphs, byteCount: glyphs.count * 2)
    }
    
    /// Adds a new horizontally-positioned run to the builder.
    /// - Parameter font: The font to use for this run
    /// - Parameter y: The vertical offset within the blob.
    /// - Parameter glyphs: The glyphs to use for this run
    public func addHorizontalRun (font: Paint, y: Float, glyphs: [ushort], positions: [Float])
    {
        let run = allocateHorizontalRun(font: font, count: Int32 (glyphs.count), y: y)
        run.clusters.copyMemory(from: glyphs, byteCount: glyphs.count * 2)
        run.pos.copyMemory(from: positions, byteCount: positions.count * MemoryLayout<Float>.size)
    }

    /// Adds a new horizontally-positioned run to the builder.
    /// - Parameter font: The font to use for this run
    /// - Parameter y: The vertical offset within the blob.
    /// - Parameter glyphs: The glyphs to use for this run
    public func addPositionedRun (font: Paint, y: Float, glyphs: [ushort], positions: [Point])
    {
        let run = allocateHorizontalRun(font: font, count: Int32 (glyphs.count), y: y)
        run.clusters.copyMemory(from: glyphs, byteCount: glyphs.count * 2)
        run.pos.copyMemory(from: positions, byteCount: positions.count * MemoryLayout<Point>.size)
    }

    /**
     * Returns run with storage for glyphs. Caller must write count glyphs to
     * Glyphs share metrics in font.
     * Glyphs are positioned on a baseline at (x, y), using font metrics to
     * determine their relative placement.
     * bounds defines an optional bounding box, used to suppress drawing when `TextBlob`
     * bounds does not intersect `Surface` bounds. If bounds is `nil`, `TextBlob` bounds
     * is computed from (x, y) and RunBuffer::glyphs metrics.
     * - Parameter font: `Font` used for this run
     * - Parameter count: number of glyphs
     * - Parameter x: horizontal offset within the blob
     * - Parameter y: vertical offset within the blob
     * - Parameter textByteCount: number of characters that will be provided
     * - Parameter bounds: optional run bounding box
     * - Returns: writable glyph buffer
     */
    func allocateRun (font: Paint, count: Int32, x: Float, y: Float, textByteCount: Int32 = 0, bounds: Rect? = nil) -> sk_textblob_builder_runbuffer_t
    {
        let lang = SKString()
        var ret = sk_textblob_builder_runbuffer_t ()
        if let b = bounds {
            var nb = b.toNative()
            
            sk_textblob_builder_alloc_run_text(handle, font.handle, count, x, y, textByteCount, lang.handle, &nb, &ret)
        } else {
            sk_textblob_builder_alloc_run_text(handle, font.handle, count, x, y, textByteCount, lang.handle, nil, &ret)
        }
        
        return ret
    }
    
    func allocateHorizontalRun (font: Paint, count: Int32, y: Float, textByteCount: Int32 = 0, bounds: Rect? = nil) -> sk_textblob_builder_runbuffer_t
    {
        let lang = SKString()
        var ret = sk_textblob_builder_runbuffer_t ()
        if let b = bounds {
            var nb = b.toNative()
            
            sk_textblob_builder_alloc_run_text_pos_h(handle, font.handle, count, y, textByteCount, lang.handle, &nb, &ret)
        } else {
            sk_textblob_builder_alloc_run_text_pos_h(handle, font.handle, count, y, textByteCount, lang.handle, nil, &ret)
        }
        
        return ret
    }
    
    func allocatePositionedRun (font: Paint, count: Int32, textByteCount: Int32 = 0, bounds: Rect? = nil) -> sk_textblob_builder_runbuffer_t
    {
        let lang = SKString()
        var ret = sk_textblob_builder_runbuffer_t ()
        if let b = bounds {
            var nb = b.toNative()
            
            sk_textblob_builder_alloc_run_text_pos(handle, font.handle, count, textByteCount, lang.handle, &nb, &ret)
        } else {
            sk_textblob_builder_alloc_run_text_pos(handle, font.handle, count, textByteCount, lang.handle, nil, &ret)
        }
        
        return ret
    }

}

