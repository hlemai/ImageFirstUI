//
//  SettingsView.swift
//  ImageFirstUI
//
//  Created by Hervé LEMAI on 02/02/2021.
//

import SwiftUI

struct SettingsView: View {

    @AppStorage("Thumbnail Size") var thumbnailSize:Double = 100

    var body: some View {
        VStack {
            Text("Preview Thumbnail Preferences").font(.headline)
            HStack {
                Text("Thumbnail Size")
                ZoomSlider(thumbnailSize: $thumbnailSize).frame( maxWidth: 300)
                Text(String(format: "%.2f", thumbnailSize))
            }
        }.padding()
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
