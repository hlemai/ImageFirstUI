//
//  FileManager.swift
//  ImageFirstUI
//
//  Created by Hervé LEMAI on 03/01/2021.
//
import Foundation
import SwiftUI

/// Extension on FileManager usefull to get List of image file and subdirectories
extension FileManager {

    /// Get list of files filtered on image
    /// parameters :
    ///     - from : url of the folder containing pictures
    ///     - includesubDirectory : recurse find directories
    func getListOfImage(from url: URL,includesubDirectory: Bool ) throws -> [URL] {
        do {
            var options:DirectoryEnumerationOptions
            if includesubDirectory {
                options = [.skipsHiddenFiles,.skipsPackageDescendants]
            }
            else {
                options = [.skipsHiddenFiles,.skipsSubdirectoryDescendants]
            }
            let directoryContents =  FileManager.default.enumerator(at: url, includingPropertiesForKeys: nil, options: options,errorHandler: nil)
            let img = try directoryContents?.filter { (it) -> Bool in
                let url = it as? URL
                let ids = try url?.resourceValues(forKeys: [URLResourceKey.typeIdentifierKey]).typeIdentifier
                return UTTypeConformsTo(ids! as CFString, kUTTypeImage)
            }.map {
                return ($0 as! URL)
            }
            return img!
        }
    }
    /// get List of sub directories
    /// parameters :
    ///     - from : url of the folder
    func getListSubDirectories(from url: URL) throws -> [URL] {
        let subDirs = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: [.isDirectoryKey], options: [.skipsSubdirectoryDescendants,.skipsHiddenFiles,.skipsPackageDescendants]).filter {url in return url.hasDirectoryPath}
        return subDirs
    }
    

    /// not used, to be tested.
    func thumbnail(from url: URL, placeholder: NSImage? = nil) -> NSImage? {
        do {
            let thumbnailDictionary = try url.promisedItemResourceValues(forKeys: [URLResourceKey.thumbnailDictionaryKey]).thumbnailDictionary
            guard let image = thumbnailDictionary?[URLThumbnailDictionaryItem.NSThumbnail1024x1024SizeKey] else {
                return placeholder
            }
            return image
        } catch {
            return placeholder
        }
    }
}
