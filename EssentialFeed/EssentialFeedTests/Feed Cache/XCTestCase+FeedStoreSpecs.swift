//
//  XCTestCase+FeedStoreSpecs.swift
//  EssentialFeed
//
//  Created by Cristian Felipe Patiño Rojas on 7/4/25.
//
import XCTest
import EssentialFeed

extension FeedStoreSpecs where Self: XCTestCase {
    @discardableResult
    func insert(_ cache: (feed: [LocalFeedImage], timestamp: Date), to sut: FeedStore) -> Error? {
        let exp = expectation(description: "Wait for cache insertion")
        var insertionError: Error?
        sut.insert(cache.feed, timestamp: cache.timestamp) { error in
            insertionError = error
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
        return insertionError
    }
    
    @discardableResult
    func deleteCache(from sut: FeedStore) -> Error? {
        let exp = expectation(description: "Wait for cache deletion")
        var receivedError: Error?
        sut.deleteCachedFeed {
            exp.fulfill()
            receivedError = $0
        }
        
        wait(for: [exp], timeout: 1.0)
        return receivedError
    }
    
    func expect(
        _ sut: FeedStore,
        toRetrieve expectedResult: RetrieveCachedFeedResult,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let exp = expectation(description: "Wait for cache retrieval")
        
        sut.retrieve { retrievedResult in
            exp.fulfill()
            switch (expectedResult, retrievedResult) {
            case (.empty, .empty), (.failure, .failure):
                break
            case let (.found(expectedFeed, expectedTimestmap), .found(retrievedFeed, retrievedTimestamp)):
                XCTAssertEqual(expectedFeed, retrievedFeed, file: file, line: line)
                XCTAssertEqual(expectedTimestmap, retrievedTimestamp, file: file, line: line)
            default:
                XCTFail("Expected to retrieve \(expectedResult), but got \(retrievedResult)", file: file, line: line)
            }
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    func expect(
        _ sut: FeedStore,
        toRetrieveTwice expectedResult: RetrieveCachedFeedResult,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        expect(sut, toRetrieve: expectedResult, file: file, line: line)
        expect(sut, toRetrieve: expectedResult, file: file, line: line)
    }
}

extension FeedStoreSpecs where Self: XCTestCase {
    func assertThatRetrieveDeliversEmptyOnEmptyCache(
        on sut: FeedStore,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        expect(sut, toRetrieve: .empty)
    }
    
    func assertThatRetrieveHasNoSideEffectsOnEmptyCache(
        on sut: FeedStore,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        expect(sut, toRetrieveTwice: .empty)
    }
    
    func assertThatRetrieveDeliversFoundValuesOnNonEmptyCache(
        on sut: FeedStore,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let feed = uniqueImageFeed().local
        let timestamp = Date()
        
        insert((feed, timestamp), to: sut)
        expect(sut, toRetrieve: .found(feed: feed, timestamp: timestamp))
    }
    
    func assertThatRetrieveHasNoSideEffectsOnNonEmptyCache(
        on sut: FeedStore,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let feed = uniqueImageFeed().local
        let timestamp = Date()
        
        insert((feed, timestamp), to: sut)
        expect(sut, toRetrieveTwice: .found(feed: feed, timestamp: timestamp))
    }
}

extension FeedStoreSpecs where Self: XCTestCase {
    func assertThatInsertDeliversNoErrorOnEmptyCache(on sut: FeedStore, file: StaticString = #file, line: UInt = #line) {
        let insertionError = insert((uniqueImageFeed().local, Date()), to: sut)
        
        XCTAssertNil(insertionError, "Expected to insert cache successfully", file: file, line: line)
    }
    
    func assertThatInsertDeliversNoErrorOnNonEmptyCache(on sut: FeedStore, file: StaticString = #file, line: UInt = #line) {
        insert((uniqueImageFeed().local, Date()), to: sut)
        
        let insertionError = insert((uniqueImageFeed().local, Date()), to: sut)
        
        XCTAssertNil(insertionError, "Expected to override cache successfully", file: file, line: line)
    }
    
    func assertThatInsertOverridesPreviouslyInsertedCacheValues(
        on sut: FeedStore,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let firstInsertionError = insert((uniqueImageFeed().local, Date()), to: sut)
        XCTAssertNil(firstInsertionError, "Expected to insert cache succesfully")
        
        let latestFeed = uniqueImageFeed().local
        let latesTimestamp = Date()
        let latestInsertionError = insert((latestFeed, latesTimestamp), to: sut)
        
        XCTAssertNil(latestInsertionError, "Expected to override cache succesfully")
        expect(sut, toRetrieve: .found(feed: latestFeed, timestamp: latesTimestamp))
    }
}

extension FeedStoreSpecs where Self: XCTestCase {
    
    func assertThatDeleteDeliversNoErrorOnEmptyCache(on sut: FeedStore, file: StaticString = #file, line: UInt = #line) {
        let deletionError = deleteCache(from: sut)
        
        XCTAssertNil(deletionError, "Expected empty cache deletion to succeed", file: file, line: line)
    }
    
    func assertThatDeleteHasNoSideEffectOnEmptyCache(
        on sut: FeedStore,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let deletionError = deleteCache(from: sut)
        
        XCTAssertNil(deletionError, "Expected empty cache deletion to succeed")
        expect(sut, toRetrieve: .empty)
    }
    
    func assertThatDeleteEmptiesPreviouslyInsertedCache(
        on sut: FeedStore,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        insert((uniqueImageFeed().local, Date()), to: sut)
        
        let deletionError = deleteCache(from: sut)
        
        XCTAssertNil(deletionError, "Expected non-empty cache deletion to succeed")
        expect(sut, toRetrieve: .empty)
    }
    
    func assertThatStoreSideEffectsRunSerially(
        on sut: FeedStore,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        var completedOperationsInOrder = [XCTestExpectation]()
        
        let op1 = expectation(description: "Operation 1")
        sut.insert(uniqueImageFeed().local, timestamp: Date()) { _ in
            completedOperationsInOrder.append(op1)
            op1.fulfill()
        }
        
        let op2 = expectation(description: "Operation 2")
        sut.deleteCachedFeed { _ in
            completedOperationsInOrder.append(op2)
            op2.fulfill()
        }
        
        let op3 = expectation(description: "Operation 3")
        sut.insert(uniqueImageFeed().local, timestamp: Date()) { _ in
            completedOperationsInOrder.append(op3)
            op3.fulfill()
        }
        
        waitForExpectations(timeout: 5.0)
        
        XCTAssertEqual(completedOperationsInOrder, [op1,op2,op3], "Expected operations to run serially but operations finished in the wrong order")
    }
}
