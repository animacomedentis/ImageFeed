@testable import ImageFeed
import XCTest
import Foundation

final class ProfileViewTests: XCTestCase {
    
    func testViewControllerCallsViewDidLoad() {
        // given
        let viewController = ProfileViewController()
        let presenter = ProfileViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        // when
        _ = viewController.view
        // then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testPresenterCallsShowBackButtonAlert() {
        // Given
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfileViewPresenter()
        viewController.presenter = presenter
        presenter.view = viewController
        // When
        presenter.tapLogoutButton()
        // Then
        XCTAssertTrue(viewController.showLogoutAlertCalled)
    }
    
    func testViewControllerCallsDidTapLogoutButton() {
        // Given
        let viewController = ProfileViewController()
        let presenter = ProfileViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        // When
        viewController.didTapLogoutButton()
        // Then
        XCTAssertTrue(presenter.didTapLogoutButtonCalled)
    }
    
    func testPresenterCallsUpdateAvatar() {
        // Given
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfileViewPresenter()
        viewController.presenter = presenter
        presenter.view = viewController
        // When
        presenter.viewDidLoad()
        NotificationCenter.default.post(name: ProfileImageService.didChangeNotification, object: nil)
        // Then
        XCTAssertTrue(viewController.updateAvatarCalled)
    }
}
