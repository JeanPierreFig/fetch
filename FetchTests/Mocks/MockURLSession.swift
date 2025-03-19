//
//  MockURLSession.swift
//  Fetch
//
//  Created by Jean Pierre on 3/18/25.
//

import Foundation
@testable import Fetch

class MockURLSession: URLSessionProtocol {
    var dataToReturn: Data?
    var responseToReturn: URLResponse?
    
    var receivedRequests: [URLRequest] = []
    
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        receivedRequests.append(request)
        
        guard let data = dataToReturn, let response = responseToReturn else {
            throw NSError(domain: "MockURLSessionError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Mock not configured properly"])
        }
        
        return (data, response)
    }
}
