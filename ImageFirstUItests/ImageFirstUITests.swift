//
//  ImageFirstUITests.swift
//  ImageFirstUITests
//
//  Created by Hervé LEMAI on 04/01/2021.
//

import XCTest
import Foundation
import SwiftUI
@testable import ImageFirstUI

class ImageFirstUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        print("Testing")
        XCTAssert(true)
    }

    func testModel() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        print("===== Testing Model")
        let modelData = ImageExplorerStore(mockup: true)
        XCTAssert(modelData.images.count == 3)
    }
    
    func testImageLoader() throws {
        print("===== Testing image loader")
        let imgLoader=ImageAndThumbnailLoader(path: "/Users/hlemai/Pictures/fond/DSC02560.jpg",thumbnail: true,size : CGSize(width:100,height:100))
        let queue = DispatchQueue(label: "ImageLoaderTests")
        
        imgLoader.uidispatchQueue=queue
        
        queue.async {
            // first time
            imgLoader.requestImage()
            // second time
            imgLoader.requestImage()
//            XCTAssert(imgLoader.image?.size.height == 15.0)
        }
        
        queue.sync {
            sleep(1)
            print("sync ")
            sleep(1)
        }
        queue.async {
            for i in 1...5 {
                print(" ---\(i)")
                sleep(2)
                if(imgLoader.image != nil) {
                    break;
                }
            }
            
            print("after loading")
            XCTAssert(imgLoader.image?.size.height==100)
        }
        queue.sync {
            sleep(1)
            print("End Tests")
        }
    }
    
    func testCache() throws {
        let cache = ImageCache.getImageCache()
        let path =  "/Users/hlemai/Pictures/fond/DSC02560.jpg"
        let size1:CGSize = CGSize(width: 100, height: 100)
        let size2:CGSize = CGSize(width: 200, height: 200)
        
        let key1 = ImgCacheKey(path:path, size:size1)
        let key2 = ImgCacheKey(path:path, size:size1)
        let key3 = ImgCacheKey(path:path, size:size2)
        XCTAssert(key1 == key2)
        XCTAssert(key1 != key3)
        
        let img1 = NSImage(systemSymbolName:"folder", accessibilityDescription:"")!
        let img2 = NSImage(systemSymbolName:"pencil", accessibilityDescription:"")!
        cache.set(path:path,size:size1,image:img1)
        cache.set(path:path,size:size2,image:img2)
        let imgret = cache.get(path:path,size:size1)
        XCTAssert(imgret==img1)
        
    }
    
    func testslowDisk() throws {
        
        let queue = DispatchQueue(label: "ImageLoaderTests")
        var imgIcon:NSImage?=nil
        var images:[String]=[]
        var imageLoaders: [ImageAndThumbnailLoader] = []

         queue.async {
            do {
                let fm = FileManager.default
                
                
                //let directory="/Volumes/data-sd/Pictures/orig"
                let directory="/Users/hlemai/Pictures/vekia"
        
        
                let files = try fm.getListOfImage(from: URL(fileURLWithPath: directory),includesubDirectory: true)
            
                for file in files {
                    images.append(file.path)
                }
                print (images.count)
                
                
                    
                for file in images {
                    let imgLoader = ImageAndThumbnailLoader(path:file)
                    imgLoader.uidispatchQueue=queue;
                    imgLoader.asyncQueue = queue
                    imageLoaders.append(imgLoader)
                    imgLoader.requestImage()
                }
                imgIcon = imageLoaders[images.count-1].image
            }
            catch {}
        }
        for i in 1...5 {
            print(" ---\(i)")
            //imgLoader.requestImage()
            sleep(1)
        }
        queue.sync {
            for i in 1...5 {
                print(" ---\(i)")
                //imgLoader.requestImage()
                sleep(1)
                if(imageLoaders[images.count-1].image != imgIcon) {
                    break;
                }
            }
            print("end of reading")
        }

    }

    func testPerformanceModel() throws {
        // This is an example of a performance test case.
        print("===== Testing image loader")
        let  modelData = ImageExplorerStore(mockup: true)
        measure {
            // Put the code you want to measure the time of here.
            modelData.changeDirectory("/Users/hlemai/Pictures/Fond/")
            print("Listing \(modelData.images.count) images")
            XCTAssert(modelData.images.count>300)
        }
    }

    
}
