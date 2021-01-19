//
//  DispImgList.swift
//  ImageFirstUI
//
//  Created by Hervé LEMAI on 31/12/2020.
//

import SwiftUI


/// view displaying table of thumbnal pictures
struct DispImgList: View {
    
    @EnvironmentObject var dirVModel: ExplorerViewModel
    let directory:String
    
    /// columns definitions
    let columns = [GridItem(.adaptive(minimum: 100.0, maximum: 300.0))]
    
    
    var body: some View {
        VStack {
            Text(self.directory)
            Text(dirVModel.currentDirectory)
            ScrollView {
                LazyVGrid(columns: columns,  spacing:20 ) {
                    ForEach(dirVModel.images) { img in
                        VStack {
                            ThumbnailImg(path : img.path)
                            Text(img.name)
                        }
                    }
                }
            }
        }.onAppear(perform: {
            dirVModel.changeDirectory(self.directory)
        })
    }
    
    init(directory: String) {
        self.directory=directory
        //dirVModel.changeDirectory(self.directory)
    }
}

struct DispImgList_Previews: PreviewProvider {
    static var previews: some View {
        DispImgList(directory:"/Users/hlemai/Pictures/Fond")
            .environmentObject(ExplorerViewModel(mockup: true))
        
    }
}
