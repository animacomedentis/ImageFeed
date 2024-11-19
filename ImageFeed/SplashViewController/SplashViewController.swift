import UIKit

final class SplashViewController: UIViewController {
    
    //MARK: properties
    private var networkServices = OAuth2Service()
    private let showAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSplashViewController()
    }
    
    //MARK: viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let _ = OAuth2TokenStorage.shared.token {
            switchToTabBarViewController()
        }else {
            performSegue(withIdentifier: showAuthenticationScreenSegueIdentifier, sender: nil)
        }
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
    
    //MARK: viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    private func setupSplashViewController() {
        
        view.backgroundColor = .ypBlack
        
        //MARK: logo
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
    
    private func switchToTabBarViewController() {
        
        guard let window = UIApplication.shared.windows.first else {fatalError("Invalid Config")}
        let tabBar = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBar
        
    }
    
}

//MARK: AuthDelegate

extension SplashViewController: AuthViewControllerDelegate {
    func didAuthenticate(_ vc: AuthViewController) {
        vc.dismiss(animated: true)
        
        switchToTabBarViewController()
    }
    
    func authViewController(_ vc: AuthViewController, didAAuthViewController code: String) {
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.fetchOAuthToken(with: code)
        }
    }
    
    private func fetchOAuthToken(with code: String){
        networkServices.fetchOAuthToken(code: code) {[weak self] result in
            guard let self = self else{return}
            switch result {
            case .success(let token):
                OAuth2TokenStorage.shared.token = token
                self.switchToTabBarViewController()
            case .failure(let error):
                print(error)
            }
        }
    }
    
}
