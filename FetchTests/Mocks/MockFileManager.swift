//
//  MockFileManager.swift
//  Fetch
//
//  Created by Jean Pierre on 3/18/25.
//

import Foundation
@testable import Fetch

class MockFileManager: FileManagingProtocol {
    var removedItems: [URL] = []
    var shouldThrowOnRemove = false
    var directoryURLs: [FileManager.SearchPathDirectory: [URL]] = [:]
    var directoryContents: [URL: [URL]] = [:]
    var shouldThrowOnContentsOfDirectory = false
    
    enum MockError: Error {
        case removeItemFailed
        case contentsOfDirectoryFailed
    }
    
    func removeItem(at url: URL) throws {
        if shouldThrowOnRemove {
            throw MockError.removeItemFailed
        }
        removedItems.append(url)
    }
    
    func urls(for directory: FileManager.SearchPathDirectory, in domainMask: FileManager.SearchPathDomainMask) -> [URL] {
        return directoryURLs[directory] ?? []
    }
    
    func contentsOfDirectory(at url: URL, includingPropertiesForKeys keys: [URLResourceKey]?, options mask: FileManager.DirectoryEnumerationOptions) throws -> [URL] {
        if shouldThrowOnContentsOfDirectory {
            throw MockError.contentsOfDirectoryFailed
        }
        return directoryContents[url] ?? []
    }
    
    func setURLs(for directory: FileManager.SearchPathDirectory, urls: [URL]) {
        directoryURLs[directory] = urls
    }
    
    func setContents(for directoryURL: URL, contents: [URL]) {
        directoryContents[directoryURL] = contents
    }
}
