//
//  FeedRefreshViewController.swift
//  EssentialFeed
//
//  Created by Cristian Felipe Patiño Rojas on 14/4/25.
//

import UIKit

public final class FeedRefreshViewController: NSObject, FeedLoadingView {
    
    public lazy var view = loadView()
    
    private let loadFeed: () -> Void
    
    init(loadFeed: @escaping () -> Void) {
        self.loadFeed = loadFeed
    }
    
    @objc func refresh() {
        loadFeed()
    }
    
    func display(_ viewModel: FeedLoadingViewModel) {
        view.refreshIf(viewModel.isLoading)
    }
    
    func loadView() -> UIRefreshControl {
        let view = UIRefreshControl()
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return view
    }
}

private extension UIRefreshControl {
    func refreshIf(_ shouldRefresh: Bool) {
        if shouldRefresh {
            beginRefreshing()
        } else {
            endRefreshing()
        }
    }
}
