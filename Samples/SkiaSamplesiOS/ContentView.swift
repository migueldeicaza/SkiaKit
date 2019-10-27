//
//  ContentView.swift
//  SkiaSamplesiOS
//
//  Created by Miguel de Icaza on 10/26/19.
//

import SwiftUI
import SkiaKit

struct MySkia : UIViewRepresentable {
    func updateUIView(_ uiView: SkiaView, context: UIViewRepresentableContext<MySkia>) {
        uiView.setNeedsDisplay ()
    }
    
    func makeUIView (context: Context) -> SkiaView
    {
        let sv = SkiaView ()
        sv.drawingCallback = myDraw

        return sv
    }
    
    func myDraw (surface: Surface, imageInfo: ImageInfo)
    {
        let c = surface.canvas
        
        c.clear (color: Colors.aqua ())
        let paint = Paint()
        c.drawText (text: "text", x: 150, y: 175, paint: paint)
    }
}

struct ContentView: View {
    @State private var selection = 0
 
    var body: some View {
        TabView(selection: $selection){
            
            MySkia ()
                .font(.title)
                .tabItem {
                    VStack {
                        Image("first")
                        Text("First")
                    }
                }
                .tag(0)
            Text("Second View")
                .font(.title)
                .tabItem {
                    VStack {
                        Image("second")
                        Text("Second")
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
