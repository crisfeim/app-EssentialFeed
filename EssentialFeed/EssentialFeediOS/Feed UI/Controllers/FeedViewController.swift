//
//  FeedViewController.swift
//  EssentialFeed
//
//  Created by Cristian Felipe Patiño Rojas on 11/4/25.
//

import UIKit

protocol FeedViewControllerDelegate {
    func didRequestFeedRefresh()
}

public final class FeedViewController: UITableViewControllerExtendedLifecycle, UITableViewDataSourcePrefetching {
    var delegate: FeedViewControllerDelegate?
    
    var tableModel = [FeedImageCellController]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    @IBAction private func refresh() {
        delegate?.didRequestFeedRefresh()
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public override func viewFirstAppearance() {
        super.viewFirstAppearance()
        refresh()
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableModel.count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellController(forRowAt: indexPath).view(in: tableView)
    }
    
    public override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cancelCellControllerLoad(forRowAt: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
          cellController(forRowAt: indexPath).preload()
        }
    }
    
    public func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach(cancelCellControllerLoad)
    }
    
    private func cancelCellControllerLoad(forRowAt indexPath: IndexPath) {
        cellController(forRowAt: indexPath).cancelLoad()
    }
    
    private func cellController(forRowAt indexPath: IndexPath) -> FeedImageCellController {
        return tableModel[indexPath.row]
    }
}

extension FeedViewController: FeedLoadingView {
    func display(_ viewModel: FeedLoadingViewModel) {
        refreshControl?.refreshIf(viewModel.isLoading)
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

public class UITableViewControllerExtendedLifecycle: UITableViewController {
    
    var firstAppeared = true
    public override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        firstAppeared ? viewFirstAppearance() : ()
    }
    
    func viewFirstAppearance() {
        firstAppeared = false
    }
}
