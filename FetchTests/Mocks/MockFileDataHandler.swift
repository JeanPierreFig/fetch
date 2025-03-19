//
//  MockFileDataHandler.swift
//  Fetch
//
//  Created by Jean Pierre on 3/18/25.
//

import Foundation
@testable import Fetch

class MockFileDataHandler: FileDataHandlerProtocol {
    
    var urlPath: URL?
    var dataWritten: Data?
    var dataToReturn: Data?
    
    func write(data: Data, url: URL) throws {
        urlPath = url
        
        dataWritten = data
    }
    
    func read(from url: URL) throws -> Data? {
        urlPath = url
        
        return dataToReturn
    }
}
