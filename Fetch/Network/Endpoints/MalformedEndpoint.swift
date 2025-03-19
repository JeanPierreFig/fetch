//
//  MalformedEndpoint.swift
//  Fetch
//
//  Created by Jean Pierre on 3/17/25.
//

struct MalformedEndpoint: EndpointProtocol {
    
    var baseURLString: String {
        "https://d3jbb8n5wk0qxi.cloudfront.net"
    }
    
    var path: String {
        "/recipes-malformed.json"
    }

    var httpMethod: String {
        "GET"
    }
}

