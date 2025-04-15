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
    func display<T>(image: T) {
        cell?.feedImageView.image = image as? UIImage
    }
}

extension FeedImageCellController: FeedLoadingView {
    func display(_ viewModel: FeedLoadingViewModel) {
        if viewModel.isLoading {
            cell?.feedImageContainer.startShimmering()
        } else {
            cell?.feedImageContainer.stopShimmering()
        }
    }
}

extension FeedImageCellController: FeedImageRetryView {
    func display(shouldRetry: Bool) {
        cell?.feedImageRetryButton.isHidden = !shouldRetry
    }
}
