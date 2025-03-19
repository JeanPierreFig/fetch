//
//  EmptyEndpoint.swift
//  Fetch
//
//  Created by Jean Pierre on 3/17/25.
//

import Foundation

struct EmptyEndpoint: EndpointProtocol {
    
    var baseURLString: String {
        "https://d3jbb8n5wk0qxi.cloudfront.net"
    }
    
    var path: String {
        "/recipes-empty.json"
    }

    var httpMethod: String {
        "GET"
    }
}
