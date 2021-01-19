//
//  ImageLoader.swift
//
import AppKit
import SwiftUI
import Combine
import Foundation
import os.log

/// combine class use to load a pictire and compute a
public class ImageThumbnailLoader: ObservableObject
{
    /// image to load
    private var imagePath: String
    /// reference Image Cache singleton
    private var imgCache = ImageCache.getImageCache()
    
    /// queues
    /// TODO : remove or no public queue (used in tests)
    public var uidispatchQueue = DispatchQueue.main
    public var asyncQueue =  DispatchQueue.global(qos: .background)
    
    /// Image loader, send
    public private(set) var image: NSImage?
    {
        willSet
        {
            self.objectWillChange.send()
        }
    }
    /// combine publisher (Subjet) that publish updates
    public var objectWillChange = PassthroughSubject<Void, Never>()

    /// construct a new ImageLoader
    public init( path: String)
    {
        self.imagePath = path
    }

    
    /// downsample
    /// parameters :
    ///     - imageat : url of the image
    ///     - to : size of image
    ///     - scale : retina scale
    /// return : NsImage or null if problems.
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
    
    /// load filename and call downsample
    private func loadImageFromDiskWith(fileName: String) -> NSImage? {
        let path = fileName;
        let size = CGSize(width: 100.0, height: 100.0)
        os_log("try to load : %@ ", log: OSLog.imageLoad ,type: .debug,path)
        if let image = downsample(imageAt: URL(fileURLWithPath: path), to: size, scale: 2) {
            image.resizingMode = .tile
            os_log("Thumbnal loaded: %@ ", log: OSLog.imageLoad ,type: .info,path)
            return image
        }
        os_log("Fail to load: %@ ", log: OSLog.imageLoad ,type: .error,path)
        return nil
    }
    
    /// Load and Comptute image Thumbnail
    /// Attention :
    ///     - use asynchronous queue
    ///     - temporary loading icon during computation
    ///     - Error image in case of probleme
    public func requestImage() -> Void {
        let imgPath = imagePath
        os_log("request: %@ ", log: OSLog.imageLoad ,type: .debug,self.imagePath)
        if !loadImageFromCache() {
            os_log("not in cache: %@ ", log: OSLog.imageLoad ,type: .debug,imgPath)

            let reading = NSImage(systemSymbolName: "arrow.3.trianglepath",accessibilityDescription: "loading")!
            self.imgCache.set(forKey: imgPath, image: reading)
            self.image=reading
            os_log("push temp image in cache ", log: OSLog.imageLoad ,type: .debug)

            let queue = asyncQueue
            queue.async{
                [weak self] in
                    guard let self = self else {
                        // Oups, i'm not existing yet
                        ImageCache.getImageCache().cache.removeObject(forKey: NSString(string: imgPath))
                        os_log("abord image in cache : %@", log: OSLog.imageLoad ,type: .debug,imgPath)
                        return
                    }
                    let img = self.loadImageFromDiskWith(fileName: self.imagePath)
                    self.uidispatchQueue.sync {
                        if img != nil {
                            self.image=img
                            self.imgCache.set(forKey: self.imagePath, image: img!)
                            os_log("push real image in cache ", log: OSLog.imageLoad ,type: .debug)
                        }
                        else {
                            os_log("Fail to load image, push error image in cache ", log: OSLog.imageLoad ,type: .error)
                            self.image=NSImage(systemSymbolName: "exclamationmark.triangle.fill", accessibilityDescription: "Error")
                            self.imgCache.set(forKey: self.imagePath, image: self.image!)
                        }
                        
                    }
            }
        }
    }
    
    /// if image is in cache, return true and set image
    private func loadImageFromCache() -> Bool {
            guard let cacheImage = imgCache.get(forKey: imagePath) else {
                return false
            }
            image = cacheImage
            return true
        }
}

