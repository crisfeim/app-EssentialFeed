//
//  SharedTestHelpers.swift
//  EssentialFeed
//
//  Created by Cristian Felipe Patiño Rojas on 4/4/25.
//

import Foundation

func anyNSError() -> NSError { NSError(domain: "any error", code: 0)
}

func anyURL() -> URL {
    URL(string: "http://any-url.com")!
}
