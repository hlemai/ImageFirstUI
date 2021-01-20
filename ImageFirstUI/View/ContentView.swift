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
    
    func changeDirectory() {
        dirVModel.uiChangeDirectory()
    }
    func refresh() {
        dirVModel.changeDirectory(dirVModel.currentDirectory)
    }
    
    var body: some View {
        NavigationView {
            
            List {
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
        }.navigationTitle(dirVModel.title)
        .navigationSubtitle(dirVModel.currentDirectory).toolbar(content: {
                Toggle(isOn: $dirVModel.includeSubDirectory, label: {
                    Text("Include sub directory")
            }).toggleStyle(CheckboxToggleStyle())
            Button(action:changeDirectory) {
                Label("Change Directory",systemImage:"folder")
                Text("Change Directory")
            }
            Button(action:refresh) {
                Label("Change Directory",systemImage:"circle.dashed")
                Text("Refresh")
            }
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(ExplorerViewModel(mockup:true)).font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
    }
}
