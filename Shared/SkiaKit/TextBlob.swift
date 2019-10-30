//
//  TextBlob.swift
//  SkiaKit
//
//  Created by Miguel de Icaza on 10/18/19.
//  Copyright © 2019 Miguel de Icaza. All rights reserved.
//

import Foundation

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
}

