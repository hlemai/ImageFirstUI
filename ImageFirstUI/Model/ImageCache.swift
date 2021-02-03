import Foundation
import SwiftUI

/// utility class : KEY of thumbnail Image cache
class ImgCacheKey :NSObject{

    /// keys sub Members
    let path:NSString
    let size:CGSize

    /// new key
    init(path:String,size:CGSize) {
        self.path = NSString(string : path)
        self.size = size
    }
    
    /// implement function for cache management
    override func isEqual(_ object: Any?) -> Bool {
         guard let other = object as? ImgCacheKey else {
             return false
         }
         return path == other.path && size == other.size
     }
    
    /// implement function for cache management
    override var hash: Int {
        return path.hashValue ^ size.width.hashValue ^ size.height.hashValue
     }
}

/// class managing thumbnail cache with ImgCacheKey as key
/// store NSImage
class ImageCache {
    var cache = NSCache<ImgCacheKey, NSImage>()
    
    func get(path: String, size : CGSize) -> NSImage? {
        return cache.object(forKey: ImgCacheKey(path:path,size:size))
    }
    
    func set(path: String, size : CGSize, image: NSImage) {
        cache.setObject(image, forKey: ImgCacheKey(path:path,size:size))
    }
}

/// Singleton extention
extension ImageCache {
    private static var imageCache = ImageCache()
    static func getImageCache() -> ImageCache {
        return imageCache
    }
}
