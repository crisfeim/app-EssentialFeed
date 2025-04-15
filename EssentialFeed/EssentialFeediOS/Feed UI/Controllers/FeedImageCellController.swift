//
//  FeedImageCellController.swift
//  EssentialFeed
//
//  Created by Cristian Felipe Patiño Rojas on 14/4/25.
//

import EssentialFeed
import UIKit

final class FeedImageCellController {
    
    let presenter: FeedImagePresenter<UIImage>
    private var cell: FeedImageCell?
    
    init(presenter: FeedImagePresenter<UIImage>) {
        self.presenter = presenter
    }
    
    func view() -> UITableViewCell {
        let cell = makeCell()
        presenter.loadImageData()
        return cell
    }
    
    func preload() {
        presenter.loadImageData()
    }
    
    func cancelLoad() {
        presenter.cancelImageDataLoad()
    }
    
    private func makeCell() -> FeedImageCell {
        let cell = FeedImageCell()
        self.cell = cell
        cell.locationContainer.isHidden = !presenter.hasLocation
        cell.locationLabel.text = presenter.location
        cell.descriptionLabel.text = presenter.description
        cell.onRetry = presenter.loadImageData
        
        return cell
    }
}


extension FeedImageCellController: FeedImageView {
    func display<T>(_ viewModel: FeedImageViewModel<T>) {
        cell?.feedImageView.image = viewModel.image as? UIImage
    }
}

extension FeedImageCellController: FeedImageLoadingView  {
    func display(_ viewModel: FeedImageLoadingViewModel) {
        if viewModel.isLoading {
            cell?.feedImageContainer.startShimmering()
        } else {
            cell?.feedImageContainer.stopShimmering()
        }
    }
}

extension FeedImageCellController: FeedImageRetryView {
    func display(_ viewModel: FeedImageRetryViewModel) {
        cell?.feedImageRetryButton.isHidden = !viewModel.shouldRetry
    }
}
