//
//  Region.swift
//  SkiaKit
//
//  Created by Miguel de Icaza on 10/18/19.
//  Copyright © 2019 Miguel de Icaza. All rights reserved.
//

import Foundation

public final class Region {
    var handle: OpaquePointer
    
    public init ()
    {
        handle = sk_region_new()
    }
    
    public init (region: Region)
    {
        handle = sk_region_new2(region.handle)
    }
    
    deinit {
        sk_region_delete(handle)
    }
    
//    public func contains (region: Region) -> Bool
//    {
//        return sk_region_contains(handle, region.handle)
//    }
    
    
}
