//
//  ImageFilter.swift
//  SkiaKit
//
//  Created by Miguel de Icaza on 10/17/19.
//  Copyright © 2019 Miguel de Icaza. All rights reserved.
//

import Foundation
#if canImport(CSkiaSharp)
import CSkiaSharp
#endif

public final class ImageFilter {
    var handle : OpaquePointer
    init (handle: OpaquePointer)
    {
        self.handle = handle
    }
    
    deinit
    {
        sk_imagefilter_unref(handle)
    }
    // sk_imagefilter_croprect_new
    //sk_imagefilter_croprect_new_with_rect
    //sk_imagefilter_croprect_destructor
    //sk_imagefilter_croprect_get_rect
    //sk_imagefilter_croprect_get_flags
    //sk_imagefilter_unref
    //sk_imagefilter_new_matrix
    //sk_imagefilter_new_alpha_threshold
    //sk_imagefilter_new_blur
    //sk_imagefilter_new_color_filter
    //sk_imagefilter_new_compose
    //sk_imagefilter_new_displacement_map_effect
    //sk_imagefilter_new_drop_shadow
    //sk_imagefilter_new_distant_lit_diffuse
    //sk_imagefilter_new_point_lit_diffuse
    //sk_imagefilter_new_spot_lit_diffuse
    //sk_imagefilter_new_distant_lit_specular
    //sk_imagefilter_new_point_lit_specular
    //sk_imagefilter_new_spot_lit_specular
    //sk_imagefilter_new_magnifier
    //sk_imagefilter_new_matrix_convolution
    //sk_imagefilter_new_merge
    //sk_imagefilter_new_dilate
    //sk_imagefilter_new_erode
    //sk_imagefilter_new_offset
    //sk_imagefilter_new_picture
    //sk_imagefilter_new_picture_with_croprect
    //sk_imagefilter_new_tile
    //sk_imagefilter_new_xfermode
    //sk_imagefilter_new_arithmetic
    //sk_imagefilter_new_image_source
    //sk_imagefilter_new_image_source_default
    //sk_imagefilter_new_paint

}
