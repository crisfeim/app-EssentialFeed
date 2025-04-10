//
//  FeedItemsMapper.swift
//  EssentialFeed
//
//  Created by Cristian Felipe Patiño Rojas on 28/11/24.
//
import Foundation



enum FeedItemsMapper {
    
    struct Root: Decodable {
        let items: [RemoteFeedItem]
    }
    
    private static let jsonDecoder = JSONDecoder()
    private static let OK_200 = 200
    
    static func map(_ data: Data, from response: HTTPURLResponse) throws -> [RemoteFeedItem] {
        guard
            response.statusCode == OK_200,
            let root = try? jsonDecoder.decode(Root.self, from: data) else {
            throw RemoteFeedLoader.Error.invalidData
        }
        
        return root.items
    }
}
