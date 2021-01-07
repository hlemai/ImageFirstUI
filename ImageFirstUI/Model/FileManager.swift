//
//  FileManager.swift
//  ImageFirstUI
//
//  Created by Hervé LEMAI on 03/01/2021.
//
import Foundation
import SwiftUI

extension FileManager {
    /*
    func getListOfDocument(from url: URL, id: String) -> [URL] {
        do {
            let directoryContents = try FileManager.default.contentsOfDirectory(at: url.appendingPathComponent(id), includingPropertiesForKeys: nil, options: [.skipsHiddenFiles])
            let filterById = directoryContents.filter({ $0.absoluteString.contains(id) })
            let doc = try filterById.filter { (url) -> Bool in
                let ids = try url.resourceValues(forKeys: [URLResourceKey.typeIdentifierKey]).typeIdentifier
                let typeIds = ids! as CFString
                return UTTypeConformsTo(typeIds, kUTTypePDF) || UTTypeConformsTo(typeIds, kUTTypeRTF) || UTTypeConformsTo(typeIds, "com.microsoft.word.doc" as CFString) || UTTypeConformsTo(typeIds, "org.openxmlformats.wordprocessingml.document" as CFString)
            }
            return doc
        } catch {
            return []
        }
    }*/
    
    func  getListOfImage(from url: URL,includesubDirectory: Bool ) throws -> [URL] {
        do {
            
            var options:DirectoryEnumerationOptions
            if includesubDirectory {
                options = [.skipsHiddenFiles,.skipsPackageDescendants]
            }
            else {
                options = [.skipsHiddenFiles,.skipsSubdirectoryDescendants]
            }
            //let directoryContents = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: options)
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
