import UIKit

final class SplashViewController: UIViewController {
    
    //MARK: properties
    private var networkServices = OAuth2Service()
    private let storage = OAuth2TokenStorage()
    private let profileService = ProfileService()
    private let showAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
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
    
    //MARK: viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    //MARK: viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        checkAuthStatus()
    }
}

//MARK: AuthDelegate

extension SplashViewController: AuthViewControllerDelegate {
   
    func authViewController(_ vc: AuthViewController, didAAuthViewController code: String) {
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.fetchOAuthToken(code: code)
        }
    }
    
    private func fetchOAuthToken(code: String){
        UIBlockingProgressHUD.show()
        
        networkServices.fetchOAuthToken(code: code) { [weak self] authResult in
            guard let self = self else{ return }
            
            switch authResult {
            case .success(_):
                fetchProfile(complition: {
                    UIBlockingProgressHUD.dismiss()
                })
            case .failure(let error):
                showLoginAlert(error: error)
                UIBlockingProgressHUD.dismiss()
            }
        }
    }
    
    private func fetchProfile(complition: @escaping () -> Void) {
        profileService.fetchProfile { [weak self] profileResult in
            guard let self = self else { return }

            switch profileResult {
            case .success(_):
                presentAuth()
                switchToTabBarViewController()
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
        vc.dismiss(animated: true)
        
        switchToTabBarViewController()
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
        guard let window = UIApplication.shared.windows.first else {fatalError("Invalid Config")}
        let tabBar = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBar
    }
    
    private func presentAuth () {
        let storuboard = UIStoryboard(name: "Main", bundle: .main)
        let viewController = storuboard.instantiateViewController(identifier: "AuthViewControllerID")
        
        guard let authViewController = viewController as? AuthViewController else { return }
        authViewController.delegate = self
        authViewController.modalPresentationStyle = .fullScreen
        present(authViewController, animated: true)
    }
    
    private func showAuthCotroller () {
        let viewController = UIStoryboard (name: "Main",
                                           bundle:.main).instantiateViewController(identifier: "AuthViewControllerID")
        guard let authViewController = viewController as? AuthViewController else { return }
        authViewController.delegate = self
        authViewController.modalPresentationStyle = .fullScreen
        present (authViewController, animated: true)
    }
    
    private func checkAuthStatus () {
        guard !checked else { return }
        
                
        if networkServices.isAuth {
            UIBlockingProgressHUD.show()
            fetchProfile { [weak self] in
                UIBlockingProgressHUD.dismiss()
                self?.switchToTabBarViewController()
            }
        } else {
            showAuthCotroller()
            checked = true
            
        }
    }
}
