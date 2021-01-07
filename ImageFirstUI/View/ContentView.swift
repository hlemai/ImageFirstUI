//
//  ContentView.swift
//  ImageFirstUI
//
//  Created by Hervé LEMAI on 31/12/2020.
//

import SwiftUI
import os.log

struct ContentView: View {
    @EnvironmentObject var modelData: ModelData
    func ChangeDirectory() {
        let dialog = NSOpenPanel();

        dialog.title                   = "Choose a Directory containing Pictures| Raw or jpeg";
        dialog.showsResizeIndicator    = true;
        dialog.showsHiddenFiles        = false;
        dialog.allowsMultipleSelection = false;
        dialog.canChooseDirectories = true;
        dialog.canChooseFiles=false;

        if (dialog.runModal() ==  NSApplication.ModalResponse.OK) {
            let result = dialog.url // Pathname of the file

            if (result != nil) {
                let path: String = result!.path
                
                // path contains the file directory e.g
                modelData.changeDirectory(path+"/")
            }
            
        } else {
            // User clicked on "Cancel"
            return
        }
        
    }
    func Clear() {
        modelData.directory=""
        modelData.images.removeAll()
    }
    var body: some View {
        VStack {
            Text("Pictures from \(modelData.directory)")
                .padding()
            DispImgList()
        }.toolbar(content: {
            Toggle(isOn: $modelData.includeSubDirectory, label: {
                Text("Include sub directory")
            }).toggleStyle(CheckboxToggleStyle())
            Button(action:ChangeDirectory) {
                Label("Change Directory",systemImage:"folder")
                Text("Change Directory")
            }
            Button(action:Clear) {
                Label("Clear",systemImage:"clear")
            }
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(ModelData(mockup:true))
    }
}
