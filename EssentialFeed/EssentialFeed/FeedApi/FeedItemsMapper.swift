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
        
        var feed: [FeedItem] {
            items.map(\.item)
        }
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
    
    internal static func map(_ data: Data, from response: HTTPURLResponse) -> RemoteFeedLoader.Result {
        guard
            response.statusCode == OK_200,
            let root = try? jsonDecoder.decode(Root.self, from: data) else {
            return .failure(RemoteFeedLoader.Error.invalidData)
        }
        
        return .success(root.feed)
    }
}
