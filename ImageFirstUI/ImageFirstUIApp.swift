//
//  ImageFirstUIApp.swift
//  ImageFirstUI
//
//  Created by Hervé LEMAI on 31/12/2020.
//

import SwiftUI

@main
struct ImageFirstUIApp: App {
    @StateObject private var modelData = ModelData()
        
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(modelData)

        }
    }
}
