//
//  HTTPClientResult.swift
//  EssentialFeed
//
//  Created by Cristian Felipe Patiño Rojas on 28/11/24.
//
import Foundation

public enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void)
}
