//
//  CodableFeedStoreTests.swift
//  EssentialFeed
//
//  Created by Cristian Felipe Patiño Rojas on 4/4/25.
//

import XCTest
import EssentialFeed

class CodableFeedStore {
    func retrieve(completion: @escaping FeedStore.RetrievalCompletion) {
        completion(.empty)
    }
}

class CodableFeedStoreTests: XCTestCase {
    
    func test_retrieve_deliversEmptyOnEmptyCache() {
        let sut = CodableFeedStore()
        let exp = expectation(description: "")
        sut.retrieve { result in
            exp.fulfill()
            switch result {
            case .empty: break
            default: XCTFail("Expected empty result,  got \(result) instead")
            }
        }
        
        wait(for: [exp], timeout: 1.0)
    }
}
