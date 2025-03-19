//
//  ImageDataCacheTest.swift
//  Fetch
//
//  Created by Jean Pierre on 3/18/25.
//

import XCTest
@testable import Fetch

class ImageDataCacheTest: XCTestCase {
    var sut: ImageDataCache!
    var mockFileManager: MockFileManager!
    var mockFileDataHandler: MockFileDataHandler!
    var cacheDirectory: URL!
    var imageURL: URL = URL(string: "https://url-of-image")!
    
    override func setUp() {
        super.setUp()
        
        mockFileManager = MockFileManager()
        mockFileDataHandler = MockFileDataHandler()
        
        cacheDirectory = URL(fileURLWithPath: "/mock/cache/directory")
        mockFileManager.setURLs(for: .cachesDirectory, urls: [cacheDirectory])
        
        sut = ImageDataCache(fileManager: mockFileManager, fileDataHandler: mockFileDataHandler)
    }
    
    override func tearDown() {
        sut = nil
        mockFileManager = nil
        mockFileDataHandler = nil
        cacheDirectory = nil
        super.tearDown()
    }
    
    func testSaveImageData_WhenGivenImageData_ThenWritesToCorrectPathWithCorrectData() async throws {
        let mockData = Data("test image data".utf8)
        
        let urlHash = sut.keyForURL(for: imageURL)
        let expectedURL = cacheDirectory.appendingPathComponent(urlHash)
    
        try await sut.saveImageData(mockData, forKey: imageURL)
        
        XCTAssertEqual(mockFileDataHandler.urlPath, expectedURL)
        XCTAssertEqual(mockFileDataHandler.dataWritten, mockData)
    }
    
    func testLoadImageData_WhenImageExistsInCache_ThenReturnsCorrectDataFromCorrectPath() async throws {
        let mockData = Data("test image data".utf8)

        let urlHash = sut.keyForURL(for: imageURL)
        let expectedURL = cacheDirectory.appendingPathComponent(urlHash)
        mockFileDataHandler.dataToReturn = mockData

        let data = await sut.loadImageData(forKey: imageURL)
        
        XCTAssertEqual(mockFileDataHandler.urlPath, expectedURL)
        XCTAssertEqual(data, mockData)
    }
    
    func testClearingCacheRemovesAllFiles() async throws {
        let imageURL1 = cacheDirectory.appendingPathComponent("image1.cache")
        let imageURL2 = cacheDirectory.appendingPathComponent("image2.cache")
        mockFileManager.setContents(for: cacheDirectory, contents: [imageURL1, imageURL2])
        
        try await sut.clearCache()
        
        XCTAssertEqual(mockFileManager.removedItems.count, 2)
        XCTAssertTrue(mockFileManager.removedItems.contains(imageURL1))
        XCTAssertTrue(mockFileManager.removedItems.contains(imageURL2))
    }
    
    func testErrorHandlingWhenRemovingFails() async {
        let imageURL = cacheDirectory.appendingPathComponent("image.cache")
        mockFileManager.setContents(for: cacheDirectory, contents: [imageURL])
        mockFileManager.shouldThrowOnRemove = true
        
        do {
            try await sut.clearCache()
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertTrue(error is MockFileManager.MockError)
        }
    }
}
