//
//  Data+Extension.swift
//  Fetch
//
//  Created by Jean Pierre on 3/18/25.
//

import Foundation

protocol FileDataHandlerProtocol {
    func write(data: Data, url: URL) throws
    func read(from url: URL) throws -> Data?
}
