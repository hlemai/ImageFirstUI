//
//  ThumbnailImg.swift
//  ImageFirstUI
//
//  Created by Hervé LEMAI on 02/01/2021.
//

import SwiftUI

struct ThumbnailImg: View {
    @ObservedObject private var imageLoader: ImageLoader
    
    var body: some View {
        Image(nsImage: imageLoader.image ?? NSImage(systemSymbolName: "tortoise", accessibilityDescription: "to load")!)
            .frame(width: 100.0, height: 100.0)
            .onAppear( perform:{
            imageLoader.requestImage()
        }).scaledToFill()
    }
    init(directory:String, name:String )
    {
        imageLoader = ImageLoader(directory : directory, name: name)
    }
}

struct ThumbnailImg_Previews: PreviewProvider {
    static var previews: some View {
        ThumbnailImg(directory:  "/Users/hlemai/Pictures/Fond/",name:"_DSC5171.jpg")
    }
}
