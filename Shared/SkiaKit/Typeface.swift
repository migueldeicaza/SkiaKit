//
//  Typeface.swift
//  SkiaKit
//
//  Created by Miguel de Icaza on 10/17/19.
//  Copyright © 2019 Miguel de Icaza. All rights reserved.
//

import Foundation
#if canImport(CSkiaSharp)
import CSkiaSharp
#endif

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
    
    /**
     * Gets the contents of the specified table tag as an array, or nil if the table is not found
     *
     * - Parameter tag: The table tag whose contents are to be copied
     * - Returns: An array with the table contents, or nil on error
    */
    public func getTableData (tag: UInt32) -> [UInt8]?
    {
        let size = getTableSize(tag: tag)
        if size == 0 {
            return nil
        }
        var arr = Array<UInt8>.init(repeating: 0, count: size)
        
        if getTableData(tag: tag, offset: 0, length: size, storage: &arr) == size {
            return arr
        }
        return nil
    }
    
    /**
     * Copy the contents of a table into data (allocated by the caller). Note
     * that the contents of the table will be in their native endian order
     * (which for most truetype tables is big endian). If the table tag is
     * not found, or there is an error copying the data, then 0 is returned.
     * If this happens, it is possible that some or all of the memory pointed
     * to by data may have been written to, even though an error has occured.
     *
     * - Parameter tag: The table tag whose contents are to be copied
     * - Parameter offset: The offset in bytes into the table's contents where the
     * copy should start from.
     * - Parameter length: The number of bytes, starting at offset, of table data
     * to copy.
     * - Parameter storage: storage address where the table contents are copied to
     * - Returns: the number of bytes actually copied into data. If offset+length
     * exceeds the table's size, then only the bytes up to the table's
     * size are actually copied, and this is the value returned. If
     * offset > the table's size, or tag is not a valid table,
     * then 0 is returned.
     */
    public func getTableData (tag: UInt32, offset: Int, length: Int, storage: UnsafeMutablePointer<UInt8>) -> Int
    {
        return sk_typeface_get_table_data(handle, tag, offset, length, storage)
    }
    
    /// Returns the number of glyphs in the string.
    public func countGlyphs (str: String) -> Int32
    {
        let utflen = str.utf8.count
        return sk_typeface_chars_to_glyphs(handle, str, UTF8_ENCODING, nil, Int32 (utflen))
    }
    
    /// Retrieve the corresponding glyph IDs of a string of characters.
    /// - Returns: the array of glyphs, or nil if there is an error
    public func getGlyphs (str: String) -> [UInt16]?
    {
        let utflen = str.utf8.count
        let nglyphs = sk_typeface_chars_to_glyphs(handle, str, UTF8_ENCODING, nil, Int32 (utflen))
        if nglyphs <= 0 {
            return nil
        }
        var glyphs = Array<UInt16>.init (repeating: 0, count: Int(nglyphs))
        sk_typeface_chars_to_glyphs(handle, str, UTF8_ENCODING, &glyphs, nglyphs)
        return glyphs
    }

    /// Returns a stream for the contents of the font data.
    public func openStream () -> (stream: SKStream, trueTypeCollectionIndex: Int32)?
    {
        var ttcIndex: Int32 = 0
        if let x = sk_typeface_open_stream(handle, &ttcIndex) {
            return (SKStream(handle: x, owns: true), ttcIndex)
        }
        return nil
    }
    
    deinit
    {
        if owns {
            sk_typeface_unref(handle)
        }
    }
}
