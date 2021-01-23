import Foundation
import SwiftUI

class ImgCacheKey :NSObject{
    let path:NSString
    let size:CGSize
    
    init(path:String,size:CGSize) {
        self.path = NSString(string : path)
        self.size = size
    }
    
    override func isEqual(_ object: Any?) -> Bool {
         guard let other = object as? ImgCacheKey else {
             return false
         }
         return path == other.path && size == other.size
     }
     
     override var hash: Int {
        return path.hashValue ^ size.width.hashValue ^ size.height.hashValue
     }
}

class ImageCache {
    var cache = NSCache<ImgCacheKey, NSImage>()
    
    func get(path: String, size : CGSize) -> NSImage? {
        return cache.object(forKey: ImgCacheKey(path:path,size:size))
    }
    
    func set(path: String, size : CGSize, image: NSImage) {
        cache.setObject(image, forKey: ImgCacheKey(path:path,size:size))
    }
}

extension ImageCache {
    private static var imageCache = ImageCache()
    static func getImageCache() -> ImageCache {
        return imageCache
    }
}
