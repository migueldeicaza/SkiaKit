//
//  ContentView.swift
//  SkiaSamplesiOS
//
//  Created by Miguel de Icaza on 10/26/19.
//

import SwiftUI
import SkiaKit


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
                Display<TwoDPathSample>()
                Display<gradientSample>()
                Display<fractalPerlinNoiseShaderSample>()
                Display<filledHeptagramSample> ()
                Display<sampleTest> ()
                Display<sampleDraw> ()
                Display<samplePathBounds>()
                Display<sampleText>()
                Display<sampleXamagon>()
                Display<animationSample>()
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
