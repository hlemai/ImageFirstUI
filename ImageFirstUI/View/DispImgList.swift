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

    /// columns definitions
    var columns = [GridItem(.adaptive(minimum: 200, maximum: 1000.0))]
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            ScrollView {
                LazyVGrid(columns:
                            [GridItem(.adaptive(minimum: CGFloat(imageStore.userSettings.thumbnailSize), maximum: 1000.0),  spacing:20 )]) {
                    ForEach(imageStore.images) { img in 
                                VStack {
                                    ThumbnailImg(path : img.path,thumbnailSize: imageStore.userSettings.thumbnailSize)
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
        DispImgList()
            .environmentObject(ImageExplorerStore(mockup: true))
        
    }
}
