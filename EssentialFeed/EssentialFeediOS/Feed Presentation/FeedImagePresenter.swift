//
//  FeedImagePresenter.swift
//  EssentialFeed
//
//  Created by Cristian Felipe Patiño Rojas on 15/4/25.
//

import Foundation
import EssentialFeed

struct FeedImageViewModel<T> {
    let image: T
}

protocol FeedImageView {
    func display<T>(_ viewModel: FeedImageViewModel<T>)
}


struct FeedImageLoadingViewModel {
    let isLoading: Bool
}

protocol FeedImageLoadingView {
    func display(_ viewModel: FeedImageLoadingViewModel)
}

struct FeedImageRetryViewModel {
    let shouldRetry: Bool
}

protocol FeedImageRetryView {
    func display(_ viewModel: FeedImageRetryViewModel)
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
    
    var imageView: FeedImageView?
    var imageLoadingView: FeedImageLoadingView?
    var imageRetryView: FeedImageRetryView?
    
    func loadImageData() {
        imageLoadingView?.display(FeedImageLoadingViewModel(isLoading: true))
        imageRetryView?.display(FeedImageRetryViewModel(shouldRetry: false))
        task = imageLoader.loadImageData(from: url) { [weak self] result in
            self?.handle(result)
        }
    }
    
    private func handle(_ result: FeedImageDataLoader.Result) {
        if let image = (try? result.get()).flatMap(imageTransformer) {
            imageView?.display(FeedImageViewModel(image: image))
        } else {
            imageRetryView?.display(FeedImageRetryViewModel(shouldRetry: true))
        }
        imageLoadingView?.display(FeedImageLoadingViewModel(isLoading: false))
    }
    
    func cancelImageDataLoad() {
        task?.cancel()
        task = nil
    }
}
