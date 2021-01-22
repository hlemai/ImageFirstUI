//
//  DispImgList.swift
//  ImageFirstUI
//
//  Created by Hervé LEMAI on 31/12/2020.
//

import SwiftUI


/// view displaying table of thumbnal pictures
struct DispImgList: View {
    
    /// view model
    @EnvironmentObject var dirVModel: ExplorerViewModel
    
    /// columns definitions
    let columns = [GridItem(.adaptive(minimum: 100.0, maximum: 300.0))]
    
    var body: some View {
        HSplitView {
            ScrollView {
                LazyVGrid(columns: columns,  spacing:20 ) {
                    ForEach(dirVModel.images) { img in 
                                VStack {
                                    ThumbnailImg(path : img.path)
                                    Text(img.name)
                                }.onTapGesture {
                                    dirVModel.currentImagePath = img.path
                                }
                        }
                    }
            }
            FullImageView(path: dirVModel.currentImagePath)
        }.frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealWidth: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealHeight: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
    }
}

struct DispImgList_Previews: PreviewProvider {
    static var previews: some View {
        DispImgList()
            .environmentObject(ExplorerViewModel(mockup: true))
        
    }
}
