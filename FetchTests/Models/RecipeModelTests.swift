//
//  RecipeModelTests.swift
//  Fetch
//
//  Created by Jean Pierre on 3/18/25.
//

import XCTest
@testable import Fetch

class RecipeModelTests: XCTestCase {
    let recipesJSON =
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
        """
    
    let malformedRecipesJSON =
        """
        {
            "recipes": [
                {
                    "cuisine": "British",
                    "photo_url_large": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/large.jpg",
                    "photo_url_small": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/small.jpg",
                    "source_url": "https://www.bbcgoodfood.com/recipes/778642/apple-and-blackberry-crumble",
                    "uuid": "599344f4-3c5c-4cca-b914-2210e3b3312f",
                    "youtube_url": "https://www.youtube.com/watch?v=4vhcOwVBDO4"
                }
            ]
        }
        """
    
    func testSuccessRecipeDecoding_WhenUsingValidJson() throws {
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let data = try decoder.decode(RecipeData.self, from: recipesJSON.data(using: .utf8)!)

            XCTAssertEqual(data.recipes.first!, Recipe.stub())
        } catch {
            XCTFail("Failed to decode recipe Data.")
        }
    }
    
    func testFailedRecipeDecoding_WhenUsingMalformedJson() throws {
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let _ = try decoder.decode(RecipeData.self, from: malformedRecipesJSON.data(using: .utf8)!)

            XCTFail("Should not be able to decode malformed employee")
        } catch {
            XCTAssert(true)
        }
    }
}
