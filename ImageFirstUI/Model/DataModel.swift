//
//  DataModel.swift
//  ImageFirstUI
//
//  Created by Hervé LEMAI on 31/12/2020.
//

import Foundation
import SwiftUI

struct DispImg: Hashable, Codable, Identifiable {
    var id : UUID = UUID()
    var name: String
    var path :String
    var isFavorite = false
}


final class ModelData: ObservableObject {
    @Published var directory = "/Users/hlemai/Pictures/Fond/"
    @Published var includeSubDirectory:Bool = false {
        didSet {
            changeDirectory(self.directory)
        }
    }
    
    
    @Published var images: [DispImg] = [
        DispImg(name:"_DSC5171.jpg",path: "/Users/hlemai/Pictures/fond/_DSC5171.jpg"),
        DispImg(name:"_DSF1494.jpg",path: "/Users/hlemai/Pictures/fond/_DSF1494.jpg"),
        DispImg(name:"DSC02438.jpg",path: "/Users/hlemai/Pictures/fond/DSC02438.jpg")]
    
    
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
            let files = try fm.getListOfImage(from: URL(fileURLWithPath: self.directory),includesubDirectory: self.includeSubDirectory)
            images.removeAll()
            for file in files {
                images.append(DispImg(name:file.lastPathComponent,path: file.path))
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

