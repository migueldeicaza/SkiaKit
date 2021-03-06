//
//  MaskFilter.swift
//  SkiaKit
//
//  Created by Miguel de Icaza on 10/17/19.
//  Copyright © 2019 Miguel de Icaza. All rights reserved.
//

import Foundation
#if canImport(CSkiaSharp)
import CSkiaSharp
#endif

public final class MaskFilter {
    var handle : OpaquePointer
    init (handle: OpaquePointer)
    {
        self.handle = handle
    }
    
    deinit
    {
        sk_maskfilter_unref(handle)
    }
    //sk_maskfilter_new_blur
    //sk_maskfilter_new_blur_with_flags
    //sk_maskfilter_new_clip
    //sk_maskfilter_new_gamma
    //sk_maskfilter_new_shader
    //sk_maskfilter_new_table
    //sk_maskfilter_ref

}
