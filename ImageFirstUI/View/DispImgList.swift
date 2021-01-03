//
//  DispImgList.swift
//  ImageFirstUI
//
//  Created by Hervé LEMAI on 31/12/2020.
//

import SwiftUI
//import Foundation


struct DispImgList: View {
    @EnvironmentObject var modelData: ModelData

    let columns = [GridItem(.adaptive(minimum: 100.0, maximum: 300.0))]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns,  spacing:20 ) {
                ForEach(modelData.images) { img in
                    VStack {
                        ThumbnailImg(directory: modelData.directory, name: img.name)
                        Text(img.name)
                    }
                }
            }
        }
    }
}

struct DispImgList_Previews: PreviewProvider {
    static var previews: some View {
        DispImgList().environmentObject(ModelData(mockup: true))
        
    }
}
