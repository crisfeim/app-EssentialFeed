//
//  FeedImageViewModel.swift
//  EssentialFeed
//
//  Created by Cristian Felipe Patiño Rojas on 14/4/25.
//


import EssentialFeed
import UIKit

final class FeedImageViewModel {
    private var task: FeedImageDataLoaderTask?
    private let model: FeedImage
    private let imageLoader: FeedImageDataLoader
    
    var url: URL { model.url }
    
    var shouldHideLocationContainer: Bool { location == nil }
    var location: String? { model.location }
    var description: String? { model.description }
    
    init(model: FeedImage, imageLoader: FeedImageDataLoader) {
        self.model = model
        self.imageLoader = imageLoader
    }
    
    var onChange: ((Result<Data, Error>) -> Void)?
    func loadImage() {
        task = imageLoader.loadImageData(from: url) { [weak self] in
            self?.onChange?($0)
        }
    }
    
    func preloadImage() {
        task = imageLoader.loadImageData(from: url) { _ in }
    }
    
    func cancelLoad() {
        task?.cancel()
        task = nil
    }
}