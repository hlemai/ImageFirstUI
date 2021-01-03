//
//  ContentView.swift
//  ImageFirstUI
//
//  Created by Hervé LEMAI on 31/12/2020.
//

import SwiftUI
import os.log

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Hello, pictures!")
                .padding()
            DispImgList()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(ModelData(mockup:true))
    }
}
