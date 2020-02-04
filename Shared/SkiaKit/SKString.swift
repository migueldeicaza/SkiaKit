//
//  SKString.swift
//  SkiaKit
//
//  Created by Miguel de Icaza on 10/21/19.
//  Copyright © 2019 Miguel de Icaza. All rights reserved.
//

import Foundation
import CSkiaSharp

final class SKString {
    var handle: OpaquePointer
    
    init (str: String)
    {
        handle = sk_string_new_with_copy(str, str.utf8CString.count)
    }
    
    init ()
    {
        handle = sk_string_new_empty()
    }
    
    public func getStr () -> String
    {
        return String (cString: sk_string_get_c_str(handle))
    }
}
