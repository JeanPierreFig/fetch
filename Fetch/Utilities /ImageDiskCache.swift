//
//  ImageCatch.swift
//  Fetch
//
//  Created by Jean Pierre on 3/17/25.
//

import Foundation
import CryptoKit

protocol ImageDataCacheProtocol {
    func saveImageData(_ data: Data, forKey key: URL) async throws
    func loadImageData(forKey key: URL) async throws -> Data?
    func deleteImageData(forKey key: URL) async throws
    func clearCache() async throws
    func keyForURL(for url: URL) -> String
}

// This is a wrap calls to be able to use swift environmentObject as a rudimentary DI container
class ImageDataCacheContainer: ObservableObject {
    var imageDataCache: ImageDataCacheProtocol
    
    init(imageDataCache: ImageDataCacheProtocol = ImageDataCache()) {
        self.imageDataCache = imageDataCache
    }
}

class ImageDataCache: ObservableObject, ImageDataCacheProtocol {
    private let fileManager: FileManagingProtocol
    private let cacheDirectory: URL
    private let queue = DispatchQueue(label: "com.imageCache.diskAccess", attributes: .concurrent)
    
    // Add memory cache directly to the class
    private let memoryCache = NSCache<NSString, NSData>()
    private let fileDataHandler: FileDataHandlerProtocol
    
    init(fileManager: FileManagingProtocol = FileManager.default, fileDataHandler: FileDataHandlerProtocol = FileDataHandler()) {
        self.fileManager = fileManager
        self.cacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        self.fileDataHandler = fileDataHandler
        
        // Add some limits to our in memory cache. 
        memoryCache.totalCostLimit = 10_000_000 // ~50MB
        memoryCache.countLimit = 20
    }
    
    func saveImageData(_ data: Data, forKey key: URL) async throws {
        let fileURL = cacheDirectory.appendingPathComponent(keyForURL(for: key))
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            queue.async(flags: .barrier) {
                do {
                    try self.fileDataHandler.write(data: data, url: fileURL)
                    
                    // Also save to memory cache
                    self.memoryCache.setObject(data as NSData,
                                               forKey: self.keyForURL(for: key) as NSString,
                                               cost: data.count)
                
                    continuation.resume()
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func loadImageData(forKey key: URL) async -> Data? {
        let cacheKey = keyForURL(for: key) as NSString
        
        // Check memory cache first
        if let cachedData = memoryCache.object(forKey: cacheKey) as Data? {
            return cachedData
        }
        
        // Otherwise, try to get from disk asynchronously.
        let fileURL = cacheDirectory.appendingPathComponent(cacheKey as String)
        
        return await withCheckedContinuation { continuation in
            queue.async {
                do {
                    let data = try self.fileDataHandler.read(from: fileURL)
                    continuation.resume(returning: data)
                } catch {
                    continuation.resume(returning: nil) // Handle errors as appropriate
                }
            }
        }
    }
    
    func deleteImageData(forKey key: URL) async throws {
        let fileURL = cacheDirectory.appendingPathComponent(keyForURL(for: key))
        
        memoryCache.removeObject(forKey: keyForURL(for: key) as NSString)
        
        return try await withCheckedThrowingContinuation { continuation in
            queue.async(flags: .barrier) {
                do {
                    try self.fileManager.removeItem(at: fileURL)
                    continuation.resume()
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func clearCache() async throws {
        memoryCache.removeAllObjects()

        return try await withCheckedThrowingContinuation { continuation in
            queue.async(flags: .barrier) {
                do {
                    let contents = try self.fileManager.contentsOfDirectory(at: self.cacheDirectory, includingPropertiesForKeys: nil, options: [])

                    for file in contents {
                        try self.fileManager.removeItem(at: file)
                    }

                    continuation.resume()
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func keyForURL(for url: URL) -> String {
        let data = Data(url.absoluteString.utf8)
        let hashed = SHA256.hash(data: data)
        return hashed.compactMap { String(format: "%02x", $0) }.joined()
    }
}
