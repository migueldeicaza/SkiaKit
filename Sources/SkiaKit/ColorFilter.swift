//
//  ColorFilter.swift
//  SkiaKit
//
//  Created by Miguel de Icaza on 10/17/19.
//  Copyright © 2019 Miguel de Icaza. All rights reserved.
//

import Foundation
#if canImport(CSkiaSharp)
import CSkiaSharp
#endif

public final class ColorFilter {
    var handle : OpaquePointer
    init (handle: OpaquePointer)
    {
        self.handle = handle
    }
    
    deinit
    {
        sk_colorfilter_unref(handle)
    }
    // sk_colorfilter_new_color_matrix
    // sk_colorfilter_new_compose
    // sk_colorfilter_new_high_contrast
    // sk_colorfilter_new_lighting
    // sk_colorfilter_new_luma_color
    // sk_colorfilter_new_mode
    // sk_colorfilter_new_table
    // sk_colorfilter_new_table_argb

}
