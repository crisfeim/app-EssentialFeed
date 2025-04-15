//
//  FeedImagePresentationAdapter.swift
//  EssentialFeed
//
//  Created by Cristian Felipe Patiño Rojas on 15/4/25.
//


import EssentialFeed
import UIKit

final class FeedImagePresentationAdapter: FeedImageCellControllerDelegate {
    
    private var task: FeedImageDataLoaderTask?
    private let model: FeedImage
    private let imageLoader: FeedImageDataLoader
    var presenter: FeedImagePresenter<WeakRefVirtualProxy<FeedImageCellController>, UIImage>?
    
    init(model: FeedImage, imageLoader: FeedImageDataLoader) {
        self.model = model
        self.imageLoader = imageLoader
    }
    
    func didRequestImage() {
        presenter?.didStartShowingImage(for: model)
        task = imageLoader.loadImageData(from: model.url) { [weak self, model] result in
            switch result {
            case .success(let data):
                self?.presenter?.didFinishLoadingImageData(with: data, for: model)
            case .failure(let error):
                self?.presenter?.didFinishLoadingImageData(with: error, for: model)
            }
        }
    }
    
    func didCancelImageRequest() {
        task?.cancel()
    }
}