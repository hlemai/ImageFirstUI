//
//  FullImageView.swift
//  ImageFirstUI
//
//  Created by Hervé LEMAI on 20/01/2021.
//

import SwiftUI
/// view displaying a whole image
struct FullImageView: View {
    @ObservedObject private var imageLoader: ImageAndThumbnailLoader
    
    var body: some View {
        // managing loading state
        switch (imageLoader.state)
        {
        case .initial :
            EmptyView()
        case .loading :
            EmptyView()
        case .error :
            EmptyView()
        case .loaded :
            Image(nsImage: imageLoader.image ?? NSImage(systemSymbolName: "tortoise", accessibilityDescription: "to load")!)
                .resizable()
                //.frame(width: 100.0, height: 100.0)
                .shadow(radius: 50)
                .scaledToFit()
        }
    }
    /// new Image View
    /// parameter :
    /// -   path : path of the image
    init( path:String?) {
        imageLoader = ImageAndThumbnailLoader(path: path ,thumbnail: false)
        imageLoader.requestImage()
    }
}

struct FullImageView_Previews: PreviewProvider {
    static var previews: some View {
        FullImageView(path:  "/Users/hlemai/Pictures/Fond/_DSC5171.jpg")
    }
}
