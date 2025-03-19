//
//  RecipesMainViewModelTest.swift
//  Fetch
//
//  Created by Jean Pierre on 3/19/25.
//

import XCTest
@testable import Fetch


class RecipesMainViewModelTest: XCTestCase {
    
    var viewModel: RecipesMainViewModel!
    var networkService: NetworkService!
    var mockSession: MockURLSession!
    
    let recipesJSONData =
        """
        {
            "recipes": [
                {
                    "cuisine": "Malaysian",
                    "name": "Apam Balik",
                    "photo_url_large": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg",
                    "photo_url_small": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg",
                    "source_url": "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ",
                    "uuid": "0c6ca6e7-e32a-4053-b824-1dbf749910d8",
                    "youtube_url": "https://www.youtube.com/watch?v=6R8ffRRJcrg"
                }
            ]
        }
        """.data(using: .utf8)
    
    
    override func setUp() {
        super.setUp()
        mockSession = MockURLSession()
        networkService = NetworkService(session: mockSession)
        viewModel = RecipesMainViewModel(service: networkService)
    }
   
    override func tearDown() {
        viewModel = nil
        networkService = nil
        mockSession = nil
        super.tearDown()
    }
    
    func test_when_fetchRecipesSucceeds_then_contentStateReturnsRecipes() async {
        
        mockSession.dataToReturn = recipesJSONData
        mockSession.responseToReturn = HTTPURLResponse(
            url: URL(string: "https://placeholder-url")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        
        await viewModel.fetchRecipes()
        
        if case .success(let recipeViewModels) = viewModel.contentState {
            XCTAssertEqual(recipeViewModels.first?.id, "0c6ca6e7-e32a-4053-b824-1dbf749910d8")
        } else {
            XCTFail("Failed to return data.")
        }
        
    }

    func test_when_fetchRecipesFails_then_contentStateIsErrorWithErrorDetails() async {
        mockSession.responseToReturn = HTTPURLResponse(
            url: URL(string: "https://placeholder-url")!,
            statusCode: 404,
            httpVersion: nil,
            headerFields: nil
        )
        
        await viewModel.fetchRecipes()
        
        if case .networkError = viewModel.contentState {
            XCTAssert(true)
        } else {
            XCTFail("Failed to return data.")
        }
    }

    func test_when_fetchReturnsEmptyResults_then_contentStateIsEmpty() async {
        mockSession.dataToReturn = """
            { "recipes": [] }
        """.data(using: .utf8)
        
        mockSession.responseToReturn = HTTPURLResponse(
            url: URL(string: "https://placeholder-url")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        
        await viewModel.fetchRecipes()
        
        if case LoadingState.empty = viewModel.contentState {
            XCTAssert(true)
        } else {
            XCTFail("Failed to return data.")
        }
    }
}
