//
//  SettingsView.swift
//  ImageFirstUI
//
//  Created by Hervé LEMAI on 02/02/2021.
//

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var store:ImageExplorerStore


    var body: some View {
        VStack {
            HStack {
                Text("Thumbnail Size")
                ZoomSlider(zoomSize: $store.userSettings.thumbnailSize)
                Text("\(store.userSettings.thumbnailSize)")
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView().environmentObject(ImageExplorerStore(mockup: true))
    }
}
