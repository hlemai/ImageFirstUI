//
//  DataModel.swift
//  ImageFirstUI
//
//  Created by Hervé LEMAI on 31/12/2020.
//

import Foundation
import SwiftUI
import os.log


/// Struct used to store Picture information
struct PictureViewModel: Hashable, Codable, Identifiable {
    var id : UUID = UUID()
    var name: String
    var path :String
}
/// Struc use to store Directory Information
struct DirectoryViewModel : Hashable, Codable, Identifiable {
    var id : UUID = UUID()
    var name: String
    var path :String
}
/// View model to manage display of content of a directory
/// Note :
///     images contains an array of PictureViewModel
final class ImageExplorerStore: ObservableObject {
    
    /// Title of the window
    @Published var title = "Pictures"
    /// directory containing images to display
    @Published var currentDirectory = "/Users/hlemai/Pictures/"
    @Published var currentImagePath:String? = nil
    
    /// Force recurse explotation of currect directory
    @Published var includeSubDirectory:Bool = false {
        didSet {
            changeDirectory(self.currentDirectory)
        }
    }
    /// Pictures to be displayes
    @Published var directories: [DirectoryViewModel] = []
    /// Sub Directories of current Directorty
    @Published var subDirectories: [DirectoryViewModel] = []

    /// Pictures to be displayes
    @Published var images: [PictureViewModel] = []
    
    
    /// Construct a DirectoryViewModel
    init() {
        internalInit()
    }
    /// Construct a DirectoryViewModel
    /// Parameters :
    ///     - mockup : Bool to fill data with mockupdata for testing purpose
    init( mockup:Bool) {
        if(!mockup) {
            internalInit()
        }
        else {
            directories = [DirectoryViewModel(name: "Root", path: "/Users/hlemai/Pictures/Fond/")]
            subDirectories = [DirectoryViewModel(name: "Sub 1", path: "/Users/hlemai/Pictures/Fond/"),DirectoryViewModel(name: "Sub 2", path: "/Users/hlemai/Pictures/Fond/")]
            images = [PictureViewModel(name: "Image 1", path: "/Users/hlemai/Pictures/Fond/IMG_0186.jpg"),
                      PictureViewModel(name: "Image 2", path: "/Users/hlemai/Pictures/Fond/IMG_0186.jpg"),
                      PictureViewModel(name: "Image 3", path: "/Users/hlemai/Pictures/Fond/IMG_0186.jpg")]
        }
    }
    
    /// internal init
    private func internalInit() {
        currentDirectory = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("Pictures", isDirectory: true).path + "/"
        LoadImagesAndSubDIr()
    }
    /// call UI to choose a new directory
    public func uiChangeDirectory() {
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
                self.changeDirectory(path+"/")
            }
            
        } else {
            return
        }
    }
    /// Main function to change viewmodel proterty when changing directory
    /// parameters :
    ///     directory : new directory
    public func changeDirectory(_ directory:String) {
        currentDirectory = directory
        LoadImagesAndSubDIr()
    }

    /// private methode that fill array and title
    private func LoadImagesAndSubDIr() {
        os_log("Loading %@ "	, log: OSLog.imageLoad ,type: .info,self.currentDirectory)
        let fm = FileManager.default
        do {
            let urldir = URL(fileURLWithPath: currentDirectory)
            title = fm.displayName(atPath: urldir.absoluteString)
            
            let subs = try fm.getListSubDirectories(from: urldir)
            subDirectories.removeAll()
            subDirectories.append(DirectoryViewModel( name:".",path:urldir.path))
            subDirectories.append(DirectoryViewModel(name:"..",path:urldir.deletingLastPathComponent().path))
            for sub in subs {
                subDirectories.append(DirectoryViewModel(name: sub.lastPathComponent, path: sub.path))
            }
            let files = try fm.getListOfImage(from: urldir,includesubDirectory: self.includeSubDirectory)
            images.removeAll()
            for file in files {
                images.append(PictureViewModel(name:file.lastPathComponent,path: file.path))
            }
            
            os_log("-> %d subdirectories %d images", log: OSLog.imageLoad,type: .info,self.subDirectories.count,self.images.count)
        }
        catch {
            print("Error reading \(self.currentDirectory)")
        }
    }
}

