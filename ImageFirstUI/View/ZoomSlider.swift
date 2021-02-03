//
//  ZoomSlider.swift
//  ImageFirstUI
//
//  Created by Hervé LEMAI on 23/01/2021.
//

import SwiftUI

/// small view with a slider to fix thumbnail size
struct ZoomSlider: View {
    
    /// thumbnail size in pixel
    @Binding var thumbnailSize:Double
    /// minimum size of thumbnail
    let min = 100.0
    /// maximum size of thumbnail
    let max = 500.0
    /// increment step 
    let step = 50.0
    @State var leftbackColor = Color.gray.opacity(0.0)
    @State var rightbackColor = Color.gray.opacity(0.0)
    
    /// minus step to slider
    func decZoom() {
        thumbnailSize -= step
        if thumbnailSize<min {thumbnailSize = min}
    }
    /// add step to slider
    func incZoom() {
        thumbnailSize += step
        if thumbnailSize>max {thumbnailSize = max}
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
            Slider(value: $thumbnailSize, in: min...max)
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
        ZoomSlider(thumbnailSize: .constant(200.0))
    }
}
