@testable import ImageFeed
import XCTest
import Foundation

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
   
    var updateProfileDetailsCalled = false
    var updateAvatarCalled = false
    var showLogoutAlertCalled = false
    
    var presenter: ProfileViewPresenterProtocol?
    
    func updateProfileDetails(profile: ImageFeed.Profile) {
        updateProfileDetailsCalled = true
    }
    
    func updateAvatar() {
        updateAvatarCalled = true
    }
    
    func showLogoutAlert() {
        showLogoutAlertCalled = true
    }
}
