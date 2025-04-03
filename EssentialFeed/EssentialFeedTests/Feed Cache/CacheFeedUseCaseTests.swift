//
//  CacheFeedUseCaseTests.swift
//  EssentialFeed
//
//  Created by Cristian Felipe Patiño Rojas on 3/4/25.
//

import XCTest

class LocalFeedLoader {
    init(store: FeedStore) {
        
    }
}
class FeedStore {
    var deleteCachedFeedCallCount = 0
}

class CacheFeedUseCaseTests: XCTestCase {
    
    func test_doesNotDeleteCacheUponCreation() {
        let store = FeedStore()
        let _ = LocalFeedLoader(store: store)
        XCTAssertEqual(store.deleteCachedFeedCallCount, 0)
    }
}
