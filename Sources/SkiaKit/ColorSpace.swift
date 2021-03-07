//
//  ColorSpace.swift
//  SkiaKit
//
//  Created by Miguel de Icaza on 10/16/19.
//  Copyright © 2019 Miguel de Icaza. All rights reserved.
//

import Foundation
#if canImport(CSkiaSharp)
import CSkiaSharp
#endif

public final class ColorSpace {
    var handle: OpaquePointer
    
    public init ()
    {
        handle = OpaquePointer(bitPattern: 0)!
    }
    
    init (handle: OpaquePointer)
    {
        self.handle = handle
    }
    
    deinit {
        sk_colorspace_unref(handle)
    }
    
    //sk_color4f_from_color
    //sk_color4f_t
    //sk_color4f_to_color
    //sk_colorspace_DEFINED
    //sk_colorspace_equals
    //sk_colorspace_gamma_close_to_srgb
    //sk_colorspace_gamma_is_linear
    //sk_colorspace_icc_profile_delete
    //sk_colorspace_icc_profile_get_buffer
    //sk_colorspace_icc_profile_get_to_xyzd50
    //sk_colorspace_icc_profile_new
    //sk_colorspace_icc_profile_parse
    //sk_colorspace_icc_profile_t
    //sk_colorspace_is_numerical_transfer_fn
    //sk_colorspace_is_srgb
    //sk_colorspace_make_linear_gamma
    //sk_colorspace_make_srgb_gamma
    //sk_colorspace_new_icc
    //sk_colorspace_new_rgb
    //sk_colorspace_new_srgb
    //sk_colorspace_new_srgb_linear
    //sk_colorspace_primaries_t
    //sk_colorspace_primaries_to_xyzd50
    //sk_colorspace_ref
    //sk_colorspace_t
    //sk_colorspace_to_profile
    //sk_colorspace_to_xyzd50
    //sk_colorspace_transfer_fn_eval
    //sk_colorspace_transfer_fn_invert
    //sk_colorspace_transfer_fn_named_2dot2
    //sk_colorspace_transfer_fn_named_hlg
    //sk_colorspace_transfer_fn_named_linear
    //sk_colorspace_transfer_fn_named_pq
    //sk_colorspace_transfer_fn_named_rec2020
    //sk_colorspace_transfer_fn_named_srgb
    //sk_colorspace_transfer_fn_t
    //sk_colorspace_xyz_concat
    //sk_colorspace_xyz_invert
    //sk_colorspace_xyz_named_adobe_rgb
    //sk_colorspace_xyz_named_dcip3
    //sk_colorspace_xyz_named_rec2020
    //sk_colorspace_xyz_named_srgb
    //sk_colorspace_xyz_named_xyz
    //sk_colorspace_xyz_t

}
