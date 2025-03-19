//
//  Recipe+Stub.swift
//  FetchTests
//
//  Created by Jean Pierre on 3/18/25.
//

import Foundation
@testable import Fetch

extension Recipe {
    static func stub() -> Recipe {
        return Recipe(
            uuid: "0c6ca6e7-e32a-4053-b824-1dbf749910d8",
            cuisine: "Malaysian",
            name: "Apam Balik",
            photoUrlLarge: URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg"),
            photoUrlSmall: URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg"),
            sourceUrl: URL(string: "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ"),
            youtubeUrl: URL(string: "https://www.youtube.com/watch?v=6R8ffRRJcrg"))
    }
}
