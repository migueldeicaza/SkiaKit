//
//  PathEffect.swift
//  SkiaKit
//
//  Created by Miguel de Icaza on 10/17/19.
//  Copyright © 2019 Miguel de Icaza. All rights reserved.
//

import Foundation

/**
 * `PathEffect` is the base class for objects in the `Paint` that affect
 * the geometry of a drawing primitive before it is transformed by the
 * canvas' matrix and drawn.
 * Dashing is implemented as a subclass of `PathEffect`.
 */
public final class PathEffect {
    var handle : OpaquePointer
    init (handle: OpaquePointer)
    {
        self.handle = handle
    }
   
    /**
     * Stamp the specified path to fill the shape, using the matrix to define the latice.
     * - Parameter matrix: <#matrix description#>
     * - Parameter path: <#path description#>
     */
    public static func make2DPath (matrix: inout Matrix, path: Path) -> PathEffect
    {
        PathEffect (handle: sk_path_effect_create_2d_path(&matrix.back, path.handle))
    }
    
    deinit
    {
        sk_path_effect_unref(handle)
    }
}
