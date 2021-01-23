//
//  ContentView.swift
//  ImageFirstUI
//
//  Created by Hervé LEMAI on 31/12/2020.
//

import SwiftUI
import os.log

struct ContentView: View {
    @EnvironmentObject var dirVModel: ExplorerViewModel
    @State private var navBarHidden = false
    
    func changeDirectory() {
        dirVModel.uiChangeDirectory()
    }
    func refresh() {
        dirVModel.changeDirectory(dirVModel.currentDirectory)
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
                /*
                    Section(header: Text("Favorites")) {
                        ForEach (dirVModel.directories,id: \.id) {  dir in
                            NavigationLink(
                                destination: DispImgList(),
                                label: {
                                    Label(dir.name,systemImage:"star")
                                })
                        }
                    }*/
                    Section(header: Text("Subfolders")) {
                        ForEach( dirVModel.subDirectories,id:\.id) { dir in
                            Button (action: {
                                dirVModel.changeDirectory(dir.path)
                            },
                                label: {
                                    Label(dir.name,systemImage:"folder")
                                })

                        }
                    }
            }

            DispImgList()
            FullImageView(path: dirVModel.currentImagePath)
        }
        .navigationTitle(dirVModel.title)
        .navigationSubtitle(dirVModel.currentDirectory)
        .toolbar {
            //Toggle Sidebar Button
            ToolbarItem(placement: .navigation){
                Button(action: toggleSidebar, label: {
                    Image(systemName: "sidebar.left")
                })
            }
            ToolbarItem (placement: ToolbarItemPlacement.cancellationAction) {
                Toggle(isOn: $dirVModel.includeSubDirectory, label: {
                        Text("Include sub directory")
                    }).toggleStyle(CheckboxToggleStyle())
            }
            ToolbarItem(placement: .cancellationAction) {
                Button(action:changeDirectory) {
                    Label("Change Directory",systemImage:"folder")
                    Text("Change Directory")
                }
            }

        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(ExplorerViewModel(mockup:true)).font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
    }
}
