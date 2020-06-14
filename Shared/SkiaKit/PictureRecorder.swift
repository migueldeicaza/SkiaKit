//
//  PictureRecorder.swift
//  SkiaKit
//
//  Created by Miguel de Icaza on 11/6/19.
//

import Foundation
#if canImport(CSkiaSharp)
import CSkiaSharp
#endif

/// The picture recorder is used to record drawing operations made to a SKCanvas and stored in a SKPicture.
/// call the `beginRecording` method to start, issue your commands into the returned `Canvas`
/// and then call the `endRecording` method to get the `Picture` that has the recording on it.
///
public final class PictureRecorder {
    var handle: OpaquePointer
    var owns: Bool
    
    init (handle: OpaquePointer, owns: Bool) {
        self.handle = handle
        self.owns = owns
    }

    /// Creates a new instance of the SKPictureRecorder.
    public init ()
    {
        handle = sk_picture_recorder_new()
        owns = true
    }
    
    /// Start the recording process and return the recording canvas.
    /// - Parameter cullRect: The culling rectangle for the new picture.
    /// - Returns: a `Canvas` that you can issue draw operations on, and that will be recorded
    public func beginRecording (cullRect: Rect) -> Canvas {
        var r = cullRect
        return Canvas (handle: sk_picture_recorder_begin_recording(handle, &r), owns: .doesNotOwn)
    }
    
    /// Signal that the caller is done recording.
    /// - Returns: the picture with the recording on it
    public func endRecording () -> Picture
    {
        Picture (handle: sk_picture_recorder_end_recording(handle))
    }
    
    /// Returns the recording canvas if one is active, or nil if recording is
    /// not active.
    public var recordingCanvas: Canvas {
        get {
            return Canvas (handle: sk_picture_get_recording_canvas(handle), owns: .doesNotOwn)
        }
    }
    deinit {
        if owns {
            sk_picture_recorder_delete(handle)
        }
    }
    //sk_picture_recorder_end_recording_as_drawable

}
