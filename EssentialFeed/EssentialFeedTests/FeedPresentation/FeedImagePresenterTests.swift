// © 2025  Cristian Felipe Patiño Rojas. Created on 31/5/25.

import XCTest


class FeedImagePresenter {
    let view: Any
    init(view: Any) {
        self.view = view
    }
}

final class FeedImagePresenterTests: XCTestCase {
    
    func test_init_doesntMessageViewUponCreation() {
        let (_, view) = makeSUT()
        XCTAssert(view.messages.isEmpty)
    }
}

private extension FeedImagePresenterTests {
    func makeSUT(
        file: StaticString = #file,
        line: UInt = #line
    ) -> (presenter: FeedImagePresenter, view: ViewSpy) {
        let viewSpy = ViewSpy()
        let presenter = FeedImagePresenter(view: viewSpy)
        trackForMemoryLeaks(viewSpy, file: file, line: line)
        trackForMemoryLeaks(presenter, file: file, line: line)
        return (presenter, viewSpy)
    }
    
    class ViewSpy {
        var messages = [Any]()
    }
}
