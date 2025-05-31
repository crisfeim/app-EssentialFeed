//
//  Copyright © Essential Developer. All rights reserved.
//

import Foundation

public protocol FeedLoaderTask {
    func cancel()
}

public protocol FeedLoader {
    typealias Result = Swift.Result<[FeedImage], Error>
    @discardableResult
	func load(completion: @escaping (Result) -> Void) -> FeedLoaderTask?
}
