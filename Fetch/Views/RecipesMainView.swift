//
//  RecipesMainView.swift
//  Fetch
//
//  Created by Jean Pierre on 3/16/25.
//

import SwiftUI

struct RecipesMainView: View {
    
    @StateObject var viewModel = RecipesMainViewModel()
    @State private var currentRetryTask: Task<Void, Never>?
    
    var body: some View {
        NavigationStack {
            VStack {
                if case .success(let recipeViewModels) = viewModel.contentState {
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible())], spacing: 10) {
                            ForEach(recipeViewModels, id: \.id) { viewModel in
                                RecipeView(viewModel: viewModel)
                            }
                        }
                        .padding()
                    }
                    .refreshable {
                        await viewModel.refresh()
                    }
                } else {
                    ContentStateView(state: viewModel.contentState, retry: {
                        currentRetryTask?.cancel()
                        
                        currentRetryTask = Task {
                            if !Task.isCancelled {
                                await viewModel.fetchRecipes()
                            }
                        }
                    })
                    .padding(.bottom, 30)
                }
            }
            .navigationTitle(viewModel.navigationTitle)
        }
        .task {
            await viewModel.fetchRecipes()
        }
    }
}

#Preview {
    RecipesMainView()
        .environmentObject(ImageDataCache())
}
