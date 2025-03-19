//
//  NetworkSerivceTest.swift
//  Fetch
//
//  Created by Jean Pierre on 3/18/25.
//

import XCTest
@testable import Fetch

class NetworkServiceTests: XCTestCase {
    
    var networkService: NetworkService!
    var mockSession: MockURLSession!
    
    let validJsonData = """
        {
            "cuisine": "Malaysian",
            "name": "Apam Balik",
            "photo_url_large": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg",
            "photo_url_small": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg",
            "source_url": "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ",
            "uuid": "0c6ca6e7-e32a-4053-b824-1dbf749910d8",
            "youtube_url": "https://www.youtube.com/watch?v=6R8ffRRJcrg"
        }
    """.data(using: .utf8)
    
    let invalidJsonData = """
        {
            "cuisine": "British",
            "photo_url_large": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/large.jpg",
            "photo_url_small": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/small.jpg",
            "source_url": "https://www.bbcgoodfood.com/recipes/778642/apple-and-blackberry-crumble",
            "uuid": "599344f4-3c5c-4cca-b914-2210e3b3312f",
            "youtube_url": "https://www.youtube.com/watch?v=4vhcOwVBDO4"
        }
    """.data(using: .utf8)
       
    override func setUp() {
        super.setUp()
        mockSession = MockURLSession()
        networkService = NetworkService(session: mockSession)
    }
   
    override func tearDown() {
        networkService = nil
        mockSession = nil
        super.tearDown()
    }
       
    func testRequest_WithValidEndpoint_ReturnsDecodedObject() async throws {
        
        mockSession.dataToReturn = validJsonData
        mockSession.responseToReturn = HTTPURLResponse(
            url: URL(string: "https://placeholder-url")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        
        let recipe: Recipe = try await networkService.request(MockValidEndpoint())
        
        XCTAssertEqual(recipe.uuid,  "0c6ca6e7-e32a-4053-b824-1dbf749910d8")
    }
    
    func testRequest_WithInvalidURL_ThrowsInvalidURLError() async {
       
        do {
            let _ : Recipe = try await networkService.request(MockInvalidEndpoint())
            XCTFail("Should be throw invalid url error")
        } catch let error as NetworkError {
            XCTAssertEqual(error, NetworkError.invalidURL)
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }
    
    func testRequest_WithNon200StatusCode_ThrowsServerError() async {
        mockSession.dataToReturn = invalidJsonData
        mockSession.responseToReturn = HTTPURLResponse(
            url: URL(string: "https://placeholder-url")!,
            statusCode: 404,
            httpVersion: nil,
            headerFields: nil
        )
        
        do {
            let _ : Recipe = try await networkService.request(MockValidEndpoint())
            XCTFail("Should be throw network error")
        } catch let error as NetworkError {
            XCTAssertEqual(error, .serverError)
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }
    
    func testRequest_WithInvalidJsonData_ThrowsDecodingError() async {
        
        mockSession.dataToReturn = invalidJsonData
        mockSession.responseToReturn = HTTPURLResponse(
            url: URL(string: "https://placeholder-url")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        
        do {
            let _ : Recipe = try await networkService.request(MockValidEndpoint())
            XCTFail("Should be throw network error")
        } catch let error as NetworkError {
            XCTAssertEqual(error, NetworkError.decodingError)
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }
}
