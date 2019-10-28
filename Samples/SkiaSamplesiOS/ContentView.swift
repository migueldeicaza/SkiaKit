//
//  ContentView.swift
//  SkiaSamplesiOS
//
//  Created by Miguel de Icaza on 10/26/19.
//

import SwiftUI
import SkiaKit

struct sampleTest : Sample {
    static var title = "Simple Path Test"
    
    func draw (canvas: Canvas, width: Int32, height: Int32)
    {
        let paint = Paint ()
        
        paint.isAntialias = true
        paint.color = Colors.yellow
        paint.strokeCap = .round
        paint.strokeWidth = 5
        paint.isStroke = true
        
        canvas.draw (paint)

        var path = SkiaKit.Path()
        
        path.moveTo (0, 0)
        path.lineTo (Float (width), Float (height))
    
        path.close()

        paint.color = Colors.black
        canvas.drawPath (path, paint)

        path = Path()
        
        path.close()

        paint.color = Colors.white
        canvas.drawPath(path, paint)
        
        let pp = Paint ()
        pp.style = .fill
        pp.color = Colors.blue
        canvas.drawCircle(Float(width)/2, Float(height)/2, 100, pp)

        pp.style = .stroke
        pp.color = Colors.red
        pp.strokeWidth = 25
        canvas.drawCircle(Float(width)/2, Float(height)/2, 100, pp)
        
    }
}

struct Display<T> : View where T: Sample {
    var body: some View {
        NavigationLink(destination: SampleRender (T())){
            Text (T.title)
        }
    }
}

struct SampleChooserView : View {

    var body: some View {
        NavigationView {
            List {
                Display<sampleTest> ()
                Display<sampleDraw> ()
                Display<samplePathBounds>()
                Display<sampleText>()
                Display<sampleXamagon>()
            }
        }
    }
}

struct ContentView: View {
    @State private var selection = 0
 
    var body: some View {
        TabView(selection: $selection){
            SampleChooserView ()
                .font(.title)
                .tabItem {
                    VStack {
                        Image("first")
                        Text("Gallery")
                    }
                }
                .tag(0)
            SampleRender (sampleTest())
                .font(.title)
                .tabItem {
                    VStack {
                        Image("second")
                        Text("Default")
                    }
                }
                .tag(1)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
