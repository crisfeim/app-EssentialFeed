//
//  CoreDataStore.swift
//  EssentialFeed
//
//  Created by Cristian Felipe Patiño Rojas on 8/4/25.
//

import Foundation

public final class CoreDataStore: FeedStore {
    
    public init() {}
    
    public func retrieve(completion: @escaping RetrievalCompletion) {
        completion(.empty)
    }

    public func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
        
    }
    
    
    public func deleteCachedFeed(completion: @escaping DeletionCompletion) {
        
    }
}
