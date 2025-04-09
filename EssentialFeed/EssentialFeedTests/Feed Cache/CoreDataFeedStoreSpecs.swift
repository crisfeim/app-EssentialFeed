//
//  CoreDataFeedStoreSpecs.swift
//  EssentialFeed
//
//  Created by Cristian Felipe Patiño Rojas on 8/4/25.
//

import XCTest
import EssentialFeed

class CoreDataFeedStoreSpecs: XCTestCase, FeedStoreSpecs {
    func test_retrieve_deliversEmptyOnEmptyCache() {
        let sut = makeSUT()
        assertThatRetrieveDeliversEmptyOnEmptyCache(on: sut)
    }
    
    func test_retrieve_hasNoSideEffectsOnEmptyCache() {
        let sut = makeSUT()
        assertThatRetrieveHasNoSideEffectsOnEmptyCache(on: sut)
    }
    
    func test_retrieve_deliversFoundValuesOnNonEmptyCache() {
    }
    
    func test_retrieve_hasNoSideEffectsOnNonEmptyCache() {
    }
    
    func test_insert_overridesPreviouslyInsertedCacheValues() {
    }
    
    func test_delete_hasNoSideEffectsOnEmptyCache() {
    }
    
    func test_delete_emptiesPreviouslyInsertedCache() {
    }
    
    func test_storeSideEffects_runSerially() {
    }
    
    // MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> CoreDataStore {
        let storeBundle = Bundle(for: CoreDataStore.self)
        let storeURL = URL(fileURLWithPath: "/dev/null")
        let sut = try! CoreDataStore(
            storeURL: storeURL,
            bundle: storeBundle
        )
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
}
