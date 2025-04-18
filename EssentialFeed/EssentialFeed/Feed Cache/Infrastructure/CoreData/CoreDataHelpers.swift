//
//  CoreDataHelpers.swift
//  EssentialFeed
//
//  Created by Cristian Felipe Patiño Rojas on 9/4/25.
//

import CoreData

extension NSPersistentContainer {
    enum LoadingError: Error {
        case modelNotFound
        case failedToPersistentStores(Error)
    }
    
    static func load(
        modelName name: String,
        model: NSManagedObjectModel?,
        url: URL
    ) throws -> NSPersistentContainer {
        guard let model else { throw LoadingError.modelNotFound }
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

extension NSManagedObjectModel {
    static func with(name: String, in bundle: Bundle) -> NSManagedObjectModel? {
        return bundle.url(forResource: name, withExtension: "momd")
            .flatMap {
                NSManagedObjectModel(contentsOf: $0)
            }
    }
}
