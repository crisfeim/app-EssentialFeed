//
//  LocalFeedLoader.swift
//  EssentialFeed
//
//  Created by Cristian Felipe Patiño Rojas on 3/4/25.
//
import Foundation



public final class LocalFeedLoader: FeedLoader {
    private let store: FeedStore
    private let currentDate: () -> Date
    public init(store: FeedStore, currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
    }
}
   
extension LocalFeedLoader {
    public typealias LoadResult = FeedLoader.Result
    public func load(completion: @escaping (LoadResult) -> Void) {
        store.retrieve { [weak self] result in
            guard let self else { return }
            switch result {
            case let .failure(error):
                completion(.failure(error))
                
            case let .success(.found(feed, timestamp)) where FeedCachePolicy.validate(timestamp, against: currentDate()):
                completion(.success(feed.toModels()))
            case .success:
                completion(.success([]))
            }
        }
    }
}

extension LocalFeedLoader {
    public func validateCache() {
        store.retrieve { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(.found(_, timestamp)) where !FeedCachePolicy.validate(timestamp, against: currentDate()):
                self.store.deleteCachedFeed { _ in }
            case .failure:
                self.store.deleteCachedFeed { _ in }
            case .success: break
            }
        }
    }
}

extension LocalFeedLoader {
    public typealias SaveResult = Error?
    public func save(_ feed: [FeedImage], completion: @escaping (SaveResult) -> Void) {
        store.deleteCachedFeed { [weak self] error in
            guard let self else { return }
            if let cacheDeletionError = error {
                completion(cacheDeletionError)
            } else {
                self.cache(feed, with: completion)
            }
        }
    }
    
    private func cache(_ feed: [FeedImage], with completion: @escaping (SaveResult) -> Void) {
        store.insert(feed.toLocal(), timestamp: currentDate())  { [weak self] error in
            guard self != nil else { return }
            completion(error)
        }
    }
}

private extension Array where Element == FeedImage {
    func toLocal() -> [LocalFeedImage] {
        return map {
            LocalFeedImage(
                id: $0.id,
                description: $0.description,
                location: $0.location,
                url: $0.url
            )
        }
    }
}

private extension Array where Element == LocalFeedImage {
    func toModels() -> [FeedImage] {
        return map {
            FeedImage(
                id: $0.id,
                description: $0.description,
                location: $0.location,
                url: $0.url
            )
        }
    }
}
