//
//  Typeface.swift
//  SkiaKit
//
//  Created by Miguel de Icaza on 10/17/19.
//  Copyright © 2019 Miguel de Icaza. All rights reserved.
//

import Foundation

/**
 * The `Typeface` class specifies the typeface and intrinsic style of a font.
 * This is used in the paint, along with optionally algorithmic settings like
 * textSize, textskewX, textScaleX, FakeBoldText_Mask, to specify
 * how text appears when drawn (and measured).
 *
 * Typeface objects are immutable, and so they can be shared between threads.
 */
public final class Typeface {
    var handle : OpaquePointer
    var owns: Bool
    
    /// The default normal typeface
    static var defaultTypeface = Typeface (handle: sk_typeface_ref_default(), owns: false)
    
    init (handle: OpaquePointer, owns: Bool)
    {
        self.handle = handle
        self.owns = owns
    }
    
    /// Returns a new typeface configured with the defaults
    public static func createDefault () -> Typeface
    {
        return Typeface(handle: sk_typeface_create_default(), owns: true)
    }
    
    //public init (familyName: String, weight: Int, width: Int, slant: FontStyleSlant)
    
    /**
     * Initializes a new instance to a typeface that most closely matches the requested family name and style, can fail
     * - Parameter familyName: The name of the font family. May be `nil`
     */
    public convenience init? (familyName: String?)
    {
        self.init (familyName: familyName, style: FontStyle.normal)
    }

    /**
     * Initializes a new instance to a typeface that most closely matches the requested family name and style, can fail
     * - Parameter familyName: The name of the font family. May be `nil`
     * - style: The style of the typeface, one of the defaults from `FontStyle` (`normal`, `bold`, `italic`, or your own constructed `FontStyle`)
     */
    public init? (familyName: String?, style: FontStyle)
    {
        if let x = sk_typeface_create_from_name_with_font_style(familyName, style.handle) {
            handle = x
            owns = true
        } else {
            return nil
        }
    }

    /**
     * Initializes a new instance to a typeface that most closely matches the requested family name and style, can fail
     *
     * This constructor calls the FontStyle constructor with the provided parameters to create your typeface
     *
     * - Parameter familyName: The name of the font family. May be `nil`
     * - Parameter weight: the desired weight
     * - Parameter width: the desired width
     * - Parameter slant: the desired slant
     */
    public convenience init? (familyName: String?, weight: FontStyleWeight, width: FontStyleWidth, slant: FontStyleSlant)
    {
        self.init (familyName: familyName, style: FontStyle(weight: weight, width: width, slant: slant))
    }
    
    /**
     * Initializes a new typeface from a file - for example to load a true type font, can fail
     * - Parameter file: the path to the file containing the font
     * - Parameter index: The font face index in the file
     */
    public init? (file: String, index: Int32 = 0)
    {
        if let x = sk_typeface_create_from_file(file, index) {
            handle = x
            owns = true
        } else {
            return nil
        }
    }

    /**
     * Initializes a new typeface from a stream (for example from a stream reader that is reading a true type font) , can fail
     * - Parameter stream: the stream that contains the font
     * - Parameter index: The font face index in the file
     */
    public init? (stream: SKStream, index: Int32 = 0)
    {
        if let x = sk_typeface_create_from_stream(stream.handle, index){
            handle = x
            owns = true
        } else {
            return nil
        }
    }
    
    /**
     * Initializes a new typeface from a data blob (for example from a stream reader that is reading a true type font) , can fail
     * - Parameter data: the data blob that contains the font
     * - Parameter index: The font face index in the file
     */
    public init? (data: SKData, index: Int32 = 0)
    {
        if let stream = SKMemoryStream(data) {
            if let x = sk_typeface_create_from_stream(stream.handle, index){
                handle = x
                owns = true
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    /**
     * Return the family name for this typeface. It will always be returned
     * encoded as UTF8, but the language of the name is whatever the host
     * platform chooses.
     */
    public var familyName: String? {
        get {
            let ptr = sk_typeface_get_family_name(handle)
            if ptr == nil {
                return nil
            }
            return String (cString: UnsafePointer<UInt8> (ptr)!)
        }
    }
    
    /// Gets the font style
    public var fontStyle: FontStyle { FontStyle (handle: sk_typeface_get_fontstyle(handle), owns: true) }
    
    /// Getes the font weight
    public var fontWeight: Int32 {
        get {
            sk_typeface_get_font_weight(handle)
        }
    }

    /// Getes the font width
    public var fontWidth: Int32 {
        get {
            sk_typeface_get_font_width(handle)
        }
    }
    
    /// Gets the font slant
    public var fontSlant: FontStyleSlant {
        get {
            FontStyleSlant.fromNative(sk_typeface_get_font_slant(handle))
        }
    }

    /// Return the units-per-em value for this typeface, or zero if there is an error.
    public var unitsPerEm: Int32 { sk_typeface_get_units_per_em(handle)}
    
    /// Return the number of tables in the font.
    public var tableCount: Int32 { sk_typeface_count_tables(handle)}
    
    /// Given a table tag, return the size of its contents, or 0 if not present
    public func getTableSize (tag: UInt32) -> Int {
        sk_typeface_get_table_size(handle, tag)
    }
    deinit
    {
        if owns {
            sk_typeface_unref(handle)
        }
    }
}
