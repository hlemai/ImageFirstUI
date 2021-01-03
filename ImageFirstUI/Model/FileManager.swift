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
    
    func  getListOfImage(from url: URL) throws -> [URL] {
        do {
            let directoryContents = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles])
            let img = try directoryContents.filter { (url) -> Bool in
                let ids = try url.resourceValues(forKeys: [URLResourceKey.typeIdentifierKey]).typeIdentifier
                return UTTypeConformsTo(ids! as CFString, kUTTypeImage)
            }
            return img
        }
    }
    
    func createPathURL(by id: String) -> URL? {
        guard let localDirectory = try? FileManager.default.url(for: .documentDirectory , in: .userDomainMask , appropriateFor: nil, create: true) else { return nil }
        let url = localDirectory.appendingPathComponent(id)
        if !FileManager.default.fileExists(atPath: url.path) {
            try? FileManager.default.createDirectory(atPath: url.path, withIntermediateDirectories: true, attributes: nil)
        }
        return url
    }
    
    func writeFile(from url: URL, id: String) -> URL? {
        guard let localDirectory = createPathURL(by: id) else { return nil }
        let finalName = String(Date().timeIntervalSince1970) + "_" + url.lastPathComponent
        let finalPath = localDirectory.appendingPathComponent(finalName)
        do {
            let data = try Data(contentsOf: url)
            try data.write(to: finalPath)
            return finalPath
        } catch {
            print(error.localizedDescription)
            return nil
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
