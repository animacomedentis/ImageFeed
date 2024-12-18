import ImageFeed
import Foundation

final class ImagesListViewPresenterSpy: ImagesListViewPresenterProtocol {
    var view: ImageFeed.ImagesListViewControllerProtocol?
    
    var dateFormatter: DateFormatter = DateFormatter()
    var imagesListObserverCalled: Bool = false
    var updateTableViewCalled: Bool = false
    
    func imagesListObserver() {
        imagesListObserverCalled = true
    }
    
    func updeteTableView() {
        updateTableViewCalled = true
    }
}
