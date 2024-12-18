import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        connectPresenterToController()
    }
}

private extension TabBarController {
    
    func connectPresenterToController() {
        
        viewControllers?.forEach { vc in
            if let imagesListViewController = vc as? ImagesListViewController {
                let imagesListViewPresenter = ImagesListViewPresenter()
                imagesListViewController.presenter = imagesListViewPresenter
                imagesListViewPresenter.view = imagesListViewController
            }
            
            if let profileViewController = vc as? ProfileViewController {
                let profilePresenter = ProfileViewPresenter()
                profileViewController.presenter = profilePresenter
                profilePresenter.view = profileViewController
            }
        }
    }
}
