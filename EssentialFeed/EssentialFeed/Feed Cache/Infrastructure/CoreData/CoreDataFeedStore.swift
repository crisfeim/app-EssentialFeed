//
//  CoreDataStore.swift
//  EssentialFeed
//
//  Created by Cristian Felipe Patiño Rojas on 8/4/25.
//

import CoreData

public final class CoreDataFeedStore: FeedStore {
    
    private let container: NSPersistentContainer
    private let context: NSManagedObjectContext
    
    static private let modelName = "FeedStore"
    static private let model = NSManagedObjectModel.with(name: modelName, in: Bundle(for: CoreDataFeedStore.self))
    
    public init(storeURL: URL) throws {
        container = try NSPersistentContainer.load(
            modelName: Self.modelName,
            model: Self.model,
            url: storeURL
        )
        context = container.newBackgroundContext()
    }
    
    public func retrieve(completion: @escaping RetrievalCompletion) {
        perform { context in
            completion(
                Result {
                    try ManagedCache.find(in: context).map {
                        CacheFeed(feed: $0.localFeed, timestamp: $0.timestamp)
                    }
                }
            )
        }
    }

    public func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
        perform { context in
            completion(
                Result {
                    let managedCache = try ManagedCache.newUniqueInstance(in: context)
                    managedCache.timestamp = timestamp
                    managedCache.feed = ManagedFeedImage.images(
                        from: feed,
                        in: context
                    )
                    try context.save()
                }
            )
        }
        
    }
    
    
    public func deleteCachedFeed(completion: @escaping DeletionCompletion) {
        perform { context in
            completion(
                Result {
                    try ManagedCache.find(in: context)
                        .map(context.delete)
                        .map(context.save)
                }
                
            )
        }
    }
    
    private func perform(_ action: @escaping (NSManagedObjectContext) -> Void) {
        context.perform { [context] in
            action(context)
        }
    }
}
