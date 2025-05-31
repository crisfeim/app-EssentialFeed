//
//  FeedViewAdapter.swift
//  EssentialFeed
//
//  Created by Cristian Felipe Patiño Rojas on 15/4/25.
//


import EssentialFeed
import UIKit

final class FeedViewAdapter: FeedView {
    private weak var controller: FeedViewController?
    private let imageLoader: FeedImageDataLoader
    
    init(controller: FeedViewController, imageLoader: FeedImageDataLoader) {
        self.controller = controller
        self.imageLoader = imageLoader
    }
    
    func display(_ viewModel: FeedViewModel) {
        controller?.tableModel = viewModel.feed.map { model in
            let adapter = FeedImagePresentationAdapter(
                model: model,
                imageLoader: imageLoader
            )
           
            let controller = FeedImageCellController(delegate: adapter)
            
            let presenter = FeedImagePresenter(
                view: WeakRefVirtualProxy(controller),
                imageTransformer: UIImage.init
            )
            
            adapter.presenter = presenter
            return controller
        }
    }
}
