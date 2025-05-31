// © 2025  Cristian Felipe Patiño Rojas. Created on 31/5/25.

import XCTest
import EssentialFeed

class FeedImagePresenter<View: FeedImageView, Image> where View.Image == Image {
    private let view: View
    private let imageTransformer: (Data) -> Image?
    
    init(view: View, imageTransformer: @escaping (Data) -> Image?) {
        self.view = view
        self.imageTransformer = imageTransformer
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
    
    func didFinishLoadingImageData(with data: Data, for model: FeedImage) {
        guard let image = imageTransformer(data) else {
            view.display(
                FeedImageViewModel<Image>(
                    description: model.description,
                    location: model.location,
                    image: nil,
                    isLoading: false,
                    shouldRetry: true
                )
            )
            return
        }
        view.display(
            FeedImageViewModel(
                description: model.description,
                location: model.location,
                image: image,
                isLoading: false,
                shouldRetry: false
            )
        )
    }
    
    func didFinishLoadingImageData(with error: Error, for model: FeedImage) {
        view.display(
            FeedImageViewModel<Image>(
                description: model.description,
                location: model.location,
                image: nil,
                isLoading: false,
                shouldRetry: true
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
    
    
    func test_didFinishLoadingImageData_displaysRetryOnFailedImageTransformation() {
        let (sut, view) = makeSUT(imageTransformer: fail)
        let image = uniqueImage()
        
        sut.didFinishLoadingImageData(with: Data(), for: image)
        
        let message = view.messages.first
        XCTAssertEqual(view.messages.count, 1)
        XCTAssertEqual(message?.description, image.description)
        XCTAssertEqual(message?.location, image.location)
        XCTAssertEqual(message?.isLoading, false)
        XCTAssertEqual(message?.shouldRetry, true)
        XCTAssertNil(message?.image)
    }
    
    func test_didFinishLoadingImageDataWithError_displaysRetry() {
        let image = uniqueImage()
        let (sut, view) = makeSUT()
        
        sut.didFinishLoadingImageData(with: anyNSError(), for: image)
        
        let message = view.messages.first
        XCTAssertEqual(view.messages.count, 1)
        XCTAssertEqual(message?.description, image.description)
        XCTAssertEqual(message?.location, image.location)
        XCTAssertEqual(message?.isLoading, false)
        XCTAssertEqual(message?.shouldRetry, true)
        XCTAssertNil(message?.image)
    }
}


private extension FeedImagePresenterTests {
    func makeSUT(
        imageTransformer: @escaping (Data) -> AnyImage? = { _ in nil },
        file: StaticString = #file,
        line: UInt = #line
    ) -> (presenter: FeedImagePresenter<ViewSpy, AnyImage>, view: ViewSpy) {
        let viewSpy = ViewSpy()
        let presenter = FeedImagePresenter<ViewSpy, AnyImage>(
            view: viewSpy,
            imageTransformer: imageTransformer
        )
        trackForMemoryLeaks(viewSpy, file: file, line: line)
        trackForMemoryLeaks(presenter, file: file, line: line)
        return (presenter, viewSpy)
    }
    
    var fail: (Data) -> AnyImage? {{ _ in nil }}
    
    struct AnyImage: Equatable {}
    
    class ViewSpy: FeedImageView {
        
        var messages = [FeedImageViewModel<AnyImage>]()
        
        func display(_ viewModel: FeedImageViewModel<AnyImage>) {
            messages.append(viewModel)
        }
    }
}
