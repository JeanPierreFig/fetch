//
//  CachedAsyncImage.swift
//  Fetch
//
//  Created by Jean Pierre on 3/17/25.
//

import SwiftUI

struct CachedAsyncImage<Content: View>: View {
    @EnvironmentObject private var imageDataCacheContainer: ImageDataCacheContainer

    private let url: URL
    private let scale: CGFloat
    private let transaction: Transaction
    private let content: (AsyncImagePhase) -> Content
    
    @State private var phase: AsyncImagePhase = .empty
    
    init(
        url: URL,
        scale: CGFloat = 1.0,
        transaction: Transaction = Transaction(),
        @ViewBuilder content: @escaping (AsyncImagePhase) -> Content
    ) {
        self.url = url
        self.scale = scale
        self.transaction = transaction
        self.content = content
    }
    
    var body: some View {
        content(phase)
            .onAppear {
                loadImage()
            }
            .onChange(of: url) { _, _ in
                loadImage()
            }
    }
    
    private func loadImage() {
        Task {
            do {
                if let cachedData = try await imageDataCacheContainer.imageDataCache.loadImageData(forKey: url),
                   let uiImage = UIImage(data: cachedData) {
                    let image = Image(uiImage: uiImage)
                        .resizable()
                    withTransaction(transaction) {
                        phase = .success(image)
                    }
                    return
                }
                
                phase = .empty
                
                let (data, _) = try await URLSession.shared.data(from: url)
                
                guard let uiImage = UIImage(data: data) else {
                    throw URLError(.cannotDecodeContentData)
                }
                
                try await imageDataCacheContainer.imageDataCache.saveImageData(data, forKey: url)
                
                let image = Image(uiImage: uiImage)
                    .resizable()
                
                withTransaction(transaction) {
                    phase = .success(image)
                }
            } catch {
                withTransaction(transaction) {
                    phase = .failure(error)
                }
            }
        }
    }
}
