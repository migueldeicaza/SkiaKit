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

//
//func sampleDrawMatrix (canvas: Canvas, width: Int, height: Int)
//{
//    let size = (height > width ? width : height) / 2
//
//    let center = Point(x: Float((width-size)/2), y: Float((height-size) / 2))
//    
//   //var leftRect = Rect(left: center.x - size / 2, top: center.Y, right: size, bottom: size)
//   //var rightRect = Rect(left: center.x + size / 2, top: center.Y, right: size, bottom: size
//   //
//   //var rotatedRect = Rect(0,0,size,size)
//   //var paint = Paint()
//   //paint.isAntialias = true
//   //canvas.clear(color: Colors.purple)
//   //paint.color = Colors.darkBlue
//   //canvas.drawRect(leftRect, paint)
//    
//}
//let bmp = try! Bitmap(ImageInfo (300, 300))
//let canvas = Canvas(bmp)
//let paint = Paint()
//canvas.drawText (text: "text", x: 150, y: 175, paint: paint)
//
//print("Hello, Skia!")
