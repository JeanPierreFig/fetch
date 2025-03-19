//
//  MockNetworkService.swift
//  FetchTests
//
//  Created by Jean Pierre on 3/18/25.
//

import Foundation
@testable import Fetch

class MockValidEndpoint: EndpointProtocol {
    var baseURLString: String = "https://google.com"
    
    var path: String = "/valid"
    
    var httpMethod: String = "GET"
}

class MockInvalidEndpoint: EndpointProtocol {
    var baseURLString: String = ""
    
    var path: String = ""
    
    var httpMethod: String = ""
}
