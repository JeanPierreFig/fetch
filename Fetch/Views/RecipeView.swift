//
//  RecipeView.swift
//  Fetch
//
//  Created by Jean Pierre on 3/16/25.
//

import SwiftUI

struct RecipeView: View {
    
    var viewModel: RecipeViewModel
    
    var body: some View {
        ZStack {
            if let imageUrl = viewModel.imageUrl {
                CachedAsyncImage(url: imageUrl) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .clipped()
                    default:
                        Image(systemName: "photo.badge.exclamationmark.fill")
                    }
                }
            }

            LinearGradient(gradient: Gradient(colors: [Color.black, Color.black.opacity(0.3), Color.clear]), startPoint: .bottom, endPoint: .top)
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            HStack {
                VStack(alignment: .leading) {
                    Spacer()
                    
                    Text(viewModel.title)
                        .font(.headline)
                        .foregroundStyle(.white)
                    Text(viewModel.cuisine)
                        .font(.subheadline)
                        .foregroundStyle(.white)
                }
                
                Spacer()
            }
            .padding()
        }
        .frame(maxWidth: .infinity)
        .aspectRatio(1, contentMode: .fit)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(.separator, lineWidth: 1))
    }
}

struct RecipePreview: PreviewProvider {
    static var previews: some View {
        RecipeView(viewModel: RecipeViewModel(recipe: Recipe(
            uuid: "f8b20884-1e54-4e72-a417-dabbc8d91f12",
            cuisine: "American",
            name: "Banana Pancakes",
            photoUrlLarge: nil,
            photoUrlSmall: nil,
            sourceUrl: nil,
            youtubeUrl: nil
        )))
        .environmentObject(ImageDataCache())
    }
}
