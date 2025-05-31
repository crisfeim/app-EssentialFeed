// © 2025  Cristian Felipe Patiño Rojas. Created on 31/5/25.


import Foundation

public struct FeedImageViewModel<T> {
    public let description: String?
    public let location: String?
    public let image: T?
    
    public let isLoading: Bool
    public let shouldRetry: Bool
    
    var hasLocation: Bool { location != nil }
}