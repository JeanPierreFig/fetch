//
//  UrlSession+Extension.swift
//  Fetch
//
//  Created by Jean Pierre on 3/18/25.
//
import Foundation

protocol URLSessionProtocol {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol { }
