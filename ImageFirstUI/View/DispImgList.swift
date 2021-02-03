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
    @ObservedObject var imageStore: ImageExplorerStore
    @AppStorage("Thumbnail Size") var thumbnailSize:Double = 100

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
        }
    }
}

struct DispImgList_Previews: PreviewProvider {
    static var previews: some View {
        DispImgList(imageStore: ImageExplorerStore(mockup: true))
        
    }
}
