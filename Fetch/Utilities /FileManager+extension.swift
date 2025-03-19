//
//  FileManager+extension.swift
//  Fetch
//
//  Created by Jean Pierre on 3/18/25.
//

import Foundation

protocol FileManagingProtocol {
    func removeItem(at url: URL) throws
    func urls(for directory: FileManager.SearchPathDirectory, in domainMask: FileManager.SearchPathDomainMask) -> [URL]
    func contentsOfDirectory(at url: URL, includingPropertiesForKeys keys: [URLResourceKey]?, options mask: FileManager.DirectoryEnumerationOptions) throws -> [URL]
}

extension FileManager: FileManagingProtocol { }
