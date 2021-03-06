//
//  Data.swift
//  SkiaKit
//
//  Created by Miguel de Icaza on 10/18/19.
//  Copyright © 2019 Miguel de Icaza. All rights reserved.
//

import Foundation
#if canImport(CSkiaSharp)
import CSkiaSharp
#endif

/**
 * `SKData` holds an immutable data buffer. Not only is the data immutable,
 * but the actual ptr that is returned (by `data`)) is guaranteed
 * to always be the same for the life of this instance.
 */
public final class SKData {
    var handle: OpaquePointer
    
    /**
     * Initializes a new instance of SKData, if `size` is zero, this creates an empty SKData, otherwise it
     * creates an uninitialized SKData with the specified number of bytes
     * - Parameter size: number of bytes to allocate for this SKData, or zero for an empty one.
     */
    public init (size: Int = 0)
    {
        if size == 0 {
            handle = sk_data_new_empty()
        } else {
            handle = sk_data_new_uninitialized(size)
        }
    }
    
    /**
     * Initializes a new instance of SKData with the contents of the provided array `data`
     * - Parameter data: contains the initial data to load, the contents are copied.
     */
    public init (data: [UInt8])
    {
        handle = sk_data_new_with_copy(data, data.count)
    }
    
    /**
     * Creates a subset SKData that reprents the specified range.
     * - Parameter range: the range of bytes that will be extracted
     * - Returns: the new SKData object, if the values of the range are beyond the boundaries of the SKData, an empty SKData is returned.
     */
    public subscript (_ range: Range<Int>) -> SKData {
        get {
                return SKData (handle:sk_data_new_subset(handle, range.startIndex, range.count))
        }
    }
    
    /**
     * Creates a new `Data` with the contents of the specified file
     * - Parameter file: the file to load
     * - Returns: if the file is present, a new `SKData` with the contents of the file, or nil on failure
     */
    public static func fromFile (file: String) -> SKData?
    {
        if let x = sk_data_new_from_file(file) {
            return SKData(handle: x)
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
    
    /// Returns the number of bytes stored.
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
    
    /// Returns the ptr to the data.
    public var data: UnsafeRawPointer! {
        get {
            sk_data_get_data(handle)
        }
    }
    
    //sk_data_get_bytes
    //sk_data_new_from_stream
    //sk_data_new_with_proc
    //sk_data_ref

}
