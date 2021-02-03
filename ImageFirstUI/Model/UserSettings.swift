import Foundation
import Combine
import os.log


class UserSettings: ObservableObject {
    @Published var thumbnailSize: Double {
        didSet {
            UserDefaults.standard.set(thumbnailSize, forKey: "thumbnailSize")
            os_log("set new thumbNailsize %f",log:OSLog.imageLoad, type:.debug,thumbnailSize)
        }
    }
    
    init() {
        self.thumbnailSize = max(UserDefaults.standard.double(forKey: "thumbnailSize"),100.0)
        os_log("getting thumbNailsize %f",log:OSLog.imageLoad, type:.debug,thumbnailSize)
        
    }
}
