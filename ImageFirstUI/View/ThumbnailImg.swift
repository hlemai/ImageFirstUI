//
//  ThumbnailImg.swift
//  ImageFirstUI
//
//  Created by Hervé LEMAI on 02/01/2021.
//

import SwiftUI

/// view displaying an image
struct ThumbnailImg: View {
    @ObservedObject private var imageLoader: ImageThumbnailLoader
    
    var body: some View {
        Image(nsImage: imageLoader.image ?? NSImage(systemSymbolName: "tortoise", accessibilityDescription: "to load")!)
            //.frame(width: 100.0, height: 100.0)
            .scaledToFill().onAppear(perform: {
                //imageLoader.requestImage()
            })
    }
    init( path:String)
    {
        imageLoader = ImageThumbnailLoader(path: path)
        imageLoader.requestImage()
    }
}

struct ThumbnailImg_Previews: PreviewProvider {
    static var previews: some View {
        ThumbnailImg(path:  "/Users/hlemai/Pictures/Fond/_DSC5171.jpg")
    }
}
