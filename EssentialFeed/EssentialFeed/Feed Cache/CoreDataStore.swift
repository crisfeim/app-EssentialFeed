//
//  CoreDataStore.swift
//  EssentialFeed
//
//  Created by Cristian Felipe Patiño Rojas on 8/4/25.
//

import CoreData

public final class CoreDataStore: FeedStore {
    
    let container: NSPersistentContainer
    private let context: NSManagedObjectContext
    public init(storeURL: URL, bundle: Bundle = .main) throws {
        container = try NSPersistentContainer.load(
            modelName: "FeedStore",
            url: storeURL,
            in: bundle
        )
        context = container.newBackgroundContext()
    }
    
    public func retrieve(completion: @escaping RetrievalCompletion) {
        context.perform { [context] in
            
            do {
                let request = NSFetchRequest<ManagedCache>(entityName: ManagedCache.entity().name!)
                request.returnsObjectsAsFaults = false
                if let cache = try context.fetch(request).first {
                    completion(.found(feed: cache.localFeed, timestamp: cache.timestamp))
                } else {
                    completion(.empty)
                }
            } catch {
                completion(.failure(error))
            }
        }
    }

    public func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
        context.perform { [context] in
            do {
                let managedCache = ManagedCache(context: context)
                managedCache.timestamp = timestamp
                managedCache.feed = ManagedFeedImage.images(
                    from: feed,
                    in: context
                )
                try context.save()
                completion(nil)
            } catch {
                completion(error)
            }
        }
        
    }
    
    
    public func deleteCachedFeed(completion: @escaping DeletionCompletion) {
        
    }
}

private extension NSPersistentContainer {
    enum LoadingError: Error {
        case modelNotFound
        case failedToPersistentStores(Error)
    }
    
    static func load(
        modelName name: String,
        url: URL,
        in bundle: Bundle
    ) throws -> NSPersistentContainer {
        guard let model = NSManagedObjectModel.with(name: name, in: bundle) else { throw LoadingError.modelNotFound }
        let container = NSPersistentContainer(name: name, managedObjectModel: model)
        
        container.persistentStoreDescriptions = [
            NSPersistentStoreDescription(url: url)
        ]
        
        var loadError: Error?
        container.loadPersistentStores {
            loadError = $1
        }
        
        try loadError.map {
            throw LoadingError.failedToPersistentStores($0)
        }
        
        return container
    }
}

private extension NSManagedObjectModel {
    static func with(name: String, in bundle: Bundle) -> NSManagedObjectModel? {
        return bundle.url(forResource: name, withExtension: "momd")
            .flatMap {
                NSManagedObjectModel(contentsOf: $0)
            }
    }
}

@objc(ManagedCache)
private class ManagedCache: NSManagedObject {
    @NSManaged var timestamp: Date
    @NSManaged var feed: NSOrderedSet
    
    var localFeed: [LocalFeedImage] {
        return feed.compactMap { ($0 as? ManagedFeedImage)?.local }
    }
}

@objc(ManagedFeedImage)
private class ManagedFeedImage: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var imageDescription: String?
    @NSManaged var location: String?
    @NSManaged var url: URL
    @NSManaged var cache: ManagedCache
    
    static func images(from localFeed: [LocalFeedImage], in context: NSManagedObjectContext) -> NSOrderedSet {
        let managedFeedImages = localFeed.map {
            let managedFeedImage = ManagedFeedImage(context: context)
            managedFeedImage.id = $0.id
            managedFeedImage.imageDescription = $0.description
            managedFeedImage.location = $0.location
            managedFeedImage.url = $0.url
            return managedFeedImage
        }
        return NSOrderedSet(array: managedFeedImages)
    }
    
    var local: LocalFeedImage {
        LocalFeedImage(
            id: id,
            description: imageDescription,
            location: location,
            url: url
        )
    }
}
