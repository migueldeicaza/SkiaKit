//
//  Data.swift
//  SkiaKit
//
//  Created by Miguel de Icaza on 10/18/19.
//  Copyright © 2019 Miguel de Icaza. All rights reserved.
//

import Foundation

public class Data {
    var handle: OpaquePointer
    
    public init (size: Int = 0)
    {
        if size == 0 {
            handle = sk_data_new_empty()
        } else {
            handle = sk_data_new_uninitialized(size)
        }
    }
    
    public init (data: [UInt8])
    {
        handle = sk_data_new_with_copy(data, data.count)
    }
    
    public static func fromFile (file: String) -> Data?
    {
        if let x = sk_data_new_from_file(file) {
            return Data(handle: x)
        }
        return nil
    }
    
    init (handle: OpaquePointer)
    {
        self.handle = handle
    }
    
    deinit{
        sk_data_unref(handle)
    }
    
    public var size: Int {
        get {
            return sk_data_get_size(handle)
        }
    }
    
    public var isEmpty: Bool {
        get {
            return size == 0
        }
    }
    
    public var data: UnsafeRawPointer! {
        get {
            sk_data_get_data(handle)
        }
    }
}
