//
//  Endpoint.swift
//  Fetch
//
//  Created by Jean Pierre on 3/16/25.
//

import Foundation

protocol EndpointProtocol {
    var baseURLString: String { get }
    var path: String { get }
    var httpMethod: String { get }
        
    func constructURL() -> URL?
}

extension EndpointProtocol {

    func constructURL() -> URL? {
        guard let baseUrl = URL(string: baseURLString) else { return nil }
        
        let urlComponents = URLComponents(url: baseUrl.appendingPathComponent(path), resolvingAgainstBaseURL: false)
        
        return urlComponents?.url
    }
}
