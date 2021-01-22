//
//  FullImageView.swift
//  ImageFirstUI
//
//  Created by Hervé LEMAI on 20/01/2021.
//

import SwiftUI

struct FullImageView: View {
    @ObservedObject private var imageLoader: ImageThumbnailLoader
    
    var body: some View {
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
    
    init( path:String?) {
        imageLoader = ImageThumbnailLoader(path: path ,thumbnail: false)
        imageLoader.requestImage()
    }
}

struct FullImageView_Previews: PreviewProvider {
    static var previews: some View {
        FullImageView(path:  "/Users/hlemai/Pictures/Fond/_DSC5171.jpg")
    }
}
