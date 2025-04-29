//
//  MainQueueDispatchDecorator.swift
//  EssentialFeed
//
//  Created by Cristian Felipe Patiño Rojas on 15/4/25.
//


import EssentialFeed
import UIKit

final class MainQueueDispatchDecorator<T> {
    private let decoratee: T
    init(_ decorate: T) {
        self.decoratee = decorate
    }
    
    static func dispatch(work: @escaping () -> Void) {
        Thread.isMainThread ? work() : DispatchQueue.main.async(execute: work)
    }
}

extension MainQueueDispatchDecorator: FeedLoader where T == FeedLoader {
    func load(completion: @escaping (FeedLoader.Result) -> Void) -> FeedLoaderTask? {
        decoratee.load { result in
            Self.dispatch {
                completion(result)
            }
        } 
    }
}

extension MainQueueDispatchDecorator: FeedImageDataLoader where T == FeedImageDataLoader {
    func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> any FeedImageDataLoaderTask {
        decoratee.loadImageData(from: url) { result in
            Self.dispatch {
                completion(result)
            }
        }
    }
}
