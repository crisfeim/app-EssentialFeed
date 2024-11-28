//
//  FeedItemsMapper.swift
//  EssentialFeed
//
//  Created by Cristian Felipe Patiño Rojas on 28/11/24.
//
import Foundation

internal enum FeedItemsMapper {
    
    struct Root: Decodable {
        let items: [Item]
    }

    struct Item: Decodable {
        let id: UUID
        let description: String?
        let location: String?
        let image: URL
        
        var item: FeedItem {
            FeedItem(
                id: id,
                description: description,
                location: location,
                imageURL: image)
        }
    }
    
    private static let jsonDecoder = JSONDecoder()
    
    private static let OK_200 = 200
    internal static func map(_ data: Data, _ response: HTTPURLResponse) throws -> [FeedItem] {
        guard response.statusCode == OK_200 else {
            throw RemoteFeedLoader.Error.invalidData
        }
        return try jsonDecoder.decode(Root.self, from: data).items.map(\.item)
    }
}
