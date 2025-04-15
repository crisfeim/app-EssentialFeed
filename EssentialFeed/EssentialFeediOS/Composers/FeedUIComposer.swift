//
//  FeedUIComposer.swift
//  EssentialFeed
//
//  Created by Cristian Felipe Patiño Rojas on 14/4/25.
//


import EssentialFeed
import UIKit

public enum FeedUIComposer {
   
    public static func feedComposedWith(
        feedLoader: FeedLoader,
        imageLoader: FeedImageDataLoader
    ) -> FeedViewController {
        
        let presentationAdapter = FeedLoaderPresentationAdapter(feedLoader: MainQueueDispatchDecorator(feedLoader))
       
        let feedController = FeedViewController.makeWith(
            delegate: presentationAdapter,
            title: FeedPresenter.title
        )
        
        presentationAdapter.presenter = FeedPresenter(
            feedView:  FeedViewAdapter(
                controller: feedController,
                imageLoader: MainQueueDispatchDecorator(imageLoader)
            ),
            loadingView: WeakRefVirtualProxy(feedController)
        )
        return feedController
    }
}





