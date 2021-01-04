//
//  DataModel.swift
//  ImageFirstUI
//
//  Created by Hervé LEMAI on 31/12/2020.
//

import Foundation
import SwiftUI

struct DispImg: Hashable, Codable, Identifiable {
    var id : String
    var name: String
    var description: String
    var isFavorite = false
}


final class ModelData: ObservableObject {
    @Published var directory = "/Users/hlemai/Pictures/Fond/"
    //@Published var rep = "/Users/hlemai/Pictures/orig/"
    //@Published var rep = "/Volumes/data-sd/Pictures/orig/"
    
    
    @Published var images: [DispImg] = [
        DispImg(id: "_DSC5171",name:"_DSC5171.jpg",description: "lanbscape from Mont Des Cats"),
        DispImg(id: "_DSF1494",name:"_DSF1494.jpg",description: "Photo camera"),
        DispImg(id: "DSC02438",name:"DSC02438.jpg",description: "san francisco display")]
    
    
    init() {
        internalInit()
    }
    init( mockup:Bool) {
        if(!mockup) {
            internalInit()
        }
    }
    private func internalInit() {
        directory = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("Pictures", isDirectory: true).path + "/"
        LoadImages()
    }
    
    public func LoadImages() {
        let fm = FileManager.default
        do {
            //let  files = try fm.contentsOfDirectory(atPath: self.rep)
            let files = try fm.getListOfImage(from: URL(fileURLWithPath: self.directory))
            images.removeAll()
            for file in files {
                images.append(DispImg(id:file.lastPathComponent,name:file.lastPathComponent,description: ""))
            }
        }
        catch {
            print("Error reading \(self.directory)")
        }
    }
    public func changeDirectory(_ directory:String) {
        self.directory=directory
        LoadImages()
    }
    

}

