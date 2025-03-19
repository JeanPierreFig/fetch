//
//  ContentStateView.swift
//  Fetch
//
//  Created by Jean Pierre on 3/16/25.
//

import SwiftUI

enum LoadingState<T> {
    case loading
    case success(T)
    case empty
    case dataError
    case networkError
    
    var image: String? {
        switch self {
        case .loading, .success:
            return nil
        case .dataError:
            return "externaldrive.badge.exclamationmark"
        case .networkError:
            return "wifi.exclamationmark"
        case .empty:
            return nil
        }
    }
        
    var message: String? {
        switch self {
        case .loading, .success:
            return nil
        case .dataError:
            return "Could not process data from network."
        case .networkError:
            return "Check your connection & try again."
        case .empty:
            return "No Recipes"
        }
    }
}

struct ContentStateView<T>: View {
    
    var state: LoadingState<T>
    var retry: (() -> Void)?
    
    init(state: LoadingState<T>, retry: (() -> Void)? = nil) {
        self.state = state
        self.retry = retry
    }
    
    var body: some View {
        Group {
            switch state {
            case .loading:
                ProgressView()
            case .success:
                EmptyView()
            case .empty, .dataError, .networkError:
                VStack(spacing: 10) {
                    if let image = state.image {
                        Image(systemName: image)
                            .font(.system(size: 60))
                    }

                    if let message = state.message {
                        Text(message)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 30)
                            .padding(.bottom, 15)
                    }

                    Button(action: {
                        retry?()
                    }) {
                        Text("Retry")
                            .padding(.horizontal, 20)
                            .padding(.vertical, 5)
                            .foregroundColor(.gray)
                            .background(Color.white)
                            .cornerRadius(5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                    }
                }
            }
        }
    }
}

#Preview("Data Error") {
    ContentStateView<Any>(state: .dataError) { }
}

#Preview("Empty") {
    ContentStateView<Any>(state: .empty) { }
}

#Preview("Loading") {
    ContentStateView<Any>(state: .loading) { }
}

#Preview("Network Error") {
    ContentStateView<Any>(state: .networkError) { }
}
