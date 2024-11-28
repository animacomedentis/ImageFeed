import UIKit

final class SplashViewController: UIViewController {
    
    //MARK: properties
    private var networkServices = OAuth2Service()
    private let storage = OAuth2TokenStorage()
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private let showAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    private let showImagesListIdentifier = "ShowImagesList"
    private let alertPresenter = AlertPresenter()
    private var checked: Bool = false
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showAuthenticationScreenSegueIdentifier {
            guard let navigationController = segue.destination as? UINavigationController,
                  let rootVC = navigationController.viewControllers[0] as? AuthViewController
            else {fatalError("FAiled to prepare for\(showAuthenticationScreenSegueIdentifier)")}
            rootVC.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }

    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSplashViewController()
    }
    //MARK: viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkAuthStatus()
    }
    //MARK: viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
        
    }
    
}
 
//MARK: AuthDelegate

extension SplashViewController: AuthViewControllerDelegate {
   
//    func authViewController(_ vc: AuthViewController, didAAuthViewController code: String) {
//        dismiss(animated: true) { [weak self] in
//            guard let self = self else { return }
//            self.fetchOAuthToken(code: code)
//        }
//    }
//    
//    private func fetchOAuthToken(code: String){
//        UIBlockingProgressHUD.show()
//        
//        networkServices.fetchOAuthToken(code: code) { [weak self] authResult in
//            guard let self = self else{ return }
//            
//            switch authResult {
//            case .success(_):
//                fetchProfile(complition: {
//                    UIBlockingProgressHUD.dismiss()
//                })
//            case .failure(let error):
//                showLoginAlert(error: error)
//                UIBlockingProgressHUD.dismiss()
//            }
//        }
//    }
    
    private func fetchProfile(complition: @escaping () -> Void) {
        profileService.fetchProfile { [weak self] profileResult in
            guard let self = self else { return }

            switch profileResult {
            case .success(let profile):
                self.profileImageService.fetchProfileImageURL(username: profile.username) {_ in}
            case .failure(let error):
                showLoginAlert(error: error)
            }
            complition()
        }
    }
    
    private func showLoginAlert (error: Error) {
        alertPresenter.showAlert(title: "Что-то пошло не так :(",
                                 message: "Не удалось войти в систему"){
            self.performSegue(withIdentifier: self.showAuthenticationScreenSegueIdentifier, sender: nil)
        }
    }
    
    func didAuthenticate(_ vc: AuthViewController) {
        fetchProfile { [weak self] in
            self?.dismiss(animated: false)
            self? .switchToTabBarViewController()
        }
    }
}

//MARK: -SetupView
extension SplashViewController {
    
    private func setupSplashViewController() {
        
        view.backgroundColor = .ypBlack
        let imageLogo = UIImage(named: "logo_practicum")
        let logo = UIImageView(image: imageLogo)
        logo.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logo)
        
        NSLayoutConstraint.activate([
            logo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logo.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logo.widthAnchor.constraint(equalToConstant: 75),
            logo.heightAnchor.constraint(equalToConstant: 78)
        ])
    }
}

extension SplashViewController {
    
    private func switchToTabBarViewController() {
      dismiss(animated: false)
        performSegue(withIdentifier: showImagesListIdentifier, sender: self)
    }
    
    private func showAuthCotroller () {
      performSegue(withIdentifier: showAuthenticationScreenSegueIdentifier, sender: self)
    }
    
    private func checkAuthStatus () {
        guard !checked else { return }
        
        checked = true
        if networkServices.isAuth {
            UIBlockingProgressHUD.show()
            fetchProfile { [weak self] in
                UIBlockingProgressHUD.dismiss()
                self?.switchToTabBarViewController()
            }
        } else {
            showAuthCotroller()
        }
    }
}

