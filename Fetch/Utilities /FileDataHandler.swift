//
//  FileDataHandler.swift
//  Fetch
//
//  Created by Jean Pierre on 3/18/25.
//

import Foundation

class FileDataHandler: FileDataHandlerProtocol {
    func read(from url: URL) throws -> Data? {
        return try Data(contentsOf: url)
    }
    
    func write(data: Data, url: URL) throws {
        return try data.write(to: url)
    }
}
