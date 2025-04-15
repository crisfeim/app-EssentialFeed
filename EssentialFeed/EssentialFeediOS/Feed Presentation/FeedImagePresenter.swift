//
//  FeedImagePresenter.swift
//  EssentialFeed
//
//  Created by Cristian Felipe Patiño Rojas on 15/4/25.
//

import Foundation
import EssentialFeed

struct FeedImageViewModel<T> {
    let description: String?
    let location: String?
    let image: T?
    
    let isLoading: Bool
    let shouldRetry: Bool
    
    var hasLocation: Bool { location != nil }
}

protocol FeedImageView {
    func display<T>(_ viewModel: FeedImageViewModel<T>)
}

final class FeedImagePresenter<Image> {
    
    private let view: FeedImageView
    private let model: FeedImage
    private let imageTransformer: (Data) -> Image?

    
    init(view: FeedImageView, model: FeedImage, imageTransformer: @escaping (Data) -> Image?) {
        self.view = view
        self.model = model
        self.imageTransformer = imageTransformer
    }
    
    func didStartShowingImage(for model: FeedImage) {
        view.display(
            FeedImageViewModel<Image>(
                description: model.description,
                location: model.location,
                image: nil,
                isLoading: true,
                shouldRetry: false
            )
        )
    }
    
    func didFinishLoadingImageData(with data: Data, for model: FeedImage) {
        guard let image = imageTransformer(data) else {
            view.display(
                FeedImageViewModel<Image>(
                    description: model.description,
                    location: model.location,
                    image: nil,
                    isLoading: false,
                    shouldRetry: true
                )
            )
            return
        }
        view.display(
            FeedImageViewModel(
                description: model.description,
                location: model.location,
                image: image,
                isLoading: false,
                shouldRetry: false
            )
        )
    }
    
    func didFinishLoadingImageData(with error: Error, for model: FeedImage) {
        view.display(
            FeedImageViewModel<Image>(
                description: model.description,
                location: model.location,
                image: nil,
                isLoading: false,
                shouldRetry: true
            )
        )
    }
}
