//
//  FeedRefreshViewController.swift
//  EssentialFeed
//
//  Created by Cristian Felipe Patiño Rojas on 14/4/25.
//

import UIKit

public final class FeedRefreshViewController: NSObject {
    
    public lazy var view = binded(UIRefreshControl())
    
    private let viewModel: FeedViewModel
    
    init(viewModel: FeedViewModel) {
        self.viewModel = viewModel
    }
    
    @objc func refresh() {
        viewModel.loadFeed()
    }
    
    func binded(_ view: UIRefreshControl) -> UIRefreshControl {
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        // @todo @question: when capturingo only the view
        // test fail: test_loadingFeedIndicator_isVisibleWhileLoadingFeed
        viewModel.onLoadingStateChange = { [weak self] isLoading in
            self?.view.refreshIf(isLoading)
        }
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
