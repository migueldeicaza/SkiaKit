//
//  SKCanvasTest.swift
//  SkiaKitTests
//
//  Created by Miguel de Icaza on 10/16/19.
//  Copyright © 2019 Miguel de Icaza. All rights reserved.
//

import Foundation

import XCTest
@testable import SkiaKit

class SKCanvasTest : XCTestCase {
    override func setUp() {
      // Put setup code here. This method is called before the invocation of each test method in the class.
        print ("Starting SKCanvasTest")
    }

    override func tearDown() {
      // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCanDrawText ()
    {
        let bmp = try! Bitmap(ImageInfo (300, 300))
        let canvas = Canvas(bmp)
        let paint = Paint()
        canvas.drawText (text: "text", x: 150, y: 175, paint: paint)
    }
}
