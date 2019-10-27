//
//  SKStream.swift
//  SkiaKit
//
//  Created by Miguel de Icaza on 10/22/19.
//  Copyright © 2019 Miguel de Icaza. All rights reserved.
//

import Foundation

public class SKStream {
    var handle: OpaquePointer
    
    init (handle: OpaquePointer)
    {
        self.handle = handle
    }
    
    public var isAtEnd : Bool {
        get {
            sk_stream_is_at_end(handle)
        }
    }
    
    public func readInt8 () -> Int8?
    {
        var b: Int8 = 0
        return sk_stream_read_s8(handle, &b) ? b : nil
    }
    
    public func readInt16 () -> Int16?
    {
        var b: Int16 = 0
        return sk_stream_read_s16(handle, &b) ? b : nil
    }
    
    public func readInt32 () -> Int32?
    {
        var b: Int32 = 0
        return sk_stream_read_s32(handle, &b) ? b : nil
    }
    
    public func readUInt8 () -> UInt8?
    {
        var b: UInt8 = 0
        return sk_stream_read_u8(handle, &b) ? b : nil
    }
    
    public func readUInt16 () -> UInt16?
    {
        var b: UInt16 = 0
        return sk_stream_read_u16(handle, &b) ? b : nil
    }
    
    public func readUInt32 () -> UInt32?
    {
        var b: UInt32 = 0
        return sk_stream_read_u32(handle, &b) ? b : nil
    }
    
    public func read (_ buffer: inout [UInt8], _ size: Int)
    {
        sk_stream_read (handle, &buffer, size)
    }
    
    public func peek (_ buffer: inout [UInt8], _ size: Int)
    {
        sk_stream_peek (handle, &buffer, size)
    }
    
    public func skip (_ size: Int) -> Int
    {
        sk_stream_skip(handle, size)
    }
    
    public func rewind ()
    {
        sk_stream_rewind(handle)
    }
    
    public func seek (_ position: Int) -> Bool
    {
        sk_stream_seek(handle, position)
    }
    
    public func seekAbsolute (_ position: Int) -> Bool
    {
        sk_stream_move(handle, position)
    }
    
    public func getMemoryBase () -> UnsafeRawPointer!
    {
        sk_stream_get_memory_base(handle    )
    }
    
    // This needs to know the type to wrap
    // TODO: Fork
    //public func fork () -> SKStream?
    //{
    //    if let x = sk_stream_fork(handle) {
    //        return
    //    }
    //}
    
    // TODO: Duplicate
    
    public var hasPosition : Bool {
        get {
            return sk_stream_has_position(handle)
        }
    }
    
    public var position: Int {
        get {
            return sk_stream_get_position(handle)
        }
    }

    
    public var hasLength : Bool {
        get {
            return sk_stream_has_length(handle)
        }
    }
    
    public var length: Int {
        get {
            return sk_stream_get_length(handle)
        }
    }
}

public class SKFileStream : SKStream {
    public init? (path: String)
    {
        if let handle = sk_filestream_new(path) {
            super.init (handle: handle)
        } else {
            return nil
        }
        
    }
    
    deinit {
        sk_filestream_destroy(handle)
    }
    
    public var isValid: Bool { sk_filewstream_is_valid(handle)}
}

public class SKMemoryStream: SKStream {
    public init ()
    {
        super.init (handle: sk_memorystream_new())
    }
    
    public init? (length: Int)
    {
        if let h = sk_memorystream_new_with_length(length) {
            super.init (handle: h)
        } else {
            return nil
        }
    }
    
    public init? (_ data: UnsafeRawPointer!, _ length: Int, copyData: Bool = true)
    {
        if let h = sk_memorystream_new_with_data(data, length, copyData) {
            super.init (handle: h)
        } else {
            return nil
        }
    }
    
    public init? (_ data: Data)
    {
        if let h = sk_memorystream_new_with_skdata (data.handle) {
            super.init (handle: h)
        } else {
            return nil
        }
    }
    
    public func setMemory (data: inout [UInt8])
    {
        sk_memorystream_set_memory(handle, &data, data.count, true)
    }
    
    deinit {
        sk_memorystream_destroy(handle)
    }
}

