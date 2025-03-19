//
//  NetworkError.swift
//  Fetch
//
//  Created by Jean Pierre on 3/19/25.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case decodingError
    case serverError
    case unknownError(Error)
}

extension NetworkError: Equatable {
    static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidURL, .invalidURL),
             (.decodingError, .decodingError),
             (.serverError, .serverError):
            return true
        case (.unknownError, .unknownError):
            // Since we can't compare Error objects directly,
            // we'll consider all unknownError cases equal for testing
            return true
        default:
            return false
        }
    }
}
