//
//  FeedImageCellController.swift
//  EssentialFeed
//
//  Created by Cristian Felipe Patiño Rojas on 14/4/25.
//


import EssentialFeed
import UIKit

final class FeedImageCellController {
   
    let viewModel: FeedImageViewModel
    
    init(viewModel: FeedImageViewModel) {
        self.viewModel = viewModel
    }
    
    func view() -> UITableViewCell {
        let cell = FeedImageCell()
        cell.locationContainer.isHidden = viewModel.shouldHideLocationContainer
        cell.locationLabel.text = viewModel.location
        cell.descriptionLabel.text = viewModel.description
        cell.feedImageView.image = nil
        cell.feedImageRetryButton.isHidden = true
        cell.feedImageContainer.startShimmering()
        
        viewModel.onChange = { [weak cell] result in
            let data = try? result.get()
            let image = data.map(UIImage.init) ?? nil
            cell?.feedImageView.image = image
            cell?.feedImageRetryButton.isHidden = (image != nil)
            cell?.feedImageContainer.stopShimmering()
        }
        
        cell.onRetry = viewModel.loadImage
        viewModel.loadImage()
        return cell
    }
    
    func preload() {
        viewModel.preloadImage()
    }
    
    func cancelLoad() {
        viewModel.cancelLoad()
    }
}
