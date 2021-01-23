//
//  ThumbnailImg.swift
//  ImageFirstUI
//
//  Created by Hervé LEMAI on 02/01/2021.
//

import SwiftUI
import os.log

/// view displaying an image
struct ThumbnailImg: View {
    @ObservedObject private var imageLoader: ImageAndThumbnailLoader
    
    var body: some View {
        switch (imageLoader.state)
        {
        case .initial :
            Text("Initial").frame(width: 100.0, height: 100.0)
        case .loading :
            Text("Loading ...").frame(width: 100.0, height: 100.0)
        case .error :
            Text("Error").frame(width: 100.0, height: 100.0)
        case .loaded :
            Image(nsImage: imageLoader.image ?? NSImage(systemSymbolName: "tortoise", accessibilityDescription: "to load")!)
                //.frame(width: 100.0, height: 100.0)
                .shadow(radius: 50)
                .scaledToFill().onAppear(perform: {
                    os_log("  ThumbnailImg -- onAppear",log:OSLog.imageLoad,type:.debug)
                })
        }
    }
    init( path:String)
    {
        imageLoader = ImageAndThumbnailLoader(path: path)
        imageLoader.requestImage()
    }
}

struct ThumbnailImg_Previews: PreviewProvider {
    static var previews: some View {
        ThumbnailImg(path:  "/Users/hlemai/Pictures/Fond/_DSC5171.jpg")
    }
}
