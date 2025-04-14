//
//  FeedRefreshViewController.swift
//  EssentialFeed
//
//  Created by Cristian Felipe Patiño Rojas on 14/4/25.
//


import EssentialFeed
import UIKit

public final class FeedRefreshViewController: NSObject {
    
    public lazy var view: UIRefreshControl = {
        let view = UIRefreshControl()
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return view
    }()
    
    private let feedLoader: FeedLoader
    
    var onRefresh: (([FeedImage]) -> Void)?
    init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }
    
    @objc func refresh() {
        view.beginRefreshing()
         feedLoader.load { [weak self] result in
             self?.view.endRefreshing()
             if let feed = try? result.get() {
                 self?.onRefresh?(feed)
             }
         }
    }
}