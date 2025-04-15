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
        cell.locationContainer.isHidden = !presenter.hasLocation
        cell.locationLabel.text = presenter.location
        cell.descriptionLabel.text = presenter.description
        cell.onRetry = presenter.loadImageData

        presenter.onImageLoad = { [weak cell] image in
            cell?.feedImageView.image = image
        }
        
        presenter.onImageLoadingStateChange = { [weak cell] isLoading in
            if isLoading {
                cell?.feedImageContainer.startShimmering()
            } else {
                cell?.feedImageContainer.stopShimmering()
            }
        }
        
        presenter.onShouldRetryImageLoadStateChange = { [weak cell] shouldRetry in
            cell?.feedImageRetryButton.isHidden = !shouldRetry
        }
        
        return cell
    }
}
