//
//  FeedLoaderPresentationAdapter.swift
//  EssentialFeed
//
//  Created by Cristian Felipe Patiño Rojas on 15/4/25.
//


import EssentialFeed
import UIKit

final class FeedLoaderPresentationAdapter: FeedViewControllerDelegate {
    private let feedLoader: FeedLoader
    var presenter: FeedPresenter?
    
    init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }
    
    func loadFeed() {
        presenter?.didStartLoadingFeed()
        feedLoader.load { [weak self] result in
            switch result {
            case let .success(feed):
                self?.presenter?.didFinishLoadingFeed(with: feed)
            case let .failure(error):
                self?.presenter?.didFinishLoadingFeed(with: error)
            }
        }
    }
    
    func didRequestFeedRefresh() {
        loadFeed()
    }
}