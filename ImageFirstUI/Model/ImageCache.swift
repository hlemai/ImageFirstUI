import Foundation
import SwiftUI

class ImageCache {
    var cache = NSCache<NSString, NSImage>()
    
    func get(forKey: String) -> NSImage? {
        return cache.object(forKey: NSString(string: forKey))
    }
    
    func set(forKey: String, image: NSImage) {
        cache.setObject(image, forKey: NSString(string: forKey))
    }
}

extension ImageCache {
    private static var imageCache = ImageCache()
    static func getImageCache() -> ImageCache {
        return imageCache
    }
}
