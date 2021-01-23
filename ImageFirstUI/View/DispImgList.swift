//
//  DispImgList.swift
//  ImageFirstUI
//
//  Created by Hervé LEMAI on 31/12/2020.
//

import SwiftUI


/// view displaying table of thumbnal pictures
struct DispImgList: View {
    
    /// view model
    @EnvironmentObject var imageStore: ImageExplorerStore
    @State var thumbnailSize = 200.0
    
    /// columns definitions
    var columns = [GridItem(.adaptive(minimum: 200, maximum: 1000.0))]
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            ScrollView {
                LazyVGrid(columns:
                            [GridItem(.adaptive(minimum: CGFloat(thumbnailSize), maximum: 1000.0),  spacing:20 )]) {
                    ForEach(imageStore.images) { img in 
                                VStack {
                                    ThumbnailImg(path : img.path,thumbnailSize: thumbnailSize)
                                    Text(img.name)
                                }
                                .padding()
                                .onTapGesture {
                                    imageStore.currentImagePath = img.path
                                }
                        }
                    }
            }
            ZoomSlider(zoomSize: $thumbnailSize)
                .scaleEffect(0.4)
                .background(Color(NSColor.underPageBackgroundColor))
                .opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
        }
    }
}

struct DispImgList_Previews: PreviewProvider {
    static var previews: some View {
        DispImgList()
            .environmentObject(ImageExplorerStore(mockup: true))
        
    }
}
