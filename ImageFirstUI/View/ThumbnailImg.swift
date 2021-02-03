//
//  ThumbnailImg.swift
//  ImageFirstUI
//
//  Created by Hervé LEMAI on 02/01/2021.
//

import SwiftUI
import os.log

/// view displaying a thumbnail
struct ThumbnailImg: View {
    @ObservedObject private var imageLoader: ImageAndThumbnailLoader
    
    var body: some View {
        // managing loading state lifecycle
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
                .shadow(radius: 50)
                .scaledToFill()
        }
    }
    /// new Thumbnail
    /// parameters :
    /// -   path : full path of the image
    /// -   thumbnailSize size of the thumbnail
    init( path:String, thumbnailSize:Double)
    {
        let size = CGSize(width: thumbnailSize, height: thumbnailSize)
        os_log(" request thumbnail %f size",log:OSLog.imageLoad,type:.debug,thumbnailSize)
        imageLoader = ImageAndThumbnailLoader(path: path,thumbnail: true,size: size)
        imageLoader.requestImage()
    }
}

struct ThumbnailImg_Previews: PreviewProvider {
    static var previews: some View {
        ThumbnailImg(path:  "/Users/hlemai/Pictures/Fond/_DSC5171.jpg",thumbnailSize:200)
    }
}
