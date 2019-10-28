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
public class TextBlob {
    var handle: OpaquePointer
    
    init (handle: OpaquePointer)
    {
        self.handle = handle
    }
    
    public func getUniqueId () -> UInt32
    {
        sk_textblob_get_unique_id(handle)
    }
    
    deinit {
        sk_textblob_unref(handle)
    }
}
