//
//  RecipesMainViewModel.swift
//  Fetch
//
//  Created by Jean Pierre on 3/16/25.
//

import Foundation

class RecipesMainViewModel: ObservableObject {
    
    @Published private(set) var contentState: LoadingState<[RecipeViewModel]> = .loading

    private var service: NetworkServiceProtocol
    
    // This is for your convenience. You can change the endpoint here to test empty or malformed endpoints.
    private var activeEndpoint: EndpointProtocol = RecipesEndpoint()
    
    var navigationTitle: String {
        "Recipes by Fetch"
    }
    
    init(service: NetworkServiceProtocol = NetworkService()) {
        self.service = service
    }

    @MainActor
    func refresh() async {
        await loadData()
    }
    
    @MainActor
    func fetchRecipes() async {
        contentState = .loading
        
        await loadData()
    }
    
    @MainActor
    private func loadData() async {
        do {
            try Task.checkCancellation()

            let data: RecipeData = try await service.request(activeEndpoint)
            let viewModels = data.recipes.compactMap { RecipeViewModel(recipe: $0) }
            
            try Task.checkCancellation()

            if viewModels.isEmpty {
                contentState = .empty
            } else {
                contentState = .success(viewModels)
            }
        } catch {
            if let error = error as? NetworkError {
                switch error {
                case .decodingError:
                    contentState = .dataError
                case .serverError, .unknownError, .invalidURL:
                    contentState = .networkError
                }
            } else {
                contentState = .networkError
            }
        }
    }
}
