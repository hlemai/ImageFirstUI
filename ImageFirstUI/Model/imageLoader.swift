//
//  ImageLoader.swift
//


import AppKit
import SwiftUI
import Combine
import Foundation
import os.log

public class ImageLoader: ObservableObject
{
    private var imagePath: String
    private var imgCache = ImageCache.getImageCache()
    
    public var dispatchQueue = DispatchQueue.main
    
    
    public private(set) var image: NSImage?
    {
        willSet
        {
            self.objectWillChange.send()
        }
    }

    public var objectWillChange = PassthroughSubject<Void, Never>()

    public init( directory: String, name: String)
    {
        self.imagePath = directory+name
    }

    private func downsample(imageAt imageURL: URL, to pointSize: CGSize, scale: CGFloat) -> NSImage? {

        let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
        guard let imageSource = CGImageSourceCreateWithURL(imageURL as CFURL, imageSourceOptions) else {
            os_log("Fail to open image: %@ ", log: OSLog.imageLoad ,type: .error,imageURL.absoluteString)
            return nil
        }
        
        let maxDimentionInPixels = max(pointSize.width, pointSize.height) * scale
        
        let downsampledOptions = [kCGImageSourceCreateThumbnailFromImageAlways: true,
                                  kCGImageSourceShouldCacheImmediately: true,
                                  kCGImageSourceCreateThumbnailWithTransform: true,
                                  kCGImageSourceThumbnailMaxPixelSize: maxDimentionInPixels] as CFDictionary
            guard let downsampledImage =     CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampledOptions) else {
                os_log("Fail to downsample: %@ ", log: OSLog.imageLoad ,type: .error,imageURL.absoluteString)
                return nil
            }
        
            return NSImage(cgImage: downsampledImage,size: NSSize(width: pointSize.width, height: pointSize.height))
    }
    
    private func loadImageFromDiskWith(fileName: String) -> NSImage? {
        let path = fileName;
        let size = CGSize(width: 100.0, height: 100.0)
        os_log("try to load : %@ ", log: OSLog.imageLoad ,type: .debug,path)
        if let image = downsample(imageAt: URL(fileURLWithPath: path), to: size, scale: 2) {
            image.resizingMode = .tile
            os_log("image loaded: %@ ", log: OSLog.imageLoad ,type: .info,path)
            return image
        }
        os_log("Fail to load: %@ ", log: OSLog.imageLoad ,type: .error,path)
        return nil
    }
    
    public func requestImage() -> Void {
        os_log("request: %@ ", log: OSLog.imageLoad ,type: .debug,self.imagePath)
        if !loadImageFromCache() {
            os_log("not in cache: %@ ", log: OSLog.imageLoad ,type: .debug,self.imagePath)

            self.imgCache.set(forKey: self.imagePath, image: NSImage(systemSymbolName: "bonjour",accessibilityDescription: "")!)
            os_log("push temp image in cache ", log: OSLog.imageLoad ,type: .debug)

            let queue = DispatchQueue.global(qos: .default)
            queue.async{
                [weak self] in
                    guard let self = self else { return }
                    let img = self.loadImageFromDiskWith(fileName: self.imagePath)
                    self.dispatchQueue.sync {
                        self.image=img
                        if img != nil {
                            self.imgCache.set(forKey: self.imagePath, image: img!)
                            os_log("push real image in cache ", log: OSLog.imageLoad ,type: .debug)
                        }
                    }
            }
        }
    }
    
    private func loadImageFromCache() -> Bool {
            guard let cacheImage = imgCache.get(forKey: imagePath) else {
                return false
            }
            image = cacheImage
            return true
        }
}

