//
//  ImageFirstUITests.swift
//  ImageFirstUITests
//
//  Created by Hervé LEMAI on 04/01/2021.
//

import XCTest
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
        let modelData = ModelData(mockup: true)
        XCTAssert(modelData.images.count == 3)
    }
    func testImageLoader() throws {
        print("===== Testing image loader")
        let imgLoader=ImageLoader(directory: "/Users/hlemai/Pictures/fond/", name: "DSC02560.jpg")
        let queue = DispatchQueue(label: "ImageLoaderTests")
        
        imgLoader.dispatchQueue=queue
        var imgicon : NSImage?
        queue.async {
            XCTAssert(imgLoader.image == nil)
            // first time
            imgLoader.requestImage()
            XCTAssert(imgLoader.image == nil)
            // second time
            imgLoader.requestImage()
            XCTAssert(imgLoader.image?.size.height == 15.0)
            imgicon = imgLoader.image
        }
        
        queue.sync {
            sleep(1)
            print("sync ")
            sleep(1)
        }
        queue.async {
            for i in 1...5 {
                print(" ---\(i)")
                //imgLoader.requestImage()
                sleep(2)
                if(imgLoader.image != imgicon) {
                    break;
                }
            }
            
            print("after loading")
            XCTAssert(imgLoader.image?.size.height==100)
            XCTAssert(imgLoader.image != imgicon)
        }
        queue.sync {
            sleep(1)
            print("End Tests")
        }
    }

    func testPerformanceModel() throws {
        // This is an example of a performance test case.
        print("===== Testing image loader")
        let  modelData = ModelData(mockup: true)
        measure {
            // Put the code you want to measure the time of here.
            modelData.changeDirectory("/Users/hlemai/Pictures/Fond/")
            print("Listing \(modelData.images.count) images")
            XCTAssert(modelData.images.count>300)
        }
    }

}
