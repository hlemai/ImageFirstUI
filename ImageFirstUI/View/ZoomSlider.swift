//
//  ZoomSlider.swift
//  ImageFirstUI
//
//  Created by Hervé LEMAI on 23/01/2021.
//

import SwiftUI


struct ZoomSlider: View {
    @Binding var zoomSize:Double
    let min = 100.0
    let max = 500.0
    let step = 50.0
    @State var leftbackColor = Color.gray.opacity(0.0)
    @State var rightbackColor = Color.gray.opacity(0.0)
    
    func decZoom() {
        zoomSize -= step
        if zoomSize<min {zoomSize = min}
    }
    func incZoom() {
        zoomSize += step
        if zoomSize>max {zoomSize = max}
    }
    var body : some View {
        HStack {
            Button(action: decZoom) {
                Image(systemName: "minus")
                    .scaledToFit()
                    .frame(width: 30, height:30)
                    .background(leftbackColor)
            }.onHover(perform: {st  in
                if st {leftbackColor=Color.gray.opacity(80.0)}
                else {leftbackColor=Color.gray.opacity(0)}
            })
            Slider(value: $zoomSize, in: min...max)
            Button(action: incZoom) {
                Image(systemName: "plus")
                    .scaledToFit()
                    .frame(width: 30, height:30)
                    .background(rightbackColor)
            }.onHover(perform: {st  in
                if st {rightbackColor=Color.gray.opacity(80.0)}
                else {rightbackColor=Color.gray.opacity(0)}
            })
        }.foregroundColor(.accentColor)
        .buttonStyle(PlainButtonStyle())
    }
}

struct ZoomSlider_Previews: PreviewProvider {
    @State var zoom = 200.0
    
    static var previews: some View {
        ZoomSlider(zoomSize: .constant(200.0))
    }
}
