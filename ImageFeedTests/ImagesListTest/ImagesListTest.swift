@testable import ImageFeed
import XCTest
import Foundation

final class ImagesListViewTests: XCTestCase {
    
    func testCallsObserver() {
        //Given
        let viewController =  ImagesListViewController()
        let presenter =  ImagesListViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        //When
        presenter.imagesListObserver()
        
        //Then
        XCTAssertTrue(presenter.imagesListObserverCalled)
    }
    
    func testCallsUpdateTableView() {
        //Given
        let viewController =  ImagesListViewController()
        let presenter =  ImagesListViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        //When
        presenter.updateTableView()
        
        //Then
        XCTAssertTrue(presenter.updateTableViewCalled)
    }
}
