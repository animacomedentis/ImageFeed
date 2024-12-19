@testable import ImageFeed
import XCTest
import Foundation

final class ProfileViewPresenterSpy: ProfileViewPresenterProtocol {
    var viewDidLoadCalled = false
    var didTapLogoutButtonCalled = false

    weak var view: ProfileViewControllerProtocol?
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    func tapLogoutButton() {
        didTapLogoutButtonCalled = true
    }
}
