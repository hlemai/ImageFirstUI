//
//  ImageLoader.swift
//
import AppKit
import SwiftUI
import Combine
import Foundation
import os.log

/// combine class use to load a pictire and compute a
public class ImageAndThumbnailLoader: ObservableObject
{
    public enum StateLoading {
        case initial
        case loading
        case loaded
        case error
    }
    
    enum Destination {
        case thumbnail(CGSize)
        case fullimage
    }

    /// image to load
    private var imagePath: String?
    /// reference Image Cache singleton
    private var imgThumbnailCache = ImageCache.getImageCache()
    
    /// queues change are available for tests (in order to do test)
    var uidispatchQueue = DispatchQueue.main
    // TODO : parameter for slowing and less power consumption
    var asyncQueue =  DispatchQueue.global(qos: .userInteractive)
    
    private let destination:Destination
    private let iscachedtoThumbnail:Bool
    
    /// Image loader, send
    @Published
    public private(set) var image: NSImage?
    
    
    @Published
    public var state:StateLoading = .initial
    
//    /// combine publisher (Subjet) that publish updates
//    public var objectWillChange = PassthroughSubject<Void, Never>()

    /// construct a new ImageLoader
    public init( path: String?, thumbnail : Bool = true, size:CGSize = CGSize(width: 100, height: 100))
    {
        self.imagePath = path
        if thumbnail {
            destination = .thumbnail(size)
            iscachedtoThumbnail = true
        } else {
            destination = .fullimage
            iscachedtoThumbnail = false
        }
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
    private func loadImageFromDisk() -> NSImage? {
    
        os_log("  try to load : %@ ", log: OSLog.imageLoad ,type: .debug,imagePath!)
        
        switch destination {
        case .thumbnail(let size):
            if let image = downsample(imageAt: URL(fileURLWithPath: imagePath!), to: size, scale: 2) {
                image.resizingMode = .tile
                os_log("Thumbnal loaded: %@ ", log: OSLog.imageLoad ,type: .info,imagePath!)
                return image
            }

        case .fullimage:
            return NSImage(contentsOfFile: imagePath!)
        }
        os_log("Fail to load: %@ ", log: OSLog.imageLoad ,type: .error,imagePath!)
        return nil
    }
    
    /// Load and Comptute image Thumbnail
    /// Attention :
    ///     - use asynchronous queue
    ///     - temporary loading icon during computation
    ///     - Error image in case of probleme
    public func requestImage() -> Void {
        guard let imgPath = imagePath else {
            return
        }
        os_log("  request: %@ ", log: OSLog.imageLoad ,type: .debug,imgPath)
        
        
        if loadImageThumbnailFromCacheIfNeeded() {
            return
        } else {
            os_log("  not in cache: %@ ", log: OSLog.imageLoad ,type: .debug,imgPath)
        }
        
        self.state = .loading
        os_log("  change image state to loading ", log: OSLog.imageLoad ,type: .debug)
        asyncQueue.async{
            [weak self] in
                guard let self = self else {
                    // Oups, i'm not existing yet
                    return
                }
                let img = self.loadImageFromDisk()
                self.uidispatchQueue.async {
                    if img != nil {
                        self.image=img
                        self.state = .loaded
                        self.pushImageInCacheifNeeded(img!)
                    }
                    else {
                        os_log("Fail to load image ", log: OSLog.imageLoad ,type: .error)
                        self.state = .error
                    }
                }
        }
    }
    
    /// if image is in cache, return true and set image
    private func loadImageThumbnailFromCacheIfNeeded() -> Bool {
        
        switch destination {
        case .thumbnail(let size):
            guard let cacheImage = imgThumbnailCache.get(path: imagePath!,size:size ) else {
                return false
            }
            image = cacheImage
            state = .loaded
            return true
        default:
            return false
        }
    }
    private func pushImageInCacheifNeeded(_ img:NSImage) {
        switch destination {
        case .thumbnail(let size):
            self.imgThumbnailCache.set(path: imagePath!,size : size, image: img)
            os_log("  push real image in cache ", log: OSLog.imageLoad ,type: .debug)
        default :
            return
        }
    }
}

