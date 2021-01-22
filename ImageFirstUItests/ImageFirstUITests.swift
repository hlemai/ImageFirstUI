//
//  ImageFirstUITests.swift
//  ImageFirstUITests
//
//  Created by Hervé LEMAI on 04/01/2021.
//

import XCTest
import Foundation
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
        let modelData = ExplorerViewModel(mockup: true)
        XCTAssert(modelData.images.count == 3)
    }
    
    func testImageLoader() throws {
        print("===== Testing image loader")
        let imgLoader=ImageThumbnailLoader(path: "/Users/hlemai/Pictures/fond/DSC02560.jpg")
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
    
    func testslowDisk() throws {
        
        let queue = DispatchQueue(label: "ImageLoaderTests")
        var imgIcon:NSImage?=nil
        var images:[String]=[]
        var imageLoaders: [ImageThumbnailLoader] = []

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
                    let imgLoader = ImageThumbnailLoader(path:file)
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
        let  modelData = ExplorerViewModel(mockup: true)
        measure {
            // Put the code you want to measure the time of here.
            modelData.changeDirectory("/Users/hlemai/Pictures/Fond/")
            print("Listing \(modelData.images.count) images")
            XCTAssert(modelData.images.count>300)
        }
    }

    
}
