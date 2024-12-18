import Foundation

public protocol ProfileViewPresenterProtocol {
    var view: ProfileViewControllerProtocol? {get set}
}

final class ProfileViewPresenter: ProfileViewPresenterProtocol {
    weak var view: ProfileViewControllerProtocol?
    
}
