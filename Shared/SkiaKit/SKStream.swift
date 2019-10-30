//
//  SKStream.swift
//  SkiaKit
//
//  Created by Miguel de Icaza on 10/22/19.
//  Copyright © 2019 Miguel de Icaza. All rights reserved.
//

import Foundation

/**
 * bstraction for a source of bytes. Subclasses can be backed by
 *  memory, or a file, or something else.
 *
 * Classic "streams" APIs are sort of async, in that on a request for N
 *  bytes, they may return fewer than N bytes on a given call, in which case
 *  the caller can "try again" to get more bytes, eventually (modulo an error)
 *  receiving their total N bytes.
 *
 *  Skia streams behave differently. They are effectively synchronous, and will
 *  always return all N bytes of the request if possible. If they return fewer
 *  (the `read` call returns the number of bytes read) then that means there is
 *  no more data (at EOF or hit an error). The caller should *not* call again
 *  in hopes of fulfilling more of the request.
 */
public class SKStream {
    var handle: OpaquePointer
    var owns: Bool
    
    init (handle: OpaquePointer, owns: Bool)
    {
        self.handle = handle
        self.owns = owns
    }
    
    /**
     * Returns true when all the bytes in the stream have been read.
     *
     * This may return true early (when there are no more bytes to be read)
     * or late (after the first unsuccessful read).
     */
    public var isAtEnd : Bool {
        get {
            sk_stream_is_at_end(handle)
        }
    }
    
    /// Reads the next Int8 from the stream, returns nil if the end was reached before the read completed
    public func readInt8 () -> Int8?
    {
        var b: Int8 = 0
        return sk_stream_read_s8(handle, &b) ? b : nil
    }
    
    /// Reads the next Int16 from the stream, returns nil if the end was reached before the read completed
    public func readInt16 () -> Int16?
    {
        var b: Int16 = 0
        return sk_stream_read_s16(handle, &b) ? b : nil
    }
    
    /// Reads the next Int32 from the stream, returns nil if the end was reached before the read completed
    public func readInt32 () -> Int32?
    {
        var b: Int32 = 0
        return sk_stream_read_s32(handle, &b) ? b : nil
    }
    
    /// Reads the next UInt8 from the stream, returns nil if the end was reached before the read completed
    public func readUInt8 () -> UInt8?
    {
        var b: UInt8 = 0
        return sk_stream_read_u8(handle, &b) ? b : nil
    }
    
    /// Reads the next UInt16 from the stream, returns nil if the end was reached before the read completed
    public func readUInt16 () -> UInt16?
    {
        var b: UInt16 = 0
        return sk_stream_read_u16(handle, &b) ? b : nil
    }
    
    /// Reads the next UInt16 from the stream, returns nil if the end was reached before the read completed
    public func readUInt32 () -> UInt32?
    {
        var b: UInt32 = 0
        return sk_stream_read_u32(handle, &b) ? b : nil
    }
    
    /**
     * Reads or skips size number of bytes.
     * If buffer == nil, skip size bytes, return how many were skipped.
     * If buffer != nil, copy size bytes into buffer, return how many were copied.
     * - Parameter buffer: copy size bytes into buffer
     * - Parameter size: the number of bytes to skip or copy
     * - Returns: the number of bytes actually read.
     */
    public func read (_ buffer: inout [UInt8], _ size: Int)
    {
        sk_stream_read (handle, &buffer, size)
    }
    
    /**
     * Attempt to peek at size bytes.
     * If this stream supports peeking, copy min(size, peekable bytes) into
     * buffer, and return the number of bytes copied.
     * If the stream does not support peeking, or cannot peek any bytes,
     * return 0 and leave buffer unchanged.
     * The stream is guaranteed to be in the same visible state after this
     * call, regardless of success or failure.
     * - Parameter buffer: Must not be nil, and must be at least size bytes. Destination to copy bytes.
     * - Parameter size: Number of bytes to copy.
     * - Returns: The number of bytes peeked/copied.
     */
    public func peek (_ buffer: inout [UInt8], _ size: Int)
    {
        sk_stream_peek (handle, &buffer, size)
    }
    
    /**
     * Attempts to skip the specified number of bytes.
     *
     * - Returns: The number of bytes actually skipped.
     */
    public func skip (_ size: Int) -> Int
    {
        sk_stream_skip(handle, size)
    }
    
    /**
     * Rewinds to the beginning of the stream. Returns true if the stream is known
     * to be at the beginning after this call returns.
     */
    public func rewind ()
    {
        sk_stream_rewind(handle)
    }

    /**
     * Changes the stream position by the specified value in the stream. If this cannot be done, returns false.
     * If an attempt is made to seek past the end of the stream, the position will be set
     * to the end of the stream.
     *
     * - Parameter delta: the number of bytes to seek forward or backwards
     * - Returns: `true` if it was possible to seek to that position, `false` otherwise
     */

    public func seek (_ delta: Int) -> Bool
    {
        sk_stream_seek(handle, delta)
    }
    
    /**
     * Seeks to an absolute position in the stream. If this cannot be done, returns false.
     * If an attempt is made to seek past the end of the stream, the position will be set
     * to the end of the stream.
     *
     * - Parameter position: the target position for this stream
     * - Returns: `true` if it was possible to seek to that position, `false` otherwise
     */
    public func seekAbsolute (_ position: Int) -> Bool
    {
        sk_stream_move(handle, position)
    }
    
    /// Returns the starting address for the data. If this cannot be done, returns nil.
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
    
    /// Returns true if this stream can report it's current position.
    public var hasPosition : Bool {
        get {
            return sk_stream_has_position(handle)
        }
    }
    
    /// Returns the current position in the stream. If this cannot be done, returns 0
    public var position: Int {
        get {
            return sk_stream_get_position(handle)
        }
    }

    /// Returns true if this stream can report it's total length.
    public var hasLength : Bool {
        get {
            return sk_stream_has_length(handle)
        }
    }
    
    /// Returns the total length of the stream. If this cannot be done, returns 0.
    public var length: Int {
        get {
            return sk_stream_get_length(handle)
        }
    }
}

/**
 * A reading stream that wraps a native file.   To write use `SKFileWStream`
 */
public final class SKFileStream : SKStream {
    /**
     * Initialize the stream by calling sk_fopen on the specified path.
     * This internal stream will be closed in the destructor.
     */
    public init? (path: String)
    {
        if let handle = sk_filestream_new(path) {
            super.init (handle: handle, owns: true)
        } else {
            return nil
        }
        
    }
    
    deinit {
        if owns {
            sk_filestream_destroy(handle)
        }
    }
    
    /// Returns true if the current path could be opened.
    public var isValid: Bool { sk_filestream_is_valid(handle)}
}

/**
 * A memory-based stream.
 */
public final class SKMemoryStream: SKStream {
    public init ()
    {
        super.init (handle: sk_memorystream_new(), owns: true)
    }
    
    /**
     * Creates a new instance of SKMemoryStream with a buffer size of the specified size.
     * - Parameter lenght: the desired size for the in-memory stream
     */
    public init? (length: Int)
    {
        if let h = sk_memorystream_new_with_length(length) {
            super.init (handle: h, owns: true)
        } else {
            return nil
        }
    }
    
    /**
     * Creates a new instance of SKMemoryStream with the buffer being the provided data.
     * - Parameter data: pointer to a block of memory that will be wrapped as a memory stream
     * - Parameter length: the size for the stream
     * - Parameter copyData: if `true` this will allocate a buffer and make a copy of the data, otherwise, it will use the data as provided.
     */
    public init? (_ data: UnsafeRawPointer!, _ length: Int, copyData: Bool = true)
    {
        if let h = sk_memorystream_new_with_data(data, length, copyData) {
            super.init (handle: h, owns: true)
        } else {
            return nil
        }
    }

    /**
     * Creates a new instance of SKMemoryStream with the buffer being the provided data.
     * - Parameter data: The data wrapper
     */
    public init? (_ data: Data)
    {
        if let h = sk_memorystream_new_with_skdata (data.handle) {
            super.init (handle: h, owns: true)
        } else {
            return nil
        }
    }
    
    /// Resets the stream with a copy of the provided data.
    public func setMemory (data: inout [UInt8])
    {
        sk_memorystream_set_memory(handle, &data, data.count, true)
    }
    
    deinit {
        if owns {
            sk_memorystream_destroy(handle)
        }
    }
}

public class SKWStream {
    var handle: OpaquePointer
    var owns: Bool
    
    init (handle: OpaquePointer, owns: Bool)
    {
        self.handle = handle
        self.owns = owns
    }

    /// Gets the number of bytes written so far.
    public var bytesWritten : Int { sk_wstream_bytes_written(handle)}

    /**
     * Write the provided data to the stream.
     * - Parameter buffer: the buffer containing the data to be written
     * - Parameter size: the number of bytes to write to the stream
     * - Returns: Returns true if the write succeeded, otherwise false.
     */
    public func write (_ buffer: inout [UInt8], _ size: Int) -> Bool
    {
        return sk_wstream_write(handle, &buffer, size)
    }
    
    /**
     * Write a newline character to the stream, if one was not already written.
     * Returns: Returns true if the write succeeded, otherwise false.
     */
    public func newLine () -> Bool
    {
        sk_wstream_newline(handle)
    }
    
    /// Flush the buffer to the underlying destination.
    public func flush ()
    {
        sk_wstream_flush(handle)
    }
    
    /// Write the number of specified bytes from the provided stream into this stream
    public func writeStream (stream: SKStream, length: Int)
    {
        sk_wstream_write_stream(handle, stream.handle, length)
    }
    
    /// Writes the provided UIn8 to the stream
    public func write (byte: UInt8) { sk_wstream_write_8(handle, byte)}
    /// Writes the provided UInt16 to the stream
    public func write (uint16: UInt16) { sk_wstream_write_16(handle, uint16)}
    /// Writes the provided UInt32 to the stream
    public func write (uint32: UInt32) { sk_wstream_write_32 (handle, uint32)}
    /// Writes the provided text to the stream
    public func write (text: String) { sk_wstream_write_text(handle, text) }
}

/**
 * Opens a write-only stream to the specified file.  To read use `SKFileStream`
 */
public final class SKFileWStream : SKWStream {
    public init? (path: String)
    {
       if let handle = sk_filewstream_new(path) {
        super.init (handle: handle, owns: true)
       } else {
           return nil
       }
       
    }

    deinit {
        if (owns) {
            sk_filewstream_destroy(handle)
        }
    }

    /// Returns true if the current path could be opened.
    public var isValid: Bool { sk_filewstream_is_valid(handle)}
}

/**
 * A writeable, dynamically-sized, memory-based stream.
 */
public final class SKDynamicMemoryWStream : SKWStream {
    public init ()
    {
        super.init(handle: sk_dynamicmemorywstream_new(), owns: true)
    }
    
    deinit {
        if owns {
            sk_dynamicmemorywstream_destroy(handle)
        }
    }
    
    /**
     * Returns the contents of this dynamic memory stream as a Data, this makes a copy of the underlying data
     */
    public func getData () -> Data
    {
        let d = Data.init(size: bytesWritten)
        sk_dynamicmemorywstream_copy_to (handle, UnsafeMutableRawPointer (mutating: d.data))
        return d
    }
    
    /**
     * Copies the content of the dynamic memory stream into the provided stream.
     * - Parameter to: the target stream to write to
     */
    public func copy (to: SKWStream)
    {
        sk_dynamicmemorywstream_write_to_stream(handle, to.handle)
    }
}
