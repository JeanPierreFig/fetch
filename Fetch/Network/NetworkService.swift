//
//  NetworkService.swift
//  Fetch
//
//  Created by Jean Pierre on 3/16/25.
//

import Foundation

protocol NetworkServiceProtocol {
    func request<T: Decodable>(_ endpoint: EndpointProtocol) async throws -> T
}

class NetworkService: NetworkServiceProtocol {
    
    private let session: URLSessionProtocol

    init(session: URLSessionProtocol = URLSession.shared) {
       self.session = session
    }
    
    func request<T>(_ endpoint: EndpointProtocol) async throws -> T where T : Decodable {
        guard let endpointUrl = endpoint.constructURL() else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: endpointUrl)
        // Ignoring default cache policy to allow for state management demonstration on disconnected network. 
        request.cachePolicy = .reloadIgnoringLocalCacheData

        do {
            let (data, response) = try await session.data(for: request)

            guard
                let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode)
            else {
                throw NetworkError.serverError
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            return try decoder.decode(T.self, from: data)
            
        } catch let error as DecodingError {
            throw NetworkError.decodingError
        } catch let error as NetworkError {
            throw error
        } catch {
            throw NetworkError.unknownError(error)
        }
    }
}
