//
//  Recipe.swift
//  Fetch
//
//  Created by Jean Pierre on 3/16/25.
//

import Foundation

struct RecipeData: Codable {
    let recipes: [Recipe]
}

struct Recipe: Codable, Equatable {
    let uuid: String
    let cuisine: String
    let name: String
    let photoUrlLarge: URL?
    let photoUrlSmall: URL?
    let sourceUrl: URL?
    let youtubeUrl: URL?
}
