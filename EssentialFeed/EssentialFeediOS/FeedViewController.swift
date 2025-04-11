//
//  FeedViewController.swift
//  EssentialFeed
//
//  Created by Cristian Felipe Patiño Rojas on 11/4/25.
//

import EssentialFeed
import UIKit

public protocol FeedImageDataLoader {
    func loadImageData(from url: URL)
    func cancelImageDataLoad(from url: URL)
}

public final class FeedViewController: UITableViewController {
    private var feedLoader: FeedLoader?
    private var imageLoader: FeedImageDataLoader?
    private var tableModel = [FeedImage]()
    
    private var onViewIsAppearing: ((FeedViewController) -> ())?
    
    public convenience init(
        loader: FeedLoader,
        imageLoader: FeedImageDataLoader
    ) {
        self.init()
        self.feedLoader = loader
        self.imageLoader = imageLoader
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(load), for: .valueChanged)
        onViewIsAppearing = { vc in
            vc.load()
            vc.onViewIsAppearing = nil
        }
    }
    
    public override func viewIsAppearing(_ animated: Bool) {
        onViewIsAppearing?(self)
    }
    
    @objc func load() {
       refreshControl?.beginRefreshing()
        feedLoader?.load { [weak self] result in
            self?.refreshControl?.endRefreshing()
            if let feed = try? result.get() {
                self?.tableModel = feed
                self?.tableView.reloadData()
            }
        }
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableModel.count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellModel = tableModel[indexPath.row]
        let cell = FeedImageCell()
        cell.locationContainer.isHidden = (cellModel.location == nil)
        cell.locationLabel.text = cellModel.location
        cell.descriptionLabel.text = cellModel.description
        imageLoader?.loadImageData(from: cellModel.url)
        return cell
    }
    
    public override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cellModel = tableModel[indexPath.row]
        imageLoader?.cancelImageDataLoad(from: cellModel.url)
    }
}
