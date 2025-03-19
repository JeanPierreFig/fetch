//
//  FetchApp.swift
//  Fetch
//
//  Created by Jean Pierre on 3/16/25.
//

import SwiftUI

@main
struct FetchApp: App {
    // Let's inject the ImageDataCache service here.
    @ObservedObject var imageDataCacheContainer = ImageDataCacheContainer()

    var body: some Scene {
        WindowGroup {
            RecipesMainView()
                .environmentObject(imageDataCacheContainer)
        }
    }
}
