@testable import ImageFeed
import XCTest

final class ImagesListTests: XCTestCase {
    
    func testCallObserver(){
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
        presenter.updeteTableView()
        
        //Then
        XCTAssertTrue(presenter.updateTableViewCalled)

    }
}
