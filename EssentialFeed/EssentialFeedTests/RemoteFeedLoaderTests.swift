//
//  RemoteFeedLoaderTests.swift
//  EssentialFeed
//
//  Created by Cristian Felipe Patiño Rojas on 27/11/24.
//

import XCTest

class RemoteFeedLoader {
    
}

class HTTPClient {
    var requestedURL: URL?
}
 
class RemoteFeedLoaderTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        let client = HTTPClient()
        _ = RemoteFeedLoader()
        XCTAssertNil(client.requestedURL)
    }
}
