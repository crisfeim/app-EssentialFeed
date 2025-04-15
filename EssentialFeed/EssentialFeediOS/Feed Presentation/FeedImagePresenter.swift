//
//  FeedImagePresenter.swift
//  EssentialFeed
//
//  Created by Cristian Felipe Patiño Rojas on 15/4/25.
//

import Foundation
import EssentialFeed

protocol FeedImageView: AnyObject {
    func display<T>(image: T)
}

protocol FeedImageLoadingView: AnyObject {
    func display(isLoading: Bool)
}

protocol FeedImageRetryView: AnyObject {
    func display(shouldRetry: Bool)
}

final class FeedImagePresenter<Image> {
    typealias Observer<T> = (T) -> Void
    
    private var task: FeedImageDataLoaderTask?
    private let model: FeedImage
    private let imageLoader: FeedImageDataLoader
    private let imageTransformer: (Data) -> Image?
    
    init(model: FeedImage, imageLoader: FeedImageDataLoader, imageTransformer: @escaping (Data) -> Image?) {
        self.model = model
        self.imageLoader = imageLoader
        self.imageTransformer = imageTransformer
    }
    
    private var url: URL { model.url }
    var location: String? { model.location }
    var hasLocation: Bool { location != nil }
    var description: String? { model.description }
    
    weak var imageView: FeedImageView?
    weak var imageLoadingView: FeedImageLoadingView?
    weak var imageRetryView: FeedImageRetryView?
    
    func loadImageData() {
        imageLoadingView?.display(isLoading: true)
        imageRetryView?.display(shouldRetry: false)
        task = imageLoader.loadImageData(from: url) { [weak self] result in
            self?.handle(result)
        }
    }
    
    private func handle(_ result: FeedImageDataLoader.Result) {
        if let image = (try? result.get()).flatMap(imageTransformer) {
            imageView?.display(image: image)
        } else {
            imageRetryView?.display(shouldRetry: true)
        }
        imageLoadingView?.display(isLoading: false)
    }
    
    func cancelImageDataLoad() {
        task?.cancel()
        task = nil
    }
}
