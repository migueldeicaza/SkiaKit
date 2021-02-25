//
//  AnimationSample.swift
//  SkiaSamplesiOS
//
//  Created by Sash Zats on 12/13/20.
//

import Foundation
import SkiaKit

struct animationSample : Sample {
    static var title = "Animation"
    
    var isLoop: Bool { true }
    
    class AnimationViewModel {
        private let circleRadius: Float = 100
        private lazy var position = Point(x: circleRadius, y: circleRadius)
        private var velocity = Point(x: 10, y: 10)
        private var bounds = Rect()
                        
        func update(width: Float, height: Float) {
            self.bounds = Rect(x: 0,
                               y: 0,
                               width: Float(width) - circleRadius * 2,
                               height: Float(height) - circleRadius * 2)
            
            var nextPosition = Point(x: position.x + velocity.x,
                                     y: position.y + velocity.y)
            if nextPosition.x < bounds.left || nextPosition.x > bounds.right {
                velocity.x *= -1
                nextPosition = Point(x: position.x + velocity.x,
                                     y: position.y + velocity.y)
            }
            
            if nextPosition.y < bounds.top || nextPosition.y > bounds.bottom {
                velocity.y *= -1;
                nextPosition = Point(x: position.x + velocity.x,
                                     y: position.y + velocity.y)
            }
            
            position = nextPosition
        }
        
        var ovalBounds: Rect {
            return Rect(x: position.x, y: position.y, width: circleRadius * 2, height: circleRadius * 2)
        }
    }

    let viewModel = AnimationViewModel()
  
    func draw(canvas: Canvas, width: Int32, height: Int32)
    {
        viewModel.update(width: Float(width), height: Float(height))
        
        canvas.clear (color: Colors.white)

        let paint = Paint()
        paint.isAntialias = true
        paint.color = Colors.darkGray
        paint.strokeCap = .round
        paint.strokeWidth = 10
        paint.isStroke = true
        
        let path = SkiaKit.Path()
        path.addOval(viewModel.ovalBounds)
        path.close()
        
        canvas.drawPath(path, paint)

    }
}
