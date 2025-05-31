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
    public func load(completion: @escaping (LoadResult) -> Void) -> FeedLoaderTask? {
        store.retrieve { [weak self] result in
            guard let self else { return }
            switch result {
            case let .failure(error):
                completion(.failure(error))
                
            case let .success(.some(cache)) where FeedCachePolicy.validate(cache.timestamp, against: currentDate()):
                completion(.success(cache.feed.toModels()))
            case .success:
                completion(.success([]))
            }
        }
        return nil
    }
}

extension LocalFeedLoader {
    public func validateCache() {
        store.retrieve { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(.some(cache)) where !FeedCachePolicy.validate(cache.timestamp, against: currentDate()):
                self.store.deleteCachedFeed { _ in }
            case .failure:
                self.store.deleteCachedFeed { _ in }
            case .success: break
            }
        }
    }
}

extension LocalFeedLoader {
    public typealias SaveResult = Result<Void, Error>
    public func save(_ feed: [FeedImage], completion: @escaping (SaveResult) -> Void) {
        store.deleteCachedFeed { [weak self] deletionResult in
            guard let self else { return }
            switch deletionResult {
            case .success:
                self.cache(feed, with: completion)
            case let .failure(error):
                completion(.failure(error))
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
