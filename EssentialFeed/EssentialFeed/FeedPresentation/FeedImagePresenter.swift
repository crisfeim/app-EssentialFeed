// © 2025  Cristian Felipe Patiño Rojas. Created on 31/5/25.


import Foundation

public protocol FeedImageView {
    associatedtype Image
    func display(_ viewModel: FeedImageViewModel<Image>)
}

public struct FeedImageViewModel<T> {
    public let description: String?
    public let location: String?
    public let image: T?
    
    public let isLoading: Bool
    public let shouldRetry: Bool
    
    var hasLocation: Bool { location != nil }
}


public final class FeedImagePresenter<View: FeedImageView, Image> where View.Image == Image {
    private let view: View
    private let imageTransformer: (Data) -> Image?
    
   public init(view: View, imageTransformer: @escaping (Data) -> Image?) {
        self.view = view
        self.imageTransformer = imageTransformer
    }
    
    public func didStartShowingImage(for model: FeedImage) {
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
    
    public func didFinishLoadingImageData(with data: Data, for model: FeedImage) {
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
    
    public func didFinishLoadingImageData(with error: Error, for model: FeedImage) {
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
