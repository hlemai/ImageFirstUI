//
//  ContentView.swift
//  ImageFirstUI
//
//  Created by Hervé LEMAI on 31/12/2020.
//

import SwiftUI
import os.log

struct ContentView: View {
    @StateObject var imageStore: ImageExplorerStore = ImageExplorerStore()
    @State private var navBarHidden = false
    
    func changeDirectory() {
        imageStore.uiChangeDirectory()
    }
    func refresh() {
        imageStore.changeDirectory(imageStore.currentDirectory)
    }
    
    private func toggleSidebar() {
        #if os(iOS)
        #else
        NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
        #endif
    }
    
    @State var selection: Set<Int> = [0]
    var body: some View {
        NavigationView {
            List(selection:self.$selection) {
                Section(header: Text(LocalizedStringKey("SubFolders"))) {
                        ForEach( imageStore.subDirectories,id:\.id) { dir in
                            Button (action: {
                                imageStore.changeDirectory(dir.path)
                            },
                                label: {
                                    Label(dir.name,systemImage:"folder")
                                })

                        }
                    }
            }

            DispImgList(imageStore: imageStore)
            FullImageView(path: imageStore.currentImagePath)
        }
        .navigationTitle(imageStore.title)
        .navigationSubtitle(imageStore.currentDirectory)
        .toolbar {
            //Toggle Sidebar Button
            ToolbarItem(placement: .navigation){
                Button(action: toggleSidebar, label: {
                    Image(systemName: "sidebar.left")
                })
            }
            ToolbarItem (placement: ToolbarItemPlacement.cancellationAction) {
                Toggle(isOn: $imageStore.includeSubDirectory, label: {
                        Text("IncludeSubDirs")
                    }).toggleStyle(CheckboxToggleStyle())
            }
            ToolbarItem(placement: .cancellationAction) {
                Button(action:changeDirectory) {
                    Label("ChangeDirectory",systemImage:"folder")
                    Text("ChangeDirectory")
                }
            }

        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(imageStore: ImageExplorerStore(mockup: true))
            .environment(\.locale, .init(identifier: "en"))
    }
}
