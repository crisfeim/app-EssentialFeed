// © 2025  Cristian Felipe Patiño Rojas. Created on 31/5/25.

import XCTest
import EssentialFeed

class FeedImagePresenter<View: FeedImageView, Image> where View.Image == Image {
    let view: View
    init(view: View) {
        self.view = view
    }
    
    func didStartShowingImage(for model: FeedImage) {
        view.display(
            FeedImageViewModel<Image>(
                description: model.description,
                location: model.location,
                image: nil,
                isLoading: true,
                shouldRetry: false
            )
        )
    }
}


protocol FeedImageView {
    associatedtype Image
    func display(_ viewModel: FeedImageViewModel<Image>)
}

struct FeedImageViewModel<T> {
    let description: String?
    let location: String?
    let image: T?
    
    let isLoading: Bool
    let shouldRetry: Bool
    
    var hasLocation: Bool { location != nil }
}

final class FeedImagePresenterTests: XCTestCase {
    
    func test_init_doesntMessageViewUponCreation() {
        let (_, view) = makeSUT()
        XCTAssert(view.messages.isEmpty)
    }
    
    func test_didStartShowingImage_displaysImage() {
        let (sut, view) = makeSUT()
        let image = uniqueImage()
        sut.didStartShowingImage(for: image)
        
        let captured = view.messages.first
        XCTAssertEqual(captured?.description, image.description)
        XCTAssertEqual(captured?.location, image.location)
        XCTAssertNil(captured?.image)
        XCTAssertEqual(captured?.isLoading, true)
        XCTAssertEqual(captured?.shouldRetry, false)
    }
}


private extension FeedImagePresenterTests {
    func makeSUT(
        file: StaticString = #file,
        line: UInt = #line
    ) -> (presenter: FeedImagePresenter<ViewSpy, AnyImage>, view: ViewSpy) {
        let viewSpy = ViewSpy()
        let presenter = FeedImagePresenter<ViewSpy, AnyImage>(view: viewSpy)
        trackForMemoryLeaks(viewSpy, file: file, line: line)
        trackForMemoryLeaks(presenter, file: file, line: line)
        return (presenter, viewSpy)
    }
    
    struct AnyImage: Equatable {}
    
    class ViewSpy: FeedImageView {
    
        var messages = [FeedImageViewModel<AnyImage>]()
        
        func display(_ viewModel: FeedImageViewModel<AnyImage>) {
            messages.append(viewModel)
        }
    }
}
