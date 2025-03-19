//
//  RecipeViewModel.swift
//  Fetch
//
//  Created by Jean Pierre on 3/16/25.
//

import Foundation

class RecipeViewModel {
    
    private var recipe: Recipe
    
    var id: String {
        recipe.uuid
    }
    
    var title: String {
        recipe.name
    }
    
    var cuisine: String {
        recipe.cuisine
    }
    
    var imageUrl: URL? {
        recipe.photoUrlLarge ?? recipe.photoUrlSmall
    }

    init(recipe: Recipe) {
        self.recipe = recipe
    }
}

