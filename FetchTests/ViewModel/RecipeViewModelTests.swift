//
//  RecipeViewModelTests.swift
//  Fetch
//
//  Created by Jean Pierre on 3/18/25.
//
import XCTest
@testable import Fetch

class RecipeViewModelTests: XCTestCase {
    
    func testWhenModelIsInitialized_ShouldReturnCorrectProperties() {
        let recipe = Recipe.stub()
        
        let viewModel = RecipeViewModel(recipe: recipe)
        
        XCTAssertEqual(viewModel.id, recipe.uuid)
        XCTAssertEqual(viewModel.title, recipe.name)
        XCTAssertEqual(viewModel.cuisine, recipe.cuisine)
        XCTAssertEqual(viewModel.imageUrl, recipe.photoUrlLarge)
    }

    func testWhenModelDoesHaveALargePhotoUrl_ShouldReturnLargePhotoUrl() {
        let recipe = Recipe.stub()
        let viewModel = RecipeViewModel(recipe: recipe)
        
        XCTAssertEqual(viewModel.imageUrl, recipe.photoUrlLarge)
    }
    
    func testWhenModelDoesNotHaveALargePhotoUrl_ShouldReturnSmallPhotoUrl() {
        let stub = Recipe.stub()
        
        let recipe = Recipe(
            uuid: stub.uuid,
            cuisine: stub.cuisine,
            name: stub.name,
            photoUrlLarge: nil,
            photoUrlSmall: stub.photoUrlSmall,
            sourceUrl: stub.sourceUrl,
            youtubeUrl: stub.youtubeUrl
        )
        
        let viewModel = RecipeViewModel(recipe: recipe)
        
        XCTAssertEqual(viewModel.imageUrl, recipe.photoUrlSmall)
    }
}
