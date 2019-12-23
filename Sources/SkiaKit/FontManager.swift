//
//  FontManager.swift
//  SkiaKit
//
//  Created by Miguel de Icaza on 11/4/19.
//

import Foundation
import SkiaSharp

/// Skia's FontManager
/// The default font manager can be accessed via the `default` static property of `FontManager`.
public final class FontManager {
    var handle: OpaquePointer
    var owns: Bool
    
    init (handle: OpaquePointer, owns: Bool) {
        self.handle = handle
        self.owns = owns
    }
    
    /// The default font manager
    public static var system: FontManager = FontManager (handle: sk_fontmgr_ref_default(), owns: false)
    
    /// Gets the number of font families available.
    public var fontFamilyCount: Int32 {
        get {
            return sk_fontmgr_count_families(handle)
        }
    }
    
    func getFamilyName (index: Int32) -> String
    {
        let str = SKString()
        sk_fontmgr_get_family_name(handle, index, str.handle)
        return str.getStr()
    }
    
    /// Gets all the font family names loaded by this font manager.
    public var fontFamilies: [String] {
        get {
            let n = fontFamilyCount
            var ret : [String] = []
            for x in 0..<n {
                ret.append (getFamilyName(index: x))
            }
            return ret
        }
    }
    
    /// Returns the font style set for the specified index.
    public func getFontStyles (index: Int32) -> FontStyleSet? {
        if let x = sk_fontmgr_create_styleset(handle, index) {
            return FontStyleSet (handle: x)
        }
        return nil
    }
    
    /// Use the system fallback to find the typeface styles for the given family.
    /// - Returns: Always returns a FontStyleSet, it might be an empty set if there is no font family match
    public func getFontStyles (familyName: String) -> FontStyleSet {
        FontStyleSet (handle: sk_fontmgr_match_family(handle, familyName))
    }
    
    /// Find the closest matching typeface to the specified family name and style.
    /// - Parameter familyName: The font family name to use when searching.
    /// - Parameter style: The font style to use when searching.
    /// - Returns: Returns the Typeface that contains the given family name and style, or the default font if no matching font was found.
    public func match (familyName: String, style: FontStyle) -> Typeface {
        return Typeface (handle: sk_fontmgr_match_family_style (handle, familyName, style.handle), owns: true)
    }
    
    /// Find the closest matching typeface to the specified family name and style.
    /// - Parameter typeface: The typeface to use when searching.
    /// - Parameter style: The font style to use when searching.
    /// - Returns: Returns the Typeface that matches the typeface and style, or the default font if no matching font was found.
    public func match (typeface: Typeface, style: FontStyle) -> Typeface {
        return Typeface (handle: sk_fontmgr_match_face_style(handle, typeface.handle, style.handle), owns: true)
    }
    
    /// Creates a new SKTypeface from the specified file path.
    /// - Parameter path: The path to the typeface.
    /// - Parameter index: The TTC index
    /// - Returns: the typeface from the specified path and TTC index, or nil on error.
    public func createTypeface (path: String, index: Int32 = 0) -> Typeface? {
        if let x = sk_fontmgr_create_from_file (handle, path, index) {
            return Typeface (handle: x, owns: true)
        }
        return nil
    }
    
    /// Creates a new SKTypeface from the provided SKStream
    /// - Parameter path: The path to the typeface.
    /// - Parameter index: The TTC index
    /// - Returns: the typeface from the specified path and TTC index, or nil on error.
    public func createTypeface (stream: SKStream, index: Int32 = 0) -> Typeface? {
        if let x = sk_fontmgr_create_from_stream(handle, stream.handle, index) {
            return Typeface (handle: x, owns: true)
        }
        return nil
    }
    
    public func scan<
      S : Sequence, U
    >(_ seq: S, _ initial: U, _ combine: (U, S.Iterator.Element) -> U) -> [U] {
      var result: [U] = []
      result.reserveCapacity(seq.underestimatedCount)
      var runningResult = initial
      for element in seq {
        runningResult = combine(runningResult, element)
        result.append(runningResult)
      }
      return result
    }
    
    func withArrayOfCStrings<R>(
      _ args: [String], _ body: ([UnsafeMutablePointer<CChar>?]) -> R
    ) -> R {
      let argsCounts = Array(args.map { $0.utf8.count + 1 })
      let argsOffsets = [ 0 ] + scan(argsCounts, 0, +)
      let argsBufferSize = argsOffsets.last!

      var argsBuffer: [UInt8] = []
      argsBuffer.reserveCapacity(argsBufferSize)
      for arg in args {
        argsBuffer.append(contentsOf: arg.utf8)
        argsBuffer.append(0)
      }

      return argsBuffer.withUnsafeMutableBufferPointer {
        (argsBuffer) in
        let ptr = UnsafeMutableRawPointer(argsBuffer.baseAddress!).bindMemory(
          to: CChar.self, capacity: argsBuffer.count)
        var cStrings: [UnsafeMutablePointer<CChar>?] = argsOffsets.map { ptr + $0 }
        cStrings[cStrings.count - 1] = nil
        return body(cStrings)
      }
    }

    
    /// Use the system fallback to find a typeface for the given character.
    /// - Parameter char: The character to find a typeface for.
    /// - Parameter familyName: <#familyName description#>
    /// - Parameter style: The family name to use when searching.
    /// - Parameter bcp47: The ISO 639, 15924, and 3166-1 code to use when searching, such as "ja" and "zh"
    public func match (familyName: String, char: Character, style: FontStyle = .normal, bcp47: [String]? = nil) -> Typeface?
    {
        let scalars = char.unicodeScalars
        let skUnicode = Int32 (scalars [scalars.startIndex].value)

        if let th = sk_fontmgr_match_family_style_character(handle, familyName, style.handle, nil, 0, skUnicode) {
            return Typeface (handle: th, owns: true)
        }
        return nil
    }

    /// Creates a new SKTypeface from the provided SKStream
    /// - Parameter path: The path to the typeface.
    /// - Parameter index: The TTC index
    /// - Returns: the typeface from the specified path and TTC index, or nil on error.
    public func createTypeface (data: SKData, index: Int32 = 0) -> Typeface? {
        if let x = sk_fontmgr_create_from_data(handle, data.handle, index) {
            return Typeface (handle: x, owns: true)
        }
        return nil
    }

}
